//
//  OCV_Wrapper.h
//  PhotoConvertDemo
//
//  Created by Peter.Li on 2015/8/14.
//  Copyright (c) 2015年 Peter.Li. All rights reserved.
//

#ifndef PhotoConvertDemo_OCV_Wrapper_h
#define PhotoConvertDemo_OCV_Wrapper_h


#import <UIKit/UIKit.h>

@interface OCV_Wrapper : NSObject

+ (UIImage*)ocvGrayConvert:(UIImage*)img;
+ (UIImage*)ocvBinaryConvert:(UIImage*)img threshhold:(float)value;

@end


#endif
