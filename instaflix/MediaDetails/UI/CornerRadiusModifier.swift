//
//  CornerRadiusModifier.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import SwiftUI

struct CornerRadiusModifier: ViewModifier {
    var radius: CGFloat

    func body(content: Content) -> some View {
        content.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

extension View {
    func customCornerRadius(radius: CGFloat) -> some View {
        modifier(CornerRadiusModifier(radius: radius))
    }
}
