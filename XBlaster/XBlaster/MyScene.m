//
//  MyScene.m
//  XBlaster
//
//  Created by Michael Nwani on 9/18/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    SKNode *_playerLayerNode;
    SKNode *_hudLayerNode;
    SKAction *_scoreFlashAction;
    SKLabelNode *_playerHealthLabel;
    NSString *_healthBar;
}

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        /* Setup your scene here */
        
        [self setupSceneLayers];
        [self setupUI];
        
//        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
//        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
//        
//        myLabel.text = @"Hello, World!";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        
//        myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight; //aligning the text ACCORDING the label's position. We set the label's position to the center of the screen, so the text will be aligned to the left of the center of the screen
//        [self addChild:myLabel];
    }
    return self;
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)setupSceneLayers
{
    //zPosition = the height of a node relative to its parent; the nodes with the higher numbers are closer to the viewer (as in, on the stack of layers displaying each other, it would be the top-most layer)
    _playerLayerNode = [SKNode node];
    [self addChild:_playerLayerNode];
    
    _hudLayerNode = [SKNode node];
    [self addChild:_hudLayerNode];
}

-(void)setupUI
{
    int barHeight = 45;
    CGSize backgroundSize = CGSizeMake(self.size.width, barHeight);
    
    SKColor *backgroundColor = [SKColor colorWithRed:0 green:0 blue:0.05 alpha:1.0];
    SKSpriteNode *hudBarBackground = [SKSpriteNode spriteNodeWithColor:backgroundColor size:backgroundSize];
    
    hudBarBackground.position = CGPointMake(0, self.size.height - barHeight);
    hudBarBackground.anchorPoint = CGPointZero;
    [_hudLayerNode addChild:hudBarBackground];
    
    //1
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    //2
    scoreLabel.fontSize = 20.0;
    scoreLabel.text = @"Score: 0";
    scoreLabel.name = @"scoreLabel";
    //3
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    //4; the frame is the smallest rectangle that represents this node and its content
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - scoreLabel.frame.size.height + 3);
    //5
    [_hudLayerNode addChild:scoreLabel];
    
    _scoreFlashAction = [SKAction sequence:
                            @[[SKAction scaleTo:1.5 duration:0.1],
                              [SKAction scaleTo:1.0 duration:0.1]] //knows to execute these actions on whatever node is running them
                         ];
    [scoreLabel runAction:[SKAction repeatAction:_scoreFlashAction count:10]];
    
    //1
    _healthBar = @"============================================================";

    float testHealth = 75;
    NSString *actualHealth = [_healthBar substringToIndex:(testHealth / 100 *_healthBar.length)];
    
    //2
    SKLabelNode *playerHealthBackground = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    playerHealthBackground.name = @"playerHealthBackground";
    playerHealthBackground.fontColor = [SKColor darkGrayColor];
    playerHealthBackground.fontSize = 10.0f;
    playerHealthBackground.text = _healthBar;
    
    //3
    playerHealthBackground.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    playerHealthBackground.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    playerHealthBackground.position = CGPointMake(0, self.size.height - barHeight + playerHealthBackground.frame.size.height);
    [_hudLayerNode addChild:playerHealthBackground];
    
    //4
    _playerHealthLabel = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    _playerHealthLabel.name = @"playerHealth";
    _playerHealthLabel.fontColor = [SKColor whiteColor];
    _playerHealthLabel.fontSize = 10.0f;
    _playerHealthLabel.text = actualHealth;
    _playerHealthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _playerHealthLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _playerHealthLabel.position = CGPointMake(0, self.size.height - barHeight + _playerHealthLabel.frame.size.height);
    [_hudLayerNode addChild:_playerHealthLabel];
    
    
    
}

@end
