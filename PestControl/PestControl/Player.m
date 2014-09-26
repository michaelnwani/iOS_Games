//
//  Player.m
//  PestControl
//
//  Created by Michael Nwani on 9/25/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "Player.h"
#import "MyScene.h"

@implementation Player

-(instancetype)init
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"characters"];
    SKTexture *texture = [atlas textureNamed:@"player_ft1"];
    texture.filteringMode = SKTextureFilteringNearest;
    
    self = [super initWithTexture:texture];
    if (self)
    {
        self.name = @"player";
        
        //1
        CGFloat minDiam = MIN(self.size.width, self.size.height);
        minDiam = MAX(minDiam-16, 4);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:minDiam/2.0];
        
        //2
        self.physicsBody.usesPreciseCollisionDetection = YES;
        //3
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.restitution = 1;
        self.physicsBody.friction = 0;
        self.physicsBody.linearDamping = 0; //do not dampen linear velocity at all
        
        self.physicsBody.categoryBitMask = PCPlayerCategory;
        self.physicsBody.contactTestBitMask = 0xFFFFFFFF; //he can come into contact with any physics body, is all.
        self.physicsBody.collisionBitMask = PCBoundaryCategory | PCWallCategory | PCWaterCategory;
        
        self.facingForwardAnim = [Player createAnimWithPrefix:@"player" suffix:@"ft"];
        self.facingBackAnim = [Player createAnimWithPrefix:@"player" suffix:@"bk"];
        self.facingSideAnim = [Player createAnimWithPrefix:@"player" suffix:@"lt"];
        
    }
    
    return self;
}

-(void)moveToward:(CGPoint)targetPosition
{
    CGPoint targetVector = CGPointNormalize(CGPointSubtract(targetPosition, self.position)); //normalize the distance between the destination point and the current point. First subtract the distance, then get the unit vector
    targetVector = CGPointMultiplyScalar(targetVector, 300);
    self.physicsBody.velocity = CGVectorMake(targetVector.x, targetVector.y); //where to move to (per frame). quite simple
    [self faceCurrentDirection];
}

-(void)faceCurrentDirection
{
    //1
    PCFacingDirection facingDir = self.facingDirection;
    CGVector dir = self.physicsBody.velocity;
    if (abs(dir.dy) > abs(dir.dx))
    {
        if (dir.dy < 0)
        {
            facingDir = PCFacingForward; //facing forward is our "going down" animation
        }
        else
        {
            facingDir = PCFacingBack; //our "going up" animation;
        }
    }
    else
    {
        facingDir = (dir.dx > 0) ? PCFacingRight : PCFacingLeft;
    }
    
    //3
    self.facingDirection = facingDir; //setFacingDirection
}
@end
