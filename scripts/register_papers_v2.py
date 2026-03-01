#!/usr/bin/env python3
"""Register all papers on the new PaperNFT contract with pre-hashed emails."""

import json, subprocess, sys, time
from eth_abi import encode
from eth_hash.auto import keccak

CONTRACT = "0x9091B8b6682FF90B80ef2Fc399467c9340cC9be5"
RPC_URL = "https://sepolia.base.org"
DEPLOYER = "0x5A370b73385085091de23E0fD21B54F2724EAD8D"

with open("papers_private.json") as f:
    papers = json.load(f)
with open("ipfs_mapping.json") as f:
    ipfs = json.load(f)

key = subprocess.check_output(["bash", "-c", "cat ~/.foundry/keystores/deployer.key"]).decode().strip()

def get_nonce():
    out = subprocess.check_output([
        "cast", "nonce", DEPLOYER, "--rpc-url", RPC_URL
    ], stderr=subprocess.DEVNULL).decode().strip()
    return int(out)

def is_registered(pid):
    out = subprocess.check_output([
        "cast", "call", CONTRACT, "paperMetadataURI(uint256)(string)", str(pid),
        "--rpc-url", RPC_URL
    ], stderr=subprocess.DEVNULL).decode().strip()
    return out != '""' and len(out) > 2

selector = keccak(b"registerPaper(uint256,bytes32[],string)")[:4]
registered = 0
skipped = 0

for p in papers:
    pid = p["id"]
    emails = p.get("emails", [])
    mapping = ipfs.get(str(pid))
    if not mapping:
        print(f"SKIP paper #{pid}: no IPFS mapping")
        skipped += 1
        continue

    if is_registered(pid):
        print(f"SKIP paper #{pid}: already registered")
        skipped += 1
        continue

    metadata_uri = mapping["metadata_uri"]
    email_hashes = [keccak(e.lower().encode()) for e in emails]
    encoded = encode(["uint256", "bytes32[]", "string"], [pid, email_hashes, metadata_uri])
    calldata = "0x" + selector.hex() + encoded.hex()

    nonce = get_nonce()
    print(f"Paper #{pid}: {len(emails)} emails, nonce={nonce}")
    result = subprocess.run([
        "cast", "send", CONTRACT, "--data", calldata,
        "--private-key", key, "--rpc-url", RPC_URL,
        "--nonce", str(nonce), "--confirmations", "1",
    ], capture_output=True, text=True)

    if result.returncode != 0:
        print(f"  ERROR: {result.stderr.strip()}")
        sys.exit(1)

    for line in result.stdout.split("\n"):
        if "transactionHash" in line:
            print(f"  tx: {line.split()[-1]}")
            break
    registered += 1
    time.sleep(3)

print(f"\nDone. Registered {registered}, skipped {skipped}.")
