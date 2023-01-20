//
//  NotificationHandler.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 1/15/23.
//

import Foundation
import UserNotifications

//https://github.com/indently/SimpleNotifications/blob/main/SimpleNotifications/Handlers/Notifications.swift
//template for setting up easy to use notifications.


class NotificationHandler

{
    init(){
        
        askPermission()
        
        //
        let startupDataWrapper = CoreDataManager.shared.loadStartUp()
        
        
        if(startupDataWrapper == nil)
        {
            
            
        }
        else
        {
            
            let startUpData = (startupDataWrapper!)
            
            if(startUpData.count > 0 )
            { //there exists some startup data to use
                
                print(startUpData[0].firstUse)
            }
            else
            {
                
            CoreDataManager.shared.addNewStartupInfo(captionNumber: 0, dayUse: 1) //should probably be doing this in like a StartupHandler Class
                
                
            }
            
            
           
            
        }
        
        
        
        
        
        
        
        
        //I think we should probably set up weekly notifications on first startup of the app.
        //also can think of sending notification to caption after 
    }
    
    func askPermission()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){
            success, error in
            
            if success{
                
                print("User granted access for sending notifications")
                
            }
            else if let error = error
            {
                print(error.localizedDescription)
                
            }
            
        }
        
        
    }
    
    
    func sendNotification(date: Date, type: String, timeInterval:Double, title:String, body: String, shouldRepeat: Bool = false)
    {
        
        
        var trigger: UNNotificationTrigger? //type of trigger we will use for local notifications.
        
        
        //type of trigger
        
        if type == "date"
        {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: shouldRepeat)
            
        }
        else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: shouldRepeat)
            
        }
        
        //content of the notification
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        
        //create the request
        //so this is a local request for a notification
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        
        
    }
    
    
    
    
}
