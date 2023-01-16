//
//  ItemsView.swift
//  PHPickerDemo
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import AVKit
import UIKit

enum MyError: Error {
    case runtimeError(String)
}


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
                                    
                                }
                                
                                if(curItem != nil) { //if we still have photos to save
                                
                                    saveCaptionThenSaveToCaptioned()

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
                                    setCaptionFromSelectedPhoto()
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
    
    
    private func saveCaptionThenSaveToCaptioned() { 
        
        //grab current image UIImage
        var current_photo: UIImage
        current_photo = (curItem?.photo)!
        
        let current_image_properties = (curItem?.image_properties)!
        
        
        
        //get jpegData of the image to create a imgsource with
        let imageData: Data = current_photo.jpegData(compressionQuality: 0)! //Returns a data object that contains the image in JPEG format. At the lowest quality

        
        //Source Code
        //the image source is basically a file that holds the images info
        
        let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)! //imageSource temp file
        
        let imageProperties = current_image_properties as NSDictionary //get the image that we're trying to captions properties
        
        //modify the data
        let mutable: NSMutableDictionary = imageProperties.mutableCopy() as! NSMutableDictionary //create a mutable copy in the form of a dictionary
        var IPTCDictionary: NSMutableDictionary? = (mutable[kCGImagePropertyIPTCDictionary as String] as? NSMutableDictionary) //access the {IPTC} dict thats inside
        
        
        if(IPTCDictionary == nil)
        {
            mutable[kCGImagePropertyIPTCDictionary as String] =  NSMutableDictionary()
            IPTCDictionary = (mutable[kCGImagePropertyIPTCDictionary as String] as? NSMutableDictionary)
        }
        
        
        
        //*****************************************************************************
        //testing code
        //print("before modification \(mutable)") //check if changed before modification
        //******************************************************************************
        
        
        //modify copy of image meta data
        IPTCDictionary!["ArtworkContentDescription"] = currentCaption
        

        
        //Destination Code
        //an image destination is basically a file we create to store new modified image info to
        
        let uti: CFString = CGImageSourceGetType(imageSource)! //The uniform type identifier of the image source container.
        let imageDestData: NSMutableData = NSMutableData(data: imageData) //create an Mutable Data object (when destination change, this is where the data will be changed)
        
        let destination: CGImageDestination = CGImageDestinationCreateWithData((imageDestData as CFMutableData), uti, 1, nil)! //image destination

        
        //add the modified meta data to the image destination temp file
        CGImageDestinationAddImageFromSource(destination, imageSource, 0, mutable)
        CGImageDestinationFinalize(destination)
        
        
        
        ///******************************************************
        //testing code
        //check that it's been saved
        //let testImage: CIImage = CIImage(data: imageDestData as Data, options: nil)! //imageDestData is where dest changes occur
        //let newproperties: NSDictionary = testImage.properties as NSDictionary
        //print("after modification \(newproperties)") //changes are in IPTC section
        //
        //*******************************************************
        
        photoLibrary.saveImageData(imageData: imageDestData as Data) //save the image to the phone's library using the modified meta data
        
    }
    
    
    
    private func setCaptionFromSelectedPhoto() { //when user selects image to caption, if it exists, fill the caption field with the images current caption
        
        let current_image_properties = (curItem?.image_properties)!
        let imageProperties = current_image_properties as NSDictionary //return properties of image at a specificied location in image source.
       
        let IPTCDictionary: NSMutableDictionary? = (imageProperties[kCGImagePropertyIPTCDictionary as String] as? NSMutableDictionary)
        if(IPTCDictionary == nil)
        { //IPTCDictionary not set
            
           currentCaption = "Enter Your Caption"
            return
        }
        
        let potential_caption = IPTCDictionary!["ArtworkContentDescription"]
        
        if(potential_caption == nil)
        {
            
           currentCaption = "Enter Your Caption"
            return;
        }
        
         currentCaption = IPTCDictionary!["ArtworkContentDescription"]! as! String // we can modify this to put the images caption here if it already exists
        

    }

    
}




//how XCode loads the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




