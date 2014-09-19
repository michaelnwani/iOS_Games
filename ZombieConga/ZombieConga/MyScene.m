//
//  MyScene.m
//  ZombieConga
//
//  Created by Michael Nwani on 9/15/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//  Scenes are still being displayed in view controllers.

#import "MyScene.h"
#import "GameOverScene.h"


#define ARC4RANDOM_MAX 0x100000000
//[SKAction followPath:... duration:...] & [SKAction fadeAlphaTo:... duration:...]

static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max)
{
    //arc4random() / is dividing ARC4RANDOM_MAX by a random number from 0 to ARC4RANDOM_MAX, therefore it'll return a random float from 0 to 1
    //so multiplying by the range of values (max - min) will give a float between 0 and the range. If you add that to the min value, you'll get a float between min and max
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b) //only magnitude, not direction
{
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGFloat CGPointLength(const CGPoint a)
{
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a)
{
    CGFloat length = CGPointLength(a);
    return CGPointMake(a.x / length, a.y / length); //the unit vector; normalized vector; vector of length 1
}

static inline CGFloat CGPointToAngle(const CGPoint a)
{
    return atan2f(a.y, a.x);
}

static const float ZOMBIE_MOVE_POINTS_PER_SEC = 120.0;
static const float CAT_MOVE_POINTS_PER_SEC = 120.0;
static const float BG_POINTS_PER_SEC = 50.0;

@implementation MyScene

-(void)playBackgroundMusic:(NSString *)filename
{
    NSError *error;
    //will copy the specified file (a music file in this case) to our application bundle
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _backgroundMusicPlayer.numberOfLoops = -1; //a negative number means "loop indefinitely, until you call the stop method"
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

-(void)spawnEnemy
{
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemy"];
    //basically, the y-coordinate will be for anywhere from the enemy's height / 2 (to make up for her whole body possibly appearing at the very bottom of the screen), to the top of the screen
//    enemy.position = CGPointMake(self.size.width + enemy.size.width/2, ScalarRandomRange(enemy.size.height/2, self.size.height - enemy.size.height/2));
    CGPoint enemyScenePos = CGPointMake(
                                        self.size.width + enemy.size.width/2,
                                        ScalarRandomRange(enemy.size.height/2,
                                                          self.size.height-enemy.size.height/2));
    enemy.position = [self convertPoint:enemyScenePos toNode:_bgLayer];
    enemy.name = @"enemy"; //You can give a bunch of nodes the same name, to use with enumerateChildNodesWithName:usingBlock:
    [_bgLayer addChild:enemy];
    
    
    //enemy.size.height/2 is to account for the sprite's size on screen. Never forget that; Pretty standard code to keep your sprites 'appearing in bounds'.
    //"give me the x-coordinate that is at half of the screen, minus half of granny's size.
    //remember that moveByX is about offsets (x = x + <>)
    SKAction *actionMidMove = [SKAction moveByX:-self.size.width/2 - enemy.size.width/2 y:-self.size.height/2 + enemy.size.height/2 duration:1.0];
    
    //Give me the x-coordinate that makes up the end of the other half of the screen, accounting for granny's size.
    //Also the y-coordinate that would be half of the height of the screen, also accounting for granny's size.
    //    SKAction *actionMove = [SKAction moveByX:-self.size.width/2 - enemy.size.width/2 y:self.size.height/2 + enemy.size.height/2 duration:1.0];
//    SKAction *actionMove = [SKAction moveToX:-enemy.size.width/2 duration:2.0];
    SKAction *actionMove =
    [SKAction moveByX:-self.size.width + enemy.size.width y:0 duration:2.0];
    SKAction *actionRemove = [SKAction removeFromParent]; //removes the node that's running the action from its parent (look down: enemy is running the action)
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *logMessage = [SKAction runBlock:^{
        NSLog(@"Reached bottom!");
    }];
    //the reverse action's dont give a shit about coordinates. Just think in terms of "they do the exact opposite movement as before"
    //    SKAction *reverseMid = [actionMidMove reversedAction];
    //    SKAction *reverseMove = [actionMove reversedAction];
    //    SKAction *sequence = [SKAction sequence:@[actionMidMove, logMessage, wait, actionMove, reverseMove, logMessage, wait, reverseMid]];
    SKAction *sequence = [SKAction sequence:@[actionMidMove, logMessage, wait, actionMove]];
    sequence = [SKAction sequence:@[sequence, [sequence reversedAction]]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    
    [enemy runAction:[SKAction sequence:@[actionMove, actionRemove]]];
}

-(void)spawnCat
{
    //1
    SKSpriteNode *cat = [SKSpriteNode spriteNodeWithImageNamed:@"cat"];
    cat.name = @"cat";
//    cat.position = CGPointMake(ScalarRandomRange(0, self.size.width), ScalarRandomRange(0, self.size.height));
    CGPoint catScenePos = CGPointMake(
                                      ScalarRandomRange(0, self.size.width),
                                      ScalarRandomRange(0, self.size.height));
    cat.position = [self convertPoint:catScenePos toNode:_bgLayer];
                               
    cat.xScale = 0;
    cat.yScale = 0;
    [_bgLayer addChild:cat];
    
    
    //2
    cat.zRotation = -M_PI / 16;
    SKAction *appear = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *leftWiggle = [SKAction rotateByAngle:M_PI / 8 duration:0.5];
    SKAction *rightWiggle = [leftWiggle reversedAction];
    SKAction *fullWiggle = [SKAction sequence:@[leftWiggle, rightWiggle]];
    //    SKAction *wiggleWait = [SKAction repeatAction:fullWiggle count:10];
    SKAction *scaleUp = [SKAction scaleBy:1.2 duration:0.25];
    SKAction *scaleDown = [scaleUp reversedAction];
    SKAction *fullScale = [SKAction sequence:@[scaleUp, scaleDown, scaleUp, scaleDown]];
    
    SKAction *group = [SKAction group:@[fullScale, fullWiggle]];
    SKAction *groupWait = [SKAction repeatAction:group count:10];
    
    SKAction *disappear = [SKAction scaleTo:0.0 duration:0.5];
    SKAction *removeFromParent = [SKAction removeFromParent];
    [cat runAction:[SKAction sequence:@[appear, groupWait, disappear, removeFromParent]]];
}

-(void)loseCats
{
    //1
    __block int loseCount = 0;
    [_bgLayer enumerateChildNodesWithName:@"train" usingBlock:^(SKNode *node, BOOL *stop){
        
        //2
        CGPoint randomSpot = node.position;
        randomSpot.x += ScalarRandomRange(-100, 100);
        randomSpot.y += ScalarRandomRange(-100, 100);
        
        //3
        node.name = @"";
        [node runAction:[SKAction sequence:@[
                                             [SKAction group:@[
                                                               [SKAction rotateByAngle:M_PI * 4 duration:1.0],
                                                               [SKAction moveTo:randomSpot duration:1.0],
                                                               [SKAction scaleTo:0 duration:1.0]]],
                                             [SKAction removeFromParent]]]];
        
        //4
        loseCount++;
        if (loseCount >= 2)
        {
            *stop = YES;
        }
    }];
}

#pragma mark - initWithSize
-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _bgLayer = [SKNode node];
        [self addChild:_bgLayer];
        self.backgroundColor = [SKColor whiteColor];
        
        _lives = 5;
        _gameOver = NO;
        for (int i = 0; i < 2; i++)
        {
            SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
            //        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
            bg.anchorPoint = CGPointZero;
            //bg.position = CGPointZero;
            bg.position = CGPointMake(i * bg.size.width, 0); //0 * bg.size.width = self-explanatory. 1 * bg.size.width = make its position start where the previous position has ended
            //        bg.anchorPoint = CGPointMake(0.5, 0.5); //same as default
            //        bg.zRotation = M_PI / 8;
            bg.name = @"bg";
            [_bgLayer addChild:bg];
        }
        
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"zombie1"];
        _zombie.zPosition = 100;
        _zombie.position = CGPointMake(100, 100); //definitely in 'points', not pixels.
//        [_zombie setScale:2.0];
        [_bgLayer addChild:_zombie];
        [self playBackgroundMusic:@"bgMusic.mp3"];

        //1
        NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
        //2
        for (int i = 1; i < 4; i++)
        {
            NSString *textureName = [NSString stringWithFormat:@"zombie%d", i];
            SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
            [textures addObject:texture];
        }
        //3
        for (int i = 4; i > 1; i--)
        {
            NSString *textureName = [NSString stringWithFormat:@"zombie%d", i];
            SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
            [textures addObject:texture];
        }
        //4
        _zombieAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
        //5
//        [_zombie runAction:[SKAction repeatActionForever:_zombieAnimation]];
        
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                           [SKAction performSelector:@selector(spawnEnemy) onTarget:self],
                                                                           [SKAction waitForDuration:2.0]]]]];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                           [SKAction performSelector:@selector(spawnCat) onTarget:self],
                                                                           [SKAction waitForDuration:1.0]]]]];
        
        _catCollisionSound = [SKAction playSoundFileNamed:@"hitCat.wav" waitForCompletion:NO];
        _enemyCollisionSound = [SKAction playSoundFileNamed:@"hitCatLady.wav" waitForCompletion:NO];
        
//        CGSize mySize = bg.size;
//        NSLog(@"Size: %@", NSStringFromCGSize(mySize));
    }
    
    return self;
}

//_dt = Delta Time; Kind of represents time per frame in a second. (e.g. 33 milliseconds per frame, is about 33 frames per second)
-(void)update:(NSTimeInterval)currentTime //update is getting called per frame, not per second
{
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
//    NSLog(@"%0.2f milliseconds since last update", _dt * 1000); //its in seconds by default; mult. by 1000 to get milliseconds
    
    CGPoint offset = CGPointSubtract(_lastTouchLocation, _zombie.position);
    float distance = CGPointLength(offset);
    
//    if (distance <= ZOMBIE_MOVE_POINTS_PER_SEC * _dt)
//    {
//        _zombie.position = _lastTouchLocation;
//        _velocity = CGPointZero;
//        [self stopZombieAnimation];
//    }
//    else
//    {
//        [self moveSprite:_zombie velocity:_velocity];
//        [self boundsCheckPlayer];
//        [self rotateSprite:_zombie toFace:_velocity];
//    }
    [self moveSprite:_zombie velocity:_velocity];
    [self boundsCheckPlayer];
    [self rotateSprite:_zombie toFace:_velocity];
    [self moveTrain];
    [self moveBg];
//    [self checkCollisions];
    
    if (_lives <= 0 && !_gameOver)
    {
        _gameOver = YES;
        NSLog(@"You lose!");
        [_backgroundMusicPlayer stop];
        //1
        SKScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        //2
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        //3
        [self.view presentScene:gameOverScene transition:reveal];
    }
}

-(void)didEvaluateActions //called once per frame, after the scene, its nodes (their locations too), and actions have been accounted for. by default it does nothing, do collision checking here
{
    [self checkCollisions];
}

-(void)moveBg
{
    CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0); //because its anchor is the lower left
    CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt); //we've broken down its movement into a per frame basis to make it smooth. At the end of a second, BG_POINTS_PER_SEC is still what will be moved
    _bgLayer.position = CGPointAdd(_bgLayer.position, amtToMove);
    //Remember that the background layer (node) is empty. Its like a blank canvas, child of the scene, so it can scroll infinitely. What we're visually manipulating is its children nodes
    [_bgLayer enumerateChildNodesWithName:@"bg" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *bg = (SKSpriteNode *)node;
        CGPoint bgScreenPos = [_bgLayer convertPoint:bg.position toNode:self];
//        bg.position = CGPointAdd(bg.position, amtToMove); //bg.position.x + amtToMove.x, bg.position.y + amtToMove.y
        //remember, the anchor point is 0,0; once it starts to go off screen, append it to the right
        if (bgScreenPos.x <= -bg.size.width) //it is COMPLETELY off screen now
        {   //say bg.position.x = -1, and bg.size.width = 100. -1 + (2 * 100) = 200, new starting location
            bg.position = CGPointMake(bg.position.x + bg.size.width*2, bg.position.y);
        }
    }];
}

-(void)moveSprite:(SKSpriteNode *)sprite
         velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMultiplyScalar(velocity, _dt);

    // 1
//    CGPoint amountToMove = CGPointMake(velocity.x * _dt, velocity.y * _dt); //will always be positive
    //If I wanted to move 100 points per second, and did so by * by delta time, it would end up moving 100 points per second
    
    //2
//    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
    sprite.position = CGPointAdd(sprite.position, amountToMove);
}
//a unit vector: a vector of length 1
//a vector's arrowhead is all 'direction' means
-(void)moveZombieToward:(CGPoint)location
{
    [self startZombieAnimation];
    CGPoint offset = CGPointSubtract(location, _zombie.position);
    CGPoint direction = CGPointNormalize(offset);
    _velocity = CGPointMultiplyScalar(direction, ZOMBIE_MOVE_POINTS_PER_SEC);


    
    
//    CGPoint offset = CGPointMake(location.x - _zombie.position.x, location.y - _zombie.position.y);
    
//    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y); //pythag. theorem, to get hypotenuse
    //LENGTH WAS A FLOAT AHHHHHH THAT'S WHY GETTING THE UNIT VECTOR IS IMPORTANT
    //DID NOT HAVE THE LENGTH BEFORE THIS
//    CGFloat length = CGPointLength(offset); Not necessary
    
//    CGPoint direction = CGPointMake(offset.x / length, offset.y / length); //the unit vector (a vector of length 1)
    
//    _velocity = CGPointMake(direction.x * ZOMBIE_MOVE_POINTS_PER_SEC, direction.y * ZOMBIE_MOVE_POINTS_PER_SEC);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:_bgLayer]; //think of everything in terms of the background layer
    [self moveZombieToward:touchLocation];
    _lastTouchLocation = touchLocation;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:_bgLayer];
    [self moveZombieToward:touchLocation];
    _lastTouchLocation = touchLocation;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:_bgLayer];
    [self moveZombieToward:touchLocation];
    _lastTouchLocation = touchLocation;
}

-(void)boundsCheckPlayer
{
    //1
    CGPoint newPosition = _zombie.position;
    CGPoint newVelocity = _velocity;
    
    //2
//    CGPoint bottomLeft = CGPointZero;
    CGPoint bottomLeft = [_bgLayer convertPoint:CGPointZero fromNode:self];
//    CGPoint topRight = CGPointMake(self.size.width, self.size.height);
    CGPoint topRight = [_bgLayer convertPoint:CGPointMake(self.size.width, self.size.height) fromNode:self];
    //the background layer is the one that is moving off the screen from right to left, not the scene. So to keep the zombie in bounds, compare the NON-CHANGING scene coordinates.
    //3
    if (newPosition.x <= bottomLeft.x)
    {
        newPosition.x = bottomLeft.x;
        newVelocity.x = -newVelocity.x;
    }
    
    if (newPosition.x >= topRight.x)
    {
        newPosition.x = topRight.x;
        newVelocity.x = -newVelocity.x;
    }
    
    if (newPosition.y <= bottomLeft.y)
    {
        newPosition.y = bottomLeft.y;
        newVelocity.y = -newVelocity.y;
    }
    
    if (newPosition.y >= topRight.y)
    {
        newPosition.y = topRight.y;
        newVelocity.y = -newVelocity.y;
    }
    
    //4
    _zombie.position = newPosition;
    _velocity = newVelocity;
}

-(void)rotateSprite:(SKSpriteNode *)sprite
             toFace:(CGPoint)direction
{
    sprite.zRotation = CGPointToAngle(direction);
    //Makes sense if you start thinking about CGPoint's x and y values in true grid-like, coordinate system fashion
//    sprite.zRotation = atan2f(direction.y, direction.x); //tan(angle) = opposite/adjacent. tan^-1 (arctan) = the angle in radians
    
    //always remember this arctan method in combination with zRotation
}

-(void)startZombieAnimation
{
    if (![_zombie actionForKey:@"animation"])
    {
        [_zombie runAction:[SKAction repeatActionForever:_zombieAnimation]
                   withKey:@"animation"];
    }
}

-(void)stopZombieAnimation
{
    [_zombie removeActionForKey:@"animation"];
}


-(void)checkCollisions
{
    [_bgLayer enumerateChildNodesWithName:@"cat" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *cat = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(cat.frame, _zombie.frame)) {
            //[cat removeFromParent];
            [self runAction:_catCollisionSound];
            cat.name = @"train";
            [cat removeAllActions]; //ends and removes all actions from a node (then we create a new one)
            [cat setScale:1];
            cat.zRotation = 0;
            [cat runAction:[SKAction colorizeWithColor:[SKColor greenColor] colorBlendFactor:1.0 duration:0.2]];
        }
    }];
    
    if (_invincible) return;
    
    [_bgLayer enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *enemy = (SKSpriteNode *)node;
        CGRect smallerFrame = CGRectInset(enemy.frame, 20, 20); //an inset is like a smaller (or larger) circle. a positive value means (create a rectangle from the supplied frame, that has a 20px less width and height from the supplied frame, and return it)
        if (CGRectIntersectsRect(smallerFrame, _zombie.frame)) {
            //[enemy removeFromParent];
            [self runAction:_enemyCollisionSound];
            
            [self loseCats];
            _lives--;
            
            _invincible = YES;
            float blinkTimes = 10;
            float blinkDuration = 3.0;
            SKAction *blinkAction =
            [SKAction customActionWithDuration:blinkDuration
                                   actionBlock:
             ^(SKNode *node, CGFloat elapsedTime) {
                 float slice = blinkDuration / blinkTimes;
                 float remainder = fmodf(elapsedTime, slice);
                 node.hidden = remainder > slice / 2;
             }];
            SKAction *sequence = [SKAction sequence:@[blinkAction, [SKAction runBlock:^{
                _zombie.hidden = NO;
                _invincible = NO;
            }]]];
            [_zombie runAction:sequence];
        }
    }];
}


#pragma mark - moveTrain
- (void)moveTrain
{
    __block int trainCount = 0;
    __block CGPoint targetPosition = _zombie.position;
    [_bgLayer enumerateChildNodesWithName:@"train"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               trainCount++;
                               if (!node.hasActions) {
                                   float actionDuration = 0.3;
                                   CGPoint offset = CGPointSubtract(targetPosition, node.position);
                                   CGPoint direction = CGPointNormalize(offset); //CGPointLength to get hypot. is inside
                                   CGPoint amountToMovePerSec = CGPointMultiplyScalar(direction, CAT_MOVE_POINTS_PER_SEC);
                                   //do the multiplication. Somehow it makes sense... over the course of a second, regardless of the current FPS
                                   CGPoint amountToMove = CGPointMultiplyScalar(amountToMovePerSec, actionDuration);
                                   SKAction *moveAction = [SKAction moveByX:amountToMove.x y:amountToMove.y duration:actionDuration];
                                   [node runAction:moveAction];
                               }
                               targetPosition = node.position;
                           }];
    
    if (trainCount >= 10 && !_gameOver) //The win factor
    {
        _gameOver = YES;
        NSLog(@"You win!");
        [_backgroundMusicPlayer stop];
        //1
        SKScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
        //2
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        //3
        [self.view presentScene:gameOverScene transition:reveal];
    }
}
@end
