//
//  SlideshowViewController.h
//  PlayerProject
//
//  Created by Georges Kovacs Ribeiro on 26/10/12.
//  Copyright (c) 2012 Felipe Gringo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
@interface SlideshowViewController : MainViewController
@property (strong, nonatomic) UIImageView* animatedImageView;
@property (strong, nonatomic) NSMutableArray* images;
@end
