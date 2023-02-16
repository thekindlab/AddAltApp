//
//  ImagePicker.swift
//  Media-Accessibility
//
//  Created by Ian Vechey on 1/24/22.
//

/*This code came from: https://medium.com/swlh/how-to-open-the-camera-and-photo-library-in-swiftui-9693f9d4586b
 */
import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    
    @Binding var curItem: PhotoPickerModel?
    @ObservedObject var captionTimeControl: Time
    
    
    
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
