/// @file

#ifdef CPT_IS_FRAMEWORK
#import <CorePlot/CPTDefinitions.h>
#import <CorePlot/CPTPlatformSpecificDefines.h>
#import <CorePlot/CPTTextStylePlatformSpecific.h>
#else
#import "CPTDefinitions.h"
#import "CPTPlatformSpecificDefines.h"
#import "CPTTextStylePlatformSpecific.h"
#endif

@class CPTColor;
@class CPTTextStyle;

/**
 *  @brief An array of text styles.
 **/
typedef NSArray<CPTTextStyle *> CPTTextStyleArray;

/**
 *  @brief A mutable array of text styles.
 **/
typedef NSMutableArray<CPTTextStyle *> CPTMutableTextStyleArray;

@interface CPTTextStyle : NSObject<NSCopying, NSMutableCopying, NSCoding, NSSecureCoding>

// font would override fontName/fontSize if not nil
@property (readonly, strong, nonatomic, nullable) CPTNativeFont *font;
@property (readonly, copy, nonatomic, nullable) NSString *fontName;
@property (readonly, nonatomic) CGFloat fontSize;
@property (readonly, copy, nonatomic, nullable) CPTColor *color;
@property (readonly, nonatomic) CPTTextAlignment textAlignment;
@property (readonly, assign, nonatomic) NSLineBreakMode lineBreakMode;

/// @name Factory Methods
/// @{
+(nonnull instancetype)textStyle;
+(nonnull instancetype)textStyleWithStyle:(nullable CPTTextStyle *)textStyle;
/// @}

@end

#pragma mark -

@interface CPTTextStyle(CPTPlatformSpecificTextStyleExtensions)

@property (readonly, nonatomic, nonnull) CPTDictionary *attributes;

/// @name Factory Methods
/// @{
+(nonnull instancetype)textStyleWithAttributes:(nullable CPTDictionary *)attributes;
/// @}

@end

#pragma mark -

@interface NSString(CPTTextStyleExtensions)

/// @name Measurement
/// @{
-(CGSize)sizeWithTextStyle:(nullable CPTTextStyle *)style;
/// @}

/// @name Drawing
/// @{
-(void)drawInRect:(CGRect)rect withTextStyle:(nullable CPTTextStyle *)style inContext:(nonnull CGContextRef)context;
/// @}

@end
