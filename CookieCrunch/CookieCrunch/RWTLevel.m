//
//  RWTLevel.m
//  CookieCrunch
//
//  Created by Michael Nwani on 1/16/15.
//  Copyright (c) 2015 Michael Nwani. All rights reserved.
//

#import "RWTLevel.h"

@implementation RWTLevel{
    RWTCookie *_cookies[NumColumns][NumRows];
    RWTTile *_tiles[NumColumns][NumRows];
}

-(RWTCookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %1d", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %1d", (long)row);
    
    return _cookies[column][row];
}

-(NSSet *)shuffle
{
    return [self createInitialCookies];
}

-(NSSet *)createInitialCookies
{
    NSMutableSet *set = [NSMutableSet set];
    
    //1
    for (NSInteger row = 0; row < NumRows; row++)
    {
        for (NSInteger column = 0; column < NumColumns; column++)
        {
            //This line is new:
            if (_tiles[column][row] != nil)
            {
                //2
                NSUInteger cookieType = arc4random_uniform(NumCookieTypes) + 1;
                
                //3
                RWTCookie *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
                
                //4
                [set addObject:cookie];
            }
            
        }
    }
    
    return set;
}

-(RWTCookie *)createCookieAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cookieType
{
    RWTCookie *cookie = [[RWTCookie alloc] init];
    cookie.cookieType = cookieType;
    cookie.column = column;
    cookie.row = row;
    _cookies[column][row] = cookie;
    return cookie;
}

-(NSDictionary *)loadJSON:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path == nil)
    {
        NSLog(@"Could not find level file: %@", filename);
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil)
    {
        NSLog(@"Could not load level file: %@, error: %@", filename, error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
        return nil;
    }
    
    return dictionary;
}

-(instancetype)initWithFile:(NSString *)filename
{
    self = [super init];
    if (self != nil)
    {
        NSDictionary *dictionary = [self loadJSON:filename];
        
        //Loop through the rows
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            
            //Loop through the columns in the current row
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                
                //Note: In Sprite Kit (0,0) is at the bottom of the screen,
                //so we need to read this file upside down.
                NSInteger tileRow = NumRows - row - 1;
                
                //If the value is 1, create a tile object
                if ([value integerValue] == 1)
                {
                    _tiles[column][tileRow] = [[RWTTile alloc] init];
                }
            }];
        }];
    }
    
    return self;
}

-(RWTTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %1d", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %1d", (long)row);
    
    return _tiles[column][row];
}
@end
























