//
//  ProviderMainTabView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct ProviderMainTabView: View {
    var body: some View {
        TabView {
            ProviderHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ProviderActivityView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Activity")
                }
            ProviderAccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
        }
    }
}

struct ProviderMainTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderMainTabView()
    }
}

// MARK: - Placeholder Views

struct ProviderHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Provider Home")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}

struct ProviderActivityView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Provider Activity")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationBarTitle("Activity", displayMode: .inline)
        }
    }
}

struct ProviderAccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Provider Account")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
        }
    }
}
