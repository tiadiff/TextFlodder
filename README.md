# TextFlodderm-MacOS 🌊

Un'utilità di automazione minimale ed elegante per macOS progettata per simulare l'invio rapido di messaggi (flooding).

## Caratteristiche

- **Design Moderno**: Barra orizzontale compatta con effetto glassmorphism nativo per macOS 15.
- **Automazione Rapida**: Simula la digitazione del testo seguita dal tasto "Invio".
- **Comando Globale**: Attiva/Disattiva il flooding da qualsiasi applicazione con `Cmd + Shift + Alt + F`.
- **Delay Personalizzabile**: Imposta l'intervallo tra un invio e l'altro in millisecondi.
- **Icona Personalizzata**: Icona nativa ad alta risoluzione con trasparenza.

## Requisiti

- macOS 11.0 o superiore (Ottimizzato per macOS 15).
- Permessi di **Accessibilità** (necessari per simulare gli eventi della tastiera).

## Come Utilizzare

1. **Installazione**: Scarica o compila l'applicazione `Flodder.app`.
2. **Permessi**: Vai in `Impostazioni di Sistema > Privacy e Sicurezza > Accessibilità` e aggiungi `Flodder.app` all'elenco delle app consentite.
3. **Configurazione**:
   - Apri l'app.
   - Digita il messaggio desiderato nel campo "MESSAGGIO".
   - Imposta il ritardo desiderato in "DELAY" (es. 1000 per 1 secondo).
4. **Esecuzione**:
   - Spostati sull'applicazione dove vuoi inviare il testo (es. Note, WhatsApp, Terminale).
   - Premi la combinazione globale `⌘ + ⇧ + ⌥ + F` per avviare il flooding.
   - Premi la stessa combinazione per fermarlo.

## Sviluppo

Il progetto è scritto in Swift e SwiftUI.

### Compilazione manuale
```bash
swiftc -o Flodder.app/Contents/MacOS/Flodder FlodderApp.swift ContentView.swift FlooderManager.swift KeyEventSimulator.swift
```

---
Sviluppato con ❤️ per macOS.
