# FC26 Paper NFT — Handoff Notes

## What This Is
NFT system where FC'26 paper authors claim NFTs by proving email ownership via ZK-TLS (Sigstore + GitHub Actions). Based on github-zktls EmailNFT pattern.

## Current State

### Done
- **Email extraction**: `papers.json` has 46 papers, 24 with emails, 22 without (LNCS format)
- **AI artwork**: 46 images in `images/composited/` (Gemini-generated placeholders with title overlay)
- **IPFS**: All 46 uploaded to Pinata, CIDs in `ipfs_mapping.json`
- **Contract**: `PaperNFT.sol` deployed to Base Sepolia at `0x927248059289d1942c809D034D26fCef79c52d77`
  - Papers #5 and #26 registered with `socrates1024@gmail.com` for testing
  - Commit SHA restriction disabled (bytes20(0))
  - Reuses SigstoreVerifier at `0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1`
- **Workflows**: `.github/workflows/email-challenge.yml` and `email-verify.yml` adapted for paper NFTs
- **Artist briefs**: `artist_briefs.md` ready for human commissioning
- **VERSIONS.json**: Copied from github-zktls for prover reference

### NOT Done — Immediate Next Steps
1. **Push to GitHub** at `git@github.com:amiller/fc26-nfts.git`
2. **Set GitHub repo variables**:
   - `PAPER_NFT_ADDRESS` = `0x927248059289d1942c809D034D26fCef79c52d77`
3. **Set GitHub repo secrets** (same as github-zktls):
   - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `SES_FROM_EMAIL`
   - `RELAYER_PRIVATE_KEY` (deployer key from `~/.foundry/keystores/deployer.key`)
4. **End-to-end test**: Open issue with `[PAPER]` title, body: `paper_id: 5\nemail: socrates1024@gmail.com\nrecipient: 0x5A370b73385085091de23E0fD21B54F2724EAD8D`
5. **Register remaining 44 papers** on-chain via `register_papers.py` + cast commands

### NOT Done — Later
- **Missing emails**: 22 papers need email lookup (HotCRP data or ask authors)
- **Human artwork**: Use rentahuman.ai MCP server to commission artists (briefs ready)
- **Production deployment**: Set commit SHA restriction, deploy to mainnet
- **Frontend**: Nice claim UI (optional, issues work fine)

## Key Files
| File | Purpose |
|------|---------|
| `papers.json` | All paper metadata + extracted emails |
| `ipfs_mapping.json` | Paper ID → IPFS CIDs for images + metadata |
| `contracts/PaperNFT.sol` | The NFT contract (deployed) |
| `contracts/ISigstoreVerifier.sol` | Interface for existing verifier |
| `.github/workflows/email-challenge.yml` | Phase 1: send verification email |
| `.github/workflows/email-verify.yml` | Phase 2: verify + ZK proof + mint |
| `VERSIONS.json` | Prover version pinning |
| `extract_metadata.py` | PDF email extraction script |
| `generate_images.py` | Gemini image generation (already ran) |
| `upload_pinata.py` | IPFS upload (already ran) |
| `register_papers.py` | Generate cast commands for on-chain registration |
| `artist_briefs.md` | Per-paper visual concepts for human artists |
| `foundry.toml` | Forge config |

## Credentials & Addresses
- **Deployer**: `0x5A370b73385085091de23E0fD21B54F2724EAD8D` (key: `~/.foundry/keystores/deployer.key`, raw hex)
- **Contract**: `0x927248059289d1942c809D034D26fCef79c52d77` (Base Sepolia)
- **SigstoreVerifier**: `0xbD08fd15E893094Ad3191fdA0276Ac880d0FA3e1` (Base Sepolia)
- **Pinata**: Admin key `2b874fedc28d354aa24a` works for V1 pinning API
- **Gemini**: `AIzaSyDhAFsqXEsIPhmr31b3LJF6_eYM85y88W8`
- **Deploy command**: `cast send --create` (forge create has RPC routing issues)

## Workflow Changes from github-zktls EmailNFT
- Issue trigger: `[PAPER]` not `[EMAIL]`
- Issue body adds `paper_id: N`
- Certificate includes `paper_id` field, type `paper-authorship`
- Claim call: extra `uint256 paperId` argument
- Repo var: `PAPER_NFT_ADDRESS` not `EMAIL_NFT_ADDRESS`
- Contract checks email is authorized for the specific paper
