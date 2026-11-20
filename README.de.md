# AutoMath – Formel-Werkstatt für PowerPoint

🌍 **English version:** [README.md](README.md)

Für Tutorien in HM 1 (Elektrotechnik): **Screenshot einfügen (`Strg+V`) → die KI liest die Formel (OCR) → Live-Vorschau → ein Klick kopieren → in PowerPoint als native, editierbare Formel einfügen.**

## Online nutzen

**▶ https://etwasjonas.github.io/AutoMath/**

Keine Installation nötig – die Seite ist eine einzelne HTML-Datei via GitHub Pages (läuft in jedem modernen Browser). Für die komplett offline Nutzung (z. B. im Tutorium) [`AutoMath.html`](https://github.com/EtwasJonas/AutoMath/raw/main/AutoMath.html) herunterladen und per Doppelklick öffnen – alles ist eingebettet; nur der erste OCR-Modell-Download braucht Internet.

## Schnellstart

1. `AutoMath.html` per Doppelklick öffnen (eine einzige Datei – Bibliothek und Schrift sind eingebettet).
2. **Screenshot einfügen:** `Win + Shift + S` über die Formel im Skript → in AutoMath `Strg + V` – die Erkennung startet automatisch und übernimmt das LaTeX in den Editor (OCR mit TexTeller3, läuft im Browser; beim ersten Mal werden ~250 MB Modell geladen, danach läuft es offline aus dem Cache). Alternativ LaTeX direkt tippen, z. B. `F(s) = \int_{0}^{\infty} f(t)\,e^{-st}\,dt`
   - `$…$` / `$$…$$` beim Einfügen werden automatisch entfernt.
   - Zeichen-Palette über dem Eingabefeld; Formelbibliothek (Grundlagen, Zeiger, Laplace, Fourier, DGL, Matrizen/Felder, Struktur) per Klick einfügbar.
3. **„Für PowerPoint kopieren"** klicken (oder `Strg+Enter`).
4. In PowerPoint `Strg+V` → es entsteht eine **echte Office-Formel** (editierbar, skaliert scharf, Cambria-Math-Look).

Die Oberfläche startet auf **Englisch** und lässt sich über den EN/DE-Schalter im Kopfbereich jederzeit auf **Deutsch** umstellen – die Wahl wird gemerkt.

## Drei Wege nach PowerPoint

| Weg | Wie | Ergebnis |
|---|---|---|
| 1 · MathML (Standard) | „Für PowerPoint kopieren" → `Strg+V` auf der Folie. Falls es als Text landet: *Start → Einfügen → Inhalte einfügen → MathML* | Native Formel, editierbar |
| 2 · LaTeX direkt (M365 ab Build 2606/2026) | „LaTeX mit $$ … $$ kopieren" → auf der Folie einfügen; alternativ in PowerPoint `Alt+=` → im Formel-Menüband auf **{}LaTeX** umstellen → Code einfügen → `Strg+Alt+=` (Konvertieren) | Native Formel, editierbar |
| 3 · PNG (Fallback) | „PNG kopieren" oder „PNG herunterladen" (transparent, 3× Auflösung) | Bild, nicht editierbar |

Quellen zur Office-Unterstützung:
- LaTeX-Unterstützung: <https://learn.microsoft.com/de-de/office/math/latex>
- MathML-Import (elementgenau): <https://learn.microsoft.com/en-us/office/math/mathml>
- Announcement: <https://techcommunity.microsoft.com/blog/microsoft365insiderblog/from-latex-to-accessible-pdfs-transforming-math-workflows-in-microsoft-365/4523506>

## Formeln aus Skript / Buch (OCR) — integriert!

1. Screenshot der Formel kopieren (`Win + Shift + S` – „Rechteckiger Ausschnitt", Ergebnis ist automatisch in der Zwischenablage).
2. In AutoMath `Strg + V` drücken (oder Bild in die Dropzone ziehen / Datei wählen) – die Erkennung startet von selbst.
3. Die KI **TexTeller3** liest die Formel und übernimmt das LaTeX in den Editor.
4. Kurz gegen das Original prüfen → **„Für PowerPoint kopieren"** → `Strg+V` auf der Folie.

- Die Erkennung läuft **lokal im Browser** – auf der GPU (WebGPU), falls verfügbar, sonst auf der CPU. Beim ersten Mal wird das Modell (~200–250 MB, quantisiert) heruntergeladen und im Browser-Cache behalten – danach funktioniert OCR auch offline. Bilder werden vor der Erkennung automatisch auf den Formelinhalt zugeschnitten und seitenverhältnistreu auf ein Quadrat aufgefüllt.
- Für Handschrift oder schwierige Fälle: [OpenMathpix](https://github.com/JhuoW/OpenMathpix) (offline, gratis) – das LaTeX landet in der Zwischenablage, einfach in AutoMath einfügen. Weitere Alternativen: [Mathpix Snip](https://mathpix.com) (Freemium), [mathcheap.xyz](https://mathcheap.xyz), [imagetolatex.com](https://imagetolatex.com).

## Verlauf & Speicherung

- Jede kopierte Formel landet im **Verlauf** (Klick lädt sie zurück, ✕ löscht).
- Aktuelle Formel, Verlauf und OCR-Modell liegen lokal im Browser (`localStorage`/Cache) – Formelbilder verlassen den Rechner nicht.

## Projektstruktur

```
AutoMath/
├── AutoMath.html              ← die fertige App (einzeln verteilen/nutzen)
├── build.ps1                  ← baut AutoMath.html neu
├── src/AutoMath.template.html ← Quellcode der App (Platzhalter für Temml)
└── vendor/                    ← Temml 0.14 (MathML-Renderer) + Cambria-Math-CSS + Schrift
```

Nach Änderungen an `src/AutoMath.template.html`:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

## Technik-Notizen

- Rendering: [Temml](https://temml.org/) → Presentation MathML; Vorschau mit **Cambria Math** (= dieselbe Schrift wie PowerPoint-Formeln → WYSIWYG).
- Die Kopier-Version des MathML wird automatisch bereinigt (xmlns gesichert, `display="block"` bei Anzeigeformel, CSS-Klassen/Styles entfernt) – exakt passend zum MathML-3-Import von Microsoft 365 (ab Version 2606/16.110; ältere Versionen unterstützen Teile davon).
- PNG-Export: MathML → SVG(foreignObject) → Canvas, 3× skaliert, transparenter Hintergrund.
- OCR: [TexTeller3](https://huggingface.co/onnx-community/TexTeller3-ONNX) (Apache-2.0, ViT-Encoder 448×448 + TrOCR-Decoder, q4-quantisiert) via [transformers.js](https://github.com/huggingface/transformers.js) im Browser. Die transformers.js-Bibliothek lädt einmalig vom CDN, das Modell von Hugging Face (beide im Browser-Cache). Screenshots werden vor der Erkennung automatisch auf den Formelinhalt zugeschnitten und in Graustufen (1 Kanal) umgewandelt.
- Sprache: Englisch (Standard) und Deutsch, im Kopfbereich umstellbar, pro Browser gespeichert.

## Ideen für die Zukunft

- Persistente, editierbare eigene Formelbibliothek; „Formel merken"-Button.
- Serien-Workflow: viele Screenshots nacheinander mit „Weiter"-Knopf.
- Mehrzeilige Formeln & ganze Skript-Seiten erkennen.
