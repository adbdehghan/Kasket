//
//  PinView.m
//  Motori
//
//  Created by aDb on 2/7/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "PinView.h"

@implementation PinView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        _angle = 0;
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawCanvas1WithFrame:rect angle:self.angle];
}

- (void)drawCanvas1WithFrame: (CGRect)frame angle: (CGFloat)angle
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color0 = [UIColor colorWithRed: 0.957 green: 0 blue: 0.701 alpha: 1];
    
    //// Page-1
    {
        //// Group
        {
            //// location
            {
                //// Group 4
                {
                    //// Shape Drawing
                    UIBezierPath* shapePath = UIBezierPath.bezierPath;
                    
                    [shapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 1.71)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 15.61) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 8.06, CGRectGetMinY(frame) + 1.71) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 7.93)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 40) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 27.2) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 40)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 29.08, CGRectGetMinY(frame) + 15.61) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 40) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 29.08, CGRectGetMinY(frame) + 27.2)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 1.71) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 29.08, CGRectGetMinY(frame) + 7.93) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 23.02, CGRectGetMinY(frame) + 1.71)];
                    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 1.71)];
                    [shapePath closePath];
                    [shapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 4.21)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 26.48, CGRectGetMinY(frame) + 15.45) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 21.58, CGRectGetMinY(frame) + 4.21) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 26.48, CGRectGetMinY(frame) + 9.24)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 26.68) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 26.48, CGRectGetMinY(frame) + 21.65) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 21.58, CGRectGetMinY(frame) + 26.68)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 4.6, CGRectGetMinY(frame) + 15.45) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 9.5, CGRectGetMinY(frame) + 26.68) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 4.6, CGRectGetMinY(frame) + 21.65)];
                    [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 4.21) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 4.6, CGRectGetMinY(frame) + 9.24) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 9.5, CGRectGetMinY(frame) + 4.21)];
                    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.54, CGRectGetMinY(frame) + 4.21)];
                    [shapePath closePath];
                    shapePath.miterLimit = 4;
                    
                    shapePath.usesEvenOddFillRule = YES;
                    
                    [color0 setFill];
                    [shapePath fill];
                }
            }
            
            
            //// compass-tool
            {
                CGContextSaveGState(context);
                CGContextTranslateCTM(context, CGRectGetMinX(frame) + 15.53, CGRectGetMinY(frame) + 15.37);
                CGContextRotateCTM(context, -(angle - 638.425140381) * M_PI / 180);
                
                
                
                //// Capa_1
                {
                    //// Group 8
                    {
                        //// Shape 2 Drawing
                        UIBezierPath* shape2Path = UIBezierPath.bezierPath;
                        [shape2Path moveToPoint: CGPointMake(0.86, -6.8)];
                        [shape2Path addLineToPoint: CGPointMake(0, -8.34)];
                        [shape2Path addCurveToPoint: CGPointMake(-3.45, -0.53) controlPoint1: CGPointMake(-2.3, -4.36) controlPoint2: CGPointMake(-3.45, -1.75)];
                        [shape2Path addLineToPoint: CGPointMake(-3.45, 0.43)];
                        [shape2Path addCurveToPoint: CGPointMake(0.05, 8.34) controlPoint1: CGPointMake(-3.45, 1.66) controlPoint2: CGPointMake(-2.28, 4.29)];
                        [shape2Path addCurveToPoint: CGPointMake(3.45, 0.58) controlPoint1: CGPointMake(2.32, 4.36) controlPoint2: CGPointMake(3.45, 1.77)];
                        [shape2Path addLineToPoint: CGPointMake(3.45, -0.53)];
                        [shape2Path addCurveToPoint: CGPointMake(2.59, -3.3) controlPoint1: CGPointMake(3.45, -1.08) controlPoint2: CGPointMake(3.16, -2)];
                        [shape2Path addCurveToPoint: CGPointMake(0.86, -6.8) controlPoint1: CGPointMake(2.01, -4.61) controlPoint2: CGPointMake(1.44, -5.77)];
                        [shape2Path addLineToPoint: CGPointMake(0.86, -6.8)];
                        [shape2Path closePath];
                        [shape2Path moveToPoint: CGPointMake(1.39, 1.35)];
                        [shape2Path addCurveToPoint: CGPointMake(0, 1.93) controlPoint1: CGPointMake(1.01, 1.74) controlPoint2: CGPointMake(0.54, 1.93)];
                        [shape2Path addCurveToPoint: CGPointMake(-1.39, 1.35) controlPoint1: CGPointMake(-0.54, 1.93) controlPoint2: CGPointMake(-1.01, 1.74)];
                        [shape2Path addCurveToPoint: CGPointMake(-1.96, -0.05) controlPoint1: CGPointMake(-1.77, 0.96) controlPoint2: CGPointMake(-1.96, 0.5)];
                        [shape2Path addCurveToPoint: CGPointMake(-1.39, -1.45) controlPoint1: CGPointMake(-1.96, -0.59) controlPoint2: CGPointMake(-1.77, -1.06)];
                        [shape2Path addCurveToPoint: CGPointMake(0, -2.03) controlPoint1: CGPointMake(-1.01, -1.83) controlPoint2: CGPointMake(-0.54, -2.03)];
                        [shape2Path addCurveToPoint: CGPointMake(1.39, -1.45) controlPoint1: CGPointMake(0.54, -2.03) controlPoint2: CGPointMake(1.01, -1.83)];
                        [shape2Path addCurveToPoint: CGPointMake(1.96, -0.05) controlPoint1: CGPointMake(1.77, -1.06) controlPoint2: CGPointMake(1.96, -0.59)];
                        [shape2Path addCurveToPoint: CGPointMake(1.39, 1.35) controlPoint1: CGPointMake(1.96, 0.5) controlPoint2: CGPointMake(1.77, 0.96)];
                        [shape2Path addLineToPoint: CGPointMake(1.39, 1.35)];
                        [shape2Path closePath];
                        shape2Path.miterLimit = 4;
                        
                        shape2Path.usesEvenOddFillRule = YES;
                        
                        [color0 setFill];
                        [shape2Path fill];
                    }
                }
                
                
                
                CGContextRestoreGState(context);
            }
        }
    }
}

@end
