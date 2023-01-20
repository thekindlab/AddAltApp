//
//  StartupHandler.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 1/20/23.
//

import Foundation


class StartupHandler
{
    
    init(notif_handler: NotificationHandler)
    {
        checkFirstAppUse()
        
    }
    
    
    func checkFirstAppUse()
    {
        
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
            { //no startup data available, lets create some. 
                
                handleNoStartupData() //create a new Startup Core Data entity
                
                
            }
            
        }
        
        
    }
    
    func handleNoStartupData()
    {
        
        let image_data = CoreDataManager.shared.loadAllImageData()
        let number_of_captions = image_data!.count
        CoreDataManager.shared.addNewStartupInfo(captionNumber: number_of_captions, dayUse: 0, dateOfFirstUse: Date() )
        
    }
    
    func updateStartupInformation()
    {
        
        
    }
    
    
}
