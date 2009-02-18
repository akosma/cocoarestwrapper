//
//  WindowController.m
//  WrapperTest
//
//  Created by Adrian on 10/18/08.
//  Copyright 2008 Adrian Kosmaczewski. All rights reserved.
//

#import "Controller.h"
#import "Wrapper.h"

@implementation Controller

#pragma mark -
#pragma mark Constructor and destructor

- (id)init
{
    if (self = [super init])
    {
        engine = [[Wrapper alloc] init];
        engine.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [engine release];
    engine = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    [popUpButton removeAllItems];
    [popUpButton addItemsWithTitles:[NSArray arrayWithObjects:@"GET", @"POST", @"PUT", @"DELETE", nil]];
}

#pragma mark -
#pragma mark WrapperDelegate methods

- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data
{
    NSString *text = [engine responseAsText];
    if (text != nil)
    {
        [output setStringValue:text];
    }
    [indicator stopAnimation:self];
}

- (void)wrapperHasBadCredentials:(Wrapper *)wrapper
{
    [indicator stopAnimation:self];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Bad credentials!" 
                                     defaultButton:@"OK" 
                                   alternateButton:nil 
                                       otherButton:nil 
                         informativeTextWithFormat:nil];
    [alert runModal];
}

- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url
{
    [indicator stopAnimation:self];
    NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Resource created at %@!", url]
                                     defaultButton:@"OK" 
                                   alternateButton:nil 
                                       otherButton:nil 
                         informativeTextWithFormat:nil];
    [alert runModal];
}

- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error
{
    [indicator stopAnimation:self];
    NSAlert *alert = [NSAlert alertWithError:error];
    [alert runModal];
}

- (void)wrapper:(Wrapper *)wrapper didReceiveStatusCode:(int)statusCode
{
    [indicator stopAnimation:self];
    NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Status code not OK: %d!", statusCode]
                                     defaultButton:@"OK" 
                                   alternateButton:nil 
                                       otherButton:nil 
                         informativeTextWithFormat:nil];
    [alert runModal];
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)launch:(id)sender
{
    NSURL *url = [NSURL URLWithString:[address stringValue]];
    NSDictionary *parameters = nil;
    if ([[parameter stringValue] length] > 0)
    {
        NSArray *keys = [NSArray arrayWithObjects:@"parameter", nil];
        NSArray *values = [NSArray arrayWithObjects:[parameter stringValue], nil];
        parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }

    [indicator startAnimation:self];
    [output setStringValue:@""];

    [engine sendRequestTo:url usingVerb:[popUpButton titleOfSelectedItem] withParameters:parameters];
}

@end
