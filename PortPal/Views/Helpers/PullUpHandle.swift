//
//  PullUpHandle.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/26/25.
//

import Foundation
import SwiftUI

struct PullUpHandle: View {
    var onPullUp: () -> Void

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 32) // Height of the swipe area
            .contentShape(Rectangle())
            .overlay(
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 40, height: 6)
                    .padding(.top, 8)
            )
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        if value.translation.height < -40 {
                            onPullUp()
                        }
                    }
            )
    }
}
