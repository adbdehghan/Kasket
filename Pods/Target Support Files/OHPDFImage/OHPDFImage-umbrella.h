#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "OHPDFDocument.h"
#import "OHPDFImage.h"
#import "OHPDFPage.h"
#import "OHVectorImage.h"
#import "UIImage+OHPDF.h"

FOUNDATION_EXPORT double OHPDFImageVersionNumber;
FOUNDATION_EXPORT const unsigned char OHPDFImageVersionString[];

