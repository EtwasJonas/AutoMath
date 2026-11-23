# AutoMath – Projektanweisungen (für KI-Sitzungen)

## Sitzungs-Handoff (wichtigster Punkt)

- **Lese zu Sitzungsbeginn immer zuerst `PROJEKT-STATUS.md`** – dort steht der komplette Projektstand (Funktionen, technische Details, offene Punkte, letzte Änderungen).
- **Aktualisiere `PROJEKT-STATUS.md` am Ende jeder Sitzung** (oder nach jedem größeren Meilenstein): Datum, was geändert wurde, offene Punkte, nächster Schritt. Ziel: Eine neue Sitzung kann ohne Kontextverlust direkt weiterarbeiten.
- Melde dich nicht mit Details aus `PROJEKT-STATUS.md` beim Nutzer – er kennt sie; die Datei ist für die Sitzungskontinuität.

## Arbeitsablauf in diesem Projekt

1. Code liegt in `src/AutoMath.template.html` (NIEMALS direkt in `AutoMath.html` arbeiten – es wird gebaut!).
2. Nach Template-Änderungen: `powershell -ExecutionPolicy Bypass -File build.ps1` (erzeugt `AutoMath.html` + `index.html`).
3. Dann committen + pushen (GitHub Pages auf `main` baut automatisch, ~1 min).
4. Zum Testen: `py -3 -m http.server 8765 --bind 127.0.0.1` im Projektordner (Hintergrund), OpenCode-Browser-Tools auf `http://127.0.0.1:8765/AutoMath.html`. `file://` wird vom In-App-Browser nicht akzeptiert.
5. Test-Hooks im Browser: `window.AM` (siehe `PROJEKT-STATUS.md`, Abschnitt 3).

## Konventionen

- Sprache des Tools: Englisch = Basis, Deutsch vollständig mitpflegen (I18N-Dict in beiden Sprachen, `data-i18n`-Attribute).
- OCR-Bildverarbeitung: Auto-Crop + seitenverhältnistreues Quadrat-Padding beibehalten (kritisch für Qualität); Graustufen-RawImage (1 Kanal) nötig.
- Nutzer (EtwasJonas) ist Tutor in HM 1 (Elektrotechnik); primärer Anwendungsfall: reine Formeln aus Skripten → native PowerPoint-Formeln. Kommunikation auf Deutsch.
