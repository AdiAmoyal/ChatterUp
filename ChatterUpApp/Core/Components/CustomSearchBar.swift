//
//  CustomSearchBar.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import SwiftUI

struct CustomSearchBar: View {
    
    @Binding var searchText: String
    @FocusState var isSearchFocus: Bool
    let placeHolder: String
    
    var body: some View {
        TextField("Search by name...", text: $searchText)
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .font(.headline)
            .focused($isSearchFocus)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isSearchFocus ? Color.theme.primaryBlue : Color.theme.stroke ,lineWidth: 2)
            )
    }
}

#Preview {
    CustomSearchBar(searchText: .constant(""), placeHolder: "Search by Name...")
}
