//
//  MessageComposeView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI
import MessageUI

struct MessageComposeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMessageComposeViewController

    var bodyText: String
    var recipients: [String] = [] // Optional: Pre-fill recipient numbers if desired

    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.body = bodyText
        vc.recipients = recipients
        vc.messageComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // No update needed
    }
}
