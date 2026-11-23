# AutoMath – Projektstatus (Handoff)

> **Für KI-Sitzungen:** Diese Datei wird nach jeder Sitzung aktualisiert. Lies sie zuerst,
> dann kennst du den kompletten Stand ohne Rückfragen. Ändere sie am Sitzungsende.

**Stand: 23.11.2026** · Version v3 · Repo: https://github.com/EtwasJonas/AutoMath · Live: https://etwasjonas.github.io/AutoMath/

## 1. Was ist das Projekt?

Eine **einzige HTML-Datei** (`AutoMath.html`) für Tutorien in HM 1 (Elektrotechnik):
**Screenshot einfügen (Strg+V) → KI liest die Formel (OCR, läuft im Browser) → Live-Vorschau → ein Klick kopieren → in PowerPoint als native, editierbare Formel einfügen (Strg+V).**
Zweisprachig (Englisch = Basis, DE/EN-Schalter im Header, Wahl wird gespeichert). Vorschau in Cambria Math (= PowerPoint-Schrift). Läuft komplett lokal; nur der erste OCR-Modell-Download braucht Internet.

## 2. Aktueller Funktionsumfang

- **OCR:** TexTeller3 (`onnx-community/TexTeller3-ONNX`, Apache-2.0) via transformers.js v4.3.2 (CDN) im Browser. **WebGPU-first** (q4f16, ~198 MB) mit automatischem CPU-Fallback (q4, ~250 MB) + Warm-up-Validierung. Bildvorverarbeitung: weißer Hintergrund → Auto-Crop auf Formelinhalt → **seitenverhältnistreues Quadrat-Padding** (kritisch! ohne das: Müll bei komplexen Formeln) → Graustufen-RawImage (1 Kanal). OCR startet automatisch beim Einfügen eines Bildes.
- **Formel → PowerPoint:** 3 Wege – (1) MathML kopieren → natives, editierbares Office-Formelobjekt (Hauptweg), (2) LaTeX mit `$$…$$` kopieren (M365 ab Build 2606 fügt direkt als Formel ein), (3) PNG (transparent, 3×) als Fallback.
- **Formelbibliothek** (56 Einträge, bilingual): Grundlagen, Zeiger & komplexe Zahlen, Laplace, Fourier, DGL & Systeme, Matrizen & Felder, Struktur. **„Meine Formeln"** (erster Tab): aktuelle Formel per „📌 Merken" speichern (Name optional, Prompt-Dialog), dauerhaft im Browser (`automath.mylib`), per ✕ löschbar. Zeichen-Palette (~30 Tokens). Verlauf (localStorage, max 40). Aktuelle Formel wird automatisch gespeichert.
- **OCR-Cache-Knopf „🧹 Clear cache":** löscht den `transformers-cache` (Cache-Storage, ~200–250 MB); `ocrPipe`/`tjsMod` werden genullt → nächste Erkennung lädt neu (getestet: Download + OCR danach erfolgreich).
- **Editor-Verhalten:** Neues OCR-Bild **ersetzt den Editor-Inhalt immer** (letzte Änderung, Commit `c357b18` – explizit vom Nutzer gewünscht).
- **i18n:** Basis Englisch, `data-i18n`-Attribute + I18N-Dict, DE/EN-Schalter, persistsiert in `localStorage` (`automath.lang`).

## 3. Wichtige technische Fakten (zum Weiterarbeiten)

- **Struktur:** `AutoMath.html` (Fertigprodukt) ← gebaut aus `src/AutoMath.template.html` (Quelle; Platzhalter `/*__TEMML_CSS__*/`, `/*__TEMML_JS__*/`) + `vendor/` (Temml 0.14 + Cambria-Math-CSS + Temml.woff2). **Nach jeder Template-Änderung:** `powershell -ExecutionPolicy Bypass -File build.ps1` (erzeugt `AutoMath.html` **und** `index.html` für Pages-Root) → commit + push → GitHub Pages baut automatisch (~1 min).
- **MathML für Office:** Kopier-Version wird bereinigt: `xmlns` gesichert, `display="block"` bei Anzeigeformel, CSS-Klassen/Styles entfernt (passend zum MathML-3-Import von M365, Doku: learn.microsoft.com/en-us/office/math/mathml). Office unterstützt u. a. `menclose notation="top|bottom"` (→ `\overline`/`\underline`/Zeiger!) und übersetzt U+02C6 zu Akzenten.
- **OCR-Pipeline-Details:**
  - TexTeller3 erwartet **Graustufen (1 Kanal)** – RGBA führt zu Fehler → `canvasToRawGray()` baut `RawImage` selbst.
  - CPU-Inferenz blockiert den Hauptthread (GitHub Pages kann keine COOP/COEP-Header → kein threaded WASM). **WebGPU** löst das; im OpenCode-In-App-Browser ist `navigator.gpu` = false (nur zum Testen relevant!).
  - `max_new_tokens: 512` (Cap gegen Endlos-Müll).
  - Test-Hooks: `window.AM` = `{ S, render, sanitizeMml, renderToString, stripDelims, lib, insert, pngBlob, recognize, setPendingImage, prepareCanvas, setLang, lang, ocrDevice }`.
- **Test-Setup:** `py -3 -m http.server 8765 --bind 127.0.0.1` im Projektordner (Hintergrund), dann OpenCode-Browser-Tools auf `http://127.0.0.1:8765/AutoMath.html` (`file://` wird vom In-App-Browser nicht akzeptiert). Geschlossener OCR-Testlauf: Formel `AM.insert(tex, true)` → `AM.pngBlob()` → `AM.recognize(blob, true)`.
- **Storage-Orte:** OCR-Modell liegt im Cache-Storage unter Name **`transformers-cache`** (Cache API, kein IndexedDB/OPFS). localStorage: `automath.current`, `automath.history`, `automath.mylib`, `automath.lang`.
- **Automationshinweis:** `window.prompt` wird im In-App-Browser automatisch verworfen → zum Testen von „Merken" `window.prompt = () => "Name"` stubben, bevor `#btnPin` geklickt wird.
- **GitHub:** Repo `EtwasJonas/AutoMath`, `gh` CLI ist authentifiziert (Konto EtwasJonas). Pages = Branch `main`, Root, URL https://etwasjonas.github.io/AutoMath/. Build-Status: `gh api repos/EtwasJonas/AutoMath/pages/builds/latest --jq .status`.
- **Git-Historie (Meilensteine):** `e76d402` v2 (OCR integriert) → `11ee30a` v3 (bilingual, Layout) → `8733253` Pages + Vorschau über Eingabe → `e0b30ec` OCR-Fix (Quadrat-Padding, WebGPU-first) → `1f5f527` Segmentierungs-Versuch → `1617dcb` **Revert davon** → `c357b18` Replace-Verhalten behalten.

## 4. Bekannte Grenzen & offene Punkte

- **Fließtext vor Formeln** (z. B. „Dreiecksungleichung |a+b|≤|a|+|b|"): TexTeller3 liest Text nicht zuverlässig → Müll. Ein Segmentierungs-Ansatz (Bild in Text|Formel-Bereiche trennen, einzeln erkennen) wurde gebaut, machte alles nur **langsamer ohne Qualitätsvorteil** und wurde auf Wunsch **komplett revertiert** (außer: Editor wird ersetzt). Empfohlene Workarounds: nur die Formel umrahmen; Beschriftung in PowerPoint setzen; für Text+Formel-Mix ggf. Mathpix Snip. **Mögliche Zukunftsidee:** zweites, text-spezifisches Modell neben TexTeller (nur auf expliziten Nutzerwunsch angehen!).
- Ideen (nicht gebaut): persistente Bearbeitung/Umbenennen gemerkter Formeln, Serien-Workflow (viele Screenshots nacheinander), mehrzeilige Formeln/ganze Seiten.
- Kleinkram: `\binom` wird als `\begin{matrix} n \\ k \end{matrix}` erkannt (mathematisch identisch); gelegentlich `\boldsymbol`-Rauschen oder „..."-Enden (Nutzer prüft eh – Hinweis steht im Tool).

## 5. Was in der letzten Sitzung passierte

23.11.2026 (2. Teil): Sitzungs-Handoff eingerichtet (`PROJEKT-STATUS.md` + `AGENTS.md`, Commit `ba98478`). Danach zwei Features umgesetzt und im Browser getestet: **„📌 Merken" / „Meine Formeln"** (eigener Tab, Persistenz über Reload, Dubletten ersetzen statt duplizieren, Löschen per ✕, beide Sprachen) und **„🧹 Clear cache"** (löscht `transformers-cache` – verifiziert: 221 MB → 0 MB → Neu-Download 195 MB → OCR erfolgreich). Alles gepusht; Pages aktualisiert sich. Warten auf Feedback aus echtem Tutoriums-Betrieb.
