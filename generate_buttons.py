#!/usr/bin/env python3
"""Generate retro-dithered nav buttons and banner matching FC99 Expedition theme."""

import os, numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter

OUT_DIR = os.path.join(os.path.dirname(__file__), "buttons")
FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf"

BUTTONS = [
    ("gallery", "Gallery"),
    ("claim_nft", "Claim NFT"),
    ("protocol", "Protocol"),
    ("github", "GitHub"),
    ("github-zktls", "Github-ZKTLS"),
    ("blockscout", "Blockscout"),
]

def brown_texture(width, height):
    """Generate a warm brown noise texture similar to the FrontPage Expedition theme."""
    # Generate at half res then upscale with blur for chunky dithered look
    hw, hh = width // 2, height // 2
    base = np.array([160, 100, 50], dtype=np.float64)
    lum = np.random.normal(0, 25, (hh, hw, 1))
    tex_small = np.clip(base + lum * (base / base.max()), 0, 255).astype(np.uint8)
    img = Image.fromarray(tex_small).resize((width, height), Image.BILINEAR)
    img = img.filter(ImageFilter.GaussianBlur(radius=1.2))
    tex = np.array(img)
    return Image.fromarray(tex)

def add_border(img):
    draw = ImageDraw.Draw(img)
    w, h = img.size
    # Outer black line
    draw.rectangle([0, 0, w-1, h-1], outline=(10, 8, 5))
    draw.rectangle([1, 1, w-2, h-2], outline=(10, 8, 5))
    # Inner highlight (tan/gold bevel)
    draw.rectangle([2, 2, w-3, h-3], outline=(190, 160, 110))
    draw.rectangle([3, 3, w-4, h-4], outline=(170, 140, 90))
    return img

def render_text(img, text, font):
    draw = ImageDraw.Draw(img)
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (img.width - tw) // 2
    y = (img.height - th) // 2 - bbox[1]
    draw.text((x, y), text, font=font, fill=(240, 230, 200))
    return img

def to_gif(img):
    return img.quantize(colors=64, dither=1)

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    btn_font = ImageFont.truetype(FONT_PATH, 16)
    banner_font = ImageFont.truetype(FONT_PATH, 28)

    for fname, label in BUTTONS:
        out_path = os.path.join(OUT_DIR, fname + ".gif")
        img = brown_texture(150, 50)
        add_border(img)
        render_text(img, label, btn_font)
        to_gif(img).save(out_path)
        print(f"  {fname}.gif")

    img = brown_texture(600, 60)
    add_border(img)
    render_text(img, "FC26 Rump Session NFT", banner_font)
    to_gif(img).save(os.path.join(OUT_DIR, "banner.gif"))
    print("  banner.gif")

if __name__ == "__main__":
    main()
