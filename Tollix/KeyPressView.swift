import SwiftUI
import AppKit

struct KeyPressView: NSViewRepresentable {
    var onKeyPress: (Int) -> Void

    func makeNSView(context: Context) -> NSHostingView<EmptyView> {
        let hostingView = NSHostingView(rootView: EmptyView())
        hostingView.addSubview(KeyboardResponder(onKeyPress: onKeyPress))
        return hostingView
    }

    func updateNSView(_ nsView: NSHostingView<EmptyView>, context: Context) {
        // no update needed
    }

    private class KeyboardResponder: NSView {
        var onKeyPress: (Int) -> Void

        init(onKeyPress: @escaping (Int) -> Void) {
            self.onKeyPress = onKeyPress
            super.init(frame: .zero)
            self.translatesAutoresizingMaskIntoConstraints = false
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var acceptsFirstResponder: Bool { true }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            self.window?.makeFirstResponder(self)
        }

        override func keyDown(with event: NSEvent) {
            if let number = Int(event.characters ?? ""), (1...5).contains(number) {
                onKeyPress(number)
            }
        }
    }
}
