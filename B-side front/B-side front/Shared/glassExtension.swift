//
//  glassExtension.swift
//  B-side front
//
//  Created by Mounir Emahoten on 12/12/2025.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func glassCard(
        cornerRadius: CGFloat = 30,
        tintOpacity: Double = 0.19,
        strokeOpacity: Double = 0.25,
        interactive: Bool = false,
        color: Color = .black,
        rectangle: Bool = true
    ) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(
                    interactive ? .clear.tint(color.opacity(tintOpacity)).interactive()
                    : .clear.tint(color.opacity(tintOpacity)),
                    in: rectangle
                    ? AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
                    : AnyShape(Circle())

                    
                )

        } else {
            self
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.black.opacity(strokeOpacity), lineWidth: 1)
                )
        }
    }
}
