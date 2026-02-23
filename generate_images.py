#!/usr/bin/env python3
"""Generate AI artwork for each FC26 paper using Gemini image generation."""

import json, os, time, base64, requests

PAPERS_JSON = os.path.join(os.path.dirname(__file__), "papers.json")
OUT_DIR = os.path.join(os.path.dirname(__file__), "images")

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "AIzaSyDhAFsqXEsIPhmr31b3LJF6_eYM85y88W8")
MODEL = "gemini-2.0-flash-exp-image-generation"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent?key={GEMINI_API_KEY}"

def generate_image(title):
    prompt = (
        f'Create a purely abstract scientific illustration inspired by the concept: "{title}". '
        f'The image must contain absolutely NO text, NO words, NO letters, NO numbers, NO labels whatsoever. '
        f'Style: elegant geometric patterns, flowing lines, node networks, subtle color gradients. '
        f'Dark background (#0a0a1a) with luminous cyan, magenta, and gold accents. '
        f'Think data visualization art meets constellation maps.'
    )
    resp = requests.post(URL, json={
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"responseModalities": ["IMAGE", "TEXT"]},
    })
    resp.raise_for_status()
    for part in resp.json()["candidates"][0]["content"]["parts"]:
        if "inlineData" in part:
            return base64.b64decode(part["inlineData"]["data"])
    return None

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    with open(PAPERS_JSON) as f:
        papers = json.load(f)

    for paper in papers:
        pid = paper["id"]
        out_path = os.path.join(OUT_DIR, f"{pid}.png")
        if os.path.exists(out_path):
            print(f"#{pid}: already exists, skipping")
            continue
        print(f"#{pid}: generating... {paper['title'][:50]}")
        img_data = generate_image(paper["title"])
        if img_data:
            with open(out_path, "wb") as f:
                f.write(img_data)
            print(f"#{pid}: saved {len(img_data)} bytes")
        else:
            print(f"#{pid}: NO IMAGE returned")
        time.sleep(3)

    print(f"\nDone. Images in {OUT_DIR}/")

if __name__ == "__main__":
    main()
