# FC26 Paper Author NFTs — Rump Session Demo

Authors of FC26 papers can claim an NFT proving their authorship, using email-based ZK-TLS verification from [github-zktls](https://github.com/amiller/github-zktls).

## How it works

1. Author opens a GitHub issue with `[EMAIL] claim NFT` containing their email + ETH address + paper ID
2. GitHub Actions sends a verification code to their email
3. Author replies with the code → workflow generates a ZK proof of email ownership
4. Smart contract verifies proof + checks email is an authorized author → mints NFT
5. NFT has AI-generated artwork for the paper, stored on IPFS

## Scripts

| Script | Purpose |
|--------|---------|
| `extract_metadata.py` | Extract author emails from preproceedings PDFs → `papers.json` |
| `generate_images.py` | Generate per-paper artwork via DALL-E → `images/` |
| `upload_pinata.py` | Upload images + metadata to IPFS via Pinata → `ipfs_mapping.json` |
| `register_papers.py` | Generate cast commands to register papers on-chain |

## Contract

`contracts/PaperNFT.sol` — ERC-721, one NFT per (paper, author_email) pair.
- Reuses SigstoreVerifier at `0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1` (Base Sepolia)
- Owner registers papers with authorized emails; can update later
- `tokenURI` returns IPFS metadata

## Setup

```bash
# 1. Extract metadata
python extract_metadata.py

# 2. Generate images (needs OPENAI_API_KEY)
python generate_images.py

# 3. Upload to IPFS (needs PINATA_JWT)
PINATA_JWT=... python upload_pinata.py

# 4. Deploy contract (needs forge + funded wallet)
# 5. Register papers
python register_papers.py
```

## Status

- [x] Email extraction (24/46 papers have emails, 22 need manual lookup)
- [ ] Image generation
- [ ] IPFS upload
- [ ] Contract deployment
- [ ] Workflow adaptation (email-challenge + email-verify)
- [ ] End-to-end test
