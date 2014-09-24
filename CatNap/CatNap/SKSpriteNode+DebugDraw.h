//
//  SKSpriteNode+DebugDraw.h
//  CatNap
//
//  Created by Michael Nwani on 9/22/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (DebugDraw)

-(void)attachDebugRectWithSize:(CGSize)s;
-(void)attachDebugFrameFromPath:(CGPathRef)bodyPath;

@end
