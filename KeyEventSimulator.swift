import Foundation
import CoreGraphics

struct KeyEventSimulator {
    static func typeString(_ text: String) {
        for char in text {
            if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) {
                // We use a trick here: post an event with the character directly
                // This is more reliable for Unicode than mapping keys manually.
                let utf16Chars = Array(String(char).utf16)
                event.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
                event.post(tap: .cghidEventTap)
                
                // Key Up
                if let upEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) {
                    upEvent.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
                    upEvent.post(tap: .cghidEventTap)
                }
            }
            // Small delay between characters to avoid overwhelming the receiver
            Thread.sleep(forTimeInterval: 0.01)
        }
    }
    
    static func pressEnter() {
        let enterKey: CGKeyCode = 0x24 // kVK_Return
        
        let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: enterKey, keyDown: true)
        keyDown?.post(tap: .cghidEventTap)
        
        let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: enterKey, keyDown: false)
        keyUp?.post(tap: .cghidEventTap)
    }
}
