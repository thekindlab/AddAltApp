//
//  ItemsView.swift
//  PHPickerDemo
//
//  
//

import SwiftUI
import AVKit
import UIKit
import MessageUI


enum MyError: Error {
    case runtimeError(String)
}




struct Settings: View{
    
    var body: some View{
        
        Text("Settings").bold().padding(.top, 50.0)
        
        List{
                NavigationLink(destination: AboutPage()) { Text("About Page")  } //for about research, goals of research
                NavigationLink(destination: CaptioningHistory()){ Text("Captioning History")} //would be cools to have and easy to implement
                NavigationLink(destination: CaptionGuide()){Text("Caption Guide")} //we need to have this
                NavigationLink(destination: Contact(emailBody: "Something Is Wrong!", senderName: "", recieveResponse: false)){Text("Contact")}

            }
    }
    
}

struct CaptionGuide : View{
    var body: some View{
        
        VStack(spacing: 8){
            
            Text("Caption Guide").fontWeight(.bold).font(.title)
            
            
            Divider()
            
            VStack(spacing: 20){
                
                ScrollView{
                    
                Text("Why Caption?").fontWeight(.bold).font(.title2)
                
                    Text("People with visual disabilities can have difficulties interpreting visual information such as images, graphs, or tables. Adding a caption to your photo will allow individuals on the internet who use assistive technology to better understand what they are viewing.").font(.body)
                
                Text("Spread Your Photo!").fontWeight(.bold).font(.title2)
                
                    Text("In addition to making the internet more friendly towards visually impaired individuals, adding captions to photos can make it easier to find on the internet if posted.").font(.body)
                }.frame(height: 180)
                
                Divider()
                
                VStack(spacing: 12){
                    
                    Text("Best practices").fontWeight(.bold).font(.title2)
                    
                    Text("Do's ").fontWeight(.semibold).font(.title3)
                    
                    ScrollView{
                        
                        VStack(alignment:.leading){
                            
                            Text(" - Be descriptive and concise (150  characters MAX).").padding(5).font(.body)
                            Divider()
                            Text(" - Focus on conveying the main concept of the image and what it's trying to accomplish.  ").padding(5).font(.body)
                            
                            Divider()
                            
                            Text(" - Do consider the both the image content and context. ").padding(5).font(.body)
                        }
                        
                        
                    }.border(Color.green, width:3).padding()
                    
                    Text("Don't's ").fontWeight(.semibold).font(.title3)
                    
                    ScrollView{
                        
                        VStack(alignment:.leading){
                            
                            Text(" - Don't include \"graphic of\", \" photo of\", or \"image of\" .").padding(5).font(.body)
                            Divider()
                            Text(" - Don't make assumptions: verify race, identity, gender of individuals in photo.").padding(5).font(.body)
                        }
                        
                        
                    }.border(Color.red, width:3).padding()
                    
                    
                }
                
                
                
            }.padding()
            
         
            
        }
        
    }
    
}

struct AboutPage: View{
    
    var body: some View{
        
        VStack(alignment: .center, spacing: 16){
            Text("About Us").bold().font(.title)
            
            VStack( spacing: 8){
                
                VStack(alignment: .leading){
                    
                    
                    
                    Divider()
                    Text("Spring 2022 - Winter 2023 Research Group").fontWeight(.bold).font(.title)
                    
                    
                    ScrollView(.horizontal)
                    {
                        HStack(spacing:10){
                            Text("Yasmine Elglaly").font(.caption).frame(width:120, height:50).font(.largeTitle).background(Color.blue).clipShape(Capsule()).foregroundColor(.white)
                            Text("Robert Bowen").font(.caption).frame(width:120, height:50).font(.largeTitle).background(Color.blue).clipShape(Capsule()).foregroundColor(.white)
                            Text("Braxton Eidem").font(.caption).frame(width:120, height:50).font(.largeTitle).background(Color.blue).clipShape(Capsule()).foregroundColor(.white)
                            Text("Charlie Koenig").font(.caption).frame(width:120, height:50).font(.largeTitle).background(Color.blue).clipShape(Capsule()).foregroundColor(.white)
                            Text("Keagan Cantrell").font(.caption).frame(width:120, height:50).font(.largeTitle).background(Color.blue).clipShape(Capsule()).foregroundColor(.white)
                        }
                    }
                    
                    
                    Divider()
                    
                    Text("Background").fontWeight(.bold).font(.title)
                    ScrollView{
                        
                        
                        VStack(alignment: .center)
                        {
                            
                            
                            
                            
                        
                        
                        Text("A professor at the Western Washington University had an idea for a mobile application that would spread awareness and allow resources for non visually impaired people to help create an accessible environment. The application will allow users to caption their pictures and save their description as metadata so a screen reader can then convey that information to the visually impaired. The application would be an extension of a phone’s native camera app and would prompt the user to add an alt-text or caption to every picture taken by the camera. If the user chooses to use the application, they can then record or type a short description of the image. The application will then save that description as text in the images’ alt-text metadata. When the user chooses to publish the image, that metadata will be included in the publishing, which then can be used by screen readers to make the internet more accessible to those who use screen readers to navigate the internet.The importance of this application is that it will spread awareness and create accessibility by adding descriptions to images. The importance in this is that people with disabilities suffer greatly when their lives depend on the internet. For example, people with disabilities may have jobs that rely on the internet, and if they cannot navigate the internet successfully then they could lose those jobs. Another goal of this application is to show people who are not technology experts that they can still help make an accessible environment for people with disabilities."
                        ).fontWeight(.bold).font(.caption).foregroundColor(.gray).multilineTextAlignment(.center).lineSpacing(10).padding()
                    }
                }
                Divider()
                
                }
                
                
                
            }.padding()
            Spacer()
        }
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

struct MailView: UIViewControllerRepresentable
{//NEED TO TEST ON A PHYSICAL DEVICE. CANNOT TEST ON A SIMULATOR
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding  var emailBody: String
    @Binding  var senderName :String
    @Binding  var recieveResponse: Bool
    @Binding  var recieveEmail: String
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate{
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>)
                {
                    _presentation = presentation
                    _result = result
                    
                }
        
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            defer{
                $presentation.wrappedValue.dismiss()
                
            }
            
            guard error == nil else
            {
                self.result = .failure(error!)
                return
            }
            
            self.result = .success(result)
            
        }
        
        
        
        
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> some MFMailComposeViewController {
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients([recieveEmail])
        if(recieveResponse)
        {
            emailBody = emailBody + " \n I want to recieve a Response!"
            
        }
        
        viewController.setMessageBody(emailBody, isHTML: true) //BUG THIS DOESN't actually add the I want to recieve a response until they've returned from view. Odd. 
        return viewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    
    
}


struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.90)
        .overlay(content)
    }
}


struct Contact: View{
    
    @State  var recipientEmail = "bowenr4@wwu.edu"
    @State  var emailBody: String
    @State  var senderName: String
    @State  var recieveResponse: Bool
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var text_color = Color.gray
    @State var button_color = !MFMailComposeViewController.canSendMail() ? Color.gray : Color.blue
    @State var can_mail = !MFMailComposeViewController.canSendMail()
    var body: some View{
        
        Background{
            
            
            HStack(alignment: .top)
            {
                
                
                
                VStack(alignment: .center, spacing: 16){
                    Text("Contact Us").bold()
                    
                    
                    
                    
                    VStack( spacing: 8){
                        
                        Divider()
                        
                        HStack(spacing:16){
                            Text("Name")
                            
                            TextField(text: $senderName, prompt: Text("Optional"))
                            {
                                Text("name")
                            }.padding(.top, 20).padding(.bottom,20).autocorrectionDisabled().padding(.leading,10)
                        }
                        Divider()
                        
                        VStack(alignment: .leading, spacing:16)
                        {
                            Text("Message")
                            TextEditor(text: $emailBody).frame(width: 350, height: 200, alignment: .center)
                                .cornerRadius(10.0)
                                .foregroundColor(text_color).border(Color.gray, width:0.5).onTapGesture {
                                    
                                    clearEditor()
                                    
                                    
                                }
                            
                        }.padding(.top, 20).padding(.bottom,20)
                        Divider()
                        
                        Toggle("Recieve a Response", isOn: $recieveResponse).padding(.top, 20).padding(.bottom,20)
                        Divider()
                        
                    }
                    
                    VStack(alignment: .center)
                    {
                        Button(action: {
                            self.isShowingMailView.toggle()
                        }, label: {
                            Text(" Send Message").foregroundColor(Color.white)
                        })
                        .frame(width: 200.00, height: 33.0)
                        .background(button_color)
                        .clipShape(Capsule()).disabled(!MFMailComposeViewController.canSendMail()).sheet(isPresented: $isShowingMailView)
                        {
                            
                            MailView(result: self.$result, emailBody: self.$emailBody, senderName: self.$senderName, recieveResponse: self.$recieveResponse, recieveEmail: self.$recipientEmail)
                        }
                    }
                    if(can_mail)
                    {
                        Divider()
                        Text("It Looks like email is not setup")
                    }
                    Spacer()
                    
                    
                    
                }.padding(.bottom, 25.0).padding(.horizontal)
                
            }
            
        }.onTapGesture {
            self.endEditing()
        }
        //write a contactable email for any questions or concerns
        
    }
    
    private func clearEditor() {
        text_color = Color.black
        if(emailBody == "Something Is Wrong!") {
            emailBody = ""
        }
    }
    
    private func endEditing() {
            UIApplication.shared.endEditing()
        }
    
 
    

    
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
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
    @State private var timeToCaption = Time()
    @State private var notificationManager = NotificationHandler()
    @State private var startupManager = StartupHandler(notif_handler : NotificationHandler())
    
    
    
    var body: some View {
        
        

        //App View Stack    (what the user sees on startup )
                
                NavigationView {
                    
                    
                    
                    VStack {
                        
                        //navigation to Settings page
                        NavigationLink(destination: Settings()) { Text("Settings")  }.padding(.top, 30).padding(.trailing, UIScreen.main.bounds.size.width*1.5/2 )
                        
                        VStack{
                            
                            
                            
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
                                                    
                                                    if(item.image_properties != nil) //only set caption if image properties exist.
                                                    {
                                                        setCaptionFromSelectedPhoto()
                                                    }
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
                                ImagePickerView( curItem: $curItem,  captionTimeControl: timeToCaption, sourceType: .camera)
                                
                                    
                                    
                            
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
                        }.onTapGesture{
                            self.endEditing()
                            
                        }

                    }
                }
    }
    
    private func endEditing() {
            UIApplication.shared.endEditing()
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
        
        var current_image_properties: NSDictionary
        
        //get jpegData of the image to create a imgsource with
        let imageData: Data = current_photo.jpegData(compressionQuality: 0)! //Returns a data object that contains the image in JPEG format. At the lowest quality
        
        if(curItem?.image_properties != nil)
        {
            
            current_image_properties = (curItem?.image_properties)!
        }
        else
        {
            let imageSourceData : CGImageSource = CGImageSourceCreateWithData( imageData as CFData, nil)!
            current_image_properties = CGImageSourceCopyPropertiesAtIndex(imageSourceData, 0, nil)! as NSDictionary
             
        }
        
        
        
       

        
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
        
        let photo_data = current_photo.jpegData(compressionQuality: 0.2)!
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




