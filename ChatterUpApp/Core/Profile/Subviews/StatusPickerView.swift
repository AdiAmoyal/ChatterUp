//
//  StatusPickerView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import SwiftUI

struct StatusPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStatus: StatusOption
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                ForEach(StatusOption.allCases, id: \.self) { status in
                    VStack {
                        Text(status.title)
                            .foregroundStyle(selectedStatus.title == status.title ? Color.theme.primaryBlue : Color.theme.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.background)
                            .padding(.leading, 10)
                            .onTapGesture {
                                selectedStatus = status
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                        Divider()
                    }
                    
                }
                
                Spacer()
            }
            .font(.headline)
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        StatusPickerView(selectedStatus: .constant(.available))
    }
}
