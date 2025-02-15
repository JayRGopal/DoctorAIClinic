//
//  PatientMainTabView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct PatientMainTabView: View {
    var body: some View {
        TabView {
            PatientHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            PatientServicesView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Services")
                }
            PatientActivityView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Activity")
                }
            PatientAccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
        }
    }
}

struct PatientMainTabView_Previews: PreviewProvider {
    static var previews: some View {
        PatientMainTabView()
    }
}
