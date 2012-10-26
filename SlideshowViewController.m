//
//  SlideshowViewController.m
//  PlayerProject
//
//  Created by Georges Kovacs Ribeiro on 26/10/12.
//  Copyright (c) 2012 Felipe Gringo. All rights reserved.
//

#import "SlideshowViewController.h"

@interface SlideshowViewController() {
    int touchBeganX, touchBeganY;
    int touchMovedX, touchMovedY;
    int state;
}
- (void) viewDidSwipeLeft;
- (void) viewDidSwipeRight;
@end

@implementation SlideshowViewController
@synthesize animatedImageView;


- (void)initPlayer {
    return;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    state = 0;
    self.images = [NSArray arrayWithObjects:
              [UIImage imageNamed:@"slide1.png"],
              [UIImage imageNamed:@"slide2.png"],
              [UIImage imageNamed:@"slide3.png"], nil];
    self.animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    //[self.view addSubview:animatedImageView];
    self.animatedImageView.animationImages = self.images;//etc
    self.animatedImageView.animationDuration = 3.0f * [animatedImageView.animationImages count];
    self.animatedImageView.animationRepeatCount = 0;
    //[self.animatedImageView startAnimating];
    [videoLayer addSubview: self.animatedImageView];
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice]orientation];
    [self swithBetweenToolbarsBasedOnOrientation:interfaceOrientation];
    [super animateToolbars];
    [self performSelector:@selector(initPlayerNotifications)  withObject:nil afterDelay:0.3f];
}

-(void)swithBetweenToolbarsBasedOnOrientation:(UIDeviceOrientation)orientation {
    [super swithBetweenToolbarsBasedOnOrientation:orientation];
   if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight) {
       self.animatedImageView.frame = CGRectMake(0, 0, 480, 320);
    }
    if(orientation == UIDeviceOrientationPortrait) {
        
    self.animatedImageView.frame = CGRectMake(0, (480-(320*320)/480)/2, 320, (320*320)/480);
    }
    NSLog(@"%d",orientation);
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt;
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] == 1) {
        UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
        if ([touch tapCount] == 1) {
            pt = [touch locationInView:self.view];
            touchBeganX = pt.x;
            touchBeganY = pt.y;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt;
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] == 1) {
        UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
        if ([touch tapCount] == 1) {
            pt = [touch locationInView:self.view];
            touchMovedX = pt.x;
            touchMovedY = pt.y;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] == 1) {
        int diffX = touchMovedX - touchBeganX;
        int diffY = touchMovedY - touchBeganY;
        if (diffY >= -20 && diffY <= 20) {
            if (diffX > 20) {
                NSLog(@"swipe right");
                [self viewDidSwipeRight];
               // if (swipeDelegate) [swipeDelegate viewDidSwipeRight:self];
            } else if (diffX < -20) {
                NSLog(@"swipe left");
                [self viewDidSwipeLeft];
                //if (swipeDelegate) [swipeDelegate viewDidSwipeLeft:self];
            }
        }
    }
}

- (void) getRotatedArray {
    int a,b,c;
    a = state;
    b = (state+1)%3;
    c = (state+1)%3;
    
    NSString *image1, *image2, *image3;
    image1 = [NSString stringWithFormat:@"slide%d.png",a];
    image2 = [NSString stringWithFormat:@"slide%d.png",b];
    image3 = [NSString stringWithFormat:@"slide%d.png",c];
    self.images = [NSMutableArray arrayWithObjects:
                   [UIImage imageNamed:image1],
                   [UIImage imageNamed:image2],
                   [UIImage imageNamed:image3], nil];
    self.animatedImageView.animationImages = self.images;
}

- (void) viewDidSwipeLeft {
    state = (state-1)%3;
}

- (void) viewDidSwipeRight {
    state = (state+1)%3;
}

@end
