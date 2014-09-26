//
//  AnimatingSprite.h
//  PestControl
//
//  Created by Michael Nwani on 9/25/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int32_t, PCFacingDirection)
{
    PCFacingForward,
    PCFacingBack,
    PCFacingRight,
    PCFacingLeft
};

@interface AnimatingSprite : SKSpriteNode

@property (nonatomic, strong) SKAction *facingForwardAnim;
@property (nonatomic, strong) SKAction *facingBackAnim;
@property (nonatomic, strong) SKAction *facingSideAnim;
@property (nonatomic, assign) PCFacingDirection facingDirection;

+(SKAction *)createAnimWithPrefix:(NSString *)prefix
                           suffix:(NSString *)suffix;

@end
