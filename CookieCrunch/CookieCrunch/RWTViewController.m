//
//  RWTViewController.m
//  CookieCrunch
//
//  Created by Michael Nwani on 1/16/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

@import AVFoundation; //The @import keyword lets Xcode add the framework to our project automatically, don't have to manually do it
#import "RWTViewController.h"
#import "RWTMyScene.h"
#import "RWTLevel.h"

@interface RWTViewController()

@property (strong, nonatomic) RWTLevel *level;
@property (strong, nonatomic) RWTMyScene *scene;

@property (assign, nonatomic) NSUInteger movesLeft;
@property (assign, nonatomic) NSUInteger score;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameOverPanel;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;

@property (strong, nonatomic) AVAudioPlayer *backgroundMusic;
@end

@implementation RWTViewController

-(IBAction)shuffleButtonPressed:(id)sender
{
    [self shuffle];
    [self decrementMoves];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    //Create and configure the scene.
    self.scene = [RWTMyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //Load the level.
    self.level = [[RWTLevel alloc] initWithFile:@"Level_1"];
    self.scene.level = self.level;
    [self.scene addTiles];
    
    id block = ^(RWTSwap *swap)
    {
        self.view.userInteractionEnabled = NO;
        
        if ([self.level isPossibleSwap:swap])
        {
            [self.level performSwap:swap];
            [self.scene animateSwap:swap completion:^
             {
                 [self handleMatches];
             }];
        }
        else
        {
            [self.scene animateInvalidSwap:swap completion:^{
                self.view.userInteractionEnabled = YES;
            }];
        }
        
    };
    
    self.scene.swipeHandler = block;
    
    self.gameOverPanel.hidden = YES;
    
    //Present the scene
    [skView presentScene:self.scene];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Mining by Moonlight" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic play];
    
    //Let's start the game!
    [self beginGame];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)beginGame
{
    
    self.movesLeft = self.level.maximumMoves;
    self.score = 0;
    [self updateLabels];
    [self.level resetComboMultiplier];
    
    [self.scene animateBeginGame];
    
    [self shuffle];
}

-(void)shuffle
{
    [self.scene removeAllCookieSprites]; //remove the previous cookie sprites
    
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
}

-(void)handleMatches
{
    NSSet *chains = [self.level removeMatches];
    if ([chains count] == 0)
    {
        [self beginNextTurn];
        return;
    }
    [self.scene animateMatchedCookies:chains completion:^{
        for (RWTChain *chain in chains)
        {
            self.score += chain.score;
        }
        [self updateLabels];
        NSArray *columns = [self.level fillHoles];
        [self.scene animateFallingCookies:columns completion:^{
            NSArray *columns = [self.level topUpCookies];
            [self.scene animateNewCookies:columns completion:^{
                [self handleMatches];
            }];
        }];
    }];
}

-(void)beginNextTurn
{
    [self.level resetComboMultiplier];
    [self.level detectPossibleSwaps];
    self.view.userInteractionEnabled = YES;
    [self decrementMoves];
}

-(void)updateLabels
{
    self.targetLabel.text = [NSString stringWithFormat:@"%1u", (long)self.level.targetScore];
    self.movesLabel.text = [NSString stringWithFormat:@"%1u", (long)self.movesLeft];
    self.scoreLabel.text = [NSString stringWithFormat:@"%1u", (long)self.score];
}

-(void)decrementMoves
{
    self.movesLeft--;
    [self updateLabels];
    
    if (self.score >= self.level.targetScore)
    {
        self.gameOverPanel.image = [UIImage imageNamed:@"LevelComplete"];
        [self showGameOver];
    }
    else if (self.movesLeft == 0)
    {
        self.gameOverPanel.image = [UIImage imageNamed:@"GameOver"];
        [self showGameOver];
    }
}

-(void)showGameOver
{
    self.shuffleButton.hidden = YES;
    
    [self.scene animateGameOver];
    
    self.gameOverPanel.hidden = NO;
    self.scene.userInteractionEnabled = NO;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGameOver)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

-(void)hideGameOver
{
    self.shuffleButton.hidden = NO;
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = nil;
    
    self.gameOverPanel.hidden = YES;
    self.scene.userInteractionEnabled = YES;
    
    [self beginGame];
}
@end
