//
//  MyScene.h
//  ZombieConga
//

//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

//Scene's are the "screens" of the application; subclasses of SKScene
@interface MyScene : SKScene
{
    SKSpriteNode *_zombie;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    CGPoint _lastTouchLocation;
    SKAction *_zombieAnimation;
    SKAction *_catCollisionSound;
    SKAction *_enemyCollisionSound;
    BOOL _invincible;
    int _lives;
    BOOL _gameOver;
    AVAudioPlayer *_backgroundMusicPlayer;
    SKNode *_bgLayer;
}

-(void)playBackgroundMusic:(NSString *)filename;

@end
