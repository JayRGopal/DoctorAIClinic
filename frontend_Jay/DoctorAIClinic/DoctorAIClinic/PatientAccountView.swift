//
//  PatientAccountView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct PatientAccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Patient Account")
                    .font(.largeTitle)
                    .padding()
                // Future account management content goes here.
                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
        }
    }
}

struct PatientAccountView_Previews: PreviewProvider {
    static var previews: some View {
        PatientAccountView()
    }
}
