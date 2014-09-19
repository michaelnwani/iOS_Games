//
//  MyScene.m
//  AvailableFonts
//
//  Created by Michael Nwani on 9/18/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    int _familyIdx;
}
-(instancetype)initWithSize:(CGSize)size {
    
    self = [super initWithSize:size];
    if (self)
    {
        [self showCurFamily];
    }
    return self;
}

-(void)showCurFamily
{
    //1
    [self removeAllChildren];
    
    //2
    NSString *familyName = [UIFont familyNames][_familyIdx];
    NSLog(@"%@", familyName);
    
    //3
    NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    
    //4
    [fontNames enumerateObjectsUsingBlock:^(NSString *fontName, NSUInteger idx, BOOL *stop) {
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
        label.text = fontName;
        label.position = CGPointMake(self.size.width/2, (self.size.height * (idx+1)/(fontNames.count + 1) ));
        label.fontSize = 20.0;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:label];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    _familyIdx++;
    if (_familyIdx >= [UIFont familyNames].count)
    {
        _familyIdx = 0;
    }
    [self showCurFamily];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
