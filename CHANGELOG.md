# Change Log

## [v4.1](https://github.com/Boris-Em/BEMSimpleLineGraph/releases/tag/v4.1)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v4.0...v4.1)

**Improvements**
* Bezier Algorithm Improvements. This modifies the algorithm used to determine the graph's line. The old
algorithm, although generating prettier graphs, displayed inaccurate information; line arcs would go above and below min/max values, and a graph that had two data points of the same value in a row would show invalid arcs between the two data points (always upward) giving the user an inaccurate representation of the data. Thanks to @tres for this wonderful improvement (9311f8d).
* Allow gesture recognizer to function simultaneously with other gesture recognizers. (8c25436).

**New Features**
*  New reference line width property (`referenceLineWidth`) allows you to control the width of the reference lines independently from the graph line. (0bb60c9)

**Bug Fixes**
* Fixes #135, an issue where bezier curve lines were not confined to the graph's boundaries (despite the fill gradients and colors being confined). (17fe25f)  
* Fixes an issue where permanent pop up labels are duplicated when `layoutSubview` is called (i.e. during interface orientation changes). (929df84)
* Fixes a crash that may have occurred when attempting to perform calculations on a graph with no data, or before data is loaded. (e2a5167)
* Fixes a static analyzer warning about uninitialized struct. (af70a96)

**GitHub Repo Updates**
* Readme Updates
  * Fixes quotation mark for Swift bridging header example (978b504)

**Public to Private API Transition**
* Removed previously public properties on `BEMLine` and made them private. These properties are not marked as deprecated because they should not have been public in the first-place, and any public use of them would have unintentional consequences. The following properties are no longer available publicly:  
   * `@property (assign, nonatomic) CGPoint P0`
   * `@property (assign, nonatomic) CGPoint P1`
   * `@property (assign, nonatomic) CGPoint P2`
   * `@property (assign, nonatomic) CGPoint P3`

## [v4.0](https://github.com/Boris-Em/BEMSimpleLineGraph/releases/tag/v4.0)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v3.3...v4.0)

**Breaking Changes**
* Changed the purpose of `lineGraphDidFinishLoading:`.
  * Added a new `lineGraphDidFinishDrawing:` delegate method to differentiate between when the graph finishes drawing & animating and when it finishes loading its data. 
  * Those who previously used `lineGraphDidFinishLoading:` to take graph snapshots should now use `lineGraphDidFinishDrawing:` instead.
  * The new `lineGraphDidFinishDrawing:` can be used to create snapshots for the  WATCH
* Deprecated the `distanceToClosestPoint` method. This method will become unavailable in a future update. There will be no replacement for this method and we suggest phasing it out.
* Removed compile-time module check (`@import` vs. `#import`). Modules are now be used by default. (a43ba9380f5b2a8dc8fcb268b3eb611e1dcfb471)
* Added warnings to deprecated methods which will be removed in the next major release:
  * `numberOfPointsInGraph`  
  * `didTouchGraphWithClosestIndex:`
  * `didReleaseGraphWithClosestIndex:`
  * `numberOfGapsBetweenLabels`

**Semi-Breaking Changes**
* Improved the implementation of the X-Axis. The X-Axis background is now drawn by BEMSimpleLineGraph (as the Y-Axis is) instead of by BEMLine. This will help ensure stability and provide a more reliable system moving forward. It also fixes issues with gradient overlap into the X-Axis area.

**Xcode 6 Improvements**
* BEMSimpleLineGraph now takes advantage of Xcode 6's new IBDesignable and IBInspectable features. Preview select graph properties in Interface Builder.
* Starting in Xcode 6.3 and Swift 1.2, BEMSimpleLineGraph is compatible with the new NULLABILITY standards. All methods and properties are, by default, non-nullable unless otherwise marked. (a43ba9380f5b2a8dc8fcb268b3eb611e1dcfb471)

**Key Feature**
* Average Lines (a939039a1e9a7d728cb71356b1e01902282b9132). Added an Average Line feature. Draw an average line with a specific y-value. Use the new `averageLine` property on BEMSimpleLineGraphView to setup and customize the line. Might be considered a fix for issue #42. The implementation of the average line feature is likely the direction BEMSimpleLineGraph is headed as it expands.

**New Features** - Shoutout to @RobDay and his team at @dowjones for PR #132
* New Properties
  * Optionally display only dots and no line on your graph (resolves #51) using the new `displayDotsOnly` property.
  * Added new `positionYAxisRight`property. A boolean flag that moves the Y-Axis to the right of the graph.  
  * Added a new `lineDashPatternForReference[X|Y]AxisLines` property. Specify a dash pattern for the reference lines drawn on the graph. This creates the reference lines with a dotted or hashed pattern.  
  * Added a new `enable[Left|Right|Top|Bottom]ReferenceAxisFrameLine` property. By setting these properties, you can control what reference frame lines are drawn on the graph.  
  * New `displayDotsWhileAnimating` property. A boolean specifying whether or not to show the dots while animating the reference lines.  
  * New `noDataLabelColor`. Specify the color for the no data label  
  * New `noDataLabelFont`. Specify the font for the no data label  
  * Created a new `formatStringForValues` property. A format string to apply to values in the Y-Axis. This lets you have fine-grain control over the decimal precision of these values (eg. ".02f")  
  * New `yAxis[Prefix|Suffix]OnLineGraph` property. Specify popup prefix and suffix to show in the built-in popup view
* Null Graph Values  
  * The graph now has the ability to plot null graph values.  `BEMSimpleLineGraph.h` now specifies a special value, `BEMNullGraphValue`, that corresponds to a null data point.  In your response to `valueForPointAtIndex`, return this special value whenever your data point is null.  BEMSimpleLineGraph will now skip over this value when drawing the line. If you set `interpolateNullValues`, the graph will connect non-null values while preserving spacing for the null value.
* Customizing Popup Views
  * Added a `popUpSuffixForlineGraph:` delegate method. A suffix to append to the stock pop up label view's value.  
  * Added a `popUpPrefixForlineGraph:` delegate method. A prefix to prepend to the stock pop up label view's value.  
  * If you want to use a custom popup view instead of the built-in popup view, you can respond to the optional method `popUpViewForLineGraph:`. You respond to this method with a UIView that will be used in place of the default popup.  
    * When you use the custom popup view, the data in the view needs to be changed whenever the user drags his or her finger.  To handle this modification, BEMSimpleLineGraph will send the message `lineGraph:modifyPopupView:ForIndex:`.  This lets you modify your view for a given datapoint. 
* Axis Customizations
  * Added a new delegate method, `incrementPositionsForXAxisOnLineGraph` that lets you set the specific indices where X-Axis labels should be drawn.  
  * Added a new delegate method, `baseIndexForXAxisOnLineGraph`, that lets you specify the index of the first X-Axis label to draw.  
  * `incrementIndexForXAxisOnLineGraph`. An increment to apply to the response.  
  * `baseIndexForXAxisOnLineGraph`.  X-Axis labels will be drawn on this increment across the X-Axis.  
  * `baseValueForYAxisOnLineGraph`. The starting Y-Axis value to plot draw on the Y-Axis. This lets you set a specifically formatted value so that your access label can be more user friendly (21.50 instead of 21.47)  
  * `incrementValueForYAxisOnLineGraph`- An increment value to add to the response of `baseValueForYAxisOnLineGraph` that specifies what Y-Axis values to draw. This lets you return a user friendly increment, eg. .25. 
* Snapshot Methods  
  * Use the new graphSnapshotImageRenderedWhileInBackground: method to capture a graph snapshot while your app is in the background. Fixes #193. (512f716a36c94663080abb80224404e17940d133)
* Animation & Drawing
  * New “expansion” animation has been added to the list of available animations. Try out the new animation with the `BEMLineAnimationExpand` type.

**Bug Fixes**
* Fixes #134, an issue where popup suffixes would not display when `alwaysDisplayPopUpLabels` was set to YES. The sample app now demonstrates the use of popup suffixes. (183a67504b3851e4f79f49b86a54e3e69935ac9f)  
* Fixes #138, an issue where popup prefixes would not display when `alwaysDisplayPopUpLabels` was set to YES. The sample app now demonstrates the use of popup prefixes. (c83d66c32e9b0ee31b95e996a919f896afdd7e38)  
* Fixes #70, a bug where reference axis frame drawing was conditional on reference axis lines being enabled. Now these properties are not dependent on one another. (f1f2ac453bcecd6f84fd5bcba5346068285e6467)  
* Fixes #196, vertical reference lines are now properly aligned with x-axis labels. (64b4fb1756eeb42c564b946a34b66edac21bf020)  
* Fixes #67, the far-right and far-left x-axis labels now re-orient themselves to avoid being clipped.(64b4fb1756eeb42c564b946a34b66edac21bf020) 
* Fixed an issue where the reference lines would have an alpha value of 0 if the line also had an alpha value of zero. Reference lines now set to an alpha of 0.1 when the line alpha is 0.0. As before, you can disable
reference lines using the boolean properties to make them appear or disappear. (1acc2e206a0bbb4020ee3e8004ab900c71295a8a)

**GitHub Repo Updates**
* Graph Properties View Controller
  * View all available public BEMSimpleLineGraph properties directly from the sample project
  * Ability to use and toggle these properties directly from the Storyboard is coming soon
* Readme Updates
  * New *Apps Using This Project* Section
  * Added details on IBDesignables
  * Added contributions note
  * Improved markdown formatting  
  * Added *StackOverflow* support details
* Updated project requirements

## [v3.3](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v3.3) (2015-01-31)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v3.2...v3.3)

**Implemented enhancements:**

- huge performance improvement suggestion [\#107](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/107)

**Fixed bugs:**

- popupReport will not show up if animation has been set off [\#106](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/106)

- autoScaleYAxis Not working with Bezier curves [\#99](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/99)

- Popup Labels Displaying as Double with iOS8 [\#74](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/74)

- BezierCurve do not always work [\#73](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/73)

**Closed issues:**

- Gradient fill [\#57](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/57)

**Merged pull requests:**

- Ensure permanent pop-up labels are not duplicated [\#122](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/122) ([kattrali](https://github.com/kattrali))

- fix bug about colorTouchInputLine [\#118](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/118) ([Vernsu](https://github.com/Vernsu))

- Update README.md [\#115](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/115) ([jeffreyjackson](https://github.com/jeffreyjackson))

- Bug/107 [\#111](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/111) ([Boris-Em](https://github.com/Boris-Em))

- Fixed touch report when no animation [\#110](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/110) ([Boris-Em](https://github.com/Boris-Em))

- Multiple lines support \(Re-pull-request\) [\#103](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/103) ([adonishi](https://github.com/adonishi))

- Multiple lines support [\#102](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/102) ([adonishi](https://github.com/adonishi))

- Allow drawing a horizontal or vertical gradient as the graph line [\#101](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/101) ([kattrali](https://github.com/kattrali))

- Add a Gitter chat badge to README.md [\#100](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/100) ([gitter-badger](https://github.com/gitter-badger))

- Add ability to fill the top and/or bottom of a graph with a gradient [\#98](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/98) ([kattrali](https://github.com/kattrali))

- Pr/90 [\#97](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/97) ([Boris-Em](https://github.com/Boris-Em))

- Add automatically generated changelog file [\#94](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/94) ([skywinder](https://github.com/skywinder))

- able to customize text on no data label [\#93](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/93) ([sbhhbs](https://github.com/sbhhbs))

- Code improvements [\#90](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/90) ([skywinder](https://github.com/skywinder))

- Fix path in bridging header section in Readme [\#89](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/89) ([DavidQL](https://github.com/DavidQL))

- Reference line color & draw order [\#88](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/88) ([gavinbunney](https://github.com/gavinbunney))

## [v3.2](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v3.2) (2014-11-02)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v3.1...v3.2)

**Implemented enhancements:**

- Dots still animating when animationGraphStyle set to BEMLineAnimationNone [\#80](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/80)

- enableReferenceAxisLines should be two: enableReferenceY-AxisLines and enableReferenceX-AxisLines [\#69](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/69)

- Y-axis label issues [\#62](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/62)

- Touch interaction on touch-down, not just start-pan? [\#59](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/59)

**Fixed bugs:**

- Dots still animating when animationGraphStyle set to BEMLineAnimationNone [\#80](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/80)

- BackgroundPopUplabel never show if enableYAxisLabel is set NO [\#71](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/71)

**Merged pull requests:**

- Split enableReferenceAxisLines into two properties [\#87](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/87) ([gavinbunney](https://github.com/gavinbunney))

- fix issue \#80 [\#86](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/86) ([skywinder](https://github.com/skywinder))

- Fix wrong presentation of years in code exmple + auto-update graph by clicking on segment controll [\#85](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/85) ([skywinder](https://github.com/skywinder))

- update travis script to avoid "exited with 134" [\#84](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/84) ([skywinder](https://github.com/skywinder))

- Fix representation of negative values in Y axis [\#83](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/83) ([skywinder](https://github.com/skywinder))

- Fix several UI bug when displaying data with negative numbers [\#79](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/79) ([ben181231](https://github.com/ben181231))

- Fixed issue \#73 and labels Y axis height [\#78](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/78) ([Boris-Em](https://github.com/Boris-Em))

- Add segment to select Bezier or straght line [\#76](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/76) ([skywinder](https://github.com/skywinder))

## [v3.1](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v3.1) (2014-08-28)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v3.0...v3.1)

**Fixed bugs:**

- alwaysDisplayDots=YES is not having effect when animationGraphEntranceTime=0.0 [\#61](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/61)

## [v3.0](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v3.0) (2014-08-19)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v2.3...v3.0)

**Fixed bugs:**

- Crash with one point or less on Feature branch [\#56](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/56)

- X-Axis label displays under the graph view [\#47](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/47)

**Merged pull requests:**

- Podname should be quoted [\#55](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/55) ([zrcoder](https://github.com/zrcoder))

- Add Y-Axis Reference Line \(\#40\) [\#43](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/43) ([japanconman](https://github.com/japanconman))

- Added Obj-C Tags and Added access to Labels [\#39](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/39) ([joeblau](https://github.com/joeblau))

- Add Y-Axis feature [\#33](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/33) ([japanconman](https://github.com/japanconman))

## [v2.3](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v2.3) (2014-06-02)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v2.2...v2.3)

**Fixed bugs:**

- index beyond bounds when touch graph [\#31](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/31)

- On Device [\#29](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/29)

**Merged pull requests:**

- Feature branch catch up on Master branch [\#32](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/32) ([Boris-Em](https://github.com/Boris-Em))

## [v2.2](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v2.2) (2014-05-19)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v2.1...v2.2)

**Fixed bugs:**

- Graph Displaying Opposite Direction [\#20](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/20)

- Outside the Graph [\#18](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/18)

**Merged pull requests:**

- Feature branch catch up on Master branch [\#25](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/25) ([Boris-Em](https://github.com/Boris-Em))

- Added support for scrolling with a GraphView placed in UIScrollView [\#12](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/12) ([nmattisson](https://github.com/nmattisson))

## [v2.1](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v2.1) (2014-04-20)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v2.0.1...v2.1)

**Fixed bugs:**

- Demo projects not working. [\#14](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/14)

## [v2.0.1](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v2.0.1) (2014-03-03)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v2.0...v2.0.1)

## [v2.0](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v2.0) (2014-03-02)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v1.3...v2.0)

**Implemented enhancements:**

- Several Graphs in the same View Controller [\#11](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/11)

**Fixed bugs:**

- Bug: The chart can not draw a single dot and it crashes. [\#6](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/6)

- CALayerInvalidGeometry exception for duplicate & zeroed data points [\#3](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/3)

**Merged pull requests:**

- 2.0 Update [\#13](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/13) ([Sam-Spencer](https://github.com/Sam-Spencer))

- Fixed issue \#3 and \#6 [\#9](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/9) ([Boris-Em](https://github.com/Boris-Em))

- Fixes crash, cleaned up for 64 bit [\#4](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/4) ([darkFunction](https://github.com/darkFunction))

## [v1.3](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v1.3) (2014-02-08)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v1.2.2...v1.3)

**Merged pull requests:**

- Feature 1.3, 1.x Update [\#2](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/2) ([Sam-Spencer](https://github.com/Sam-Spencer))

## [v1.2.2](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v1.2.2) (2014-01-14)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v1.2.1...v1.2.2)

## [v1.2.1](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v1.2.1) (2014-01-08)

[Full Changelog](https://github.com/Boris-Em/BEMSimpleLineGraph/compare/v1.2...v1.2.1)

## [v1.2](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/v1.2) (2014-01-04)

**Merged pull requests:**

- Interface Initialization & Reload Data [\#1](https://github.com/Boris-Em/BEMSimpleLineGraph/pull/1) ([Sam-Spencer](https://github.com/Sam-Spencer))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
