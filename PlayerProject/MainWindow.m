//
//  MainWindow.m
//  PlayerProject
//
//  Created by Georges Kovacs Ribeiro on 24/10/12.
//  Copyright (c) 2012 Felipe Gringo. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow
- (void) sendEvent:(UIEvent *)event {
    
    NSSet* touches = [event allTouches];
    if([touches count]==1) {
        UITouch *touch = [touches anyObject];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:touch forKey:@"touch"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MLSingleTouch" object:nil userInfo:userInfo];
    }
    [super sendEvent:event];
}
@end
