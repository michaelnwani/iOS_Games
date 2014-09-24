//
//  CustomTransitionFilter.h
//  CatNap
//
//  Created by Michael Nwani on 9/24/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface CustomTransitionFilter : CIFilter

@property (strong, nonatomic) CIImage *inputImage;
@property (strong, nonatomic) CIImage *inputTargetImage;
@property (assign, nonatomic) NSTimeInterval inputTime;

@end
