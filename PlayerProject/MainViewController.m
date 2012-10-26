//
//  MainViewController.m
//  PlayerProject
//
//  Created by Felipe Gringo on 10/17/12.
//  Copyright (c) 2012 Felipe Gringo. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

- (void)viewDidLoad {
    [[NSBundle mainBundle] loadNibNamed:@"MainViewController" owner:self options:nil];
    [self initVariables];
    [self initInterface];
    [super viewDidLoad];
    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice]orientation];
    [self swithBetweenToolbarsBasedOnOrientation:interfaceOrientation];
    
}


- (void)initVariables {
    likability = kUnknowenLikability;
    toolbarHideTime = 0;
    areToolbarsActive = YES;
    isMiniDetailActive = NO;
    canTap = YES;
    
    fbButtonFrame = self.fbButton.frame;
    twitterButtonFrame = self.twitterButton.frame;
    exitButtonFrame = self.exitButton.frame;
}

- (void) singleTouchNotification:(NSNotification *)notification {
    if(!canTap) return;
    UITouch* touch = (UITouch*)[notification.userInfo objectForKey:@"touch"];
    CGPoint location =[touch locationInView:touch.view];
    NSLog(@"(%f,%f)",location.x,location.y);
    
    if (areToolbarsActive){
        if(touch.view.frame.size.height>=320) {
            [self animateToolbars];
            [self stopToolBarsTimer];
            areToolbarsActive = NO;
        }
        
    }
    else {
        [self animateToolbars];
        [self startToolBarsTimer];
    }
    canTap = NO;
    float interval = 0.1f;
    NSTimer* tapTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                     target:self
                                                   selector:@selector(tapTick:)
                                                   userInfo:nil
                                                    repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:tapTimer forMode:NSRunLoopCommonModes];
}


- (void)animateToolbars {
    
    CGFloat superiorToolbarYLnd, inferiorToolbarYLnd, superiorToolbarYPrt, inferiorToolbarYPrt;
    
    if (areToolbarsActive) {
        superiorToolbarYLnd = -50;
        inferiorToolbarYLnd = 320+45;
        superiorToolbarYPrt = superiorToolbarYLnd;
        inferiorToolbarYPrt = 480+45;
        areToolbarsActive = NO;
    }
    else {
        superiorToolbarYLnd = 0;
        inferiorToolbarYLnd = 320-45;
        superiorToolbarYPrt = superiorToolbarYLnd;
        inferiorToolbarYPrt = 480-45;
        areToolbarsActive = YES;
    }
    
    [UIView beginAnimations:@"toolbarsAnimation" context:nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.3f];
    [self.inferiorToolBarLandscape setFrame:CGRectMake(self.inferiorToolBarLandscape.frame.origin.x, inferiorToolbarYLnd, self.inferiorToolBarLandscape.frame.size.width, self.inferiorToolBarLandscape.frame.size.height)];
    [self.superiorToolBarLandscape setFrame:CGRectMake(self.superiorToolBarLandscape.frame.origin.x, superiorToolbarYLnd, self.superiorToolBarLandscape.frame.size.width, self.superiorToolBarLandscape.frame.size.height)];
    [self.inferiorToolBarPortrait setFrame:CGRectMake(self.inferiorToolBarPortrait.frame.origin.x, inferiorToolbarYPrt, self.inferiorToolBarPortrait.frame.size.width, self.inferiorToolBarPortrait.frame.size.height)];
    [self.superiorToolBarPortrait setFrame:CGRectMake(self.superiorToolBarPortrait.frame.origin.x, superiorToolbarYPrt, self.superiorToolBarPortrait.frame.size.width, self.superiorToolBarPortrait.frame.size.height)];
    [UIView commitAnimations];
    
}


- (void)startToolBarsTimer {
    toolBarsTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                     target:self
                                                   selector:@selector(toolbarsTick:)
                                                   userInfo:nil
                                                    repeats:YES];
    areToolbarsActive = YES;
    [[NSRunLoop mainRunLoop] addTimer:toolBarsTimer forMode:NSRunLoopCommonModes];
}

- (void)stopToolBarsTimer {
    if ([toolBarsTimer isValid]) {
        [toolBarsTimer invalidate];
        toolBarsTimer = nil;
    }
    toolbarHideTime = 0;
}

- (void)setupProgressBar {
    double i = playerController.moviePlayer.duration;
    int intValueOfInterval = i;
    double remainder  = i - intValueOfInterval;
    double toComplete = 1 - remainder;
    i += toComplete;

    self.videoProgressLnd.maximumValue = i-1;
    self.videoProgressPrt.maximumValue = i-1;
    self.videoProgressLnd.value = 0;
    self.videoProgressPrt.value = 0;
    playerController.moviePlayer.currentPlaybackTime = 0;
}


- (void)playerTick:(NSTimer*)t {
    
    if ([t isEqual:playerTimer]){
        NSString *e, *c;
        e = [self timeInToString:playerController.moviePlayer.currentPlaybackTime];
        c = [self timeInToString:(playerController.moviePlayer.duration-playerController.moviePlayer.currentPlaybackTime)];
        
        [self.elapsedTimeLabelLnd setText:e];
        [self.countDownTimeLabelLnd setText:c];
        [self.elapsedTimeLabelPrt setText:e];
        [self.countDownTimeLabelPrt setText:c];
    }
}

- (void) progressTick:(NSTimer *)t {
    if ([t isEqual:progressTimer]) {
        [UIView beginAnimations:@"progressBarMovement" context:nil];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDuration: t.timeInterval];
        self.videoProgressLnd.value+=t.timeInterval;
        self.videoProgressPrt.value+=t.timeInterval;
        [UIView commitAnimations];
    }
}

- (void) toolbarsTick:(NSTimer*) t {
    if ([t isEqual:toolBarsTimer]){
    [self animateToolbars];
    [self stopToolBarsTimer];
        areToolbarsActive = NO;
    }
}

- (void) tapTick:(NSTimer*) t {
   canTap = true;
}

- (void)startPlayerProgressTimer {
    int progressValue;
    if (playerController.moviePlayer.currentPlaybackTime == NAN) progressValue = 0;
    else progressValue = playerController.moviePlayer.currentPlaybackTime;
    
    self.videoProgressLnd.value = progressValue;
    self.videoProgressPrt.value = progressValue;
    
    

    float interval = 1.0f/120.0f;
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(progressTick:)
                                                 userInfo:nil
                                                  repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:progressTimer forMode:NSRunLoopCommonModes];
    
}

- (void)stopPlayerProgressTimer {
    [progressTimer invalidate];
    progressTimer = nil;
}

- (void)startPlayerTimeControlTimer {
    float interval = 1.0f/30.0f;
    playerTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(playerTick:)
                                                 userInfo:nil
                                                  repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:playerTimer forMode:NSRunLoopCommonModes];
    
}

- (void)stopPlayerTimeControlTimer {
    [playerTimer invalidate];
    playerTimer = nil;
}

- (void)initTimeLabels {
    [self.countDownTimeLabelLnd setText:[self timeInToString:playerController.moviePlayer.duration]];
    [self.countDownTimeLabelPrt setText:self.countDownTimeLabelLnd.text];
}

- (void)initPlayerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerController.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(singleTouchNotification:)
                                                 name:@"MLSingleTouch"
                                               object:nil];
   
}

- (void)initPlayer {
    NSBundle* bundle    = [NSBundle mainBundle];
    NSString* path      = [bundle pathForResource:@"Movie" ofType:@"m4v"];
    NSURL   * url       = [NSURL fileURLWithPath:path];
    
    playerController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [playerController.moviePlayer setFullscreen:NO];
    [playerController.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [playerController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [playerController.moviePlayer.view setFrame:CGRectMake(0, 0, videoLayer.frame.size.width, videoLayer.frame.size.height)];
    videoView = playerController.moviePlayer.view;
    [videoLayer addSubview:playerController.moviePlayer.view];
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice]orientation];
    [self swithBetweenToolbarsBasedOnOrientation:interfaceOrientation];
    [playerController.moviePlayer prepareToPlay];
    [playerController.moviePlayer performSelector:@selector(stop) withObject:nil afterDelay:0.01];
    
    [self performSelector:@selector(initPlayerNotifications)  withObject:nil afterDelay:0.2];
    [self performSelector:@selector(initTimeLabels)           withObject:nil afterDelay:0.3];
    [self performSelector:@selector(setupProgressBar)         withObject:nil afterDelay:0.3];
    
}

- (void)initInterface {
    [self initPlayer];
    
    [self.view addSubview:self.superiorToolBarLandscape];
    [self.view addSubview:self.inferiorToolBarLandscape];
    [self.view addSubview:self.superiorToolBarPortrait];
    [self.view addSubview:self.inferiorToolBarPortrait];
    
    [self.superiorToolBarLandscape setFrame:CGRectMake(0, 0, self.superiorToolBarLandscape.frame.size.width, self.superiorToolBarLandscape.frame.size.height)];
    [self.inferiorToolBarLandscape setFrame:CGRectMake(0,320-45, self.inferiorToolBarLandscape.frame.size.width, self.inferiorToolBarLandscape.frame.size.height)];
    
    [self.superiorToolBarPortrait setFrame:CGRectMake(0, 0, self.superiorToolBarPortrait.frame.size.width, self.superiorToolBarPortrait.frame.size.height)];
    [self.inferiorToolBarPortrait setFrame:CGRectMake(0, 480-45, self.inferiorToolBarPortrait.frame.size.width, self.inferiorToolBarPortrait.frame.size.height)];
    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice]orientation];
    [self swithBetweenToolbarsBasedOnOrientation:interfaceOrientation];
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:Nil];
}





- (void) moviePlayerPlaybackStateChanged:(NSNotification*) notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    if(playbackState == MPMoviePlaybackStatePlaying) {
        [self startPlayerProgressTimer];
        [self startPlayerTimeControlTimer];
        [self startToolBarsTimer];
    }
    else if(playbackState == MPMoviePlaybackStatePaused) {
        [self stopPlayerProgressTimer];
        [self stopPlayerTimeControlTimer];
        [self stopToolBarsTimer];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)progressUp:(id)sender {
    [playerController.moviePlayer play];
}

- (IBAction)playVideo:(id)sender {
    [playerController.moviePlayer play];
}

- (IBAction)likeAction:(UIButton*)sender {
    if (likability != kLike){
        likability = kLike;
        [self.likeButtonLnd setSelected:YES];
        [self.likeButtonPrt setSelected:YES];
        [self.unlikeButtonLnd setSelected:NO];
        [self.unlikeButtonPrt setSelected:NO];

    }
}

- (IBAction)unlikeAction:(UIButton*)sender {
    if (likability != kUnline){
        likability = kUnline;
        [self.unlikeButtonLnd setSelected:YES];
        [self.unlikeButtonPrt setSelected:YES];
        [self.likeButtonLnd setSelected:NO];
        [self.likeButtonPrt setSelected:NO];
    }
}

- (IBAction)favoriteAction:(UIButton*)sender {
    [self.favoriteButtonLnd setSelected:!sender.selected];
    [self.favoriteButtonPrt setSelected:!sender.selected];
}

- (IBAction)videoExecutionAction:(UIButton*)sender {
    [self.executeButtonLnd setSelected:!sender.selected];
    [self.executeButtonPrt setSelected:!sender.selected];
    
    if (sender.selected){
        [playerController.moviePlayer play];
    } else {
        [playerController.moviePlayer pause];
    }
}


- (void)movieFinishedCallback:(NSNotification*)n{
    [self.replayButtonLnd setHidden:NO];
    [self.replayButtonLnd setEnabled:YES];
    [self.replayButtonPrt setHidden:NO];
    [self.replayButtonPrt setEnabled:YES];
    
    [self.executeButtonLnd setHidden:YES];
    [self.executeButtonLnd setEnabled:NO];
    [self.executeButtonPrt setHidden:YES];
    [self.executeButtonPrt setEnabled:NO];
    
    [self.presentationEndLayer setHidden:NO];
    [self.presentationEndLayer setUserInteractionEnabled:YES];
    
    [self performSelector:@selector(stopPlayerProgressTimer) withObject:nil afterDelay:1.0f];
    [self stopPlayerTimeControlTimer];
    [self.countDownTimeLabelLnd performSelector:@selector(setText:) withObject:@"00:00" afterDelay:1.0f];
    [self.countDownTimeLabelPrt performSelector:@selector(setText:) withObject:@"00:00" afterDelay:1.0f];
    [self animateToolbars];
    [self setupProgressBar];
}


- (IBAction)videoReplayAction:(UIButton *)sender {
    [self.replayButtonLnd setHidden:YES];
    [self.replayButtonLnd setEnabled:NO];
    [self.replayButtonPrt setHidden:YES];
    [self.replayButtonPrt setEnabled:NO];
    
    [self.executeButtonLnd setHidden:NO];
    [self.executeButtonLnd setEnabled:YES];
    [self.executeButtonPrt setHidden:NO];
    [self.executeButtonPrt setEnabled:YES];
    
    [self.presentationEndLayer setHidden:YES];
    [self.presentationEndLayer setUserInteractionEnabled:NO];
    
    [self performSelector:@selector(videoExecutionAction:) withObject:self.executeButtonLnd];
    [playerController.moviePlayer setCurrentPlaybackTime:0];
    [playerController.moviePlayer play];

    
}

- (IBAction)facebookAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"~Media Link~"
                                               message:@"This will bring the Facebook API"
                                              delegate:self
                                     cancelButtonTitle:@"DISSMISS"
                                     otherButtonTitles:nil];
    [alert show];
}

- (IBAction)twitterAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"~Media Link~"
                                               message:@"This will bring the Twitter API"
                                              delegate:self
                                     cancelButtonTitle:@"DISSMISS"
                                     otherButtonTitles:nil];
    [alert show];
}

- (IBAction)exitAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"~Media Link~"
                                               message:@"EXIT"
                                              delegate:self
                                     cancelButtonTitle:@"DISSMISS"
                                     otherButtonTitles:nil];
    [alert show];
}

- (IBAction)backwardAction:(id)sender {
    [playerController.moviePlayer setCurrentPlaybackTime:0.0f];
}

- (IBAction)forwardAction:(id)sender {
    [playerController.moviePlayer setCurrentPlaybackTime:19.0f];
}

- (IBAction)slideMiniDetails:(id)sender {
    
    if (isMiniDetailActive){
        isMiniDetailActive = NO;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.miniDetailView setFrame:CGRectMake(self.miniDetailView.frame.origin.x, -6, self.miniDetailView.frame.size.width, self.miniDetailView.frame.size.height)];
        } completion:nil];
    }
    else {
        isMiniDetailActive = YES;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.miniDetailView setFrame:CGRectMake(self.miniDetailView.frame.origin.x, 42, self.miniDetailView.frame.size.width, self.miniDetailView.frame.size.height)];
        } completion:nil];
    }
    
}

- (IBAction)sliderValueChange:(id)sender {
    
    UISlider *slider = (UISlider*)sender;
    float progress = [slider value]/22.0f;
    [playerController.moviePlayer pause];
    //float current = playerController.moviePlayer.currentPlaybackTime;
    float total = playerController.moviePlayer.duration;
    playerController.moviePlayer.currentPlaybackTime = progress*total;
    //[self startToolBarsTimer];
    [playerController.moviePlayer play];
    //[playerController.moviePlayer pause];

}

- (NSString*)timeInToString:(NSTimeInterval)i {
    NSString* intervalString = nil;
    
    int intValueOfInterval = i;
    double remainder  = i - intValueOfInterval;
    double toComplete = 1 - remainder;
    i += toComplete;
    
    NSDate  *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:i];
    
    unsigned int unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *time = [calendar components:unitFlags fromDate:now toDate:date options:0];
    int minutes = [time minute];
    int seconds = [time second];
    
    intervalString = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    return intervalString;
}


-(void)didRotate:(NSNotification*)notification{
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice]orientation];
    [self swithBetweenToolbarsBasedOnOrientation:interfaceOrientation];
}

- (void)toolBarAlphaChange:(NSNumber*)landscape {
    BOOL _landscape = [landscape boolValue];
    if(_landscape) {
    [self.superiorToolBarLandscape setAlpha:1.0f];
    [self.inferiorToolBarLandscape setAlpha:1.0f];
    [self.superiorToolBarPortrait setAlpha:0.0f];
    [self.inferiorToolBarPortrait setAlpha:0.0f];
    }
    else {
        [self.superiorToolBarPortrait setAlpha:1.0f];
        [self.inferiorToolBarPortrait setAlpha:1.0f];
        [self.superiorToolBarLandscape setAlpha:0.0f];
        [self.inferiorToolBarLandscape setAlpha:0.0f];
    }
}
-(void)swithBetweenToolbarsBasedOnOrientation:(UIDeviceOrientation)orientation {
    
    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight) {
        if(areToolbarsActive) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.superiorToolBarPortrait setAlpha:0.0f];
             
            [self.inferiorToolBarPortrait setAlpha:0.0f];
        } completion:nil];
        
        [UIView animateWithDuration:0.2f delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.superiorToolBarLandscape setAlpha:1.0f];
            [self.inferiorToolBarLandscape setAlpha:1.0f];
        } completion:nil];
        }
        else {
            [self.superiorToolBarPortrait setAlpha:0.0f];
            [self.inferiorToolBarPortrait setAlpha:0.0f];
            [self.superiorToolBarLandscape setAlpha:0.0f];
            [self.inferiorToolBarLandscape setAlpha:0.0f];
            [self performSelector:@selector(toolBarAlphaChange:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0f];
        }
        [self.superiorToolBarPortrait setUserInteractionEnabled:NO];
        [self.inferiorToolBarPortrait setUserInteractionEnabled:NO];
        [self.superiorToolBarLandscape setUserInteractionEnabled:YES];
        [self.inferiorToolBarLandscape setUserInteractionEnabled:YES];
        [videoView setFrame:CGRectMake(0, 0, 480, 320)];
        [videoLayer setFrame:CGRectMake(0, 0, 480, 320)];
        
        [self.fbButton setFrame:fbButtonFrame];
        [self.twitterButton setFrame:twitterButtonFrame];
        [self.exitButton setFrame:exitButtonFrame];
    }
    else if (orientation == UIDeviceOrientationPortrait) {
         //    orientation == UIDeviceOrientationPortraitUpsideDown) {
         if(areToolbarsActive) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.superiorToolBarPortrait setAlpha:1.0f];
            [self.inferiorToolBarPortrait setAlpha:1.0f];
        } completion:nil];
        
        [UIView animateWithDuration:0.2f delay:0.2f options:UIViewAnimationOptionCurveLinear animations:^{
            [self.superiorToolBarLandscape setAlpha:0.0f];
            [self.inferiorToolBarLandscape setAlpha:0.0f];
        } completion:nil];
         }
         else {
             [self.superiorToolBarPortrait setAlpha:0.0f];
             [self.inferiorToolBarPortrait setAlpha:0.0f];
             [self.superiorToolBarLandscape setAlpha:0.0f];
             [self.inferiorToolBarLandscape setAlpha:0.0f];
            [self performSelector:@selector(toolBarAlphaChange:) withObject:[NSNumber numberWithBool:NO] afterDelay:1.0f];
         }
        [self.superiorToolBarPortrait setUserInteractionEnabled:YES];
        [self.inferiorToolBarPortrait setUserInteractionEnabled:YES];
        [self.superiorToolBarLandscape setUserInteractionEnabled:NO];
        [self.inferiorToolBarLandscape setUserInteractionEnabled:NO];
        //float ratio = 320.0f/480.0f;
        [videoView setFrame:CGRectMake(0, 0, 320, 480)];
        [videoLayer setFrame:CGRectMake(0, 0, 480, 320)];
        
        const float y = (480-90)/2;
        float x = (320-(fbButtonFrame.size.width + twitterButtonFrame.size.width + exitButtonFrame.size.width))/2;
        
        [self.fbButton setFrame:CGRectMake(x, y, fbButtonFrame.size.width, fbButtonFrame.size.height)];
        [self.twitterButton setFrame:CGRectMake(x+fbButtonFrame.size.width, y, twitterButtonFrame.size.width, twitterButtonFrame.size.height)];
        [self.exitButton setFrame:CGRectMake(x+fbButtonFrame.size.width+twitterButtonFrame.size.width, y, exitButtonFrame.size.width, exitButtonFrame.size.height)];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
