import Foundation
import SwiftUI
import AppKit

class FlooderManager: ObservableObject {
    @Published var textToFlood: String = "Hello!"
    @Published var delayMs: Int = 1000
    @Published var isFlooding: Bool = false
    @Published var isPermissionGranted: Bool = AXIsProcessTrusted()
    
    private var timer: Timer?
    private var hotkeyMonitor: Any?
    private var permissionTimer: Timer?

    init() {
        setupGlobalHotkey()
        startPermissionCheckTimer()
    }

    func checkPermissions() {
        let status = AXIsProcessTrusted()
        if isPermissionGranted != status {
            isPermissionGranted = status
        }
    }

    private func startPermissionCheckTimer() {
        // Check every 2 seconds to see if the user granted permissions while the app is open
        permissionTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkPermissions()
        }
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
        
        // Safety check for Accessibility Privacy
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let isTrusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !isTrusted {
            print("ATTENTION: App is NOT trusted for Accessibility. Flooding will fail.")
        }

        isFlooding = true
        runFloodingCycle()
    }

    private func runFloodingCycle() {
        guard isFlooding else { return }
        
        // Perform one cycle in a background thread
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self, self.isFlooding else { return }
            
            // 1. Type the whole string (synchronous in this thread)
            KeyEventSimulator.typeString(self.textToFlood)
            
            // 2. Press Enter
            KeyEventSimulator.pressEnter()
            
            // 3. Wait for the user-defined delay
            Thread.sleep(forTimeInterval: Double(self.delayMs) / 1000.0)
            
            // 4. Trigger next cycle
            DispatchQueue.main.async {
                self.runFloodingCycle()
            }
        }
    }



    func stopFlooding() {
        isFlooding = false
        timer?.invalidate()
        timer = nil
    }

    private func setupGlobalHotkey() {
        let modifiers: NSEvent.ModifierFlags = [.command, .shift, .option]
        let keyCode: UInt16 = 3 // 'f' key
        
        // Monitor for other apps
        hotkeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            let required: NSEvent.ModifierFlags = [.command, .shift, .option]
            let forbidden: NSEvent.ModifierFlags = [.control]
            let flags = event.modifierFlags.intersection([.command, .shift, .option, .control])
            
            if flags == required && event.keyCode == keyCode {
                DispatchQueue.main.async {
                    self?.toggleFlooding()
                }
            }
        }
        
        // Also monitor when Flodder itself is focused
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            let required: NSEvent.ModifierFlags = [.command, .shift, .option]
            let flags = event.modifierFlags.intersection([.command, .shift, .option, .control])
            
            if flags == required && event.keyCode == keyCode {
                self?.toggleFlooding()
                return nil // consume the event
            }
            return event
        }

    }

    
    deinit {
        if let monitor = hotkeyMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
