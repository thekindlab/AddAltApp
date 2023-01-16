//
//  PhotoPickerModel.swift
//  PHPickerDemo
//
//  Created by Gabriel Theodoropoulos.
//
/*
 The PhotoPickerModel represents a struct data object that has info for one photo
 
 
 PickedMediaItems is a data structure that wraps an array of PhotoPickerModels and gives functions to manipulate said data structure
 
 
 */
import SwiftUI
import Photos

//struct data structure for each photo
struct PhotoPickerModel {
    
    enum MediaType {
        case photo, video, livePhoto
    }
    
    var id: String
    var photo: UIImage?
    var url: URL?
    var livePhoto: PHLivePhoto?
    var mediaType: MediaType = .photo
    var image_properties: CFDictionary? = nil
    
    //constructor functions
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }
    
    init(with photo: UIImage, photo_url: URL ) {
        self.url = photo_url
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }
    
    init(with photo: UIImage, photo_properties: CFDictionary ) {
        self.image_properties = photo_properties
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }
    
    
    init() {
        id = ""
    }
    
    init(with videoURL: URL) {
        id = UUID().uuidString
        url = videoURL
        mediaType = .video
    }
    
    init(with livePhoto: PHLivePhoto) {
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
    
    init(with livePhoto: PHLivePhoto, photo_url: URL) {
        self.url = photo_url
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
    
    init(with livePhoto: PHLivePhoto, photo_properties: CFDictionary) {
        self.image_properties = photo_properties
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
    
    mutating func delete() {
        switch mediaType {
            case .photo: photo = nil
            case .livePhoto: livePhoto = nil
            case .video:
                guard let url = url else { return }
                try? FileManager.default.removeItem(at: url)
                self.url = nil
        }
    }
}









class PickedMediaItems: ObservableObject {
    @Published var items = [PhotoPickerModel]() //array of photos
    //functions for manipulating array of photos
    var size: Int = 0
    
    func getSize() -> Int { //what is the purpose of this code? not used anywhere I don't think
        return size
    }
    
    func append(item: PhotoPickerModel) {
        items.append(item)
        size += 1
    }
    
    func del(index: Int) {
        
        items.remove(at: index)
        size -= 1
    }
    
    
    
    func deleteAll() {
        for (index, _) in items.enumerated() {
            items[index].delete()
        }
        
        items.removeAll()
        size = 0
    }
    

    func getDeleteItem(item: String) {
        for (index, _) in items.enumerated() {
            if(item == items[index].id) {
                print(index)
                items.remove(at: index)
                break
            }
        }
    }
    
    func getNext(item: String) -> PhotoPickerModel { //need to rewrite code, seems badly written. Should implement size variable I believe. 
        if(items.count == 1) {
            //returns an empty PhotoPickerModel
            return PhotoPickerModel()
        }
        for (index, _) in items.enumerated() {
            if(item == items[index].id) {
                if(!(index > items.count-2)) {
                    return items[index+1]
                }
                else {
                    return PhotoPickerModel()
                }
            }
        }
        return PhotoPickerModel()
        
    }
    
    
    
}
