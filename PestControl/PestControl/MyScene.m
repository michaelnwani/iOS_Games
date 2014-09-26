//
//  MyScene.m
//  PestControl
//
//  Created by Michael Nwani on 9/24/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "MyScene.h"
#import "TileMapLayer.h"
#import "TileMapLayerLoader.h"
#import "Player.h"
#import "Bug.h"

@implementation MyScene

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self createWorld];
        [self createCharacters];
        [self centerViewOn:_player.position]; //WOWza!
//        NSLog(@"Size: %@", NSStringFromCGSize(self.size));
    }
    
    return self;
}

-(TileMapLayer *)createScenery
{
//    return [[TileMapLayer alloc] initWithAtlasNamed:@"scenery" tileSize:CGSizeMake(32, 32) grid:@[@"xxxxxxxxxxxxxxxxxx",
//                                                                                                  @"xoooooooooooooooox",
//                                                                                                  @"xoooooooooooooooox",
//                                                                                                  @"xoooooooooooooooox",
//                                                                                                  @"xoooooooooooooooox",
//                                                                                                  @"xoooooooooxoooooox",
//                                                                                                  @"xoooooooooxoooooox",
//                                                                                                  @"xoooooxxxxxoooooox",
//                                                                                                  @"xoooooxoooooooooox",
//                                                                                                  @"xxxxxxxxxxxxxxxxxx"]];
    
    return [TileMapLayerLoader tileMapLayerFromFileNamed:@"level-1-bg.txt"];
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
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    SKNode *bounds = [SKNode node];
    bounds.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, _bgLayer.layerSize.width, _bgLayer.layerSize.height)];
    bounds.physicsBody.categoryBitMask = PCBoundaryCategory;
    bounds.physicsBody.friction = 0;
    [_worldNode addChild:bounds];

    self.physicsWorld.contactDelegate = self;
    
    
}

-(void)centerViewOn:(CGPoint)centerOn
{
//    CGSize size = self.size;
//    
//    CGFloat x = Clamp(centerOn.x, size.width/2, _bgLayer.layerSize.width - size.width /2); //value, min, max
//    CGFloat y = Clamp(centerOn.y, size.height/2, _bgLayer.layerSize.height - size.height /2);
//    
//    _worldNode.position = CGPointMake(-x, -y); //because of the change in the anchor point to 0.5, 0.5 of the scene
    
    _worldNode.position = [self pointToCenterViewOn:centerOn];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [_player moveToward:[touch locationInNode:_worldNode]];
}

-(void)createCharacters
{
    _bugLayer = [TileMapLayerLoader tileMapLayerFromFileNamed:@"level-1-bugs.txt"];
    [_worldNode addChild:_bugLayer];
    
    _player = [Player node];
    _player.position = CGPointMake(300, 300);
    [_worldNode addChild:_player];
    
    [_bugLayer enumerateChildNodesWithName:@"bug" usingBlock:^(SKNode *node, BOOL *stop) {
        [(Bug*)node start];
    }];
}

-(void)didSimulatePhysics //after physics simulations have been performed
{
//    [self centerViewOn:_player.position]; //called every frame essentially
    
    CGPoint target = [self pointToCenterViewOn:_player.position];
    
    CGPoint newPosition = _worldNode.position;
    newPosition.x += (target.x - _worldNode.position.x) * 0.1f;
    newPosition.y += (target.y - _worldNode.position.y) * 0.1f;
    
    _worldNode.position = newPosition;
}

-(CGPoint)pointToCenterViewOn:(CGPoint)centerOn
{
    CGSize size = self.size;
    
    CGFloat x = Clamp(centerOn.x, size.width/2, _bgLayer.layerSize.width - size.width /2); //value, min, max
    CGFloat y = Clamp(centerOn.y, size.height/2, _bgLayer.layerSize.height - size.height /2);
    
    return CGPointMake(-x, -y);
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *other = (contact.bodyA.categoryBitMask == PCPlayerCategory ? contact.bodyB : contact.bodyA);
    
    if (other.categoryBitMask == PCBugCategory)
    {
        [other.node removeFromParent];
    }
}

-(BOOL)tileAtCoord:(CGPoint)coord hasAnyProps:(uint32_t)props
{
    return [self tileAtPoint:[_bgLayer pointForCoord:coord] hasAnyProps:props];
}

-(BOOL)tileAtPoint:(CGPoint)point hasAnyProps:(uint32_t)props
{
    SKNode *tile = [_bgLayer tileAtPoint:point];
    return tile.physicsBody.categoryBitMask & props;
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    //1
    SKPhysicsBody *other = (contact.bodyA.categoryBitMask == PCPlayerCategory ? contact.bodyB : contact.bodyA);
    
    //2
    if (other.categoryBitMask & _player.physicsBody.collisionBitMask) //if it has a bit in common
    {
        //3
        [_player faceCurrentDirection];
    }
}
@end
