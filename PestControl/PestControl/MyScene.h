//
//  MyScene.h
//  PestControl
//

//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TileMapLayer;

@interface MyScene : SKScene
{
    SKNode *_worldNode;
    TileMapLayer *_bgLayer;
}

@end
