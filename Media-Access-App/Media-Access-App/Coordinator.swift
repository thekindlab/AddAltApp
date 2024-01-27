import UIKit
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        
        //set new start time for caption time object.
        //set curItem as a PhotoPickerModel of the selected Image
        let start_time = Date().timeIntervalSinceReferenceDate
        self.picker.captionTimeControl.setStartCaptionTime(newStartTime: start_time)
        self.picker.curItem = PhotoPickerModel(with: selectedImage)
        
        self.picker.isPresented.wrappedValue.dismiss()
        
    }
    
}
        
