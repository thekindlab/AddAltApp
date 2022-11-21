//
//  CoreDataManager.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 11/20/22.
//

import Foundation
import CoreData



class CoreDataManager{ //implemented a Singleton CoreDataManager object
    
    
    /*
     CLASS DESCRIPTION:
     
     
     Use CoreDataManager class to do all operations to Core Data.
    
    */
    
    
    static let shared  =  CoreDataManager() //single instance of CoreDataManager to make changes to CoreData persistent stores
    private  init(){ //singleton constructor.
        
        
        
    }
    
    private lazy var persistentContainer: NSPersistentContainer = { //creates CoreData Stack
        
           //Robert's notes:
        
            /*
             
             sets up the model, context, and store coordinator all at once.
             more info at : https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
             
             */
        
        
            let container = NSPersistentContainer(name: "Media-Access-App") // <- encapsulates the apps Core Data Stack
        
            container.loadPersistentStores(completionHandler: { _, error in //load any persistent locally stored data
                
                _ = error.map { fatalError("Unresolved error \($0)") }
            })
        
        
            return container
        
        }()
    
    
    //Access Core Data Stack
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext //gives reference to programs current main context
        
        //Robert's notes on what context is:
        
        /*
          context gives access to model objects that represent a "view" of one or more persistent stores
                basically we can use context to fetch objects that are stored in Core Data, modify those objects,
          save them back persistent stores and revert changes we made.
        */
        
    }

    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
        
        //Robert's notes:
        
        /*
         creates a new privately managed object context (does not contain information related to the projects current object stored in Database object)
         is used to create new contexts that can be saved to Local Data Storage, also tells other contexts about these changes
         
         */
        
    }
    
    
    
    //Helper methods for modifying Core Data
    func addNewImage()
    {
        
        
        //NEED TO IMPLEMENT
    }
    
    func removeImage()
    {
        
        //NEED TO IMPLEMENT
    }
    
    func modifyImage()
    {
        
        
        //NEED TO IMPLEMENT
    }
    
    
    
    
    //test code to see if it works.
    
    
    
    
    
    
    
    
    
    
    
    
}
