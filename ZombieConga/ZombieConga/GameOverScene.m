//
//  GameOverScene.m
//  ZombieConga
//
//  Created by Michael Nwani on 9/17/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"

@implementation GameOverScene

-(instancetype)initWithSize:(CGSize)size won:(BOOL)won
{
    self = [super initWithSize:size];
    
    if (self)
    {
        SKSpriteNode *bg;
        if (won)
        {
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"YouWin"];
            [self runAction:[SKAction sequence:@[
                                                 [SKAction waitForDuration:0.1],
                                                 [SKAction playSoundFileNamed:@"win.wav" waitForCompletion:NO]
                                                 ]]];
        }
        else
        {
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"YouLose"];
            [self runAction:[SKAction sequence:@[
                                                 [SKAction waitForDuration:0.1],
                                                 [SKAction playSoundFileNamed:@"lose.wav" waitForCompletion:NO]
                                                 ]]];
        }
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        //More here
        SKAction *wait = [SKAction waitForDuration:3.0];
        SKAction *block = [SKAction runBlock:^{
            MyScene *myScene = [[MyScene alloc] initWithSize:self.size];
            
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition:reveal];
        }];
        [self runAction:[SKAction sequence:@[wait, block]]];
    }
    
    return self;
}
@end
