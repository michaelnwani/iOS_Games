//
//  MainMenuScene.m
//  ZombieConga
//
//  Created by Michael Nwani on 9/18/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "MainMenuScene.h"
#import "MyScene.h"

@implementation MainMenuScene

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"MainMenu"];
     
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKAction *block = [SKAction runBlock:^{
        MyScene *myScene = [[MyScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition doorwayWithDuration:0.5];
        
        [self.view presentScene:myScene transition:transition];
    }];
    
    [self runAction:block];
    
}
@end
