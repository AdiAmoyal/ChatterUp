//
//  ProfileViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    @Published var selectedStatus: StatusOption = .available
    
}

enum StatusOption: String, CaseIterable {
    case available, busy, atSchool, atWork, batteryAboutToDie, cantTalk, inAMeeting, atTheGym, sleeping, urgentCallsOnly
    
    var title: String {
        switch self {
        case .available:
            "Available"
        case .busy:
            "Busy"
        case .atSchool:
            "At School"
        case .atWork:
            "At Work"
        case .batteryAboutToDie:
            "Battery About To Die"
        case .cantTalk:
            "Can't Talk"
        case .inAMeeting:
            "In A Meeting"
        case .atTheGym:
            "At The Gym"
        case .sleeping:
            "Sleeping"
        case .urgentCallsOnly:
            "Urgent Calls Only"
        }
    }
}
