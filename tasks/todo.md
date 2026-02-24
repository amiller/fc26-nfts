# FC26 Rump Session TODOs

## Critical — Before Production
- [ ] **Pin commit SHA on-chain** — Call `setRequirements(bytes20)` on PaperNFT (0x3a9a..f1) with the tagged release commit. Currently `0x00` (disabled). Without this, anyone can fork the repo, run modified workflow code, and produce valid attestations that bypass the email challenge. This is the key security invariant for the "low authority" design.

## Soulbound-by-Reclaim
- [ ] **Implement email-reclaimable NFTs** — Remove standard transfers, add `reclaim()` using same email challenge protocol. See `tasks/soulbound-reclaim.md` for full plan and rump session talk outline.
