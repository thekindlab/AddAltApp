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
    
     
     example code:
     
     CoreDataManager.shared.(function that modifies Core Data) <-use this style to modify core data using this class in the ContentView or other code files
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
        
        
            let container = NSPersistentContainer(name: "Local_User_Data") // <- encapsulates the apps Core Data Stack
             
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
          context gives access to model objects that represent a view of one or more persistent stores
                basically we can use context to fetch objects that are stored in Core Data, modify those objects,
          save them back persistent stores, delete them, and revert changes we made.
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
    
    
    
    
    
    
    
    //HELPER METHODS FOR MODIFYING CORE DATA
    
    
    
    func addNewImage(image_data: Data, new_caption: String = "new_caption", photo_caption_length: Int16  = 0 , time_to_caption: Double =  0.0, photo_caption_date: String = "DEFAULT DATE", photo_caption_date_epoch: Double = 0.0)
    {
        
        
        /*
         Robert: In the future we need to figure out how to use async, right now saving captions and stuff is all through this main thread,
         but Core Data support Async storage, which I think we should also be async saving the caption and stuff b/c we don't want it to prevent user
         from using app while doing background functions
         
         */
        
        let context = CoreDataManager.shared.backgroundContext() //get private context
        
          context.performAndWait { // -> in future change to .perform() for async functionality (DON'T CHANGE NOW)
              
                  do{
                      
                      let entity = Photo.entity() //get entity component of Photo entity
                      let photo = Photo(entity: entity, insertInto: context) //create new Photo entity
                      
                      //set photo attributes
                      photo.caption              = new_caption
                      photo.caption_length      = photo_caption_length
                      photo.caption_date        = photo_caption_date
                      photo.caption_date_epoch  = photo_caption_date_epoch
                      photo.time_to_caption     = time_to_caption
                      photo.image_data = image_data
                      try context.save()

                  }
                  catch{
                      
                      debugPrint(error)
                  }
              
            }
        
    }
    
    func addNewStartupInfo(firstUse:Bool = false, captionNumber: Int, daysUsed:Int, dateOfFirstUse: Date)
    {
        
        deleteStartupData() //delete the startup data and replace more current data. 
        
        
        let context = CoreDataManager.shared.backgroundContext()
        
        context.performAndWait {
            
            do{
                
                let entity = Startup.entity()
                let dataOnStartup = Startup(entity: entity, insertInto: context)
                
                dataOnStartup.daysOfUse =  Int64(daysUsed);
                dataOnStartup.firstUse = firstUse
                dataOnStartup.numberOfCaptions = Int64(captionNumber);
                dataOnStartup.dateOfFirstUse = dateOfFirstUse; 
                try context.save()
                
            }
            catch
            {
                
                debugPrint(error)
            }
            
        }
        
        
    }
    
    func removeImage(imageID: String = "") throws
    {
        
        //NEED TO IMPLEMENT
    }
    
    func modifyImage(imageId: String = "" ) throws
    {
        
        
        //NEED TO IMPLEMENT
    }
    
    func loadAllImageData() -> [Photo]?
    { //return array of Photos that are stored in Local Storage
        
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()

        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        } catch {
            debugPrint(error)
        }


        return nil;
        
    }
    
    func loadStartUp() -> [Startup]?
    {
        
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Startup> = Startup.fetchRequest()
        
        do{
            
            let result = try mainContext.fetch(fetchRequest)
            return result
        }
        catch{
            
            debugPrint(error)
        }
        
        return nil;
        
        
    }
    
    
    func deleteAllImageData()
    {//deletes all Photos entity stored in Local_User_Data
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Photo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let myContext = CoreDataManager.shared.mainContext
        
        
        do {
            
            try myContext.execute(deleteRequest)
            try myContext.save()
            
        } catch let error as NSError {
            
            debugPrint(error)
        }
        
        print("deleted all locally stored image data")
    }
    
    func deleteStartupData()
    {//deletes the startup data
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Startup")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let myContext = CoreDataManager.shared.mainContext
        
        
        do {
            
            try myContext.execute(deleteRequest)
            try myContext.save()
            
        } catch let error as NSError {
            
            debugPrint(error)
        }
        
        print("deleted all locally stored Startup data")
        
        
        
    }
    
    
    
    
    //CORE DATA TEST CODE
    
    /*
     Robert: It looks like this works, so adding to local storage persists, now what we need to do is write Helper functions that
    do what we want.
     
     
     */
    
    
    
    func testLoadAllSavedImages() -> [Photo]? //some test code for printing out all the images contents
    {
        
        let mainContext = CoreDataManager.shared.mainContext
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
            do {
                let results = try mainContext.fetch(fetchRequest)
                for saved_photo in results{
                    
                    //print some saved meta data
                    print("This is the images caption \(saved_photo.caption as Any)")
                    print("This is the images caption length \(saved_photo.caption_length as Any)");
                    print("This is the images time to caption \(saved_photo.time_to_caption as Any)")
                    print("This is the date the image was captioned \(String(describing: saved_photo.caption_date))")
                    print("This is the date in epoch that the image was captioned \(saved_photo.caption_date_epoch)")
                }
                
                return results
            }
            catch {
                debugPrint(error)
            }
        
        
        return nil;
    }
    
    //TEST CODE
    
    
    
    
    
    
    
    
}
