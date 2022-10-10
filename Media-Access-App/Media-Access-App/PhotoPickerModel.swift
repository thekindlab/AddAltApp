//
//  PhotoPickerModel.swift
//  PHPickerDemo
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import Photos

struct PhotoPickerModel {
    enum MediaType {
        case photo, video, livePhoto
    }
    
    var id: String
    var photo: UIImage?
    var url: URL?
    var livePhoto: PHLivePhoto?
    var mediaType: MediaType = .photo
    
    
    
    init(with photo: UIImage) {
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
    @Published var items = [PhotoPickerModel]()
    
    var size: Int = 0
    
    func getSize() -> Int {
        return size
    }
    
    func append(item: PhotoPickerModel) {
        items.append(item)
        size += 1
    }
    
    func del(index: Int) {
        
        items.remove(at: index)
    }
    
    
    
    func deleteAll() {
        for (index, _) in items.enumerated() {
            items[index].delete()
        }
        
        items.removeAll()
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
    
    func getNext(item: String) -> PhotoPickerModel {
        if(items.count == 1) {
            //returns an empty PhotoPickerModel
            return PhotoPickerModel()
        }
        for (index, _) in items.enumerated() {
            if(item == items[index].id) {
                if(!(index > items.count-1)) {
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
