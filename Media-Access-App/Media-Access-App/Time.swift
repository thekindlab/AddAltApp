//
//  Time.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 11/21/22.
//

import Foundation
import SwiftUI
import AVKit
import UIKit

class Time: ObservableObject {
    
     private var startCaptionTime = 0.0
     private var FinishCaptionTime = 0.0
    
    init()
    {
        
        
    }
    
     func setStartCaptionTime(newStartTime: Double = 0.0)
    {
        self.startCaptionTime = newStartTime
    }
    
    func setFinishCaptionTime(newFinishTime: Double = 0.0)
    {
        self.FinishCaptionTime = newFinishTime
        
    }
    
    func getFinishCaptionTime() -> Double
    {
        return self.FinishCaptionTime
        
    }
    
    func getStartCaptionTime() ->Double
    {
        return self.startCaptionTime
        
    }
    
}
