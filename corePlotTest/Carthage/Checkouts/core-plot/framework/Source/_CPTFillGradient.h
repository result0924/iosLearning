/// @file

#ifdef CPT_IS_FRAMEWORK
#import <CorePlot/CPTFill.h>
#else
#import "CPTFill.h"
#endif

@class CPTGradient;

@interface _CPTFillGradient : CPTFill

/// @name Initialization
/// @{
-(nonnull instancetype)initWithGradient:(nonnull CPTGradient *)aGradient NS_DESIGNATED_INITIALIZER;
-(nullable instancetype)initWithCoder:(nonnull NSCoder *)coder NS_DESIGNATED_INITIALIZER;
/// @}

@end
