//
//  TileMapLayer.m
//  PestControl
//
//  Created by Michael Nwani on 9/24/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "TileMapLayer.h"
#import "Bug.h"

@implementation TileMapLayer

SKTextureAtlas *_atlas;

-(instancetype)initWithAtlasNamed:(NSString *)atlasName tileSize:(CGSize)tileSize grid:(NSArray *)grid
{
    self = [super init];
    if (self)
    {
        _atlas = [SKTextureAtlas atlasNamed:atlasName];
        
        _tileSize = tileSize; //size of one tile (its width and height)
        _gridSize = CGSizeMake([grid.firstObject length], grid.count); // #x#
        _layerSize = CGSizeMake(_tileSize.width * _gridSize.width, _tileSize.height * _gridSize.height); //designed to make sure all the tiles fit properly on the scene (its just the fitter, size of a tile * the column length (_gridSize.width) tells the screen how wide to be. Same with the row length
        
        for (int row = 0; row < grid.count; row++)
        {
            NSString *line = grid[row];
            for (int col = 0; col < line.length; col++)
            {
                SKSpriteNode *tile = [self nodeForCode:[line characterAtIndex:col]];
                if (tile != nil)
                {
                    tile.position = [self positionForRow:row col:col];
                    [self addChild:tile];
                }
            }
        }
    }
    
    return self;
}


-(SKSpriteNode *)nodeForCode:(unichar)tileCode
{
    SKSpriteNode *tile;
    
    //1
    switch (tileCode)
    {
        case 'o':
//            tile = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"grass1"]];
            tile = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:RandomFloat() < 0.1 ? @"grass2" : @"grass1"]];
            break;
            
        case 'x':
            tile = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"wall"]];
            tile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tile.size];
            tile.physicsBody.categoryBitMask = PCWallCategory;
            tile.physicsBody.dynamic = NO;
            tile.physicsBody.friction = 0;
            break;
            
        case '=':
            tile = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"stone"]];
            break;
        
        case 'w':
//            tile = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"water1"]];
            tile = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:RandomFloat() < 0.1 ? @"water2" : @"water1"]];
            tile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tile.size];
            tile.physicsBody.categoryBitMask = PCWaterCategory;
            tile.physicsBody.dynamic = NO;
            tile.physicsBody.friction = 0;
            break;
            
        case '.':
            return nil;
            break;
            
        case 'b':
//            tile = [Bug node];
            return [Bug node];
            break;
            
        default:
            NSLog(@"Unknown tile code: %d", tileCode);
            break;
    }
    
    //2
    tile.blendMode = SKBlendModeReplace;
    tile.texture.filteringMode = SKTextureFilteringNearest;
    return tile;
}

-(CGPoint)positionForRow:(NSInteger)row col:(NSInteger)col
{
//    return CGPointMake(col * self.tileSize.width + self.tileSize.width/2, row * self.tileSize.height + self.tileSize.height/2);
    
    return CGPointMake(col * self.tileSize.width + self.tileSize.width/2, self.layerSize.height - (row * self.tileSize.height + self.tileSize.height/2));
}

-(BOOL)isValidTileCoord:(CGPoint)coord
{
    return (coord.x >= 0 && coord.y >= 0 && coord.x < self.gridSize.width && coord.y < self.gridSize.height);
}

-(CGPoint)coordForPoint:(CGPoint)point
{
    return CGPointMake((int)(point.x / self.tileSize.width), (int)((point.y - self.layerSize.height) / -self.tileSize.height)); //because sprite kit's coord system is 0 is at the bottom
}

-(CGPoint)pointForCoord:(CGPoint)coord //returns the (x,y) position at the center of the given grid coordinates
{
    return [self positionForRow:coord.y col:coord.x];
}

-(SKNode*)tileAtCoord:(CGPoint)coord
{
    return [self tileAtPoint:[self pointForCoord:coord]];
}

-(SKNode*)tileAtPoint:(CGPoint)point
{
    SKNode *n = [self nodeAtPoint:point];
    while (n && n != self && n.parent != self)
    {
        n = n.parent;
    }
    return n.parent == self ? n : nil;
}

@end
