//
//  RWTCookie.h
//  CookieCrunch
//
//  Created by Michael Nwani on 1/16/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

@import SpriteKit;

static const NSUInteger NumCookieTypes = 6;

@interface RWTCookie : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSUInteger cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;

-(NSString *)spriteName;
-(NSString *)highlightedSpriteName;
@end
