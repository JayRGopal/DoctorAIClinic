//
//  PatientServicesView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct PatientServicesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Patient Services")
                    .font(.largeTitle)
                    .padding()
                // Future services content goes here.
                Spacer()
            }
            .navigationBarTitle("Services", displayMode: .inline)
        }
    }
}

struct PatientServicesView_Previews: PreviewProvider {
    static var previews: some View {
        PatientServicesView()
    }
}
