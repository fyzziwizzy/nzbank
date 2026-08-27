---
name: eyeball
description: 'Document analysis with inline source screenshots. When you ask Copilot to analyze a document, Eyeball generates a Word doc where every factual claim includes a highlighted screenshot from the source material so you can verify it with your own eyes.'
author: GitHub Copilot (adapted)
version: 1.0.0
created: 2026-08-27
license: MIT
---

# Eyeball

Analyze documents with visual proof. When activated, Eyeball produces a Word document where every factual assertion includes an inline screenshot from the source material with the cited text highlighted, enabling verification of claims with visual evidence.

## Activation

When the user invokes this skill (e.g., "use eyeball", "run eyeball on this", "eyeball this document", "analyze with eyeball"), respond with:

> **Eyeball is active.** I'll analyze the document and produce a Word doc with inline source screenshots so you can verify every claim with your own eyes.

Then follow the workflow below.

## Supported Sources

- **Local files:** Word documents (.docx, .doc), PDFs (.pdf), RTF files, Markdown files
- **Web URLs:** Any publicly accessible web page
- **Cloud files:** SharePoint and OneDrive documents (via authenticated links)

## Tool Location

The Eyeball utility is designed to work with Copilot's native document and browser capabilities for screenshot generation and Word document authoring.

## Workflow

Follow these steps exactly. The order matters.

### Step 1: Read the source text

Before writing any analysis, extract and read the full text of the source document:

1. Use native Copilot tools to fetch document content
2. Extract and carefully read the full text
3. Identify actual section numbers, headings, page numbers, and key language

**CRITICAL:** Do not skip this step. Do not write analysis based on assumptions about how the document is structured. Read the actual text.

### Step 2: Write analysis with exact citations

For each point in your analysis, you must:

1. **Reference the correct section number as it appears in the document** (e.g., "Section 9" not "Section 8" because you assumed the numbering).
2. **Reference the correct page number or location** where the section appears in the source.
3. **Select anchors that are verbatim phrases from the source** that directly support your claim.

### Step 3: Select anchors correctly

This is the most important step. Anchors determine what gets highlighted in the screenshots.

**DO:**
- Use verbatim phrases from the source text that directly support your assertion
- Use multiple anchors to span the full range of text the reader should see
- Use specific, uncommon phrases that appear only where you intend

**DO NOT:**
- Use generic topic labels (e.g., "Confidentiality") that appear throughout the document
- Use section titles alone when they appear as cross-references elsewhere
- Use single common words that match in many places

**Examples:**

WRONG -- uses a generic topic label that matches everywhere:
```
Anchor: "User-Generated Content"
Problem: This phrase appears multiple times; unclear which section to highlight
```

RIGHT -- uses the specific language that supports the claim:
```
Anchors: "retain ownership", "Ownership of Content, Right to Post"
Problem solved: These exact phrases together pinpoint the specific clause
```

WRONG -- section title appears as a cross-reference on earlier pages:
```
Anchor: "LIMITATION OF LIABILITY"
Problem: Appears as cross-reference before actual section
```

RIGHT -- includes the section number for precision, targets the correct page:
```
Anchors: "12. LIMITATION OF LIABILITY", "INDIRECT", "CONSEQUENTIAL"
Problem solved: Section number + specific terms = correct location
```

### Step 4: Build the analysis document

Construct the analysis sections with precise citations and use Copilot's Word document tools to create the output:

Structure each section with:
- **Heading:** Clear section title in the output document
- **Analysis:** Your analysis text with citations to source location
- **Anchors:** Verbatim phrases from source for visual highlighting
- **Target Location:** Page number or section reference

Example section:

```
Heading: "1. Ownership & Copyright Provisions"
Analysis: "The document grants users conditional ownership. Section 4 on page 8 states that users retain ownership of user-generated content while granting the platform certain rights."
Anchors: ["retain ownership", "Ownership of Content", "users own"]
Target: Page 8
```

### Step 5: Generate the Word document

Use Copilot's Word document creation capability to:
1. Create a new document with title and metadata
2. Insert analysis sections with proper formatting
3. Attach screenshots with highlighted source text
4. Ensure visual proof appears inline with each claim
5. Save to user's desired location

---

## Analysis Best Practices

1. **Always cite source locations** - Section number + page for clarity
2. **Use visual evidence** - Every factual claim should have a screenshot
3. **Highlight precisely** - Focus highlight box on the exact supporting text
4. **Group related claims** - Organize by theme, not source order
5. **Flag contradictions** - When document contains conflicting statements
6. **Mark uncertainty** - If text is ambiguous, note the ambiguity

---

## Triggers

Activate this skill when the user asks to:
- "Eyeball this document"
- "Analyze with eyeball"
- "Use eyeball on this"
- "Create a verified analysis"
- "Analyze with screenshots"
- "Prove every claim in this document"
- "Create a document analysis with visual proof"
