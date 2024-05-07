//
//  CustomTabbarItem.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 06/05/2024.
//

import SwiftUI

struct CustomTabbarItem: View {
    
    let tab: Tabs
    @Binding var selectedTab: Tabs
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }, label: {
            VStack {
                Image(systemName: tab.icon)
                    .font(.title2)
                    .frame(width: 28, height: 28)
                Text(tab.title)
            }
        })
        .foregroundStyle(selectedTab == tab ? Color.theme.primaryBlue : Color.theme.body)
    }
}

#Preview {
    CustomTabbarItem(tab: .chats, selectedTab: .constant(.chats))
}
