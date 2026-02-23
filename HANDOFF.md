# FC'26 Rump Session NFT — Handoff Notes

## What This Is
Unofficial NFT system where FC'26 rump session paper authors claim NFTs by proving email ownership via GitHub-ZKTLS (Sigstore + GitHub Actions). No trusted server — everything runs in GitHub Actions with a pinned prover image.

**Repos**:
- NFTs: https://github.com/amiller/fc26-nfts
- GitHub-ZKTLS: https://github.com/amiller/github-zktls

## Current State: Working E2E

### Done
- **Contract V2**: `0x3a9a92e0b35d8c6c85ced8b92b6977a5b722f2f1` (Base Sepolia)
  - Name: "FC26 Rump Session NFT" / FC26RUMP
  - Stores salted email hash on-chain (not plaintext)
  - Papers #5, #14, #17, #26 registered; #5 and #26 claimed
- **GitHub Pages**: https://amiller.github.io/fc26-nfts/
  - Gallery with per-author claim status (X of Y claimed), NFT thumbnails, Blockscout links
  - Claim tab with client-side email hash check + pre-filled issue generation
  - "How this works" section with GitHub-ZKTLS paper link
- **Email privacy**:
  - `papers.json` has `email_hashes` (sha256), no plaintext
  - `papers_private.json` (gitignored) has real emails
  - `EMAIL_LOOKUP` GitHub secret maps hashes → emails for workflows
  - Issues contain only hashes; workflows resolve privately
- **Workflows**: All three working
  - `email-challenge.yml` — send verification email (hash-based)
  - `email-verify.yml` — ZK proof + mint
  - `update-claims.yml` — auto-update claims.json every 6h + after mints
- **AI artwork**: 46 images in `images/composited/`, served locally on GitHub Pages
- **IPFS**: All 46 uploaded to Pinata, CIDs in `ipfs_mapping.json`
- **GitHub secrets/variables**: All configured on `amiller/fc26-nfts`
- **README**: Rewritten with how-it-works, trust model, email privacy, missing-emails contact

### NOT Done — Next Steps
1. **Register remaining 42 papers** on-chain (from `papers_private.json`)
2. **Missing emails**: 22 papers need email lookup (HotCRP or ask authors)
3. **Human artwork**: Commission via rentahuman.ai (briefs in `artist_briefs.md`)
4. **Production deployment**: Set commit SHA restriction, consider mainnet
5. **"How this works" detail**: More detailed write-up, link to GitHub-ZKTLS paper on arXiv when ready
6. **Concept review**: Share with Joseph Bonneau and Stefanie Roos
   - Their test papers registered: #14 (stefanie.roos@cs.rptu.de, jbonneau@gmail.com), #17 (jbonneau@gmail.com)

## Key Files
| File | Purpose |
|------|---------|
| `index.html` | GitHub Pages claim + gallery UI |
| `papers.json` | Paper metadata + email hashes (public) |
| `papers_private.json` | Paper metadata + real emails (gitignored) |
| `claims.json` | On-chain claim events (auto-updated) |
| `ipfs_mapping.json` | Paper ID → IPFS CIDs |
| `contracts/PaperNFT.sol` | NFT contract (V2, deployed) |
| `.github/workflows/email-challenge.yml` | Phase 1: send verification email |
| `.github/workflows/email-verify.yml` | Phase 2: ZK proof + mint |
| `.github/workflows/update-claims.yml` | Refresh claims.json from chain |
| `scripts/update-claims.js` | Fetch Claimed events via RPC |
| `VERSIONS.json` | Prover version pinning |
| `favicon.svg` | FC26 RUMP favicon |

## Credentials & Addresses
- **Deployer**: `0x5A370b73385085091de23E0fD21B54F2724EAD8D` (key: `~/.foundry/keystores/deployer.key`, raw hex)
- **Contract V2**: `0x3a9a92e0b35d8c6c85ced8b92b6977a5b722f2f1`
- **SigstoreVerifier**: `0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1`
- **SES sender**: `noreply@teemail.soc1024.com`
- **AWS region**: `us-east-2`
- **GitHub-ZKTLS paper**: https://www.overleaf.com/read/vmwnhsrmbdgc#fd334b

## Email Hash Schemes
Two different hashes are used:
1. **papers.json + EMAIL_LOOKUP** (client-side + workflow): `sha256("FC26-rump-session-2026" + email)`
2. **On-chain** (contract storage): `keccak256(EMAIL_SALT, email)` where `EMAIL_SALT = keccak256("FC26-rump-session-2026")`

When adding a new author email, update: `papers_private.json` → regenerate `papers.json` hashes → update `EMAIL_LOOKUP` secret → register on-chain via `registerPaper()`.
