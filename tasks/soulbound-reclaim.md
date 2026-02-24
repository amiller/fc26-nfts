# Soulbound-by-Reclaim: Design & Rump Session Talk

## Core Thesis
"Soulbound" is not a binary property — it's relative to the stickiness of the identity that can reclaim the token. A non-transferable NFT bound to a key is key-bound, not soul-bound. A transferable NFT with email reclaim is *more* soulbound because the binding is to a stickier identity layer.

## Hierarchy of Binding Strength
- Key-bound (standard NFT, even if non-transferable) — weakest, key = bearer
- Email-bound (reclaim by email proof) — stickier, tied to identity via provider
- Government-ID-bound — stickier still
- Biometric-bound — stickiest

Non-transferable + no reclaim is actually the worst case: if key is lost or stolen, the "soul" has no recourse.

## Contract Changes
- [ ] Remove or disable `transferFrom`, `approve`, `setApprovalForAll` (revert with custom error)
- [ ] Add `reclaim(proof, publicInputs, certificate, paperId, email, newAddress)` — reuses the same Sigstore email challenge protocol as `claim()`
- [ ] `reclaim` looks up existing tokenId from `claimKey = keccak256(paperId, emailLower)`, verifies proof, moves token to `newAddress`
- [ ] Keep ERC-721 `ownerOf`/`balanceOf` bookkeeping correct on reclaim
- [ ] Consider: should reclaim require a new challenge each time, or accept any valid recent attestation?

## Workflow Changes
- [ ] Support reclaim issues (maybe `[RECLAIM]` tag) or reuse `[PAPER]` flow with detection that token already exists
- [ ] Same email challenge protocol — no new infrastructure needed

## Rump Session Talk Outline
1. "Soulbound tokens" as proposed are just non-transferable — bound to a key, not a soul
2. Key loss/theft breaks the binding permanently — no recourse
3. Real soulbinding requires a *stickier claim* that can override the current holder
4. Our design: email-reclaimable NFTs via ZK-TLS
   - Same protocol for mint and recovery
   - The email is the "soul," the key is just a convenience
   - Strictly more soulbound than non-transferable
5. Generalizes: soulboundness is a spectrum based on identity stickiness
6. Live demo: reclaim an NFT to a new address

## Open Questions
- Should there be a time delay on reclaim (to prevent email compromise from being instant)?
- Should the old holder be notified somehow?
- Does this framing apply to other SBT proposals? (What's their "stickier claim"?)
- Relationship to account abstraction / social recovery wallets?
