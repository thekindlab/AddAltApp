import XCTest
import Foundation
import Cucumberish


class CucumberishInitializer: NSObject {

    @objc class func setupCucumberish() {
    
      before({ _ in
      
      
        Given("Given I have an image of \"([^\\\"]*)\" captioned and am ready to save it") { args, _ in

         //code for captioned image
        }
        
        When(" I click the save button") { args, _ in
        
        //code for button saving image
        }
        
        Then("Then The captioned image of \"([^\\\"]*)\" should be saved to the album for captioned images with the caption \"([^\\\"]*)\" ") { args, _ in


        }


        
        Given(" I have multiple images captioned and ready to be saved") { args, _ in
         //code for captioned image
        }
        
        When(" I click the save button") { args, _ in
        
        //code for button saving image
        }
        
        Then(" all of the captioned images should be saved to the album for captioned images") { args, _ in
        }

            
        Given(" Given I have an image of \"([^\\\"]*)\" I would like to caption ") { args, _ in
         //code for captioned image
        }
        
        When(" I click on it from the phone library") { args, _ in
        
        //code for button saving image
        }
        
        Then(" Then I should be able to caption the image with text \"([^\\\"]*)\"  ") { args, _ in
        }

          Given(" I have selected an image and would like to not caption it anymore") { args, _ in
         //code for captioned image
        }
        
        When("I click on the remove button for the image") { args, _ in
        
        //code for button saving image
        }
        
        Then("Then I should be able to remove the image  ") { args, _ in
        }


      
      let bundle = Bundle(for: CucumberishInitializer.self)

          Cucumberish.executeFeatures(inDirectory:"Features", from: bundle, includeTags:nil, excludeTags:nil)
          
      })
    
    
    }



}
