//
//  RWTMyScene.h
//  CookieCrunch
//

//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

@import SpriteKit;

@class RWTLevel;

@interface RWTMyScene : SKScene

@property (strong, nonatomic) RWTLevel *level;

-(void)addSpritesForCookies:(NSSet *)cookies;

@end
