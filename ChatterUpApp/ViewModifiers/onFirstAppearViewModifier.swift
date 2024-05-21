//
//  onFirstAppearViewModifier.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 20/05/2024.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            })
    }
}

extension View {
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
