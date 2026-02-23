# FC26 Rump Session NFT — Handoff Notes

## What This Is
NFT system where FC'26 rump session paper authors claim NFTs by proving email ownership via ZK-TLS (Sigstore + GitHub Actions).

## Current State

### Done
- **Email extraction**: `papers.json` has 46 papers with email hashes (no plaintext). `papers_private.json` (gitignored) has real emails.
- **AI artwork**: 46 images in `images/composited/` (Gemini-generated placeholders with title overlay)
- **IPFS**: All 46 uploaded to Pinata, CIDs in `ipfs_mapping.json`
- **Contract V2**: `PaperNFT.sol` deployed to Base Sepolia at `0x3a9a92e0b35d8c6c85ced8b92b6977a5b722f2f1`
  - Name: "FC26 Rump Session NFT", symbol: "FC26RUMP"
  - Stores salted email hash on-chain (not plaintext)
  - Papers #5, #14, #17 registered for testing
  - Commit SHA restriction disabled (bytes20(0))
  - Reuses SigstoreVerifier at `0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1`
- **Workflows**: `.github/workflows/email-challenge.yml` and `email-verify.yml`
- **GitHub secrets/variables**: All configured on `amiller/fc26-nfts`
- **E2E test**: Paper #5 successfully claimed on V1 (need to re-test on V2)

### NOT Done — Immediate Next Steps
1. **E2E test on V2 contract** — open a new `[PAPER]` issue to verify the updated contract works
2. **Register remaining 43 papers** on-chain (need `papers_private.json` emails)
3. **Tidy repo for concept review** — Joseph Bonneau and Stefanie Roos will review

### NOT Done — Later
- **Missing emails**: 22 papers need email lookup (HotCRP data or ask authors)
- **Human artwork**: Use rentahuman.ai MCP server to commission artists (briefs ready)
- **Production deployment**: Set commit SHA restriction, deploy to mainnet
- **Frontend**: Nice claim UI (optional, issues work fine)

## Key Files
| File | Purpose |
|------|---------|
| `papers.json` | Paper metadata + email hashes (public) |
| `papers_private.json` | Paper metadata + real emails (gitignored) |
| `ipfs_mapping.json` | Paper ID → IPFS CIDs for images + metadata |
| `contracts/PaperNFT.sol` | The NFT contract (V2, deployed) |
| `contracts/ISigstoreVerifier.sol` | Interface for existing verifier |
| `.github/workflows/email-challenge.yml` | Phase 1: send verification email |
| `.github/workflows/email-verify.yml` | Phase 2: verify + ZK proof + mint |
| `VERSIONS.json` | Prover version pinning |
| `artist_briefs.md` | Per-paper visual concepts for human artists |

## Email Privacy Design
- `papers.json` stores `email_hashes` (sha256 of `"FC26-rump-session-2026" + email`)
- On-chain `registerPaper()` takes plaintext emails, stores only `keccak256` hashes
- On-chain `claim()` stores `keccak256(EMAIL_SALT, email)` in `tokenEmailHash`
- `EMAIL_SALT = keccak256("FC26-rump-session-2026")` (constant in contract)
- Claim calldata contains email plaintext (needed for verification), but not indexed or stored

## Credentials & Addresses
- **Deployer**: `0x5A370b73385085091de23E0fD21B54F2724EAD8D` (key: `~/.foundry/keystores/deployer.key`, raw hex)
- **Contract V2**: `0x3a9a92e0b35d8c6c85ced8b92b6977a5b722f2f1` (Base Sepolia)
- **Contract V1** (deprecated): `0x927248059289d1942c809D034D26fCef79c52d77`
- **SigstoreVerifier**: `0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1` (Base Sepolia)
- **Deploy command**: `cast send --create` (forge create has RPC routing issues)
