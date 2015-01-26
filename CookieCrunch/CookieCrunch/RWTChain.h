//
//  RWTChain.h
//  CookieCrunch
//
//  Created by Michael Nwani on 1/25/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

@class RWTCookie;

typedef NS_ENUM(NSUInteger, ChainType){
    ChainTypeHorizontal,
    ChainTypeVertical,
};

@interface RWTChain : NSObject

@property (strong, nonatomic, readonly) NSArray *cookies;

@property (assign, nonatomic) ChainType chainType;

-(void)addCookie:(RWTCookie *)cookie;


@end
