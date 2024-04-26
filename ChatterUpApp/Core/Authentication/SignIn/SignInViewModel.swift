//
//  SignInViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import Foundation

class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""

}
