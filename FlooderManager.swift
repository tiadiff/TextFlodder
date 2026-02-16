import Foundation
import SwiftUI
import AppKit

class FlooderManager: ObservableObject {
    @Published var textToFlood: String = "Hello!"
    @Published var delayMs: Int = 1000
    @Published var isFlooding: Bool = false
    
    private var timer: Timer?
    private var hotkeyMonitor: Any?

    init() {
        setupGlobalHotkey()
    }

    func toggleFlooding() {
        if isFlooding {
            stopFlooding()
        } else {
            startFlooding()
        }
    }

    func startFlooding() {
        guard !isFlooding else { return }
        isFlooding = true
        
        let interval = Double(delayMs) / 1000.0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            KeyEventSimulator.typeString(self.textToFlood)
            KeyEventSimulator.pressEnter()
        }
    }

    func stopFlooding() {
        isFlooding = false
        timer?.invalidate()
        timer = nil
    }

    private func setupGlobalHotkey() {
        // Cmd + Shift + F (Flags: 131072 + 1048576 = 1179648 approx, or use NSEvent.ModifierFlags)
        // Key code for 'F' is 3
        
        hotkeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Check for Cmd + Shift + F
            // Command mask: .command (1 << 20)
            // Shift mask: .shift (1 << 17)
            if event.modifierFlags.contains([.command, .shift, .option]) && event.keyCode == 3 {
                DispatchQueue.main.async {
                    self?.toggleFlooding()
                }
            }
        }
    }
    
    deinit {
        if let monitor = hotkeyMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
