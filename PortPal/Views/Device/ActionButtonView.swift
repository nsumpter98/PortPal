//
//  ActionButtonView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//

import SwiftUI

struct ActionButtonView: View {
    @Binding var isPresentingFindDeviceSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isPresentingFindDeviceSheet = true
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .foregroundColor(.accentColor)
                        .background(
                            Circle()
                                .fill(.background)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                        )
                }
                .padding(.bottom, 32)
                .padding(.trailing, 0)
                .accessibilityLabel("Find Device")
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var ispresenting = true
    ActionButtonView(isPresentingFindDeviceSheet: $ispresenting)
}
