//
//  CucumberishLoader.m
//  Media-AccessTests
//
//  Created by Kristoffer Martin on 6/7/22.
//

#import <Foundation/Foundation.h>
#import "Media_AccessTests-Swift.h"

__attribute__((constructor))
void CucumberishInit(){
    
    [CucumberishInitializer setupCucumberish];
}
