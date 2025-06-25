//
//  View+IfAvailable.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//

/// experimenting with ios26
import SwiftUI

extension View {
    @ViewBuilder
    func ifAvailableiOS185<T: View>(apply modifier: (Self) -> T) -> some View {
        if #available(iOS 18.5, *) {
            modifier(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifAvailableiOS26<T: View>(apply modifier: (Self) -> T) -> some View {
        if #available(iOS 26, *) {
            modifier(self)
        } else {
            self
        }
    }
    // Add more for other versions if needed
}
