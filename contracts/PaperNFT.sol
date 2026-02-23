// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISigstoreVerifier} from "./ISigstoreVerifier.sol";

/// @title FC26 Paper Author NFT
/// @notice ERC-721 where each (paper, author_email) pair is a unique token.
///         Authors claim by proving email ownership via Sigstore-attested challenge-response.
contract PaperNFT {
    ISigstoreVerifier public immutable verifier;
    address public immutable owner;

    string public name = "FC26 Rump Session NFT";
    string public symbol = "FC26RUMP";
    bytes32 public constant EMAIL_SALT = keccak256("FC26-rump-session-2026");

    // ERC-721 state
    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => address) public getApproved;
    mapping(address => mapping(address => bool)) public isApprovedForAll;
    uint256 public totalSupply;

    // Paper registry: paperId => authorized email hashes
    mapping(uint256 => bytes32[]) internal _paperEmails;
    mapping(uint256 => string) public paperMetadataURI; // IPFS URI per paper

    // Claim tracking: keccak256(paperId, toLower(email)) => claimed
    mapping(bytes32 => bool) public claimed;
    // Token metadata
    mapping(uint256 => uint256) public tokenPaperId;
    mapping(uint256 => bytes32) public tokenEmailHash;
    mapping(uint256 => string) public tokenMetadataURI; // per-token IPFS metadata

    bytes20 public requiredCommitSha;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Claimed(address indexed recipient, uint256 paperId, bytes32 emailHash, uint256 tokenId);
    event PaperRegistered(uint256 paperId, uint256 numAuthors);

    error InvalidProof();
    error CertificateMismatch();
    error EmailMismatch();
    error RecipientMismatch();
    error PaperIdMismatch();
    error WrongCommit();
    error AlreadyClaimed();
    error NotAuthorizedEmail();
    error NotOwner();
    error NotAuthorized();
    error InvalidRecipient();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(address _verifier, bytes20 _requiredCommitSha) {
        verifier = ISigstoreVerifier(_verifier);
        owner = msg.sender;
        requiredCommitSha = _requiredCommitSha;
    }

    /// @notice Register a paper with its authorized author emails and metadata URI
    function registerPaper(uint256 paperId, string[] calldata emails, string calldata metadataURI) external onlyOwner {
        delete _paperEmails[paperId];
        for (uint256 i = 0; i < emails.length; i++) {
            _paperEmails[paperId].push(keccak256(bytes(_toLowerMem(emails[i]))));
        }
        paperMetadataURI[paperId] = metadataURI;
        emit PaperRegistered(paperId, emails.length);
    }

    /// @notice Batch register multiple papers
    function registerPapers(
        uint256[] calldata paperIds,
        string[][] calldata emailsPerPaper,
        string[] calldata metadataURIs
    ) external onlyOwner {
        for (uint256 i = 0; i < paperIds.length; i++) {
            delete _paperEmails[paperIds[i]];
            for (uint256 j = 0; j < emailsPerPaper[i].length; j++) {
                _paperEmails[paperIds[i]].push(keccak256(bytes(_toLowerMem(emailsPerPaper[i][j]))));
            }
            paperMetadataURI[paperIds[i]] = metadataURIs[i];
            emit PaperRegistered(paperIds[i], emailsPerPaper[i].length);
        }
    }

    /// @notice Set per-token metadata URI (for IPFS JSON with image)
    function setTokenMetadataURI(uint256 tokenId, string calldata uri) external onlyOwner {
        tokenMetadataURI[tokenId] = uri;
    }

    function claim(
        bytes calldata proof,
        bytes32[] calldata publicInputs,
        bytes calldata certificate,
        uint256 paperId,
        string calldata email,
        address recipient
    ) external {
        ISigstoreVerifier.Attestation memory att = verifier.verifyAndDecode(proof, publicInputs);

        if (sha256(certificate) != att.artifactHash) revert CertificateMismatch();

        if (!containsBytes(certificate, abi.encodePacked('"email": "', email, '"')))
            revert EmailMismatch();
        if (!containsBytes(certificate, abi.encodePacked('"recipient_address": "', addressToHex(recipient), '"')))
            revert RecipientMismatch();
        // Verify paper_id in certificate
        if (!containsBytes(certificate, abi.encodePacked('"paper_id": "', _uint2str(paperId), '"')))
            revert PaperIdMismatch();

        if (requiredCommitSha != bytes20(0) && att.commitSha != requiredCommitSha)
            revert WrongCommit();

        // Check email is authorized for this paper
        string memory emailLower = toLower(email);
        bytes32 emailHash = keccak256(bytes(emailLower));
        bool authorized = false;
        bytes32[] storage allowedEmails = _paperEmails[paperId];
        for (uint256 i = 0; i < allowedEmails.length; i++) {
            if (allowedEmails[i] == emailHash) { authorized = true; break; }
        }
        if (!authorized) revert NotAuthorizedEmail();

        // Prevent double-claim per (paper, email)
        bytes32 claimKey = keccak256(abi.encodePacked(paperId, emailLower));
        if (claimed[claimKey]) revert AlreadyClaimed();
        claimed[claimKey] = true;

        uint256 tokenId = uint256(claimKey);
        tokenPaperId[tokenId] = paperId;
        bytes32 saltedHash = keccak256(abi.encodePacked(EMAIL_SALT, emailLower));
        tokenEmailHash[tokenId] = saltedHash;
        _mint(recipient, tokenId);
        totalSupply++;

        emit Claimed(recipient, paperId, saltedHash, tokenId);
    }

    function setRequirements(bytes20 _commitSha) external onlyOwner {
        requiredCommitSha = _commitSha;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        if (ownerOf[tokenId] == address(0)) revert InvalidRecipient();
        // If per-token IPFS metadata is set, use it
        bytes memory uri = bytes(tokenMetadataURI[tokenId]);
        if (uri.length > 0) return tokenMetadataURI[tokenId];
        // Fallback: paper-level metadata
        uint256 pid = tokenPaperId[tokenId];
        return paperMetadataURI[pid];
    }

    // --- Minimal ERC-721 ---

    function approve(address to, uint256 tokenId) external {
        address o = ownerOf[tokenId];
        if (msg.sender != o && !isApprovedForAll[o][msg.sender]) revert NotAuthorized();
        getApproved[tokenId] = to;
        emit Approval(o, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        if (to == address(0)) revert InvalidRecipient();
        address o = ownerOf[tokenId];
        if (from != o) revert NotAuthorized();
        if (msg.sender != from && msg.sender != getApproved[tokenId] && !isApprovedForAll[from][msg.sender])
            revert NotAuthorized();
        balanceOf[from]--;
        balanceOf[to]++;
        ownerOf[tokenId] = to;
        delete getApproved[tokenId];
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external { transferFrom(from, to, tokenId); }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata) external { transferFrom(from, to, tokenId); }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x80ac58cd || interfaceId == 0x01ffc9a7;
    }

    function _mint(address to, uint256 tokenId) internal {
        if (to == address(0)) revert InvalidRecipient();
        ownerOf[tokenId] = to;
        balanceOf[to]++;
        emit Transfer(address(0), to, tokenId);
    }

    // --- Helpers ---

    function containsBytes(bytes calldata haystack, bytes memory needle) internal pure returns (bool) {
        if (needle.length > haystack.length) return false;
        uint256 end = haystack.length - needle.length + 1;
        for (uint256 i = 0; i < end; i++) {
            bool found = true;
            for (uint256 j = 0; j < needle.length; j++) {
                if (haystack[i + j] != needle[j]) { found = false; break; }
            }
            if (found) return true;
        }
        return false;
    }

    function toLower(string calldata s) internal pure returns (string memory) {
        bytes memory b = bytes(s);
        bytes memory lower = new bytes(b.length);
        for (uint256 i = 0; i < b.length; i++) {
            lower[i] = (b[i] >= 0x41 && b[i] <= 0x5A) ? bytes1(uint8(b[i]) + 32) : b[i];
        }
        return string(lower);
    }

    function _toLowerMem(string memory s) internal pure returns (string memory) {
        bytes memory b = bytes(s);
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] >= 0x41 && b[i] <= 0x5A) b[i] = bytes1(uint8(b[i]) + 32);
        }
        return string(b);
    }

    function addressToHex(address a) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory result = new bytes(42);
        result[0] = "0"; result[1] = "x";
        uint160 value = uint160(a);
        for (uint256 i = 41; i > 1; i--) {
            result[i] = alphabet[value & 0xf];
            value >>= 4;
        }
        return string(result);
    }

    function _uint2str(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 tmp = v;
        uint256 digits;
        while (tmp != 0) { digits++; tmp /= 10; }
        bytes memory buf = new bytes(digits);
        while (v != 0) { buf[--digits] = bytes1(uint8(48 + v % 10)); v /= 10; }
        return string(buf);
    }
}
