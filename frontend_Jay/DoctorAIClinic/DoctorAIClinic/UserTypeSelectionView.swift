//
//  UserTypeSelectionView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct UserTypeSelectionView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("I am a...")
                .font(.largeTitle)
                .padding(.top, 80)
            
            Spacer()
            
            NavigationLink(destination: SignInView(userRole: .patient)) {
                Text("Patient")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            NavigationLink(destination: SignInView(userRole: .provider)) {
                Text("Medical Professional")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct UserTypeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserTypeSelectionView()
        }
    }
}
