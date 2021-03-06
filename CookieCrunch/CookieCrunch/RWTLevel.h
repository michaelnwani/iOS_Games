//
//  RWTLevel.h
//  CookieCrunch
//
//  Created by Michael Nwani on 1/16/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

#import "RWTCookie.h"
#import "RWTTile.h"
#import "RWTSwap.h"
#import "RWTChain.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface RWTLevel : NSObject

-(NSSet *)shuffle; //fills up the level with random cookies

-(RWTCookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;

-(instancetype)initWithFile:(NSString *)filename;
-(RWTTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
-(void)performSwap:(RWTSwap *)swap;
-(BOOL)isPossibleSwap:(RWTSwap *)swap;

-(NSSet *)removeMatches;
-(NSArray *)fillHoles;
-(NSArray *)topUpCookies;
-(void)detectPossibleSwaps;

@property (assign, nonatomic) NSUInteger targetScore;
@property (assign, nonatomic) NSUInteger maximumMoves;

-(void)resetComboMultiplier;
@end
