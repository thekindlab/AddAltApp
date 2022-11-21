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
     
     CoreDataManager.shared.(function that modifies Core Data) <-use this style to modify core data using this class
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
    
    
    
    func addNewImage(new_caption: String = "new_caption", photo_caption_length: Int16  = 0, photo_tags: [String] = ["no tags"] , photo_caption_quality: Double = 0.0, time_to_caption: Double =  0.0, photo_caption_date: String = "DEFAULT DATE") throws
    { // see testAddNewImage() to see comments about this
        
        
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
                  photo.caption = new_caption
                  photo.tags = photo_tags[0] //need to figure later how to turn tags into array thats being saved
                  photo.caption_quality = photo_caption_quality
                  photo.caption_length = photo_caption_length
                  photo.caption_date = photo_caption_date
                  photo.time_to_caption = time_to_caption
                  
                  try context.save()

              }
              catch{
                  
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
    
    
    
    
    //CORE DATA TEST CODE
    
    /*
     Robert: It looks like this works, so adding to local storage persists, now what we need to do is write Helper functions that
    do what we want.
     
     
     */
    
    
    
    
    func testAddNewImage(new_caption: String = "new_caption", photo_caption_length: Int16  = 0, photo_tags: [String] = ["no tags"] , photo_caption_quality: Double = 0.0, time_to_caption: Double =  0.0, photo_caption_date: String = "DEFAULT DATE")
    {
        let context = CoreDataManager.shared.backgroundContext() //get private context
        
          context.performAndWait {
            
              do{
                  let entity = Photo.entity() //get entity component of Photo entity
                  let photo = Photo(entity: entity, insertInto: context) //create new Photo entity
                  
                  //set photo attributes
                  photo.caption = new_caption
                  
                  //notes on adding Arrays as Attributes, use transformable. PRETTY DANGEROUS.
                  //WHEN I ADDED NIL TRANSFORMABLE CRASHED WHOLE PROGRAM HAD TO DELETE DATABASE TO GET WORKING AGAIN
                  //BE VERY VERY CAREFUL WITH TRANSFORMABLE / DONT PUSH BROKEN PROGRAM DATABASE TO REMOTE PLEASE
                  
                  photo.tags = photo_tags[0] //need to figure later how to turn tags
                  photo.caption_quality = photo_caption_quality
                  photo.caption_length = photo_caption_length
                  photo.time_to_caption = time_to_caption
                  photo.caption_date = photo_caption_date
                  
                  try context.save()
                  print("context saved to local storage")
              }
              catch{
                  
                  debugPrint(error)
              }
              
              
            }
        
        
        
    }
    
    
    
    func testLoadAllSavedImages() -> [Photo]? //some test code for printing out all the images contents
    {
        
        let mainContext = CoreDataManager.shared.mainContext
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
            do {
                let results = try mainContext.fetch(fetchRequest)
                for saved_photo in results{
                    
                    //print all saved meta data
                    print("This is the images caption \(saved_photo.caption as Any)")
                    print("This is the images caption length \(saved_photo.caption_length as Any)");
                    print("This is the images caption quality \(saved_photo.caption_quality as Any)")
                    print("This is the images time to caption \(saved_photo.time_to_caption as Any)")
                    print("This is the image tags [not finished yet] \(saved_photo.tags as Any)")
                    print()
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
