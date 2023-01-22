//
//  ItemsView.swift
//  PHPickerDemo
//
//  
//

import SwiftUI
import AVKit
import UIKit

enum MyError: Error {
    case runtimeError(String)
}

struct Settings: View{
    
    var body: some View{
        
        Text("Settings").bold().padding(.top, 50.0)
        
        List{
                NavigationLink(destination: AboutPage()) { Text("About Page")  } //for about research, goals of research
                NavigationLink(destination: CaptioningHistory()){ Text("Captioning History")} //would be cools to have and easy to implement
                NavigationLink(destination: Settings()){Text("Caption Guide")} //we need to have this
                NavigationLink(destination: Contact()){Text("Contact")}

            }
    }
    
}

struct AboutPage: View{
    
    var body: some View{
        
        Text("AboutPage").bold().padding(.top, 50.0)
        
        //write a couple paragraphs for explaining our research
         }
    
}

struct CaptioningHistory: View{
    
   
    
    var body: some View {
        
        VStack{
            
        Text("Caption History").bold().padding(.top, 50.0)
        
            if(CoreDataManager.shared.loadAllImageData()!.count < 1)
            {
                Text("It looks like you haven't captioned anything.").padding(.top, 50.0)
            }
            
            ScrollView{
                ForEach(CoreDataManager.shared.loadAllImageData()!) { caption_history in

                    
                    HStack(spacing: 16)
                    {
                        VStack(alignment: .leading, spacing: 8)
                        {
                            Text(caption_history.caption!)
                                .font(.title3.bold())
                            Text("Date: \(caption_history.caption_date!)" )
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(" It took \(String(round(caption_history.time_to_caption, to:4)))s to caption this photo. ").font(.system(size:12))
                            Text("The caption was \(String(caption_history.caption_length)) characters long.").font(.system(size:12))
                            
                        }
                        
                        Spacer()
                        
                        Image(uiImage: UIImage(data: caption_history.image_data!)!).resizable().scaledToFill().frame(width:96, height:88).clipped().cornerRadius(10)
                        
                        
                    }.padding(.bottom, 25.0).padding(.horizontal)
                    
                    Divider()
                }
            }
        }
    }
    
        func round(_ num: Double, to places: Int) -> Double {
            let p = log10(abs(num))
            let f = pow(10, p.rounded() - Double(places) + 1)
            let rnum = (num / f).rounded() * f

            return rnum
        }
}

struct Contact: View{
    
    var body: some View{
        
        Text("Contact").bold().padding(.top, 50.0)
        
        //write a contactable email for any questions or concerns
        
    }
    
}


struct ContentView: View {
    
    //Navigation Variable
    @State private var navigateTo = ""
    @State private var isActive = false
    
    
    
    //Global Variables
    @State public var currentCaption: String = "Enter Your Caption"
    @State private var showSheet = false
    @State private var showCamera = false
    @State private var curImage: UIImage?
    @State private var curItemID: String = ""
    @State private var curItem: PhotoPickerModel? //struct that is data structure for one photo
    @ObservedObject var mediaItems = PickedMediaItems() //array of Photos (PhotoPickerModels)
    @State private var photoLibrary = CaptionedPhotoAlbum() //users photo album
    @State private var timeToCaption = Time()
    @State private var notificationManager = NotificationHandler()
    @State private var startupManager = StartupHandler(notif_handler : NotificationHandler())
    
    
    
    var body: some View {
        
        
        
        //App View Stack    (what the user sees on startup )
        
        NavigationView {
            
            
            
            VStack {
                
                //navigation to Settings page
                NavigationLink(destination: Settings()) { Text("Settings")  }.padding(.top, 30).padding(.trailing, UIScreen.main.bounds.size.width*1.5/2 )
                
                
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
                    
                    
                    
                    //notif Scheduler test code
                    /*
                     
                     //  print local storage Button for testing
                     Button(action: {
                     
                     
                     //this just prints out the caption for all of the saved data
                     
                     }, label: {
                     Text("test DayCalc").foregroundColor(Color.white)
                     })
                     .frame(width: 100.0, height: 30.0)
                     .background(Color.blue)
                     .clipShape(Capsule())
                     //  print local storage Button for testing
                     
                     Button(action: {
                     
                     CoreDataManager.shared.deleteStartupData()
                     //this just prints out the caption for all of the saved data
                     
                     }, label: {
                     Text("RESET STARTUP").foregroundColor(Color.white)
                     })
                     .frame(width: 100.0, height: 30.0)
                     .background(Color.blue)
                     .clipShape(Capsule())
                     //  print local storage Button for testing
                     
                     
                     // delete local stroage button for testing
                     Button(action: {
                     
                     //deletes all image data
                     self.notificationManager.removeAppNotifications()
                     
                     //this just prints out the caption for all of the saved data
                     
                     }, label: {
                     Text(" stop all schedule notifications").foregroundColor(Color.white)
                     })
                     .frame(width: 100.0, height: 30.0)
                     .background(Color.purple)
                     .clipShape(Capsule())
                     //  delete local stroage button for testing
                     
                     
                     */
                    //Notification scheduling test code.
                    
                
                    
                    //submit button
                    Button(action: {
                        //On press
                        if(curItem?.mediaType == .photo) { //save the current photo
                            
                        }
                        
                        if(curItem != nil) { //if we have a photo to save
                            
                            
                            timeToCaption.setFinishCaptionTime(newFinishTime:Date().timeIntervalSinceReferenceDate)
                            
                            //Core Data save
                            savePhotoMetaDataLocally()
                            //Local library save
                            saveCaptionedPhotoToLibrary()
                            
                            //reset new start time for next caption
                            timeToCaption.setStartCaptionTime(newStartTime: Date().timeIntervalSinceReferenceDate)
                            
                            //update Startup Info
                            startupManager.updateStartupInformation()
                            
                            //Apply Notification Algo
                            notificationManager.schedulingFrequencyNotificationAlgorithm()
                            
                            
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
                    PhotoPicker(mediaItems: mediaItems, captionTimeControl: timeToCaption) { didSelectItem in
                        // Handle didSelectItems value here...
                        showSheet = false
                        
                    }
                })
                //Photo picker
                
                
                
                //End of View Stack
            }
            
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
    
    
    private func saveCaptionedPhotoToLibrary()  {
        
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
    
    
    
    private func savePhotoMetaDataLocally()
    { //used to save Photo information to Core Data
        
        var current_photo: UIImage
        current_photo = (curItem?.photo)!
        
        var photo_data = current_photo.jpegData(compressionQuality: 0.2)!
        let caption_date = getCurrentDate()
        let caption_date_epoch = Date().timeIntervalSinceReferenceDate
        let caption = currentCaption
        let caption_length = currentCaption.count
        let photo_timeToCaption = timeToCaption.getFinishCaptionTime() - timeToCaption.getStartCaptionTime()

        CoreDataManager.shared.addNewImage(image_data:  photo_data, new_caption:caption, photo_caption_length: Int16(caption_length), time_to_caption: photo_timeToCaption, photo_caption_date: caption_date, photo_caption_date_epoch: caption_date_epoch)
        //save the Photo meta data to Core Data with all the desired properties
       
    }
    
    
    private func exportLocalData()
    {//should be function for exporting all of the local data to a remote csv file or google drive type deal. 
        /*
        let sFileName = "localData.csv"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let documentURL = URL(fileURLWithPath:
            documentDirectoryPath).appendingPathComponent(sFileName)
        
        let output = OutputStream.toMemory()
        
        //let csvWriter = CHCSVWriter(outputStream: output, encoding:
        //    String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
            
        csvWriter?.writeField("PHOTO_ID")
        csvWriter?.writeField("PHOTO_TIME")
        csvWriter?.writeField("CAPTION")
        csvWriter?.writeField("CAPTION_LENGTH")
        csvWriter?.writeField("CAPTION_TIME")
        //add more headers later
        csvWriter?.finishLINE()

        var arrOfImageData = [[String]]()

        arrOfImageData.append(["", "", "", "", ""])
        
        for(elements) in arrOfImageData.enumerated()
        {
            csvWriter?.writeField(elements.element[0])
        }
        
        csvWriter?.closeStream()
        */
        //should be used to send to a server
        //(BOOL)writeToURL:(NSString *)url
        //    atomically:(BOOL)useAuxiliaryFile;
        //TODO
    }
    
    private func getCurrentDate() -> String
    { //https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
        // get the current date and time
        let currentDateTime = Date()

        // get the user's calendar
        let userCalendar = Calendar.current

        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]

        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        
        let current_date = String(dateTimeComponents.year!) + "/"  + String(dateTimeComponents.month!) + "/" + String(dateTimeComponents.day!) + " " + String(dateTimeComponents.hour!) + ":" + String(dateTimeComponents.minute!) + ":" + String(dateTimeComponents.second!)
        
        
        
        return current_date
    }

    
}




//how XCode loads the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




