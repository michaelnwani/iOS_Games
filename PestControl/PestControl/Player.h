//
//  Player.h
//  PestControl
//
//  Created by Michael Nwani on 9/25/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AnimatingSprite.h"

@interface Player : AnimatingSprite

-(void)moveToward:(CGPoint)targetPosition;
-(void)faceCurrentDirection;
@end
