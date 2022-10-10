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
    @State public var currentCaption: String = "Enter Your Caption"
    @State private var showSheet = false
    @State private var showCamera = false
    @State private var curImage: UIImage?
    @State private var curItemID: String = ""
    @State private var curItem: PhotoPickerModel?
    @ObservedObject var mediaItems = PickedMediaItems()
    @State private var photoLibrary = CaptionedPhotoAlbum()

    var body: some View {
        
        VStack {
            Text("Media Accessibility")//Header
                            .font(.headline)
                            .fontWeight(.regular)
                            .padding(.bottom, 100.0)
            
            if curItem == nil {
                Image("Media-Access")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            } else {
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
            
            TextEditor(text: $currentCaption)
                .frame(width: 350, height: 80, alignment: .center)
                .cornerRadius(3.0)
                .onTapGesture(count: 1) {
                    clearEditor()
                }
                .foregroundColor(Color.gray)
                .border(Color.black, width: 1)
                
            HStack {
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
                
                            //submit button
                            Button(action: {
                                
                                //On press
                                if(curItem?.mediaType == .photo) {
                                    photoLibrary.saveImage(image: (curItem?.photo)!)
                                    
                                }
                                if(curItem != nil) {
                                    //not working currently
                                    //saveCaptionThenSaveToCaptioned()
                                    let nextItem = mediaItems.getNext(item: curItemID)
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
                            
                            
                        }
                        .padding(.bottom, 15.0)
            
            
            NavigationView {
                
                
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
                    
                //these are where our "queue buttons are"
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
                    //camera button
                    ToolbarItem(placement: .principal) {
                        Button(action:
                                {self.showCamera.toggle()})
                        {Image (systemName: "camera")}
                    }
                    //photo library
                    ToolbarItem(placement: .primaryAction) {
                        Button(action:
                                {showSheet = true})
                        {Image (systemName: "photo")}
                    }
                }
            }
            //sheets that popup when something is pressed
            .sheet(isPresented: self.$showCamera) {
                ImagePickerView(selectedImage: self.$curImage, sourceType: .camera)
            }
            
            .sheet(isPresented: $showSheet, content: {
                PhotoPicker(mediaItems: mediaItems) { didSelectItem in
                    // Handle didSelectItems value here...
                    showSheet = false
                    
                }
            })
        }
    }
    
    
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
    //This function is not working right now
    //will change the UserComment but not save to the library
    
    //Ideas: Make a  save(CIImage) in func CPA class
    private func saveCaptionThenSaveToCaptioned() {
        var test: UIImage
        test = (curItem?.photo)!
        
        let imageData: Data = test.jpegData(compressionQuality: 0)!
        let cgImgSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let uti: CFString = CGImageSourceGetType(cgImgSource)!
        let dataWithEXIF: NSMutableData = NSMutableData(data: imageData)
        
        let destination: CGImageDestination = CGImageDestinationCreateWithData((dataWithEXIF as CFMutableData), uti, 1, nil)!
        
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(cgImgSource, 0, nil)! as NSDictionary
        
        
        let mutable: NSMutableDictionary = imageProperties.mutableCopy() as! NSMutableDictionary

        let EXIFDictionary: NSMutableDictionary = (mutable[kCGImagePropertyExifDictionary as String] as? NSMutableDictionary)!
        

        //print("before modification \(EXIFDictionary)") check before
        
        //save to User Comment, not sure it's where we want to save it
        //but it does work!!! Need to save the image to test if it works
        EXIFDictionary[kCGImagePropertyExifUserComment as String] = currentCaption
        //this seems like what we want, but nothing shows up in the "after modification" print statement
        EXIFDictionary[kCGImagePropertyPNGDescription as String] = currentCaption
        
        mutable[kCGImagePropertyExifDictionary as String] = EXIFDictionary

        CGImageDestinationAddImageFromSource(destination, cgImgSource, 0, (mutable as CFDictionary))
        CGImageDestinationFinalize(destination)

        let testImage: CIImage = CIImage(data: dataWithEXIF as Data, options: nil)!
        
        
        /*let newproperties: NSDictionary = testImage.properties as NSDictionary
        print("after modification \(newproperties)")*/
        
        photoLibrary.saveImage(image: UIImage(ciImage: testImage))
        
        
    }
        
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




