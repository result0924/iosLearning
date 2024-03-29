/// @file

#ifdef CPT_IS_FRAMEWORK
#import <CorePlot/CPTDefinitions.h>
#else
#import "CPTDefinitions.h"
#endif

/**
 *  @brief Custom exception type.
 **/
typedef NSString *CPTExceptionType cpt_swift_struct;

/// @name Custom Exception Identifiers
/// @{
extern CPTExceptionType __nonnull const CPTException;
extern CPTExceptionType __nonnull const CPTDataException;
extern CPTExceptionType __nonnull const CPTNumericDataException;
/// @}
