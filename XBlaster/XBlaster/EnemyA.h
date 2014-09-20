//
//  EnemyA.h
//  XBlaster
//
//  Created by Michael Nwani on 9/20/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "Entity.h"

@class AISteering;

@interface EnemyA : Entity
{
    int         _score;
    int         _damageTakenPerShot;
    NSString    *_healthMeterText;
}

@property (strong,nonatomic) AISteering *aiSteering;
@property (strong,nonatomic) SKLabelNode *scoreLabel;

@end
