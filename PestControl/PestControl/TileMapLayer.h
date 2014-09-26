//
//  TileMapLayer.h
//  PestControl
//
//  Created by Michael Nwani on 9/24/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"

@class Bug;

@interface TileMapLayer : SKNode

@property (readonly, nonatomic) CGSize gridSize;
@property (readonly, nonatomic) CGSize layerSize;

@property (readonly, nonatomic) CGSize tileSize;

-(instancetype)initWithAtlasNamed:(NSString *)atlasName
                         tileSize:(CGSize)tileSize
                             grid:(NSArray *)grid;

-(BOOL)isValidTileCoord:(CGPoint)coord;
-(CGPoint)pointForCoord:(CGPoint)coord;
-(CGPoint)coordForPoint:(CGPoint)point;

-(SKNode*)tileAtCoord:(CGPoint)coord;
-(SKNode*)tileAtPoint:(CGPoint)point;
@end
