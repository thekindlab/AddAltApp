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
            NavigationLink(destination: Contact(emailBody: "Something Is Wrong!", senderName: "", sendData: false, recieveResponse: false)){Text("Contact")}
            }
    }
    
}
struct CaptionGuide : View{
    var body: some View{
        
        VStack(spacing: 8){
            
            Text("Alt Text Caption Guide").fontWeight(.bold).font(.title)
            
            //Divider()
            
            VStack(spacing: 10){
                
                ScrollView{
                    
                    Image("Media-Access")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 150, height: 150) // Adjust dimensions as needed
                    
                    Text("Two golden retreiver pupies sitting together on grass spinkled with autumn leaves.")
                           .font(.body)
                           .multilineTextAlignment(.center)
                       
                    
                }.frame(height: 210)
                
               //Divider()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        // Do Section
                        Text("Do! ")
                            .fontWeight(.semibold)
                            .font(.title3)
                            .foregroundColor(.green)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("- Focus on the most important element of the image and be descriptive.")
                                .padding(.leading, 10)
                                .font(.body)

                            Text("- Organize your alt text cohesively: what they are doing, focus point of the image, and image context.")
                                .padding(.leading, 10)
                                .font(.body)

                            Text("- Include sufficient detail and context for your audience")
                                .padding(.leading, 10)
                                .font(.body)
                        }
                        .padding(.bottom, 5)

                        // Don't Section
                        Text("Don't! ")
                            .fontWeight(.semibold)
                            .font(.title3)
                            .foregroundColor(.red)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("- Start by saying \"A photo of Two Puppies\" -> Two Puppies.")
                                .padding(.leading, 10)
                                .font(.body)
                            Text("- Be redundant or include unnecessary words \"An image of dogs. The dogs are side by side. The dogs are in grass\" -> Two Puppies sitting together on grass.")
                                .padding(.leading, 10)
                                .font(.body)

                            Text("- Don't make assumptions: verify race, identity, gender of individuals in photo.")
                                .padding(.leading, 10)
                                .font(.body)
                        }
                       // .padding()
                    }.padding(.vertical, 15)
                }
                
                
            }
            
         
            
        }.padding()
        
    }
    
}
struct AboutPage: View{
    
    var body: some View{
        
        VStack(alignment: .center, spacing: 16){
            Text("About Us").bold().font(.title)
            
            VStack( spacing: 8){
                
                VStack(alignment: .leading){
                    Text("Background").fontWeight(.bold).font(.title)
                    ScrollView{

                        VStack(alignment: .center)
                        {

                        Text("A professor at the Western Washington University had an idea for a mobile application that would spread awareness and allow resources for non visually impaired people to help create an accessible environment. The application will allow users to caption their pictures and save their description as metadata so a screen reader can then convey that information to the visually impaired. "
                        ).fontWeight(.bold).font(.caption).foregroundColor(.gray).multilineTextAlignment(.center).lineSpacing(10).padding()
                    }
                }
                Divider()
                    Text("Contributors")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black) // Set the color based on your design

                    Text("Thuan Nguyen")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray) // Set the color based on your design
                    
                    Text("Selah Bellscheidt")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray) // Set the color based on your design
                }
                
                
                
            }.padding()
            Spacer()
            Text("© 2024 Media Acessibility. All rights reserved.")
                               .font(.footnote)
                               .foregroundColor(.black)
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
    @Binding  var sendData: Bool
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
        
        var pathCSV = ""
        if(recieveResponse)
        { //odd need to format like this or won't work. probably better to do it will a lock wait, but doesn't seem to work
            
            
            let new_emailBody = emailBody + " \n , I want to recieve a Response!"
            
        
            
            viewController.setMessageBody(new_emailBody, isHTML: true)
            
        }
        else
        {
            
            
            viewController.setMessageBody(emailBody, isHTML: true)
        }
        
        
        
        if(sendData)
        {
            emailBody = emailBody + " \n I want to send information about my app usage!"
            
            pathCSV = CoreDataManager.shared.createCSV()
            
            
        }
        
        viewController.setMessageBody(emailBody, isHTML: true)
        
        if(pathCSV != "")
        {
            if let fileData = NSData(contentsOfFile: pathCSV)
            {
                print("File data loaded.")
                viewController.addAttachmentData(fileData as Data, mimeType: "text/csv", fileName: "userData.csv")
            }
        }
        return viewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
struct Contact: View{
    @Environment(\.colorScheme) var colorScheme
    @State  var recipientEmail = "nguye404@wwu.edu"
    @State  var emailBody: String
    @State  var senderName: String
    @State  var sendData: Bool
    @State  var recieveResponse: Bool
    
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var text_color =   Color.gray
    @State var button_color = !MFMailComposeViewController.canSendMail() ? Color.gray : Color.blue
    @State var can_mail = !MFMailComposeViewController.canSendMail()
    var body: some View{
        
    
        VStack{
                    
                    
                    
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
                                        .foregroundColor(Color.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 3)) // Apply rounded corners
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color(red: 130/255, green: 160/255, blue: 170/255), lineWidth: 2) // Apply rounded border
                                        )
                                        .onTapGesture {
                                            clearEditor()
                                        }
                                    
                                }.padding(.top, 20).padding(.bottom,20)
                                Divider()
                                
                                Toggle("Recieve a Response", isOn: $recieveResponse).padding(.top, 20).padding(.bottom,20)
                                Toggle("Send App Data", isOn: $sendData).padding(.bottom,20)
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
                                    
                                    MailView(result: self.$result, emailBody: self.$emailBody, senderName: self.$senderName, sendData: self.$sendData, recieveResponse: self.$recieveResponse, recieveEmail: self.$recipientEmail)
                                }
                            }
                            if(can_mail)
                            {
                                Divider()
                                Text("It looks like email is not setup")
                            }
                            Spacer()
                            
                            
                            
                        }.padding(.bottom, 25.0).padding(.horizontal)
                    }
                }.ignoresSafeArea(.keyboard, edges: [.bottom]).onTapGesture {
                    self.endEditing()
                }      //write a contactable email for any questions or concerns
                    }
    
    private func clearEditor() {
        
        
        if(colorScheme == .dark)
        {
            
            text_color = Color.white
        }else
        {
            
            text_color = Color.black
        }
        
        
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
extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

struct ContentView: View {
    //Global Variables
    @State private var currentCaption: String = "Choose one photo, then add a caption to the photo. "
    @State private var showSheet = false
    @State private var showCamera = false
    @State private var curImage: UIImage?
    @State private var curItemID: String = ""
    @State private var curItem: PhotoPickerModel? //struct that is data structure for one photo
    @State private var altTextSuggestion: String = ""
    @ObservedObject var mediaItems = PickedMediaItems() //array of Photos (PhotoPickerModels)
    @State private var photoLibrary = CaptionedPhotoAlbum() //users photo album
    @State private var timeToCaption = Time()
    @State private var notificationManager = NotificationHandler()
    @State private var startupManager = StartupHandler(notif_handler : NotificationHandler())
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        
        //App View Stack    (what the user sees on startup )
                
                NavigationView {
                    
                    
                    
                    VStack {
                        
                        //navigation to Settings page
                        //NavigationLink(destination: Settings()) { Text("Settings")  }.padding(.top, 30).padding(.trailing, UIScreen.main.bounds.size.width*1.5/2 )
                        
                        //navigation to Settings page
                        NavigationLink(destination: Settings()) {
                            Image(systemName: "line.horizontal.3")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, UIScreen.main.bounds.size.width * 1.5 / 2)
                        
                        VStack{
                            
                            
                            
                            //Header
                            Text("MEDIA ACCESIBILITY")
                                .font(.system(size: 20,  weight: .bold))
                                .padding(.bottom, 20.0)
                            //Header
                            
                            
                            //current image chosen
                            if curItem == nil { //explanation photo
                                Image("Media-Access")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 230, height: 230)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(.bottom, 15.0)
                                
                            } else { //if we have a curItem figure out how to display it
                                if curItem?.mediaType == .photo {
                                    if let image = curItem?.photo {
                                        Image(uiImage: curItem?.photo ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 230, height: 230)
                                            .padding(.bottom, 0.0)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .onAppear {
                                                // Perform image analysis when the image appears
                                                analyzeImage(image)
                                            }
                                    if !altTextSuggestion.isEmpty {
                                        VStack {
                
                                            Text("Alt-Text Suggestion:")
                                                .font(.body)
                                                .multilineTextAlignment(.center)
                                                .padding(.bottom, 2)
                                                .foregroundColor(Color(red: 130/255, green: 160/255, blue: 170/255))
                                            
                                            HStack {
                                                Text(altTextSuggestion)
                                                    .font(.body)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.bottom, 2)
                                                
                                                Button(action: {
                                                    UIPasteboard.general.string = altTextSuggestion // Copy to clipboard
                                                }) {
                                                    Image(systemName: "doc.on.doc") // System name for copy icon
                                                }
                                                
                                            }
                                            
                                        }
                                        .frame(maxWidth: .infinity)
                                     }
                                    }
                                    
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
                                .foregroundColor(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 3)) // Apply rounded corners
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color(red: 130/255, green: 160/255, blue: 170/255), lineWidth: 2) // Apply rounded border
                                )
                                .onTapGesture(count: 1) {
                                    clearEditor()
                                }
                                .padding(.bottom, 5.0)


                            //Text editor input object
                            
                            
                            //Clear & Submit button Stack
                            HStack {
                                
                                
                                //  Cancel Button
                                Button(action: {
                                    print("Cancelled")
                                    if(currentCaption == "Choose one photo, then add a caption to the photo. ") {
                                        currentCaption = ""
                                    }
                                    else {
                                        currentCaption = "Choose one photo, then add a caption to the photo. "
                                    }
                                    
                                }, label: {
                                    HStack {
                                        Image(systemName: "trash") // Check icon
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                            .background(Color.black)
                                            .clipShape(Circle())
                                        Text("CLEAR")
                                            .bold() // Make the text bold
                                            .foregroundColor(.white)
                                    }
                                })
                                .frame(width: 100.0, height: 33.0)
                                .background(Color(red: 130/255, green: 160/255, blue: 170/255))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                
                                
                                //notif Scheduler test code
                                
                                //Notification scheduling test code.
                                
                                
                                
                                //submit button
                                Button(action: {
                                    //On press
                                    if(curItem?.mediaType == .photo) { //save the current photo
                                        
                                    }
                                    // Check if the caption length is within the desired range
                                   let captionLength = currentCaption.count
                                    if captionLength < 15 || captionLength > 150 {
                                            alertMessage = "Caption must be between 15 and 150 characters."
                                            showAlert = true
                                            return
                                        }
                                    
                                   // Check if the caption contains invalid words
                                   let invalidWords = ["image", "picture", "icon"]
                                    for word in invalidWords {
                                           if currentCaption.localizedCaseInsensitiveContains(word) {
                                               alertMessage = "Caption should not include the words 'image', 'picture', or 'icon'."
                                               showAlert = true
                                               return
                                           }
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
                                        currentCaption = "Choose one photo, then add a caption to the photo. "
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: "checkmark") // Check icon
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                            .background(Color.black)
                                            .clipShape(Circle())
                                        Text("SAVE")
                                            .bold() // Make the text bold
                                            .foregroundColor(.white)
                                    }
                                })
                                .frame(width: 100.0, height: 33.0)
                                .background(Color(red: 130/255, green: 160/255, blue: 170/255))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Invalid Caption"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                    //submit button
                                }
                                
                                
                            }
                            .padding(.trailing, 20.0)
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
                                            currentCaption = "Choose one photo, then add a caption to the photo. "
                                        }){Image (systemName: "trash")
                                                .foregroundColor(.black)
                                            
                                            Text("REMOVE").foregroundColor(.black)
                                        }
                                    }
                                    //Trash button
                                    
                                    
                                    //Camera button
                                    ToolbarItem(placement: .principal) {
                                        Button(action:
                                                {self.showCamera.toggle()})
                                        {Image (systemName: "camera")
                                            .foregroundColor(.black)
                                            Text("NEW").foregroundColor(.black)
                                        }
                                    }
                                    //Camera button
                                    
                                    
                                    
                                    //Photo library
                                    ToolbarItem(placement: .primaryAction) {
                                        Button(action:
                                                {showSheet = true})
                                        {Image (systemName: "photo")
                                                .foregroundColor(.black)
                                            Text("OPEN").foregroundColor(.black)
                                        }
                                        .disabled(curItem != nil) // Disable button if curItem is not nil
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
        if(currentCaption == "Choose one photo, then add a caption to the photo. ") {
            currentCaption = ""
        }
    }
    
    private func analyzeImage(_ image: UIImage) {
        let resizedImage = resizeImage(image, targetSize: CGSize(width: 3000, height: 2002))
        
        // Convert image to binary data
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.9) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        let apiKey = "c2b7be37ed4f4f9dab6b3bed64e91bce" // Securely stored API key
        let endpoint = "https://api-vision-alt-text.cognitiveservices.azure.com/vision/v3.2/analyze?visualFeatures=Description&language=en"
        guard let url = URL(string: endpoint) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpBody = imageData
        URLSession.shared.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error analyzing the image: \(error)")
                    self.altTextSuggestion = "Error analyzing the image."
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.altTextSuggestion = "No HTTP response received."
                    return
                }
                guard let data = data, httpResponse.statusCode == 200 else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    self.altTextSuggestion = "Error analyzing the image. Status Code: \(httpResponse.statusCode)"
                    return
                }
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(dataString)")
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = json["description"] as? [String: Any],
                       let captions = description["captions"] as? [[String: Any]],
                       let firstCaption = captions.first,
                       let text = firstCaption["text"] as? String {
                        self.altTextSuggestion = text.capitalizedFirstLetter() // Capitalize the first letter
                    } else {
                        self.altTextSuggestion = "The alt-text sugestion is not available."
                    }
                } catch {
                    print("Error parsing response: \(error)")
                    self.altTextSuggestion = "Error analyzing the image."
                }
            }
        }.resume()
    }

    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        // Determine what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("Error parsing response. Resize image")
        return newImage ?? image
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
            
           currentCaption = "Choose one photo, then add a caption to the photo. "
            return
        }
        
        let potential_caption = IPTCDictionary!["ArtworkContentDescription"]
        
        if(potential_caption == nil)
        {
            
           currentCaption = "Choose one photo, then add a caption to the photo. "
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
    {
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
        let emailViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            //self.presentViewController(emailViewController, animated: true, completion: nil)
        }
    }
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let emailController = MFMailComposeViewController()
       // emailController.mailComposeDelegate = self
        emailController.setSubject("CSV Export")
        emailController.setMessageBody("", isHTML: false)
        // Attaching the .CSV file to the email.
        //emailController.addAttachmentData(NSData(contentsOfFile: "localData")!, mimeType: "text/csv", fileName: "localData.csv")
        return emailController
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


