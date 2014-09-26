//
//  Bug.m
//  PestControl
//
//  Created by Michael Nwani on 9/25/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "Bug.h"
#import "MyScene.h"
#import "TileMapLayer.h"

static SKAction *sharedFacingBackAnim = nil;
static SKAction *sharedFacingForwardAnim = nil;
static SKAction *sharedFacingSideAnim = nil;

@implementation Bug

+(void)initialize
{
    static dispatch_once_t onceToken; //run once and only once, across all threads.
    dispatch_once(&onceToken, ^{
        sharedFacingForwardAnim = [Bug createAnimWithPrefix:@"bug" suffix:@"ft"];
        sharedFacingBackAnim = [Bug createAnimWithPrefix:@"bug" suffix:@"bk"];
        sharedFacingSideAnim = [Bug createAnimWithPrefix:@"bug" suffix:@"lt"];
    });
}


-(instancetype)init
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"characters"];
    SKTexture *texture = [atlas textureNamed:@"bug_ft1"];
    texture.filteringMode = SKTextureFilteringNearest;
    
    self = [super initWithTexture:texture];
    if (self)
    {
        self.name = @"bug";
        
        CGFloat minDiam = MIN(self.size.width, self.size.height);
        minDiam = MAX(minDiam-8, 8);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:minDiam/2];
        self.physicsBody.categoryBitMask = PCBugCategory;
        self.physicsBody.collisionBitMask = 0;
        [self runAction:self.facingForwardAnim];
    }
    
    return self;
}

-(void)walk
{
    //1
    TileMapLayer *tileLayer = (TileMapLayer *)self.parent;
    
    //2
    CGPoint tileCoord = [tileLayer coordForPoint:self.position]; //returns the correct grid for the specified x,y
    int randomX = arc4random() % 3 - 1;
    int randomY = arc4random() % 3 - 1;
    CGPoint randomCoord = CGPointMake(tileCoord.x + randomX, tileCoord.y + randomY);
    
    //3
    BOOL didMove = NO;
    MyScene *scene = (MyScene*)self.scene;
    if ([tileLayer isValidTileCoord:randomCoord] && ![scene tileAtCoord:randomCoord
                                                            hasAnyProps:(PCWallCategory | PCWaterCategory)])
    {
        //4
        didMove = YES;
        CGPoint randomPos = [tileLayer pointForCoord:randomCoord]; //returns the (x,y) at the center of the given grid coordinates
        SKAction *moveToPos = [SKAction sequence:@[[SKAction moveTo:randomPos duration:1],
                                                   [SKAction runBlock:^{
            [self walk];
        }
                                                    ]]];
        
        [self runAction:moveToPos];
        [self facingDirection:CGPointMake(randomX, randomY)];
        
        
    }
    
    //5
    if (!didMove)
    {
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.25 withRange:0.15],
                                             [SKAction performSelector:@selector(walk) onTarget:self]
                                             ]
                         ]];
    }
    
}

-(void)start
{
    [self walk];
}

-(SKAction *)facingBackAnim
{
    return sharedFacingBackAnim;
}

-(SKAction *)facingForwardAnim
{
    return sharedFacingForwardAnim;
}

-(SKAction *)facingSideAnim
{
    return sharedFacingSideAnim;
}

-(void)facingDirection:(CGPoint)dir
{
    //1
    PCFacingDirection facingDir = self.facingDirection;
    //2
    if (dir.y != 0 && dir.x != 0)
    {
        //3
        facingDir = dir.y < 0 ? PCFacingBack : PCFacingForward;
        self.zRotation = dir.y < 0 ? M_PI_4 : -M_PI_4;
        if (dir.x > 0)
        {
            self.zRotation *= -1;
        }
    }
    else
    {
        //4
        self.zRotation = 0;
        
        //5
        if (dir.y == 0)
        {
            if (dir.x > 0)
            {
                facingDir = PCFacingRight;
            }
            else if (dir.x < 0)
            {
                facingDir = PCFacingLeft;
            }
        }
        else if (dir.y < 0)
        {
            facingDir = PCFacingBack;
        }
        else
        {
            facingDir = PCFacingForward;
        }
        
    }
    
    //6
    self.facingDirection = facingDir;
}
@end
