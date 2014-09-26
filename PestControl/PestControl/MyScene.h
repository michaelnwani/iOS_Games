//
//  MyScene.h
//  PestControl
//

//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(uint32_t, PCPhysicsCategory)
{
  PCBoundaryCategory = 1 << 0,
    PCPlayerCategory = 1 << 1,
    PCBugCategory    = 1 << 2,
    PCWallCategory   = 1 << 3,
    PCWaterCategory  = 1 << 4,
};

@class TileMapLayer, Player, Bug;


@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    SKNode *_worldNode;
    TileMapLayer *_bgLayer;
    Player *_player;
    Bug *_bug;
    TileMapLayer *_bugLayer;
}

-(BOOL)tileAtPoint:(CGPoint)point hasAnyProps:(uint32_t)props;
-(BOOL)tileAtCoord:(CGPoint)coord hasAnyProps:(uint32_t)props;
@end
