// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PaperNFT.sol";
import "../contracts/ISigstoreVerifier.sol";

contract MockVerifier is ISigstoreVerifier {
    Attestation public mockAttestation;

    function setAttestation(Attestation memory att) external {
        mockAttestation = att;
    }

    function verify(bytes calldata, bytes32[] calldata) external pure returns (bool) {
        return true;
    }

    function verifyAndDecode(bytes calldata, bytes32[] calldata) external view returns (Attestation memory) {
        return mockAttestation;
    }

    function decodePublicInputs(bytes32[] calldata) external pure returns (Attestation memory) {
        revert("not implemented");
    }
}

contract PaperNFTTest is Test {
    PaperNFT nft;
    MockVerifier verifier;
    address owner;
    address alice = address(0xA11CE);

    function setUp() public {
        owner = address(this);
        verifier = new MockVerifier();
        nft = new PaperNFT(address(verifier), bytes20(0));
    }

    // --- registerPaper ---

    function test_registerPaper_storesHashes() public {
        bytes32[] memory hashes = new bytes32[](2);
        hashes[0] = keccak256("alice@example.com");
        hashes[1] = keccak256("bob@example.com");

        nft.registerPaper(14, hashes, "ipfs://QmTest");

        assertEq(nft.paperMetadataURI(14), "ipfs://QmTest");
    }

    function test_registerPaper_emitsEvent() public {
        bytes32[] memory hashes = new bytes32[](3);
        hashes[0] = keccak256("a@b.com");
        hashes[1] = keccak256("c@d.com");
        hashes[2] = keccak256("e@f.com");

        vm.expectEmit(false, false, false, true);
        emit PaperNFT.PaperRegistered(14, 3);
        nft.registerPaper(14, hashes, "ipfs://Qm");
    }

    function test_registerPaper_onlyOwner() public {
        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = keccak256("a@b.com");

        vm.prank(alice);
        vm.expectRevert(PaperNFT.NotOwner.selector);
        nft.registerPaper(1, hashes, "ipfs://Qm");
    }

    function test_registerPaper_overwritesPrevious() public {
        bytes32[] memory h1 = new bytes32[](1);
        h1[0] = keccak256("old@example.com");
        nft.registerPaper(14, h1, "ipfs://old");

        bytes32[] memory h2 = new bytes32[](2);
        h2[0] = keccak256("new1@example.com");
        h2[1] = keccak256("new2@example.com");
        nft.registerPaper(14, h2, "ipfs://new");

        assertEq(nft.paperMetadataURI(14), "ipfs://new");
    }

    // --- registerPapers (batch) ---

    function test_registerPapers_batch() public {
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;

        bytes32[][] memory hashesPerPaper = new bytes32[][](2);
        hashesPerPaper[0] = new bytes32[](1);
        hashesPerPaper[0][0] = keccak256("a@b.com");
        hashesPerPaper[1] = new bytes32[](2);
        hashesPerPaper[1][0] = keccak256("c@d.com");
        hashesPerPaper[1][1] = keccak256("e@f.com");

        string[] memory uris = new string[](2);
        uris[0] = "ipfs://1";
        uris[1] = "ipfs://2";

        nft.registerPapers(ids, hashesPerPaper, uris);

        assertEq(nft.paperMetadataURI(1), "ipfs://1");
        assertEq(nft.paperMetadataURI(2), "ipfs://2");
    }

    // --- registerPaper calldata has NO plaintext emails ---

    function test_registerPaper_calldataHasNoPlaintextEmails() public {
        string memory email = "jbonneau@gmail.com";
        bytes32 hash = keccak256(bytes(email));

        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = hash;

        // Build the calldata that would be sent
        bytes memory cd = abi.encodeCall(nft.registerPaper, (14, hashes, "ipfs://Qm"));

        // Verify the plaintext email does NOT appear in calldata
        bytes memory emailBytes = bytes(email);
        bool found = false;
        if (cd.length >= emailBytes.length) {
            for (uint256 i = 0; i <= cd.length - emailBytes.length; i++) {
                bool match_ = true;
                for (uint256 j = 0; j < emailBytes.length; j++) {
                    if (cd[i + j] != emailBytes[j]) { match_ = false; break; }
                }
                if (match_) { found = true; break; }
            }
        }
        assertFalse(found, "Plaintext email found in calldata!");
    }

    // --- claim flow with mock verifier ---

    function test_claim_success() public {
        string memory email = "jbonneau@gmail.com";
        bytes32 emailHash = keccak256(bytes(email));

        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = emailHash;
        nft.registerPaper(14, hashes, "ipfs://QmPaper14");

        // Build certificate containing the required fields
        bytes memory cert = abi.encodePacked(
            '{"email": "jbonneau@gmail.com", "recipient_address": "',
            _addrToHex(alice),
            '", "paper_id": "14"}'
        );

        // Set up mock verifier to return matching attestation
        verifier.setAttestation(ISigstoreVerifier.Attestation({
            artifactHash: sha256(cert),
            repoHash: bytes32(0),
            commitSha: bytes20(0)
        }));

        bytes32[] memory pubInputs = new bytes32[](0);
        nft.claim(hex"", pubInputs, cert, 14, email, alice);

        assertEq(nft.balanceOf(alice), 1);
        assertEq(nft.totalSupply(), 1);
        assertEq(nft.tokenPaperId(uint256(keccak256(abi.encodePacked(uint256(14), email)))), 14);
    }

    function test_claim_rejectsUnauthorizedEmail() public {
        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = keccak256("authorized@example.com");
        nft.registerPaper(14, hashes, "ipfs://Qm");

        string memory wrongEmail = "wrong@example.com";
        bytes memory cert = abi.encodePacked(
            '{"email": "wrong@example.com", "recipient_address": "',
            _addrToHex(alice),
            '", "paper_id": "14"}'
        );

        verifier.setAttestation(ISigstoreVerifier.Attestation({
            artifactHash: sha256(cert),
            repoHash: bytes32(0),
            commitSha: bytes20(0)
        }));

        bytes32[] memory pubInputs = new bytes32[](0);
        vm.expectRevert(PaperNFT.NotAuthorizedEmail.selector);
        nft.claim(hex"", pubInputs, cert, 14, wrongEmail, alice);
    }

    function test_claim_rejectsDoubleClaim() public {
        string memory email = "test@example.com";
        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = keccak256(bytes(email));
        nft.registerPaper(1, hashes, "ipfs://Qm");

        bytes memory cert = abi.encodePacked(
            '{"email": "test@example.com", "recipient_address": "',
            _addrToHex(alice),
            '", "paper_id": "1"}'
        );

        verifier.setAttestation(ISigstoreVerifier.Attestation({
            artifactHash: sha256(cert),
            repoHash: bytes32(0),
            commitSha: bytes20(0)
        }));

        bytes32[] memory pubInputs = new bytes32[](0);
        nft.claim(hex"", pubInputs, cert, 1, email, alice);

        // Second claim should revert
        vm.expectRevert(PaperNFT.AlreadyClaimed.selector);
        nft.claim(hex"", pubInputs, cert, 1, email, alice);
    }

    function test_claim_rejectsWrongCommit() public {
        // Set a required commit
        nft.setRequirements(bytes20(hex"49f63544e3e4e0ac9cf5da9e11cdb69a0bf1e8e7"));

        string memory email = "test@example.com";
        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = keccak256(bytes(email));
        nft.registerPaper(1, hashes, "ipfs://Qm");

        bytes memory cert = abi.encodePacked(
            '{"email": "test@example.com", "recipient_address": "',
            _addrToHex(alice),
            '", "paper_id": "1"}'
        );

        verifier.setAttestation(ISigstoreVerifier.Attestation({
            artifactHash: sha256(cert),
            repoHash: bytes32(0),
            commitSha: bytes20(hex"0000000000000000000000000000000000000001")
        }));

        bytes32[] memory pubInputs = new bytes32[](0);
        vm.expectRevert(PaperNFT.WrongCommit.selector);
        nft.claim(hex"", pubInputs, cert, 1, email, alice);
    }

    function test_claim_emailCaseInsensitive() public {
        // Register with lowercase hash
        string memory emailLower = "test@example.com";
        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = keccak256(bytes(emailLower));
        nft.registerPaper(1, hashes, "ipfs://Qm");

        // Claim with uppercase email — contract toLower's it before hashing
        string memory emailUpper = "Test@Example.COM";
        bytes memory cert = abi.encodePacked(
            '{"email": "Test@Example.COM", "recipient_address": "',
            _addrToHex(alice),
            '", "paper_id": "1"}'
        );

        verifier.setAttestation(ISigstoreVerifier.Attestation({
            artifactHash: sha256(cert),
            repoHash: bytes32(0),
            commitSha: bytes20(0)
        }));

        bytes32[] memory pubInputs = new bytes32[](0);
        nft.claim(hex"", pubInputs, cert, 1, emailUpper, alice);
        assertEq(nft.balanceOf(alice), 1);
    }

    // --- tokenURI ---

    function test_tokenURI_returnsPaperMetadata() public {
        string memory email = "test@example.com";
        bytes32[] memory hashes = new bytes32[](1);
        hashes[0] = keccak256(bytes(email));
        nft.registerPaper(1, hashes, "ipfs://QmPaper");

        bytes memory cert = abi.encodePacked(
            '{"email": "test@example.com", "recipient_address": "',
            _addrToHex(alice),
            '", "paper_id": "1"}'
        );
        verifier.setAttestation(ISigstoreVerifier.Attestation({
            artifactHash: sha256(cert),
            repoHash: bytes32(0),
            commitSha: bytes20(0)
        }));

        bytes32[] memory pubInputs = new bytes32[](0);
        nft.claim(hex"", pubInputs, cert, 1, email, alice);

        uint256 tokenId = uint256(keccak256(abi.encodePacked(uint256(1), email)));
        assertEq(nft.tokenURI(tokenId), "ipfs://QmPaper");
    }

    // --- Helper ---

    function _addrToHex(address a) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory result = new bytes(42);
        result[0] = "0";
        result[1] = "x";
        uint160 value = uint160(a);
        for (uint256 i = 41; i > 1; i--) {
            result[i] = alphabet[value & 0xf];
            value >>= 4;
        }
        return string(result);
    }
}
