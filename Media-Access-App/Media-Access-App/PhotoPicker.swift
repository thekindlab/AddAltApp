//
//  PhotoPicker.swift
//  PHPickerDemo
//
//  Created by Gabriel Theodoropoulos.
//
/*
 The PhotoPicker struct extends some Swift tools for using the photo library to pick photos. 
 
 
 */
import SwiftUI
import PhotosUI



struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    @ObservedObject var mediaItems: PickedMediaItems
    @ObservedObject var captionTimeControl: Time
    
    var didFinishPicking: (_ didSelectItems: Bool) -> Void
    
    
    //makes a UI View Controller
    func makeUIViewController(context: Context) -> PHPickerViewController { //constructs a Photo Picker Controller
        
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images, .videos, .livePhotos])
        config.selectionLimit = 0
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    
    class Coordinator: PHPickerViewControllerDelegate {
        var photoPicker: PhotoPicker
        
        init(with photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            
            photoPicker.didFinishPicking(!results.isEmpty)
            
            
            guard !results.isEmpty else { //if no pictures picked, return
                return
            }
            
            
            
            let g = DispatchGroup()
            
            
            for result in results { //for each photo chosen from library.
                
                g.enter()
                
                let itemProvider = result.itemProvider
                
                var image_properties: CFDictionary?
                
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first, //get the images type identifier
                      let utType = UTType(typeIdentifier)
                else { continue }
                
                itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { (url, error) in //get the more verbose image properties using the image URL from a temp file
                    
                    guard let file_url = url else {return }
                
                    //get the image properties from the images URL
                    do {
                        let imageDataFromURL: Data = try Data(contentsOf: file_url) //create a data object from the URL of the temp file
                        let imageSourceURL: CGImageSource = CGImageSourceCreateWithData(imageDataFromURL as CFData, nil)!
                        
                        image_properties = CGImageSourceCopyPropertiesAtIndex(imageSourceURL, 0, nil)! as NSDictionary //return verbose properties for the image using a temp image URL
                    }
                    catch{
                        print("\(error)")
                    }
                    
                    
                    g.leave()
                    
                }
                
                
                
                //dangerous!! could result in deadlock, need to implement dispatch.async in case this fails and never leaves.
                g.wait()
                
    
                
                if utType.conforms(to: .image) {
                    self.getPhoto(from: itemProvider, isLivePhoto: false, image_properties: image_properties!)
                } else if utType.conforms(to: .movie) {
                    self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
                } else {
                    self.getPhoto(from: itemProvider, isLivePhoto: true, image_properties: image_properties!)
                }
                
                g.notify(queue: .main) {
                        // completed here
                    }
                
            }
        }
        
        
        private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool, image_properties: CFDictionary) {
            let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
            
            if itemProvider.canLoadObject(ofClass: objectType) {
                itemProvider.loadObject(ofClass: objectType) { object, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    //here we need to get URL info I think
                    if !isLivePhoto {
                        if let image = object as? UIImage {
                            DispatchQueue.main.async {
                                self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: image, photo_properties: image_properties)) //append a newPhotoPickerModel object to list of picked media
                                
                                let start_time = Date().timeIntervalSinceReferenceDate
                                self.photoPicker.captionTimeControl.setStartCaptionTime(newStartTime: start_time)
                                
                                
                            }
                        }
                    } else {
                        if let livePhoto = object as? PHLivePhoto {
                            DispatchQueue.main.async {
                                self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: livePhoto, photo_properties: image_properties))
                            }
                        }
                    }
                }
            }
        }
        
        
        private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let url = url else { return }
                
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
                
                do {
                    if FileManager.default.fileExists(atPath: targetURL.path) {
                        try FileManager.default.removeItem(at: targetURL)
                    }
                    
                    try FileManager.default.copyItem(at: url, to: targetURL)
                    
                    DispatchQueue.main.async {
                        self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: targetURL))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
