#ifdef __has_include
#if __has_include(<CorePlot/CPTAnimation.h>)
#define CPT_IS_FRAMEWORK
#endif
#endif

#import <TargetConditionals.h>

#if TARGET_OS_SIMULATOR || TARGET_OS_IPHONE || TARGET_OS_MACCATALYST

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#else

#import <Cocoa/Cocoa.h>

#endif

#ifdef CPT_IS_FRAMEWORK

#import <CorePlot/CPTAnimation.h>
#import <CorePlot/CPTAnimationOperation.h>
#import <CorePlot/CPTAnimationPeriod.h>
#import <CorePlot/CPTAnnotation.h>
#import <CorePlot/CPTAnnotationHostLayer.h>
#import <CorePlot/CPTAxis.h>
#import <CorePlot/CPTAxisLabel.h>
#import <CorePlot/CPTAxisSet.h>
#import <CorePlot/CPTAxisTitle.h>
#import <CorePlot/CPTBarPlot.h>
#import <CorePlot/CPTBorderedLayer.h>
#import <CorePlot/CPTCalendarFormatter.h>
#import <CorePlot/CPTColor.h>
#import <CorePlot/CPTColorSpace.h>
#import <CorePlot/CPTConstraints.h>
#import <CorePlot/CPTDecimalNumberValueTransformer.h>
#import <CorePlot/CPTDefinitions.h>
#import <CorePlot/CPTExceptions.h>
#import <CorePlot/CPTFill.h>
#import <CorePlot/CPTFunctionDataSource.h>
#import <CorePlot/CPTGradient.h>
#import <CorePlot/CPTGraph.h>
#import <CorePlot/CPTGraphHostingView.h>
#import <CorePlot/CPTImage.h>
#import <CorePlot/CPTLayer.h>
#import <CorePlot/CPTLayerAnnotation.h>
#import <CorePlot/CPTLegend.h>
#import <CorePlot/CPTLegendEntry.h>
#import <CorePlot/CPTLimitBand.h>
#import <CorePlot/CPTLineCap.h>
#import <CorePlot/CPTLineStyle.h>
#import <CorePlot/CPTMutableLineStyle.h>
#import <CorePlot/CPTMutableNumericData+TypeConversion.h>
#import <CorePlot/CPTMutableNumericData.h>
#import <CorePlot/CPTMutablePlotRange.h>
#import <CorePlot/CPTMutableShadow.h>
#import <CorePlot/CPTMutableTextStyle.h>
#import <CorePlot/CPTNumericData+TypeConversion.h>
#import <CorePlot/CPTNumericData.h>
#import <CorePlot/CPTNumericDataType.h>
#import <CorePlot/CPTPathExtensions.h>
#import <CorePlot/CPTPieChart.h>
#import <CorePlot/CPTPlatformSpecificCategories.h>
#import <CorePlot/CPTPlatformSpecificDefines.h>
#import <CorePlot/CPTPlatformSpecificFunctions.h>
#import <CorePlot/CPTPlot.h>
#import <CorePlot/CPTPlotArea.h>
#import <CorePlot/CPTPlotAreaFrame.h>
#import <CorePlot/CPTPlotRange.h>
#import <CorePlot/CPTPlotSpace.h>
#import <CorePlot/CPTPlotSpaceAnnotation.h>
#import <CorePlot/CPTPlotSymbol.h>
#import <CorePlot/CPTRangePlot.h>
#import <CorePlot/CPTResponder.h>
#import <CorePlot/CPTScatterPlot.h>
#import <CorePlot/CPTShadow.h>
#import <CorePlot/CPTTextLayer.h>
#import <CorePlot/CPTTextStyle.h>
#import <CorePlot/CPTTheme.h>
#import <CorePlot/CPTTimeFormatter.h>
#import <CorePlot/CPTTradingRangePlot.h>
#import <CorePlot/CPTUtilities.h>
#import <CorePlot/CPTXYAxis.h>
#import <CorePlot/CPTXYAxisSet.h>
#import <CorePlot/CPTXYGraph.h>
#import <CorePlot/CPTXYPlotSpace.h>

#else

#import "CPTAnimation.h"
#import "CPTAnimationOperation.h"
#import "CPTAnimationPeriod.h"
#import "CPTAnnotation.h"
#import "CPTAnnotationHostLayer.h"
#import "CPTAxis.h"
#import "CPTAxisLabel.h"
#import "CPTAxisSet.h"
#import "CPTAxisTitle.h"
#import "CPTBarPlot.h"
#import "CPTBorderedLayer.h"
#import "CPTCalendarFormatter.h"
#import "CPTColor.h"
#import "CPTColorSpace.h"
#import "CPTConstraints.h"
#import "CPTDecimalNumberValueTransformer.h"
#import "CPTDefinitions.h"
#import "CPTExceptions.h"
#import "CPTFill.h"
#import "CPTFunctionDataSource.h"
#import "CPTGradient.h"
#import "CPTGraph.h"
#import "CPTGraphHostingView.h"
#import "CPTImage.h"
#import "CPTLayer.h"
#import "CPTLayerAnnotation.h"
#import "CPTLegend.h"
#import "CPTLegendEntry.h"
#import "CPTLimitBand.h"
#import "CPTLineCap.h"
#import "CPTLineStyle.h"
#import "CPTMutableLineStyle.h"
#import "CPTMutableNumericData+TypeConversion.h"
#import "CPTMutableNumericData.h"
#import "CPTMutablePlotRange.h"
#import "CPTMutableShadow.h"
#import "CPTMutableTextStyle.h"
#import "CPTNumericData+TypeConversion.h"
#import "CPTNumericData.h"
#import "CPTNumericDataType.h"
#import "CPTPathExtensions.h"
#import "CPTPieChart.h"
#import "CPTPlatformSpecificCategories.h"
#import "CPTPlatformSpecificDefines.h"
#import "CPTPlatformSpecificFunctions.h"
#import "CPTPlot.h"
#import "CPTPlotArea.h"
#import "CPTPlotAreaFrame.h"
#import "CPTPlotRange.h"
#import "CPTPlotSpace.h"
#import "CPTPlotSpaceAnnotation.h"
#import "CPTPlotSymbol.h"
#import "CPTRangePlot.h"
#import "CPTResponder.h"
#import "CPTScatterPlot.h"
#import "CPTShadow.h"
#import "CPTTextLayer.h"
#import "CPTTextStyle.h"
#import "CPTTheme.h"
#import "CPTTimeFormatter.h"
#import "CPTTradingRangePlot.h"
#import "CPTUtilities.h"
#import "CPTXYAxis.h"
#import "CPTXYAxisSet.h"
#import "CPTXYGraph.h"
#import "CPTXYPlotSpace.h"

#endif
