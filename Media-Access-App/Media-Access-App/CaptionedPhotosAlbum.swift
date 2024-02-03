//
//  CaptionedPhotosAlbum.swift
//  Media-Access
//
//  Created by Ian Vechey on 2/28/22.

/*
 The CaptionedPhotoAlbum is used to manipulate the library for captioning photos. 
 
 
 */
/*https://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
*/
import Foundation
import Photos
import SwiftUI

//Class of the captioned photo album
class CaptionedPhotoAlbum: NSObject { //Class Captioned PhotoAlbum inherits from NSObject
    
    //Variables
    static let albumName = "Accessible Media"
    static let sharedInstance = CaptionedPhotoAlbum()

    var assetCollection: PHAssetCollection!

    override init() {//override the init() function of the NSObject
        
        
        
        super.init() //call the init() of the NSObject

        if let assetCollection = fetchAssetCollectionForAlbum() { //see if an album that matches out album name exists
            self.assetCollection = assetCollection //set it locally
            return
        }

        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized { //if a corresponding album does not exist then request authorization
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in //PHAutho..Status is apps authorization to access user photo library
                ()
            })
        }

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
        
        
    }
    
    
    
    

    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")// <-bug we can fix
        }
    }

    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CaptionedPhotoAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in //if we sucessfully created the album then initialize it locally.
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(String(describing: error))")
            }
        }
    }

    func fetchAssetCollectionForAlbum() -> PHAssetCollection? { //fetch the assets from the album that is labled captioned
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CaptionedPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
            return collection.firstObject //if an asset exist return it's first
        }
        
        return nil
    }

    func saveImageData(imageData: Data)
    {
       
        if assetCollection == nil {
            print("error upstream")
            return                          // if there was an error upstream, skip the save
        }

        
        PHPhotoLibrary.shared().performChanges({
                let assetRequest = PHAssetCreationRequest.forAsset()
                assetRequest.addResource(with: .photo, data: imageData, options: nil)
            
                let assetPlaceHolder = assetRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                let enumeration: NSArray = [assetPlaceHolder!]
                albumChangeRequest!.addAssets(enumeration)
            
            }, completionHandler: { success, error in
                print("Finished adding the asset to the album. \(success ? "Success": String(describing: error))")
 
            })
        
        
    }
    

}
