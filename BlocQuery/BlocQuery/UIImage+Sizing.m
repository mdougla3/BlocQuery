//
//  UIImage+Sizing.m
//  BlocQuery
//
//  Created by McCay Barnes on 11/9/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "UIImage+Sizing.h"

@implementation UIImage (Sizing)

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
