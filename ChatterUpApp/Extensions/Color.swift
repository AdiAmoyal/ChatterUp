//
//  Color.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let background = Color("Background")
    let title = Color("Title")
    let body = Color("Body")
    let stroke = Color("Stroke")
    let icon = Color("Icon")
    let primaryBlue = Color("PrimaryBlue")
    let seconderyBlue = Color("SeconderyBlue")
    let skyBlue = Color("SkyBlue")
    let red = Color("LightRed")
    let green = Color("LightGreen")
    let orange = Color("LightOrange")
}
