# TEE Claim Flow

## Overview
The claim page offers two paths to claim an NFT:

1. **GitHub Issue (original)** — User opens a GitHub issue manually, GitHub Action sends verification email, user replies with code on GitHub
2. **TEE Claim (new)** — User clicks a button, TEE enclave creates the GitHub issue and posts the verification comment on their behalf. No GitHub account needed.

## How it works

### Architecture
- The TEE is a Phala CVM enclave running `oauth3-enclave` with a custom capability plugin
- The claim page calls the enclave's `/invoke/:permit_id` endpoint with a bearer token
- Two capabilities: `claim` (creates the issue + sends email) and `verify` (posts the code as a comment)

### Flow
```
Browser                          TEE Enclave                    GitHub
  |                                  |                            |
  |-- POST /invoke (claim) --------->|                            |
  |                                  |-- Create issue ----------->|
  |                                  |-- Send verification email  |
  |<-- {issue_number, url} ----------|                            |
  |                                  |                            |
  | [user checks email for code]     |                            |
  |                                  |                            |
  |-- POST /invoke (verify) -------->|                            |
  |                                  |-- Post comment w/ code --->|
  |<-- {comment_url} ----------------|                            |
  |                                  |                            |
  |                          GitHub Action triggers, mints NFT    |
```

### Auth
- Bearer token is embedded in the page (public by design)
- Rate limiting is handled by the custom capability code inside the enclave
- The TEE holds the GitHub token as a secret — callers never see it

### Endpoints
```
POST {TEE_BASE}/invoke/{PERMIT_ID}
Authorization: Bearer {TEE_BEARER}
Content-Type: application/json

# Claim
{"capability": "claim", "args": ["<paper_id>", "<email_hash>", "<recipient>"]}
→ {"result": {"issue_number": 42, "url": "https://github.com/..."}}

# Verify
{"capability": "verify", "args": ["<issue_number>", "<code>"]}
→ {"result": {"comment_url": "https://github.com/..."}}
```

### Graceful degradation
- On page load, `/health` is pinged
- If TEE is down, only the GitHub issue link is shown (same as before)

## Test paper
Paper #999 (`test@example.com`) is available for testing the flow.
Email hash: `38f90ff94aaaf1e06b173e35eca7a9e67d348310856a16153fa569d505c040f5`
Salt: `FC26-rump-session-2026`
