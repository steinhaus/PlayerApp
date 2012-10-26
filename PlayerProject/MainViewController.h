//
//  MainViewController.h
//  PlayerProject
//
//  Created by Felipe Gringo on 10/17/12.
//  Copyright (c) 2012 Felipe Gringo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

enum {
    kUnknowenLikability,
    kLike,
    kUnline
};

@interface MainViewController : UIViewController {
    IBOutlet UIView *videoLayer;
    
    int likability, toolbarHideTime;
    double kVideoProgressSlideUnit;
    BOOL areToolbarsActive, isMiniDetailActive;
    
    NSTimer *playerTimer, *progressTimer, *toolBarsTimer;
    MPMoviePlayerViewController *playerController;
    UIView* videoView;
    BOOL canTap;
    CGRect fbButtonFrame, twitterButtonFrame, exitButtonFrame;
}

- (IBAction)dismiss:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *executeButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCountDownLabel;
@property (weak, nonatomic) IBOutlet UISlider *videoProgress;

//OUTLET THAT HOLDS 'TWITTER | FACEBOOK | EXIT' BUTOTNS
@property (strong, nonatomic) IBOutlet UIView *presentationEndLayer;

//OUTLETS FOR SUPERIOR TOOLBAR PORTRAIT ORIENTATIONS
@property (strong, nonatomic) IBOutlet UIButton *backButtonPrt;
@property (strong, nonatomic) IBOutlet UIButton *likeButtonPrt;
@property (strong, nonatomic) IBOutlet UIButton *unlikeButtonPrt;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButtonPrt;
@property (strong, nonatomic) IBOutlet UIButton *moveMiniDetailButtonPrt;
@property (strong, nonatomic) IBOutlet UIView *miniDetailView;
@property (strong, nonatomic) IBOutlet UIView *superiorToolBarPortrait;

//OUTLETS FOR SUPERIOR TOOLBAR LANDSCAPE ORIENTATIONS
@property (strong, nonatomic) IBOutlet UIButton *backButtonsLnd;
@property (strong, nonatomic) IBOutlet UIButton *likeButtonLnd;
@property (strong, nonatomic) IBOutlet UIButton *unlikeButtonLnd;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButtonLnd;
@property (strong, nonatomic) IBOutlet UIView *superiorToolBarLandscape;

//OUTLETS FOR INFERIOR TOOLBAR PORTRAIT ORIENTATIONS
@property (strong, nonatomic) IBOutlet UIButton *replayButtonPrt;
@property (strong, nonatomic) IBOutlet UIButton *executeButtonPrt;
@property (strong, nonatomic) IBOutlet UISlider *videoProgressPrt;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabelPrt;
@property (strong, nonatomic) IBOutlet UILabel *countDownTimeLabelPrt;
@property (strong, nonatomic) IBOutlet UIView *inferiorToolBarPortrait;


//OUTLETS FOR INFERIOR TOOLBAR LANDSCAPE ORIENTATIONS
@property (strong, nonatomic) IBOutlet UIButton *replayButtonLnd;
@property (strong, nonatomic) IBOutlet UIButton *executeButtonLnd;
@property (strong, nonatomic) IBOutlet UISlider *videoProgressLnd;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabelLnd;
@property (strong, nonatomic) IBOutlet UILabel *countDownTimeLabelLnd;
@property (strong, nonatomic) IBOutlet UIView *inferiorToolBarLandscape;


@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;




- (IBAction)progressUp:(id)sender;
- (IBAction)playVideo:(id)sender;
- (IBAction)likeAction:(UIButton*)sender;
- (IBAction)unlikeAction:(UIButton*)sender;
- (IBAction)favoriteAction:(UIButton*)sender;
- (IBAction)videoExecutionAction:(UIButton*)sender;
- (IBAction)videoReplayAction:(UIButton*)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)backwardAction:(id)sender;
- (IBAction)forwardAction:(id)sender;
- (IBAction)slideMiniDetails:(id)sender;
- (IBAction)sliderValueChange:(id)sender;


- (NSString*)timeInToString:(NSTimeInterval)i;
- (void)setupProgressBar;
- (void)swithBetweenToolbarsBasedOnOrientation:(UIDeviceOrientation)orientation;
- (void)singleTouchNotification:(NSNotification*)notification;

- (void) viewDidLoad;
- (void) initVariables;
- (void) initInterface;
- (void) animateToolbars;
- (void) initPlayerNotifications;

@end
