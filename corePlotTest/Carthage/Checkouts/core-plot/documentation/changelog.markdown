# Release 2.4 (TBD)

## Release Notes

This release updates Core Plot to be compatible with Xcode 14, Mac Catalyst, and the Swift Package Manager. It adds support for the Swift Package Manager and Mac Catalyst.

The Mac deployment target is now macOS 10.13. The iOS deployment target has changed to iOS 12.0. The tvOS deployment target has changed to tvOS 12.0. The iOS static library is obsolete and has been removed.

The iOS and tvOS framework targets have been removed because lipo cannot combine device and simulator builds for Apple Silicon in the same output file (both use arm64). Use the Universal XCFramework that contains all platforms and architectures instead.


## Details

- **New**: Mac Catalyst support
- **New**: Swift Package Manager support
- **Changed**: Updated the deployment targets for all supported operating systems for the minimums required by Xcode 14. The Mac deployment target is now macOS 10.13. The iOS deployment target is now iOS 12.0. The tvOS deployment target is now tvOS 12.0.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the iOS static library.
- **Removed**: Removed the iOS and tvOS framework targets.

# Release 2.3 (January 10, 2020)

## Release Notes

This release updates Core Plot to be compatible with Xcode 11 and Swift 5. It adds support for platform-native fonts and colors, including dynamic system colors.

The Mac deployment target remains OS X 10.8. The iOS deployment target remains iOS 8.0 for both the framework and the static library. The tvOS deployment target remains tvOS 9.0.

## Details

- **New**: Added support for platform native fonts (`NSFont` and `UIFont`).
- **New**: Added support for platform native colors (`NSColor` and `UIColor`), including dynamic system colors.
- **New**: Added support for variable bar widths in bar, range, and trading range plots.
- **Changed**: Updated the Core Plot project to prefer the new Xcode build system introduced with Xcode 9.
- **Changed**: Updated all framework and example code to be compatible with Xcode 11 and the latest SDKs on all platforms.
- **Changed**: Updated all Swift example apps to Swift 5.
- **Changed**: Added arm64e as a valid build architecture on iOS.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed DTrace probing to support Xcode's New Build System.
- **Removed**: Removed docset generation. Docsets are no longer supported under Xcode 9.3.
- **Removed**: Removed the AAPLot and StockPlot example apps because the Yahoo finance API that both relied for data is no longer available.

# Release 2.2 (September 18, 2016)

## Release Notes

This release updates Core Plot to be compatible with Xcode 8 and Swift 3.

The Mac deployment target remains OS X 10.8. The iOS deployment target has changed to iOS 8.0 for both the framework and the static library. The tvOS deployment target remains tvOS 9.0. Core Plot no longer requires the Accelerate framework.

## Details

- **New**: Increased the iOS deployment target to iOS 8.
- **Changed**: Added Swift name mappings for all string constants.
- **Changed**: Updated all Swift example apps to Swift 3.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the dependency on the Accelerate framework.

# Release 2.1 (April 16, 2016)

## Release Notes

This release adds a tvOS framework and removes the deprecated `CorePlot-CocoaTouch.xcodeproj` project file. All Core Plot build targets for Mac, iOS, tvOS, and the documentation are in the `CorePlot.xcodeproj` project file. Annotated type definitions (e.g., `CPTNumberArray`) were changed to exclude the pointer star ("\*") so they can be used interchangeably with class names.

Curved scatter plots received several improvements. This release adds options to use Catmull-Rom and Hermite cubic splines to draw curved scatter plot lines. When a Hermite spline is used to draw a monotonic data series, the curved line will be monotonic as well. Plot spaces have new methods to scale the plot space to fit entire plots.

The Mac deployment target has increased to OS X 10.8. The iOS deployment target remains iOS 6.0 for the static library and iOS 8.0 for the framework. The tvOS deployment target is tvOS 9.0.

## Details

- **New**: Increased the Mac deployment target to OS X 10.8.
- **New**: Added a tvOS framework.
- **New**: Added an option to anchor alternating band fills to a specific starting value.
- **New**: Added support for animating `NSNumber` properties with `CPTAnimation`.
- **New**: Added support for `NSSecureCoding`.
- **New**: Added an option to draw legend swatches to the left or right side of the title.
- **New**: Added options to use Catmull-Rom and Hermite cubic splines to draw curved scatter plot lines.
- **New**: Added a method to automatically scale the plot space to fit the entire plot.
- **Changed**: Changed the annotated type definitions to exclude the pointer star ("\*").
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the deprecated `CorePlot-CocoaTouch.xcodeproj` project file.

# Release 2.0 (October 4, 2015)

## Release Notes

This release contains changes that will break apps built against earlier Core Plot
versions. For a cleaner public API and ease of use from Swift, all public properties and methods that take `NSDecimal` values have been changed to take `NSNumber` values instead. See the [Release 2.0 API Changes](https://github.com/core-plot/core-plot/wiki/Core-Plot-API-Changes-Between-Versions-1.x-and-2.x) wiki page for a detailed list of the API changes.

The Mac and iOS projects have been combined into one project file. The `CorePlot-CocoaTouch.xcodeproj` project file is deprecated and will be removed in a future release. There is now an iOS framework target in addition to the static library in the `CorePlot.xcodeproj` project file.

The deployment target has increased to iOS 6.0 for the static library and iOS 8.0 for the framework. The Mac deployment target remains OS X 10.7.

## Details

- **New**: Combined the Mac and iOS projects and added an iOS framework target. The `CorePlot-CocoaTouch.xcodeproj` project file is deprecated.
- **New**: Added histogram style options to `CPTScatterPlot`.
- **New**: Added iOS unit tests.
- **New**: Added plot space point conversion methods that take an `NSArray` of coordinate values.
- **New**: Added nullability annotations to all property and method declarations.
- **New**: Added type annotations to all arrays, sets, and dictionaries.
- **New**: Added the log-modulus scale type.
- **Changed**: Increased the deployment target to iOS 6.0 and Mac OS X 10.7. The iOS framework requires iOS 8 or higher.
- **Changed**: Changed the Installation Directory for the Mac framework to "@rpath" and updated the Runpath Search Path in each Mac example app.
- **Changed**: Changed all public properties and methods that take `NSDecimal` values to take `NSNumber` values instead. Use `NSDecimalNumber` to maintain full decimal precision.
- **Changed**: Added properties to `CPTPlotRange` and `CPTMutablePlotRange` to read and write all range properties as `NSNumber`, `NSDecimal`, or `double`.
- **Changed**: Renamed the `CPTXYAxis.orthogonalCoordinateDecimal` property to `CPTXYAxis.orthogonalPosition`.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 1.6 (May 9, 2015)

## Release Notes

This release adds support for @3x and stretchable images, plot area fill bands, new axis and plot delegate methods, and trackpad and scroll wheel gestures on the Mac. The behavior of all axis and plot xxxWasSelected delegate methods changed to require both a down and up event on the same element instead of only the down event. The deployment target has increased to iOS 5.0 and Mac OS X 10.7 and all iOS clients must now link against the Accelerate framework.

## Details

- **New**: Added hand cursors to the Mac hosting view to indicate when user interaction is enabled and when dragging is in progress.
- **New**: Added two additional initialization methods to `CPTImage`.
- **New**: Added a dependency on the Accelerate framework. All iOS clients must now link against this framework.
- **New**: Added a shared header file for apps using Core Plot with CocoaPods.
- **New**: Added support for pinch zoom gestures on the Mac.
- **New**: Added support for trackpad and mouse wheel scrolling gestures on the Mac.
- **New**: Added a scroll wheel event to `<CPTResponder>`.
- **New**: Added axis and plot delegate methods for touch down and up events on labels.
- **New**: Added scatter plot data line selection delegate methods.
- **New**: Added scatter plot area fill bands.
- **New**: Added new methods to all plots to allow labels, styles, and plot symbols to be updated independent of the plot data.
- **New**: Added support for stretchable images.
- **New**: Added support for @3x images.
- **New**: Added support for using an Objective-C block to calculate plot values in the function datasource class.
- **New**: Added support for categorical plot data.
- **New**: Added `showBarBorder` property to `CPTTradingRangePlot`.
- **Changed**: Increased the deployment target to iOS 5.0 and Mac OS X 10.7.
- **Changed**: Enabled automatic reference counting (ARC) in the framework projects.
- **Changed**: Updated `CPTImage` to automatically handle switching between Retina and non-Retina displays.
- **Changed**: Changed the behavior of all axis and plot xxxWasSelected delegate methods to require both a down and up event on the same element instead of only the down event.
- **Changed**: Changed the class prefix for the Quartz Composer plug-ins from "CP" to "CPT".
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the deprecated plot space methods.

# Release 1.5.1 (March 16, 2014)

## Release Notes

This release updates release 1.5 to work with Xcode 5.1.

## Details

- **Removed**: Removed the `-all_load` linker flag from the iOS project.
- **Removed**: Removed support for garbage collection.

# Release 1.5 (March 15, 2014)

## Release Notes

This release adds new animation options, user interaction for annotations and plot areas,
and new customization options for legends, range plots, and axis titles. It also added
plot space properties to permit more fine-grained control of momentum scrolling.

## Details

- **New**: Updated `CPTAnimation` to allow animations to start at the current value of the animated property instead of a fixed value.
- **New**: Animations can now start when the value of the animated property enters the animated range.
- **New**: Added an identifier and user info dictionary to animation operations.
- **New**: Added annotations to the responder chain.
- **New**: Added plot area delegate methods to report user interaction with the plot area.
- **New**: Added legend delegate methods to customize the swatch fill and border line style for each legend entry.
- **New**: Added a plot property to control drawing of the legend entry swatch.
- **New**: Added options to draw a background fill behind and a border line around each legend entry.
- **New**: Added an axis property to control the offset direction of the title independent of the tick direction.
- **New**: Added a border line around range plot area fills.
- **New**: Added a plot space method to scale the plot range for a single coordinate.
- **New**: Added properties to control momentum scrolling for the x- and y-directions separately.
- **Changed**: Switched to a new algorithm for computing curved scatter plots.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the elastic global range properties from `CPTXYPlotSpace`. Turning on momentum scrolling now automatically allows elastic ranges, too.

# Release 1.4 (September 28, 2013)

## Release Notes

This release adds a helper class that makes it easy to create a datasource to plot a mathematical function.
The function datasource can plot any c-style function that returns the value of _y_ = _f_(_x_).
The release also adds new delegate methods for legends and axis labels, a new line drawing style, new axis and
data label positioning options, and support for label formatters that return styled text.

This release deprecates all plot space methods that take a c-style array of coordinate values.
They have been replaced with equivalent methods that add an additional parameter to pass
the size of the array and will be removed in a future release.

## Details

- **New**: Added properties to allow axis labels to be positioned independent of the tick direction.
- **New**: Added legend delegate methods to notify the delegate when a legend entry is selected.
- **New**: Added support for lines drawn with a gradient following the stroked path.
- **New**: Added support for axis and plot data label formatters that return styled text.
- **New**: Added a datasource class that automatically creates scatter plot data from a function.
- **New**: Added an option to turn off automatic plot data label anchor point adjustments.
- **New**: Added a count parameter to all plot space methods that take a c-style array of coordinate values and deprecated the old versions. These methods will be removed in release 2.0.
- **New**: Added axis label selection delegate methods.
- **Changed**: Updated all projects to support Xcode 5.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 1.3 (June 30, 2013)

## Release Notes

This release adds support for styled text (via `NSAttributedString`) in all titles, labels, and text layers.
It adds support for momentum scrolling and "rubber band" snap-back when scrolling beyond
the global _x_- and _y_-ranges.

## Details

- **New**: Added support for styled text in all titles, labels, and text layers.
- **New**: Added a minor tick label shadow property to `CPTAxis`.
- **New**: Added a property to hide plot data labels.
- **New**: Added support for momentum scrolling.
- **New**: Added support for "rubber band" snap-back when scrolling reaches the global _x_- and _y_-ranges.
- **New**: Added line break mode support to `CPTTextStyle`.
- **New**: Added a maximum layer size to `CPTTextLayer`.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 1.2 (April 6, 2013)

## Release Notes

This release adds animation support for plot ranges, decimal values, and other properties.
It also updates some of the example apps to use ARC.

## Details

- **New**: Added animation support for plot ranges, decimal values, and other properties.
- **New**: Added starting and ending anchor point properties for radial gradients.
- **Changed**: Changed the type of all axis and plot label formatters from `NSNumberFormatter` to `NSFormatter`.
- **Changed**: Updated all _CPTTestApp_ example apps for Mac and iOS to use ARC.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 1.1 (November 11, 2012)

## Release Notes

This release adds many new plot properties, delegate methods, and data bindings.

## Details

- **New**: Added Bezier curve interpolation option to `CPTScatterPlot`.
- **New**: Added printing support to the OS X hosting view.
- **New**: Added a plot data label selection delegate method.
- **New**: Added a line fill property to `CPTLineStyle`.
- **New**: Added point selection delegate methods to `CPTRangePlot` and `CPTTradingRangePlot`.
- **New**: Added an end angle property and the ability to rotate data labels relative to the pie radius to `CPTPieChart`.
- **New**: Added the `-didFinishDrawing:` delegate method to `CPTPlot`.
- **New**: Added selection delegate methods that include the event that triggered the selection to all plots.
- **New**: Added plot space convenience methods that convert global interaction coordinates obtained from an OS event to plot area drawing coordinates.
- **New**: Added the plot symbol anchor point.
- **New**: Added a corner radius property to `CPTBarPlot` that applies to the base value end of the bars.
- **New**: Added a method to `CPTBarPlot` that computes a plot range that encloses all of the bars, including the bar width and bar offset.
- **New**: Added bindings for plot data labels, bar plot fills and borders, and pie chart fills and radial offsets.
- **New**: Added bindings and data source methods for all line styles and fills in range and trading range plots.
- **New**: Added additional data source methods to all plots so each data source item can be supplied one at a time or in an array.
- **New**: Added multi-dimensional data array support to `CPTNumericData`.
- **New**: Added a new plot datasource method that returns a multi-dimensional `CPTNumericData` containing data for all plot fields.
- **Changed**: Changed the superclass of `CPTTextLayer` from `CPTLayer` to `CPTBorderedLayer`.
- **Changed**: Changed all iOS header files to "Project" visibility to prevent problems with archiving an app that uses the Core Plot static library.
- **Changed**: Significant updates to the API documentation for organization and clarity.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 1.0 (February 20, 2012)

## Release Notes

This release contains changes that will break apps built against earlier Core Plot
versions. `CPTPlotRange` has been split into mutable and immutable variants similar to
`CPTLineStyle` and `CPTTextStyle`. This change will break existing code that changes plot
ranges; that code should be updated to use the mutable versions. The `CPTBarPlotField`
enum was changed so that the field values start at zero like all other plots. This will
affect any existing code that used hard-coded values for the fields instead of the enum
field names (`CPTBarPlotFieldBarLocation`, etc.). The `CPTNewCGColorFromNSColor()`
function was renamed to `CPTCreateCGColorFromNSColor()` to conform to Apple's memory
management naming conventions.

Core Plot now supports projects that use automatic reference counting (ARC). For
compatibility with older systems, Core Plot itself does not use ARC but its header files
and binaries can be used in applications that do.

## Details

- **New**: Added a script to automatically format the code following the coding standards using uncrustify.
- **New**: Added support for automatic reference counting (ARC).
- **New**: Added the HTML docs built with Doxygen to the source code repository so that they can be viewed online with a web browser.
- **New**: Added an `identifier` property to `CPTLayer`, replacing the one from `CPTPlot` and `CPTPlotGroup`.
- **New**: Added control chart and multi-colored bar plot examples to the Plot Gallery app.
- **New**: Added a mouse zoom user interface to the DropPlot app.
- **Changed**: Split `CPTPlotRange` into mutable and immutable variants.
- **Changed**: Changed the `CPTBarPlotField` enum values.
- **Changed**: Renamed the `CPTNewCGColorFromNSColor()` function to `CPTCreateCGColorFromNSColor()`.
- **Changed**: Updated all projects to support Xcode 4.2.
- **Changed**: Made all `CPTAxis` delegate methods optional.
- **Changed**: Added the `-[CPTAxis axis:shouldUpdateMinorAxisLabelsAtLocations:]` delegate method.
- **Changed**: Added a graph fill to the Slate theme so that all themes have explicit fills.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed unused `NSException` extensions.
- **Removed**: Removed unused methods from `CPTLayer` and `CPTTextLayer`.

# Release 0.9 Beta (September 25, 2011)

## Release Notes

This release contains several changes that will break apps built against earlier Core Plot
versions. The MacOS hosting view has been renamed and many deprecated properties and
methods have been removed. The axis constraints system has been changed; the new
class-based system is easier to set up and less prone to problems than the old
struct-based system. This release also adds support for many new features including hi-dpi
displays on MacOS, @2x images on both iOS and MacOS, shadows on many plot elements, arrows
and other line caps on axis lines, and animation support for many plot properties.

## Details

- **New**: Added support for hi-dpi displays in MacOS 10.7 Lion.
- **New**: Added support for @2x images on hi-dpi displays.
- **New**: Added support for shadows.
- **New**: Added arrows and other line caps for axis lines.
- **New**: Added animation support for many plot properties.
- **New**: Added a `shape` property setter to `CPTMutableNumericData`.
- **New**: Implemented the `<NSCoding>` protocol in all Core Plot classes.
- **New**: Added several new plots to the Plot Gallery example application.
- **New**: Added some unit tests.
- **Changed**: Renamed the MacOS hosting view to `CPTGraphHostingView` to match the iOS nomenclature.
- **Changed**: Renamed the `CPTBarPlot` `barLengths` property to `barTips` to conform with the field naming convention (location, tip, and base).
- **Changed**: Changed the axis constraints mechanism--it now uses a class instead of a struct.
- **Changed**: Made plot point pixel alignment optional.
- **Changed**: Made the header files for several internal classes private.
- **Changed**: Performance enhancements in several plots and `CPTXYAxis`.
- **Changed**: Updated all projects to support Xcode 4.1.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the unused `CPTLayoutManager` protocol.
- **Removed**: Removed the unused `CPTPolarPlotSpace` class.
- **Removed**: Removed deprecated properties and methods.
- **Removed**: Removed the unused default z-position from all layers.

# Release 0.4 Alpha (July 7, 2011)

## Release Notes

This release contains several changes that will break apps built against earlier Core Plot
versions. The class prefix for all Core Plot classes and public symbols changed from
"CP" to "CPT". Also, the iOS SDK is no longer supported. iOS projects that were built
against the SDK must be updated to include the Core Plot project file or link against the
new universal static library instead.

## Details

- **New**: Added iOS universal static library build target.
- **New**: Added graph legends.
- **New**: Implemented logarithmic plot scales.
- **New**: Added support for multi-line text in `CPTTextLayer`.
- **New**: Added a text alignment property to `CPTTextStyle`.
- **New**: Added a title rotation property to `CPTAxis`.
- **New**: Added several new plots to the Plot Gallery example application.
- **New**: Added an equal interval axis labeling policy.
- **Changed**: Changed the class prefix from "CP" to "CPT" to prevent conflicts with Apple's Core PDF framework.
- **Changed**: Updates to suppress compiler warnings when using the LLVM compiler.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the iOS SDK build and installer packaging scripts.

# Release 0.3 Alpha (May 4, 2011)

## Release Notes

This release adds a new plot type (range plots) and adds features to several other plot
types. `CPTextStyle` and `CPLineStyle` have been split into mutable and immutable
variants similar to Cocoa's string, data, and collection classes. This change will break
existing code that changes text style and line style properties; that code should be
updated to use the mutable versions.

## Details

- **New**: Added an option in `CPBarPlot` to set bar widths in data or view coordinates.
- **New**: Added the `allowPinchScaling` property to `CPGraphHostingView`.
- **New**: Added a shared cache of common values to the `NSDecimal` conversion utility functions for performance.
- **New**: Added support for variable bar plot base values, useful for making stacked plots.
- **New**: Added range plot type.
- **New**: Added minor axis tick labels.
- **New**: Added pie chart overlay fill.
- **New**: Added some unit tests.
- **Changed**: Split `CPTextStyle` and `CPLineStyle` into mutable and immutable variants.
- **Changed**: Updated all projects to support Xcode 4.
- **Changed**: Drawing performance improvements in `CPBarPlot`.
- **Changed**: Updated Doxygen configuration files and comments for Doxygen 1.7.3.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 0.2.2 Alpha (November 10, 2010)

## Release Notes

This is a maintenance release that corrects some packaging errors in release 0.2.1.
It also adds support for missing data in all plot types.

## Details

- **New**: Added support for missing plot data points.
- **New**: Added histogram interpolation to `CPScatterPlot`.
- **New**: Added secondary scatter plot fill.
- **Changed**: Updated the release packaging scripts.
- **Changed**: Miscellaneous bug fixes and cleanup.

# Release 0.2.1 Alpha (October 20, 2010)

## Release Notes

This release adds methods to improve plot performance by only updating the parts of the
data cache that changed. It also adds support for Xcode 3.2.4 and the iOS 4.1 SDK.

## Details

- **New**: Added packaging scripts for releases.
- **New**: Added plot methods to add, remove, and reload plot data records without reloading all of the data.
- **New**: Added support for axis label alignment.
- **Changed**: Updated all projects to support Xcode 3.2.4 and the iOS 4.1 SDK.
- **Changed**: Optimized plot symbol drawing.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed the Core Plot animation classes.

# Release 0.2 Alpha (September 10, 2010)

## Release Notes

This release adds data labels to all plots and adds features to scatter plots and pie charts.
It also makes substantial improvements to `CPNumericData` and modifies the plots to use it
for the internal data cache. All C++ code has been removed from Core Plot, which improves
performance and simplifies the process of linking Core Plot into other projects.

## Details

- **New**: Added plot data labels.
- **New**: Added stepped interpolation to `CPScatterPlot`.
- **New**: Added `NSDecimal` support to `CPNumericData`.
- **New**: Added `NSDecimal` utility functions for all primitive types supported by `NSNumber`.
- **New**: Added slice selection delegate method to `CPPieChart`.
- **New**: Added some unit tests.
- **Changed**: Updated the example apps to demonstrate new features.
- **Changed**: Changed the plot data cache to use `CPNumericData`.
- **Changed**: Miscellaneous bug fixes and cleanup.
- **Removed**: Removed all C++ code.

# Release 0.1 Alpha (June 20, 2010)

## Release Notes

First official release package.

## Details

- **New**: Implemented basic graph architecture, axes, and plots.
- **New**: Added several example applications.
- **New**: Added `masksToBorder` property to `CPBorderedLayer`.
- **New**: Implemented automatic and locations provided axis labeling policies.
- **New**: Added Quartz Composer plugin.
- **New**: Added documentation targets and Doxygen comments to all classes.
- **New**: Added unit tests.
- **New**: Implemented themes.
