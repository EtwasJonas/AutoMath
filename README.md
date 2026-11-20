# AutoMath – Formula Workshop for PowerPoint

🌍 **Deutsch?** → [README.de.md](README.de.md)

For tutoring in engineering mathematics (electrical engineering): **Paste a screenshot (`Ctrl+V`) → the AI reads the formula (OCR) → live preview → one click to copy → into PowerPoint as a native, editable equation.**

## Use it online

**▶ https://etwasjonas.github.io/AutoMath/**

No installation needed – the page is a single HTML file served via GitHub Pages (works in any modern browser). To use it fully offline (e.g. during lectures), download [`AutoMath.html`](https://github.com/EtwasJonas/AutoMath/raw/main/AutoMath.html) and open it by double-clicking – everything is embedded; only the first OCR model download needs internet.

## Quick start

1. Open `AutoMath.html` by double-clicking (a single file – library and fonts are embedded).
2. **Paste a screenshot:** `Win + Shift + S` over the formula in your script → press `Ctrl + V` in AutoMath – recognition starts automatically and inserts the LaTeX into the editor (OCR with TexTeller3, runs in the browser; the first use downloads ~250 MB of model data, afterwards it works offline from the cache). Alternatively, type LaTeX directly, e.g. `F(s) = \int_{0}^{\infty} f(t)\,e^{-st}\,dt`
   - `$…$` / `$$…$$` are stripped automatically when pasted.
   - Symbol palette above the input field; formula library (fundamentals, phasors, Laplace, Fourier, ODEs, matrices/fields, structure) insertable with one click.
3. Click **“Copy for PowerPoint”** (or `Ctrl+Enter`).
4. In PowerPoint, press `Ctrl+V` → you get a **real Office equation** (editable, scales sharply, Cambria Math look).

The interface starts in **English** and can be switched to **German** at any time using the EN/DE switch in the header – the choice is remembered.

## Three ways into PowerPoint

| Way | How | Result |
|---|---|---|
| 1 · MathML (default) | “Copy for PowerPoint” → `Ctrl+V` on the slide. If it lands as text: *Home → Paste → Paste Special → MathML* | Native equation, editable |
| 2 · LaTeX directly (M365 from build 2606/2026) | “Copy LaTeX with $$ … $$” → paste on the slide; or in PowerPoint `Alt+=` → switch the Equation ribbon to **{}LaTeX** → paste the code → `Ctrl+Alt+=` (Convert) | Native equation, editable |
| 3 · PNG (fallback) | “Copy PNG” or “Download PNG” (transparent, 3× resolution) | Image, not editable |

Sources on the Office support behind this:
- LaTeX support: <https://learn.microsoft.com/en-us/office/math/latex>
- MathML import (element by element): <https://learn.microsoft.com/en-us/office/math/mathml>
- Announcement: <https://techcommunity.microsoft.com/blog/microsoft365insiderblog/from-latex-to-accessible-pdfs-transforming-math-workflows-in-microsoft-365/4523506>

## Formulas from scripts / books (OCR) — built in!

1. Copy a screenshot of the formula (`Win + Shift + S`, rectangular snip – the result is on your clipboard automatically).
2. Press `Ctrl + V` in AutoMath (or drop the image / pick a file) – recognition starts by itself.
3. The AI **TexTeller3** reads the formula and inserts the LaTeX into the editor.
4. Double-check against the original → **“Copy for PowerPoint”** → `Ctrl+V` on the slide.

- Recognition runs **locally in the browser** – on the GPU (WebGPU) when available, otherwise on the CPU. On first use the model (~200–250 MB, quantized) is downloaded and kept in the browser cache – afterwards OCR also works offline. Images are auto-cropped to the formula ink and padded to a square (aspect-preserving) before recognition.
- For handwriting or difficult cases: [OpenMathpix](https://github.com/JhuoW/OpenMathpix) (offline, free) – the LaTeX lands on your clipboard, simply paste it into AutoMath. Other alternatives: [Mathpix Snip](https://mathpix.com) (Freemium), [mathcheap.xyz](https://mathcheap.xyz), [imagetolatex.com](https://imagetolatex.com).

## History & storage

- Every copied formula lands in the **history** (click to reload, ✕ to delete).
- The current formula, the history and the OCR model live in your browser (`localStorage`/cache) – formula images never leave your computer.

## Project structure

```
AutoMath/
├── AutoMath.html              ← the finished app (share/use standalone)
├── build.ps1                  ← rebuilds AutoMath.html
├── src/AutoMath.template.html ← app source (placeholders for Temml)
└── vendor/                    ← Temml 0.14 (MathML renderer) + Cambria-Math CSS + font
```

After changing `src/AutoMath.template.html`:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

## Technical notes

- Rendering: [Temml](https://temml.org/) → Presentation MathML; preview in **Cambria Math** (= the same font as PowerPoint equations → WYSIWYG).
- The MathML copy version is cleaned automatically (xmlns ensured, `display="block"` in display mode, CSS classes/styles removed) – exactly matching Microsoft 365’s MathML 3 import (from version 2606/16.110; older versions support parts of it).
- PNG export: MathML → SVG(foreignObject) → canvas, 3× scale, transparent background.
- OCR: [TexTeller3](https://huggingface.co/onnx-community/TexTeller3-ONNX) (Apache-2.0, ViT encoder 448×448 + TrOCR decoder, q4-quantized) via [transformers.js](https://github.com/huggingface/transformers.js) in the browser. The transformers.js library loads from the CDN once, the model from Hugging Face (both kept in the browser cache). Screenshots are auto-cropped to the formula ink and converted to grayscale (1 channel) before inference.
- Language: English (default) and German, switchable in the header, stored per browser.

## Ideas for the future

- Persistent, user-editable formula library; “pin formula” button.
- Batch workflow: recognise many screenshots in a row with a “next” button.
- Multi-line formulas and whole script pages.
