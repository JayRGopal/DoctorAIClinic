//
//  Patient.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import Foundation
import SwiftData

@Model
class Patient {
    var name: String
    var symptoms: String
    var imageURL: String?
    
    init(name: String, symptoms: String, imageURL: String? = nil) {
        self.name = name
        self.symptoms = symptoms
        self.imageURL = imageURL
    }
}
