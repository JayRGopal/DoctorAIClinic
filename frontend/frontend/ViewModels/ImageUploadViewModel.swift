//
//  ImageUploadViewModel.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import SwiftUI

class ImageUploadViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var uploadStatus: String = ""

    func uploadImage() {
        guard let image = selectedImage else {
            uploadStatus = "No image selected"
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            uploadStatus = "Image conversion failed"
            return
        }

        let url = URL(string: "http://localhost:5000/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.uploadStatus = "Upload failed: \(error.localizedDescription)"
                } else {
                    self.uploadStatus = "Upload successful"
                }
            }
        }
        task.resume()
    }
}
