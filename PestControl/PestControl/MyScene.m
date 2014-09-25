//
//  MyScene.m
//  PestControl
//
//  Created by Michael Nwani on 9/24/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "MyScene.h"
#import "TileMapLayer.h"

@implementation MyScene

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createWorld];
//        NSLog(@"Size: %@", NSStringFromCGSize(self.size));
    }
    
    return self;
}

-(TileMapLayer *)createScenery
{
    return [[TileMapLayer alloc] initWithAtlasNamed:@"scenery" tileSize:CGSizeMake(32, 32) grid:@[@"xxxxxxxxxxxxxxxxxx",
                                                                                                  @"xoooooooooooooooox",
                                                                                                  @"xoooooooooooooooox",
                                                                                                  @"xoooooooooooooooox",
                                                                                                  @"xoooooooooooooooox",
                                                                                                  @"xoooooooooxoooooox",
                                                                                                  @"xoooooooooxoooooox",
                                                                                                  @"xoooooxxxxxoooooox",
                                                                                                  @"xoooooxoooooooooox",
                                                                                                  @"xxxxxxxxxxxxxxxxxx"]];
}

//-(void)didChangeSize:(CGSize)oldSize //called whenever the scene's size changes
//{
//    NSLog(@"Changed size: %@", NSStringFromCGSize(self.size));
//}

-(void)createWorld
{
    _bgLayer = [self createScenery];
    _worldNode = [SKNode node];
    [_worldNode addChild:_bgLayer];
    [self addChild:_worldNode];
    
    self.anchorPoint = CGPointMake(0.5, 0.5); //by doing this, origin has actually been changed to the .5, .5 location.
    _worldNode.position = CGPointMake(-_bgLayer.layerSize.width /2, -_bgLayer.layerSize.height/2); //- half to the left, - half down because of our new origin point being 0.5, 0.5
}
@end
