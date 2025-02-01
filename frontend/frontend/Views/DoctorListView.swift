//
//  DoctorListView.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import SwiftUI
import SwiftData

struct DoctorListView: View {
    @Query var doctors: [Doctor] // Fetch doctors from SwiftData

    var body: some View {
        NavigationView {
            List(doctors) { doctor in
                VStack(alignment: .leading) {
                    Text(doctor.name)
                        .font(.headline)
                    Text("Specialty: \(doctor.specialty)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Available Doctors")
        }
    }
}
