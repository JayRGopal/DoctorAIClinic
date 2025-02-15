//
//  PatientActivityView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct PatientActivityView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Patient Activity")
                    .font(.largeTitle)
                    .padding()
                // Future activity content (past visits, etc.) goes here.
                Spacer()
            }
            .navigationBarTitle("Activity", displayMode: .inline)
        }
    }
}

struct PatientActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PatientActivityView()
    }
}
