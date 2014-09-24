
#import <SpriteKit/SpriteKit.h>

typedef enum : int {
    GameRunning      = 0,
    GameOver         = 1,
} GameState;

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKNode *playerLayerNode;
@property (nonatomic, strong) SKNode *hudLayerNode;
@property (nonatomic, strong) SKNode *bulletLayerNode;
@property (nonatomic, strong) SKNode *enemyLayerNode;
@property (nonatomic, strong) SKNode *particleLayerNode;

- (void)increaseScoreBy:(float)increment;
-(void)playExplodeSound;
-(void)playLaserSound;
@end
