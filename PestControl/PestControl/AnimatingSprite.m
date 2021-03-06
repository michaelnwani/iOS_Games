//
//  AnimatingSprite.m
//  PestControl
//
//  Created by Michael Nwani on 9/25/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "AnimatingSprite.h"

@implementation AnimatingSprite

+(SKAction *)createAnimWithPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"characters"];
    
    NSArray *textures = @[[atlas textureNamed:[NSString stringWithFormat:@"%@_%@1", prefix, suffix]],
                          [atlas textureNamed:[NSString stringWithFormat:@"%@_%@2", prefix, suffix]]];
    
    [textures[0] setFilteringMode:SKTextureFilteringNearest];
    [textures[1] setFilteringMode:SKTextureFilteringNearest];
    
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures
                                                          timePerFrame:0.20]];
}

-(void)setFacingDirection:(PCFacingDirection)facingDirection
{
    //1
    _facingDirection = facingDirection;
    
    //2
    switch (facingDirection)
    {
        case PCFacingForward:
            [self runAction:self.facingForwardAnim];
            break;
        case PCFacingBack:
            [self runAction:self.facingBackAnim];
            break;
        case PCFacingLeft:
            [self runAction:self.facingSideAnim];
            break;
        case PCFacingRight:
            [self runAction:self.facingSideAnim];
            //3
            if (self.xScale > 0.0f)
            {
                self.xScale = -self.xScale; //if you set a sprites xScale to a negative value, it flips it around the y-axis
            }
            break;
    }
    
    //4
    if (facingDirection != PCFacingRight && self.xScale < 0.0f)
    {
        self.xScale = -self.xScale; //if you set a sprites xScale to a negative value, it flips it around the y-axis
    }
}
@end
