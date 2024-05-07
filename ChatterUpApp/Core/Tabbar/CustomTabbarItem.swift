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
    @Binding var showNewChatView: Bool
    
    var body: some View {
        if tab != .plus {
            tabbarItem
        } else {
            plusButton
        }
    }
}

#Preview {
    CustomTabbarItem(tab: .chats, selectedTab: .constant(.chats), showNewChatView: .constant(false))
}

extension CustomTabbarItem {
    private var tabbarItem: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        }, label: {
            VStack {
                Image(systemName: tab.icon)
                    .font(.title2)
                    .frame(width: 18, height: 18)
                Text(tab.title)
                    .font(.footnote)
                    .bold()
            }
        })
        .foregroundStyle(selectedTab == tab ? Color.theme.primaryBlue : Color.theme.body)
    }
    
    private var plusButton: some View {
        Button(action: {
            withAnimation(.spring) {
                selectedTab = tab
                showNewChatView.toggle()
            }
        }, label: {
            Image(systemName: tab.icon)
                .font(.title2)
                .bold()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.theme.background)
        })
        .padding()
        .background(
            Circle()
                .fill(Color.theme.seconderyBlue)
        )
        .padding(8)
        .shadow(color: .theme.primaryBlue.opacity(0.6), radius: 5, x: 0.0, y: 4)
        .background(
            Circle()
                .fill(Color.theme.background)
        )
    }
}
