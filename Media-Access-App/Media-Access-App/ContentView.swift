//
//  ItemsView.swift
//  PHPickerDemo
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import AVKit
import UIKit



struct ContentView: View {
    
    
    //Global Variables
    @State public var currentCaption: String = "Enter Your Caption"
    @State private var showSheet = false
    @State private var showCamera = false
    @State private var curImage: UIImage?
    @State private var curItemID: String = ""
    @State private var curItem: PhotoPickerModel? //struct that is data structure for one photo
    @ObservedObject var mediaItems = PickedMediaItems() //array of Photos (PhotoPickerModels)
    @State private var photoLibrary = CaptionedPhotoAlbum() //users photo album

    var body: some View {
        
        //App View Stack    (what the user sees on startup )
        VStack {
            
            
            
            //Header
            Text("Media Accessibility")
                            .font(.headline)
                            .fontWeight(.regular)
                            .padding(.bottom, 100.0)
            //Header
            
            
            //current image chosen
            if curItem == nil { //explanation photo
                Image("Media-Access")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            } else { //if we have a curItem figure out how to display it
                if curItem?.mediaType == .photo {
                    Image(uiImage: curItem?.photo ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        
                    
                } else if curItem?.mediaType == .video {
                    if let url = curItem?.url {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(minHeight: 200)
                    } else { EmptyView() }
                    
                } else {
                    if let livePhoto = curItem?.livePhoto {
                        LivePhotoView(livePhoto: livePhoto)
                            .frame(minHeight: 200)
                    } else { EmptyView() }
                }
            }
            //current image chosen
            
            
            
            //Text editor input object
            TextEditor(text: $currentCaption)
                .frame(width: 350, height: 80, alignment: .center)
                .cornerRadius(3.0)
                .onTapGesture(count: 1) {
                    clearEditor()
                }
                .foregroundColor(Color.gray)
                .border(Color.black, width: 1)
            //Text editor input object
            
            
            //Clear & Submit button Stack
            HStack {
                
                
                            //  Cancel Button
                            Button(action: {
                                print("Cancelled")
                                
                                if(currentCaption == "Enter Your Caption") {
                                    currentCaption = ""
                                }
                                else {
                                    currentCaption = "Enter Your Caption"
                                }
                                
                            }, label: {
                                Text("Clear").foregroundColor(Color.white)
                            })
                            .frame(width: 100.0, height: 30.0)
                            .background(Color.red)
                            .clipShape(Capsule())
                            //  Cancel Button
                
                
                
                            //submit button
                            Button(action: {
                                
                                //On press
                                if(curItem?.mediaType == .photo) { //save the current photo
                                    photoLibrary.saveImage(image: (curItem?.photo)!)
                                    
                                }
                                if(curItem != nil) { //if we still have photos to save
                                    /*
                                     (BUG)
                                     not working currently, does not save caption to the library.
                                     
                                     
                                     */
                                    //saveCaptionThenSaveToCaptioned()
                                    let nextItem = mediaItems.getNext(item: curItemID) //move onto working on the next picked item
                                    mediaItems.getDeleteItem(item: curItemID)
                                    if(nextItem.id != "") {
                                        curItem = nextItem
                                    } else {
                                        curItem = nil
                                    }
                                    currentCaption = "Enter Your Caption"
                                }
                            }, label: {
                                Text("Submit").foregroundColor(Color.white)
                            })
                            .frame(width: 100.0, height: 30.0)
                            .background(Color.green)
                            .clipShape(Capsule())
                            //submit button
                                      
                        }
                        .padding(.bottom, 15.0)
            //Clear & Submit button Stack
            
            
            
            
            //Navigation for handeling photos that are being captioned
            NavigationView {
                
                
                
                //list of media items looking to be captioned
                List(mediaItems.items, id: \.id) { item in
                    ZStack(alignment: .topLeading) {
                        if item.mediaType == .photo {
                            Image(uiImage: item.photo ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .onTapGesture(count:1) {
                                    curItem = item
                                    curItemID = item.id
                                    currentCaption = "Enter Your Caption"
                                }
                            
                        } else if item.mediaType == .video {
                            if let url = item.url {
                                VideoPlayer(player: AVPlayer(url: url))
                                    .frame(minHeight: 200)
                            } else { EmptyView() }
                        } else {
                            if let livePhoto = item.livePhoto {
                                LivePhotoView(livePhoto: livePhoto)
                                    .frame(minHeight: 200)
                            } else { EmptyView() }
                        }
                                            
                        Image(systemName: getMediaImageName(using: item))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .padding(4)
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                    }
                }
                //list of media items looking to be captioned
                
                
                
                    
                
                
                // "queue buttons" location
                .toolbar {
                    
                    
                    //Trash button
                    ToolbarItem(placement: .navigation) {
                        Button(action:
                        //what happens when you click the button
                        {let nextItem = mediaItems.getNext(item: curItemID)
                            
                        mediaItems.getDeleteItem(item: curItemID)
                        if(nextItem.id != "") {
                            curItem = nextItem
                        } else {
                            curItem = nil
                        }
                        currentCaption = "Enter Your Caption"
                        }){Image (systemName: "trash")
                            .foregroundColor(.red)
                        }
                        
                    }
                    //Trash button
                    
                    
                    //Camera button
                    ToolbarItem(placement: .principal) {
                        Button(action:
                                {self.showCamera.toggle()})
                        {Image (systemName: "camera")}
                    }
                    //Camera button
                    
                    
                    
                    //Photo library
                    ToolbarItem(placement: .primaryAction) {
                        Button(action:
                                {showSheet = true})
                        {Image (systemName: "photo")}
                    }
                    //Photo library
                }
                // "queue buttons" location
                
            }
            
            
            
            //sheets that popup when something is pressed
            
            
            /*
             (BUG), atleast on the simluation Iphone, pressing this will throw an Exception, we should handle this so the app doesn't crash.
             
             */
            //Camera sheet
            .sheet(isPresented: self.$showCamera) {
                ImagePickerView(selectedImage: self.$curImage, sourceType: .camera)
            }
            //Camera sheet
            
            //Photo picker
            .sheet(isPresented: $showSheet, content: {
                PhotoPicker(mediaItems: mediaItems) { didSelectItem in
                    // Handle didSelectItems value here...
                    showSheet = false
                    
                }
            })
            //Photo picker
            
        //End of View Stack
        }
        
        
        
    }
    
    //(reading function notation)item is the object name, PhotoPickerModel is the type
    fileprivate func getMediaImageName(using item: PhotoPickerModel) -> String {
        switch item.mediaType {
            case .photo: return "photo"
            case .video: return "video"
            case .livePhoto: return "livephoto"
        }
    }
    
    
    private func clearEditor() {
        if(currentCaption == "Enter Your Caption") {
            currentCaption = ""
        }
    }
    
    
    /*
     (BUG) The saveCaptionThenSaveToCaptioned function does not work correctly. It will change the UserComment but not save it to the library.
     
     
     
     
     */
    //Ideas: Make a  save(CIImage) in func CPA class <- prev team notes
    private func saveCaptionThenSaveToCaptioned() {
        
        
        var test: UIImage //image objects to represent image data of all kinds
        test = (curItem?.photo)!
        
        
        
        
        let imageData: Data = test.jpegData(compressionQuality: 0)! //Returns a data object that contains the image in JPEG format. At the lowest quality
        let cgImgSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)! //Creates an image source that reads from a Core Foundation data object.
        //Data objects are typically used for raw data storage.

        let uti: CFString = CGImageSourceGetType(cgImgSource)! //The uniform type identifier of the image source container.
        let dataWithEXIF: NSMutableData = NSMutableData(data: imageData) //They are typically used for data storage and are also useful in Distributed Objects applications, where data contained in data objects can be copied or moved between applications.
        
        let destination: CGImageDestination = CGImageDestinationCreateWithData((dataWithEXIF as CFMutableData), uti, 1, nil)! //image destination that writes to a Core Foundation mutable data object
        
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(cgImgSource, 0, nil)! as NSDictionary //return properties of image at a specificied location in image source.
        
        
        let mutable: NSMutableDictionary = imageProperties.mutableCopy() as! NSMutableDictionary //create a mutable copy in the form of a dictionary

        let EXIFDictionary: NSMutableDictionary = (mutable[kCGImagePropertyExifDictionary as String] as? NSMutableDictionary)!//A dictionary of key-value pairs for an image that uses Exchangeable Image File Format
        //previous teams test code for changing the caption of a picture

        //print("before modification \(EXIFDictionary)") check before
        
        //save to User Comment, not sure it's where we want to save it
        //but it does work!!! Need to save the image to test if it works
        EXIFDictionary[kCGImagePropertyExifUserComment as String] = currentCaption //index the dict at UserComment and set it to currentCaption
        //this seems like what we want, but nothing shows up in the "after modification" print statement
        EXIFDictionary[kCGImagePropertyPNGDescription as String] = currentCaption //index at png descript and set to currentCaption
        //kCGImageAuxiliaryDataInfoDataDescription <- maybe try this?
        
        //store the new dict settings?
        mutable[kCGImagePropertyExifDictionary as String] = EXIFDictionary //resetting the dictionary?

        CGImageDestinationAddImageFromSource(destination, cgImgSource, 0, (mutable as CFDictionary))
        CGImageDestinationFinalize(destination)

        let testImage: CIImage = CIImage(data: dataWithEXIF as Data, options: nil)! //try testing if the changes were saved? 
        
        
        /*let newproperties: NSDictionary = testImage.properties as NSDictionary
        print("after modification \(newproperties)")*/
        
        photoLibrary.saveImage(image: UIImage(ciImage: testImage))
        
        
    }
        
    
}





//how XCode loads the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




