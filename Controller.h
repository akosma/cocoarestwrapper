//
//  WindowController.h
//  WrapperTest
//
//  Created by Adrian on 10/18/08.
//  Copyright 2008 Adrian Kosmaczewski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WrapperDelegate.h"

@class Wrapper;

@interface Controller : NSObject <WrapperDelegate> 
{
@private
    IBOutlet NSTextField *address;
    IBOutlet NSTextField *parameter;
    IBOutlet NSTextField *output;
    IBOutlet NSProgressIndicator *indicator;
    IBOutlet NSPopUpButton *popUpButton;

    Wrapper *engine;
}

- (IBAction)launch:(id)sender;

@end
