//
//  KeyboardResponder.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/26/25.
//
// WARNING: this was generated by AI
// jsyk...

import Foundation
import Combine
import SwiftUI

// Helper to detect keyboard height
final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { notification in
                if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    let screenHeight = UIScreen.main.bounds.height
                    self.currentHeight = max(0, screenHeight - value.origin.y)
                } else {
                    self.currentHeight = 0
                }
            }
    }
}
