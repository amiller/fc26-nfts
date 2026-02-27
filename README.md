# FC'26 Rump Session NFT

Unofficial NFTs for FC 2026 rump session paper authors. Claim yours by proving email authorship via [GitHub-ZKTLS](https://github.com/amiller/github-zktls).

**Claim page:** [amiller.github.io/fc26-nfts](https://amiller.github.io/fc26-nfts/)

## How it works

1. Select your paper on the [claim page](https://amiller.github.io/fc26-nfts/) and enter your author email
2. The page checks your email hash locally (your email never leaves the browser)
3. If eligible, you open a GitHub issue containing only the hash — not your email
4. A GitHub Action resolves the hash and sends a verification code to your email
5. You reply with the code → the workflow generates a Sigstore-attested ZK proof of email ownership
6. The relayer submits the proof on-chain → the contract verifies it and mints your NFT

### Trust model

There is nothing privileged about this repository. The verification workflow uses:

- A **pinned prover image** (`sha256:d85e563...`) that generates ZK proofs — anyone can inspect or run it
- **[Sigstore](https://www.sigstore.dev/) attestation** tied to the GitHub Actions run, providing a transparent audit trail
- A **public smart contract** on Base Sepolia ([`0x101D...e9B4`](https://sepolia.basescan.org/address/0x101DDc73E4b1e03a2a4A1d857c31A2CE98CCe9B4)) that verifies proofs on-chain

Anyone with the same commit, a prover image, and an SES key can independently run this workflow. The ZK proof is verifiable by anyone against the on-chain verifier.

### Email privacy

- `papers.json` stores `sha256(CLAIM_SALT + email)` — not plaintext emails
- The GitHub issue contains only the hash; the workflow resolves it via a private secret
- On-chain, only a salted `keccak256` hash is stored — the email is never in contract storage or event logs
- CLAIM_SALT = `"FC26-rump-session-2026"`

## Contract

[`contracts/PaperNFT.sol`](contracts/PaperNFT.sol) — ERC-721, one NFT per (paper, author_email) pair.

- **Address:** [`0x101DDc73E4b1e03a2a4A1d857c31A2CE98CCe9B4`](https://sepolia.basescan.org/address/0x101DDc73E4b1e03a2a4A1d857c31A2CE98CCe9B4) (Base Sepolia)
- Reuses [SigstoreVerifier](https://sepolia.basescan.org/address/0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1) from [github-zktls](https://github.com/amiller/github-zktls)
- Owner registers papers with authorized email hashes
- `tokenURI` returns IPFS metadata with AI-generated artwork

## Reproducibility

The contract's `requiredCommitSha` is set to the tagged release commit. Every NFT mint requires a Sigstore attestation proving the GitHub Actions workflow ran at exactly that commit. This means:

1. The workflow code that minted any NFT is the code at the tagged commit
2. Anyone can inspect the workflow source at that commit to verify what it does
3. The full repo is archived on IPFS for permanence (see `site_cid.json`)

To verify from the IPFS archive:
```bash
ipfs get <CID>          # download the archive
unzip fc26-rump-session-*.zip
cd fc26-rump-session-*/
git log --oneline -1    # should match requiredCommitSha on-chain
```

## Missing emails

Most author emails were found from public sources (DBLP, university homepages, ePrint papers, personal websites). 44 of 46 papers have at least one email registered. If your paper is listed but your email isn't recognized, please [open an issue](https://github.com/amiller/fc26-nfts/issues/new?title=Missing+email+for+paper+%23___&body=My+paper+ID+is:+%0AMy+email+is:+) or contact the maintainer to get added.

## Scripts

| Script | Purpose |
|--------|---------|
| `extract_metadata.py` | Extract author emails from PDFs → `papers.json` |
| `generate_images.py` | Generate per-paper artwork via Gemini |
| `upload_pinata.py` | Upload images + metadata to IPFS via Pinata |
| `register_papers.py` | Generate cast commands to register papers on-chain |
| `scripts/update-claims.js` | Fetch on-chain claim events → `claims.json` for gallery |
