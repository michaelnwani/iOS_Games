//
//  RWTCookie.m
//  CookieCrunch
//
//  Created by Michael Nwani on 1/16/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

#import "RWTCookie.h"

@implementation RWTCookie

-(NSString *)spriteName
{
    static NSString * const spriteNames[] = {
        @"Croissant",
        @"Cupcake",
        @"Danish",
        @"Donut",
        @"Macaroon",
        @"SugarCookie",
    };
    
    return spriteNames[self.cookieType - 1];
}

-(NSString *)highlightedSpriteName
{
    static NSString * const highlightedSpriteNames[] = {
        @"Croissant-Highlighted",
        @"Cupcake-Highlighted",
        @"Danish-Highlighted",
        @"Donut-Highlighted",
        @"Macaroon-Highlighted",
        @"SugarCookie-Highlighted",
    };
    
    return highlightedSpriteNames[self.cookieType - 1];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"type:%1d square:(%1d,%1d)", (long)self.cookieType,
            (long)self.column, (long)self.row];
}
@end
