//
//  MyScene.h
//  CatNap
//

//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol ImageCaptureDelegate <NSObject>

-(void)requestImagePicker;

@end

@interface MyScene : SKScene

@property (nonatomic, assign) id <ImageCaptureDelegate> delegate;

-(void)setPhotoTexture:(SKTexture *)texture;

@end
