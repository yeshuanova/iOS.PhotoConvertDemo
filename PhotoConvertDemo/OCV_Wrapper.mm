//
//  OCV_Wrapper.m
//  PhotoConvertDemo
//
//  Created by Peter.Li on 2015/8/14.
//  Copyright (c) 2015年 Peter.Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCV_Wrapper.h"

#include <opencv2/opencv.hpp>
#include <vector>
#include <thread>

using namespace cv;
using namespace std;

cv::Mat cvMatFromUIImage(UIImage* image)
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

UIImage* UIImageFromCVMat(cv::Mat cvMat)
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    

    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


void conv_color_thread(Mat src, Mat conv, int code)
{
    cv::cvtColor(src, conv, code);
}

UIImage* ocvColorConvert(UIImage* img, int code) {
    try {
        
        Mat img_mat = cvMatFromUIImage(img);
        Mat conv_mat(img_mat.size(), CV_8UC1);
        
        cv::cvtColor(img_mat, conv_mat, cv::COLOR_RGB2GRAY);
        std::thread conv_t(conv_color_thread, img_mat, conv_mat, code);
        conv_t.join();
        
        return UIImageFromCVMat(conv_mat);
        
    } catch (cv::Exception& e) {
        cout << "cv::Exception: " << e.what() << endl;
    } catch (std::exception& e) {
        cout << "std::exception: " << e.what() << endl;
    } catch (...) {
        cout << "Unsupport Exception" << endl;
    }
    
    return nullptr;
}


@implementation OCV_Wrapper

+ (UIImage*) ocvGrayConvert:(UIImage *)img {
    return ocvColorConvert(img, cv::COLOR_RGB2GRAY);
}

+ (UIImage*)ocvBinaryConvert:(UIImage *)img threshhold:(float)value {
    
    return nullptr;
}

@end






