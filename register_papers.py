#!/usr/bin/env python3
"""Generate the cast commands to register papers on-chain.
Papers with no extracted emails get registered with empty email lists —
owner can call registerPaper again later to add them."""

import json, os

PAPERS_JSON = os.path.join(os.path.dirname(__file__), "papers.json")
IPFS_MAPPING = os.path.join(os.path.dirname(__file__), "ipfs_mapping.json")

def main():
    with open(PAPERS_JSON) as f:
        papers = json.load(f)

    ipfs = {}
    if os.path.exists(IPFS_MAPPING):
        with open(IPFS_MAPPING) as f:
            ipfs = json.load(f)

    with_emails = [p for p in papers if p["emails"]]
    without_emails = [p for p in papers if not p["emails"]]

    print(f"Papers with emails: {len(with_emails)}")
    print(f"Papers without emails (register later): {len(without_emails)}")
    print()

    # Generate individual registerPaper calls
    for paper in papers:
        pid = paper["id"]
        emails = paper["emails"]
        uri = ipfs.get(str(pid), {}).get("metadata_uri", "")
        emails_arr = "[" + ",".join(f'"{e}"' for e in emails) + "]"
        print(f'# Paper #{pid}: {paper["title"][:60]}')
        print(f'# Authors: {paper["authors"]}')
        if not emails:
            print(f"# WARNING: No emails extracted — register later")
        print(f'cast send $CONTRACT "registerPaper(uint256,string[],string)" {pid} "{emails_arr}" "{uri}"')
        print()

    print("# --- Papers needing email lookup ---")
    for p in without_emails:
        print(f"# #{p['id']}: {p['title'][:60]} — {p['authors']}")

if __name__ == "__main__":
    main()
