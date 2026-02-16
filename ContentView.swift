import SwiftUI

struct ContentView: View {
    @StateObject private var manager = FlooderManager()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Icon
            Group {
                if let nsImage = NSImage(contentsOfFile: "/Volumes/Macintosh/Applications/MAMP/htdocs/flodder/icon.png") {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                } else {
                    Text("🌊")
                        .font(.system(size: 18))
                }
            }
            .padding(.bottom, 4)

            // Message Input
            VStack(alignment: .leading, spacing: 1) {
                Text("MESSAGGIO")
                    .font(.system(size: 7, weight: .bold))
                    .foregroundColor(.secondary)
                TextField("...", text: $manager.textToFlood)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(width: 220)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.primary.opacity(0.05)))
            }

            // Delay Input
            VStack(alignment: .leading, spacing: 1) {
                Text("DELAY")
                    .font(.system(size: 7, weight: .bold))
                    .foregroundColor(.secondary)
                TextField("", value: $manager.delayMs, formatter: NumberFormatter())
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(width: 40)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.primary.opacity(0.05)))
            }

            // Action Button
            Button(action: {
                manager.toggleFlooding()
            }) {
                Text(manager.isFlooding ? "STOP" : "START")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(manager.isFlooding ? Color.red : Color.blue)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            if !manager.isPermissionGranted {
                Button(action: {
                    manager.checkPermissions()
                    // Prompt again if they click the warning
                    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                    AXIsProcessTrustedWithOptions(options as CFDictionary)
                }) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Permessi di Accessibilità mancanti! Clicca per riprovare.")
            }



            // Status Indicator
            indicator
                .padding(.bottom, 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .frame(width: 420, height: 52)
        .background(VisualEffectView().ignoresSafeArea())


        .onAppear {
            // Hotkey Hint in Tooltip or similar if needed
        }
    }

    private var indicator: some View {
        Circle()
            .fill(manager.isFlooding ? Color.red : Color.green)
            .frame(width: 8, height: 8)
            .overlay(
                Circle()
                    .stroke(manager.isFlooding ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 4)
                    .scaleEffect(manager.isFlooding ? 1.2 : 1.0)
            )
            .animation(manager.isFlooding ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: manager.isFlooding)
    }
}


struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .sidebar
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}


#Preview {
    ContentView()
}
