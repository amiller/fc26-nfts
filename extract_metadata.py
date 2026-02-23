#!/usr/bin/env python3
"""Extract paper metadata + author emails from FC26 preproceedings PDFs."""

import json, re, sys, os
import importlib.util, fitz
_spec = importlib.util.spec_from_file_location("bp", os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "build-preproceedings.py")))
_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mod)
PAPER_TITLES, PAPER_AUTHORS, SESSIONS = _mod.PAPER_TITLES, _mod.PAPER_AUTHORS, _mod.SESSIONS

PDF_DIR = os.path.join(os.path.dirname(__file__), "..", "preproceedings")
EMAIL_RE = re.compile(r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}')
# Grouped email patterns like {a,b,c}@domain
GROUPED_RE = re.compile(r'\{([a-zA-Z0-9._%+\-,\s]+)\}@([a-zA-Z0-9.\-]+\.[a-zA-Z]{2,})')

def extract_emails_from_pdf(pdf_path, max_pages=2):
    doc = fitz.open(pdf_path)
    text = ""
    for i in range(min(max_pages, len(doc))):
        text += doc[i].get_text()
    doc.close()

    emails = set()
    # Expand grouped emails first
    for match in GROUPED_RE.finditer(text):
        names = [n.strip() for n in match.group(1).split(",")]
        domain = match.group(2)
        for name in names:
            if name:
                emails.add(f"{name}@{domain}")
    # Then find individual emails
    for match in EMAIL_RE.finditer(text):
        emails.add(match.group().lower().rstrip('.'))

    # Filter out obvious non-author emails
    filtered = set()
    for e in emails:
        if any(x in e for x in ['doi.org', 'creativecommons', 'springer', 'iacr.org']):
            continue
        filtered.add(e)
    return sorted(filtered)

def get_session_for_paper(paper_id):
    for num, title, day, time, chair, papers in SESSIONS:
        if paper_id in papers:
            return {"number": num, "title": title.replace("\\&", "&").replace("---", "—")}
    return None

def main():
    papers = []
    total_emails = 0
    missing = []

    for paper_id in sorted(PAPER_TITLES.keys()):
        pdf_path = os.path.join(PDF_DIR, f"{paper_id}.pdf")
        emails = extract_emails_from_pdf(pdf_path) if os.path.exists(pdf_path) else []
        session = get_session_for_paper(paper_id)

        paper = {
            "id": paper_id,
            "title": PAPER_TITLES[paper_id],
            "authors": PAPER_AUTHORS[paper_id],
            "emails": emails,
            "session": session,
        }
        papers.append(paper)
        total_emails += len(emails)
        if not emails:
            missing.append(paper_id)
        print(f"#{paper_id}: {len(emails)} emails — {PAPER_TITLES[paper_id][:60]}")

    out_path = os.path.join(os.path.dirname(__file__), "papers.json")
    with open(out_path, "w") as f:
        json.dump(papers, f, indent=2, ensure_ascii=False)

    print(f"\n{len(papers)} papers, {total_emails} total emails")
    if missing:
        print(f"Missing emails for: {missing}")
    print(f"Wrote {out_path}")

if __name__ == "__main__":
    main()
