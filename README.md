# TextFlodder for MacOS 🌊

A minimal and elegant automation utility for macOS designed for rapid message simulation (flooding).

<img width="483" height="120" alt="image" src="https://github.com/user-attachments/assets/1e77a70c-a9a2-44cf-b431-a60513bf24fe" />


## Features

- **Modern Design**: Compact horizontal bar with native macOS 15 glassmorphism effect.
- **Rapid Automation**: Simulates text typing followed by the "Enter" key.
- **Global Command**: Toggle flooding from any application using keyboard shortcut.
- **Customizable Delay**: Set the interval between sends in milliseconds.
- **Custom Icon**: Native high-resolution icon with transparency.

## Requirements

- macOS 11.0 or higher (Optimized for macOS 15).
- **Accessibility** Permissions (required to simulate keyboard events).

## How to Use

1. **Installation**: Download or compile the `Flodder.app` application.
2. **Permissions**: Go to `System Settings > Privacy & Security > Accessibility` and add `Flodder.app` to the allowed apps list.
3. **Configuration**:
   - Open the app.
   - Type your desired message in the "MESSAGGIO" field.
   - Set the desired interval in "DELAY" (e.g., 1000 for 1 second).
4. **Execution**:
   - Focus on the application where you want to send the text (e.g., Notes, WhatsApp, Terminal).
   - Press the global combination (`Cmd + Shift + Alt + F`) to start flooding.
   - Press the same combination to stop.

## Troubleshooting (Permissions)

If the app is running but nothing happens:
- Look for the **Orange Warning Triangle** ⚠️ next to the START button. <br>This means macOS is blocking the app from simulating keys.
- **Resetting Permissions**:
    1. Open `System Settings > Privacy & Security > Accessibility`.
    2. Select `Flodder` and remove it using the `-` button.
    3. Manually drag `Flodder.app` back into the list.
    4. Ensure the toggle is **ON**.
    5. Restart the app.

- **Advanced Reset (Terminal)**:
    If the UI settings don't work, run this command in your Terminal to force-reset the privacy database for Flodder:
    ```bash
    tccutil reset Accessibility com.tiadiff.flodder
    ```

## Development

The project is written in Swift and SwiftUI.

### Manual Compilation
```bash
swiftc -o Flodder.app/Contents/MacOS/Flodder FlodderApp.swift ContentView.swift FlooderManager.swift KeyEventSimulator.swift
```

---

# TextFlodder for Windows 10/11 🌊

A native version for Windows 10/11 is available in the `flodder_windows` folder.

- **Features**: Same flooding logic, dark mode UI, and sequential typing.
- **Hotkey**: `Ctrl + Shift + Alt + F` (Different from macOS due to system constraints).
- **No Installation**: The `Flodder.exe` file is portable and ready to run.

### Location
You can find the source code and the executable instructions in:
`/flodder_windows/`

---
Developed with ❤️ for macOS and Windows.
