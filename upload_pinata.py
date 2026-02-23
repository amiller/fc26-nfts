#!/usr/bin/env python3
"""Upload paper images and NFT metadata to IPFS via Pinata."""

import json, os, requests

PAPERS_JSON = os.path.join(os.path.dirname(__file__), "papers.json")
IMAGES_DIR = os.path.join(os.path.dirname(__file__), "images")
OUT_FILE = os.path.join(os.path.dirname(__file__), "ipfs_mapping.json")

PINATA_API = "https://api.pinata.cloud"
PINATA_JWT = os.environ.get("PINATA_JWT", "")

def pin_file(path, name):
    with open(path, "rb") as f:
        resp = requests.post(
            f"{PINATA_API}/pinning/pinFileToIPFS",
            files={"file": (name, f)},
            headers={"Authorization": f"Bearer {PINATA_JWT}"},
        )
    resp.raise_for_status()
    return resp.json()["IpfsHash"]

def pin_json(data, name):
    resp = requests.post(
        f"{PINATA_API}/pinning/pinJSONToIPFS",
        json={"pinataContent": data, "pinataMetadata": {"name": name}},
        headers={
            "Authorization": f"Bearer {PINATA_JWT}",
            "Content-Type": "application/json",
        },
    )
    resp.raise_for_status()
    return resp.json()["IpfsHash"]

def main():
    assert PINATA_JWT, "Set PINATA_JWT env var"
    with open(PAPERS_JSON) as f:
        papers = json.load(f)

    mapping = {}
    for paper in papers:
        pid = paper["id"]
        img_path = os.path.join(IMAGES_DIR, f"{pid}.png")
        if not os.path.exists(img_path):
            print(f"#{pid}: no image, skipping")
            continue

        # Upload image
        print(f"#{pid}: uploading image...")
        img_cid = pin_file(img_path, f"fc26-paper-{pid}.png")

        # Create and upload metadata JSON
        metadata = {
            "name": f"FC26 Paper #{pid}: {paper['title']}",
            "description": f"Author attestation NFT for FC26 paper #{pid}. Authors: {paper['authors']}",
            "image": f"ipfs://{img_cid}",
            "attributes": [
                {"trait_type": "Paper ID", "value": pid},
                {"trait_type": "Session", "value": paper["session"]["title"] if paper.get("session") else "Unknown"},
                {"trait_type": "Conference", "value": "FC 2026"},
            ],
        }
        meta_cid = pin_json(metadata, f"fc26-paper-{pid}-metadata.json")

        mapping[str(pid)] = {
            "image_cid": img_cid,
            "metadata_cid": meta_cid,
            "metadata_uri": f"ipfs://{meta_cid}",
        }
        print(f"#{pid}: image={img_cid} meta={meta_cid}")

    with open(OUT_FILE, "w") as f:
        json.dump(mapping, f, indent=2)
    print(f"\nWrote {OUT_FILE} ({len(mapping)} papers)")

if __name__ == "__main__":
    main()
