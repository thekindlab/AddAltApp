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
                                    //photoLibrary.saveImage(image: (curItem?.photo)!)
                                    
                                }
                                if(curItem != nil) { //if we still have photos to save
                                    /*
                                     (BUG)
                                     not working currently, does not save caption to the library.
                                     
                                     
                                     */
                                
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
    
    
    private func saveCaptionThenSaveToCaptioned() { 
        
        //grab current image UIImage
        var test: UIImage
        test = (curItem?.photo)!
        
        //get the image data
        let imageData: Data = test.jpegData(compressionQuality: 0)! //Returns a data object that contains the image in JPEG format. At the lowest quality
        
        
        //Source Code
        //the image source is basically a temp file that holds the images info
        
        let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)! //Creates an image source that reads from a Core Foundation data object. Data objects are typically used for raw data storage.
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary //return properties of image at a specificied location in image source.
        
        //modify the data
        let mutable: NSMutableDictionary = imageProperties.mutableCopy() as! NSMutableDictionary //create a mutable copy in the form of a dictionary
        let EXIFDictionary: NSMutableDictionary = (mutable[kCGImagePropertyExifDictionary as String] as? NSMutableDictionary)! //mutable dictionary copy
        
        print("before modification \(EXIFDictionary)") //check if changed before modification
        
        //EXIFDictionary[kCGImagePropertyPNGDescription as String] = currentCaption// doesn't work to save because 'kCGImagePropertyPNGDescription as String' is not a valid key in the EXIF dict
        
        //modify copy of image meta data
        EXIFDictionary[kCGImagePropertyExifUserComment as String] = currentCaption //this saves correctly because key is in right location
    
        /*
            Robert Note: In the future we need to look through Apples keys documentation and pick one that suits our caption goal. "User comment" is not a very good choice.
         
         */
        
        
        //Destination Code
        //an image destination is basically a temp file we create to store new modified image info to
        
        let uti: CFString = CGImageSourceGetType(imageSource)! //The uniform type identifier of the image source container.
        let imageDestData: NSMutableData = NSMutableData(data: imageData) //create an Mutable Data object (when destination change, this is where the data will be changed)
        
        let destination: CGImageDestination = CGImageDestinationCreateWithData((imageDestData as CFMutableData), uti, 1, nil)! //image destination

        
        
        //add the modified meta data to the image destination temp file
        CGImageDestinationAddImageFromSource(destination, imageSource, 0, mutable)//FIGURED BUG OUT , when you are changing a dict key pair, you need to follow Apples heirarchy for it to save.
        CGImageDestinationFinalize(destination)
        
        //check that it's been saved
        let testImage: CIImage = CIImage(data: imageDestData as Data, options: nil)! //imageDestData is where dest changes occur
        let newproperties: NSDictionary = testImage.properties as NSDictionary
        print("after modification \(newproperties)") //look at "Exif" dict key for comparison
         
        
        
        //create a UIImage with the modified data and try saving it to the Captioned Album on the actual phone
        let captioned_image = UIImage(data: imageDestData as Data)!
        photoLibrary.saveImage(image: captioned_image)//saves the captioned image
        
        /*saves the captioned image (NOT WORKING PROPERLY)
          Seems that when we create a UIImage using the modified data that perhaps the meta data we added does not persist or our method of saving the image does not conserve this meta data?
         IMPORTANT NOTE, when we check the image properties in this method we do so by getting the image's jpegData bitmap data first, this might not conserve our added metadata even
         if we actually do change it(can't find documentation on it) so we need to check the image on the computer user the inspector tools.
        */
        
       //might have to release the source and destination object(not sure )
        
        
    }
        
    
}





//how XCode loads the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




