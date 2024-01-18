//
//  StartupHandler.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 1/20/23.
//

import Foundation


class StartupHandler
{
    private var notif_handler:NotificationHandler?
    
    init(notif_handler: NotificationHandler)
    {
        self.notif_handler = notif_handler
        checkFirstAppUse()
      
    }
    
    
    func checkFirstAppUse()
    {
        print("check first use")
        
        let startupDataWrapper = CoreDataManager.shared.loadStartUp()
        
        
        if(startupDataWrapper == nil)
        { //if there's problems loading the data.
            
            print("error loading startup Data")
        }
        else
        {
            
            let startUpData = (startupDataWrapper!)
            
            if(startUpData.count > 0 )
            { //there exists some startup data to use
                
                print(startUpData[0].firstUse)
            }
            else
            { //no startup data available, => let's create some.
                
                handleNoStartupData() //create a new Startup Core Data entity
                
                //Moved function call to askPermission() function in NotificationHandler so doesn't trigger before get permission
                //notif_handler?.FirstUseNotificationProcedure()
                
            }
            
        }
        
        
    }
    
    func handleNoStartupData()
    {
        var number_of_captions = 0;
        let image_data = CoreDataManager.shared.loadAllImageData()
        
        if(image_data != nil)
        {
            number_of_captions = image_data!.count
            
        }
        
        

        CoreDataManager.shared.addNewStartupInfo(captionNumber: number_of_captions, daysUsed: 0, dateOfFirstUse: Date() )

    }
    
    func updateStartupInformation()
    {
        checkFirstAppUse() //check if no Startup Data is avaiable
        
        let existingStartupInfo = CoreDataManager.shared.loadStartUp()![0]
        let image_data = CoreDataManager.shared.loadAllImageData()
        
        
        let dateOfFirstUse =  existingStartupInfo.dateOfFirstUse
        var daysOfUse:Int;
        var number_of_captions = 0
        
        
        if(image_data == nil)
        {
            
            number_of_captions = 0
        }
        else
        {
            
            number_of_captions = image_data!.count
        }
        
        
        
        if(dateOfFirstUse != nil)
        {
            daysOfUse = abs(Int((Date().timeIntervalSince(dateOfFirstUse!))/(60.0*60*24)))
            //convert the difference in dates in seconds to the difference in days stored as an Int
           
        }
        else
        {
            daysOfUse = 0
           
        }
        
        
        
        CoreDataManager.shared.addNewStartupInfo(captionNumber: number_of_captions, daysUsed: daysOfUse, dateOfFirstUse: dateOfFirstUse!)
        
        
        
    }
    
    
}
