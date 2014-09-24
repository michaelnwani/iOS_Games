//
//  OldTVNode.h
//  CatNap
//
//  Created by Michael Nwani on 9/23/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h> //to get access to AVPlayer

@interface OldTVNode : SKSpriteNode
{
    AVPlayer *_player;
    SKVideoNode *_videoNode;
}


-(instancetype)initWithRect:(CGRect)frame;

@end
