//
//  RWTChain.m
//  CookieCrunch
//
//  Created by Michael Nwani on 1/25/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

#import "RWTChain.h"

@implementation RWTChain{
    NSMutableArray *_cookies;
}

-(void)addCookie:(RWTCookie *)cookie
{
    if (_cookies == nil)
    {
        _cookies = [NSMutableArray array];
    }
    [_cookies addObject:cookie];
}

-(NSArray *)cookies
{
    return _cookies;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"type:%1d cookies:%@", (long)self.chainType, self.cookies];
}


@end
