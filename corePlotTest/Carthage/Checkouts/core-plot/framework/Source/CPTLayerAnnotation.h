/// @file

#ifdef CPT_IS_FRAMEWORK
#import <CorePlot/CPTAnnotation.h>
#import <CorePlot/CPTDefinitions.h>
#else
#import "CPTAnnotation.h"
#import "CPTDefinitions.h"
#endif

@class CPTConstraints;

@interface CPTLayerAnnotation : CPTAnnotation

@property (nonatomic, readonly, cpt_weak_property, nullable) CPTLayer *anchorLayer;
@property (nonatomic, readwrite, assign) CPTRectAnchor rectAnchor;
@property (nonatomic, readwrite, strong, nullable) CPTConstraints *xConstraints;
@property (nonatomic, readwrite, strong, nullable) CPTConstraints *yConstraints;

/// @name Initialization
/// @{
-(nonnull instancetype)initWithAnchorLayer:(nonnull CPTLayer *)anchorLayer NS_DESIGNATED_INITIALIZER;
-(nullable instancetype)initWithCoder:(nonnull NSCoder *)coder NS_DESIGNATED_INITIALIZER;
/// @}

@end
