//
//  PreviewProvider.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 01/05/2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    
    @MainActor
    let signInVM = SignInViewModel()
}
