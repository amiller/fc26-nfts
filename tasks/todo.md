# FC26 Rump Session TODOs

## Critical — Before Production
- [ ] **Pin commit SHA on-chain** — Call `setRequirements(bytes20)` on PaperNFT (0x3a9a..f1) with the tagged release commit. Currently `0x00` (disabled). Without this, anyone can fork the repo, run modified workflow code, and produce valid attestations that bypass the email challenge. This is the key security invariant for the "low authority" design.

## Relay Site (No GitHub Account Required)
- [ ] **Build auxiliary claim relay** — A simple web app that lets authors claim without a GitHub account. Accepts email + paper ID, runs the email challenge directly (not via GitHub Issues), and submits the on-chain claim. Needs its own server since it must guard an SES key (can't be pure client-side or GitHub Actions). Minimal trusted surface: just email routing + relay, same ZK proof verification on-chain.

## Soulbound-by-Reclaim
- [ ] **Implement email-reclaimable NFTs** — Remove standard transfers, add `reclaim()` using same email challenge protocol. See `tasks/soulbound-reclaim.md` for full plan and rump session talk outline.
