//
//  ImageUploadView.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import SwiftUI
import PhotosUI


struct ImageUploadView: View {
    @StateObject private var viewModel = ImageUploadViewModel()
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("Select Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) { _, newItem in
                loadImage(from: newItem)
            }

            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            Button("Upload Image") {
                viewModel.uploadImage()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Text(viewModel.uploadStatus)
                .foregroundColor(.gray)
        }
        .padding()
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }

        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data, let uiImage = UIImage(data: data) {
                        viewModel.selectedImage = uiImage
                    }
                case .failure:
                    viewModel.uploadStatus = "Failed to load image"
                }
            }
        }
    }
}
