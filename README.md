<<<<<<< HEAD
# BEMSimpleLineGraph - Feature Branch
<p align = right><a target="_blank" href="https://twitter.com/intent/tweet?hashtags=iosdev&original_referer=https%3A%2F%2Fabout.twitter.com%2Fresources%2Fbuttons&text=BEMSimpleLineGraph,%20beautiful%20graphs%20for%20iOS!%20Open%20Source%20Library%20on%20GitHub&tw_p=tweetbutton&url=http%3A%2F%2Fgoo.gl%2FzgB6GL&via=Boris_Em"><img src="http://s30.postimg.org/j2q6ql27h/Tweet.png"></a>
<a target="_blank" href="https://twitter.com/Boris_Em"> <img src="http://s29.postimg.org/avb82kvv7/Follow_Twitter.png"></a>
</p>
<p align="center"><img src="http://s29.postimg.org/57dn7ve3r/BEMSimple_Line_Graph_Main.png"/></p>	
=======
# BEMSimpleLineGraph  [![Build Status](https://travis-ci.org/Boris-Em/BEMSimpleLineGraph.svg?branch=master)](https://travis-ci.org/Boris-Em/BEMSimpleLineGraph)

<p align = right><a target="_blank" href="https://twitter.com/intent/tweet?hashtags=iosdev&original_referer=https%3A%2F%2Fabout.twitter.com%2Fresources%2Fbuttons&text=BEMSimpleLineGraph,%20beautiful%20graphs%20for%20iOS!%20Open%20Source%20Library%20on%20GitHub&tw_p=tweetbutton&url=http%3A%2F%2Fgoo.gl%2FzgB6GL&via=Boris_Em"><img src="http://s30.postimg.org/j2q6ql27h/Tweet.png"></a>
<a target="_blank" href="https://twitter.com/Boris_Em"> <img src="http://s29.postimg.org/avb82kvv7/Follow_Twitter.png"></a>
</p>
<p align="center"><img src="http://s29.postimg.org/57dn7ve3r/BEMSimple_Line_Graph_Main.png"/></p>
>>>>>>> FETCH_HEAD

<p align="center">
<b>BEMSimpleLineGraph</b> makes it easy to create and customize line graphs for iOS.
</p>

BEMSimpleLineGraph is a charting library that makes it easy to create beautiful line graphs for iOS. It is easy to set-up and to use in any iOS Project. It's focused on highly customizable and interactive line graphs. Plus, its lightweight and can be integrated in minutes (maybe even seconds). 

BEMSimpleLineGraph's implementation, data source, and delgate are all modeled off of UITableView and UICollectionView. If you're familiar with using a UITableView, UITableViewController, or UICollectionView, using BEMSimpleLineGraph should be a breeze!

## Feature Branch Warning
You are currently viewing the feature branch of this GitHub repository. The feature branch contains bleeding edge commits / features, otherwise known as **alpha or beta** features. Content in this branch may be unstable, bug-ridden, non-working, and undocumented. The sole purpose of this branch is to test and improve on new features that may or may not be included in future (stable) versions.

It is not recommended that you use this branch in a production app of any kind. **For stable production ready code**, please refer to the [master branch](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/master).

## Table of Contents

* [**Project Details**](#project-details)  
    * [Requirements](#requirements)
    * [License](#license)
    * [Support](#support)
    * [Sample App](#sample-app)
* [**Setup**](#setup)
    * [Installation](#installation)
    * [Setup](#setup)
* [**Documentation**](#documentation)
<<<<<<< HEAD
    * For full documentation, see the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki)
    * [Required Delegate / Data Source Methods](#required-delegate--data-source-methods)
    * [Reloading the Data Source](#reloading-the-data-source) 
    * [Bezier Curves](#bezier-curves)
    * [Interactive Graph](#interactive-graph)
    * [Properties](#properties)
=======
  * [Installation](#installation)
  * [Setup](#setup)
  * [Required Delegate / Data Source Methods](#required-delegate--data-source-methods)
  * [Reloading the Data Source](#reloading-the-data-source)
  * [Retrieving the Data Source](#retrieving-the-data-source)
  * [Retrieving the Data Labels](#retrieving-the-data-labels)
  * [Data Source Calculations](#data-source-calculations)
  * [Status Reporting](#status-reporting)
  * [Interactive Graph](#interactive-graph)
  * [X-Axis Labels](#x-axis-labels)
  * [Bezier Curves](#bezier-curves)
  * [Line Customization](#line-customization)
  * [Properties](#properties)
  * [Graph Snapshots](#graph-snapshots)
>>>>>>> FETCH_HEAD

## Project Details
Learn more about the BEMSimpleLineGraph project requirements, licensing, and contributions.

### Requirements
- Requires iOS 6 or later. The sample project is optimized for iOS 7.
- Requires Automatic Reference Counting (ARC).
- Optimized for ARM64 Architecture

Requires Xcode 5 for use in any iOS Project. Requires a minimum of iOS 6.0 as the deployment target. 

<<<<<<< HEAD
| Current Build Target 	| Earliest Supported Build Target 	| Earliest Compatible Build Target 	|
|:--------------------:	|:-------------------------------:	|:--------------------------------:	|
|       iOS 7.1        	|            iOS 7.0             	|             iOS 6.0              	|
|     Xcode 5.1.1      	|          Xcode 5.1            	|           Xcode 5.0            	|
|      LLVM 5.0        	|             LLVM 5.0            	|             LLVM 5.0             	|
=======
### Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.
>>>>>>> FETCH_HEAD

> REQUIREMENTS NOTE  
*Supported* means that the library has been tested with this version. *Compatible* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.

### License
See the [License](https://github.com/Boris-Em/BEMSimpleLineGraph/blob/master/LICENSE). You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but it is appreciated. A little Thanks! (or something to that affect) would be much appreciated. If you use BEMSimpleLineGraph in your app, let us know.

###Support
[![Gitter chat](https://badges.gitter.im/Boris-Em/BEMSimpleLineGraph.png)](https://gitter.im/Boris-Em/BEMSimpleLineGraph)  
Join us on [Gitter](https://gitter.im/Boris-Em/BEMSimpleLineGraph) if you need any help or want to talk about the project.

### Sample App
The iOS Sample App included with this project demonstrates how to correctly setup and use BEMSimpleLineGraph. You can refer to the sample app for an understanding of how to use and setup BEMSimpleLineGraph.

## Setup
BEMSimpleLineGraph can be added to any project (big or small) in a matter of minutes (maybe even seconds if you're super speedy). Cocoapods is fully supported, and so are all the latest technologies (eg. ARC, Storyboards, Interface Builder Attributes, Modules, and more).

### Installation
The easiest way to install BEMSimpleLineGraph is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
```ruby
pod 'BEMSimpleLineGraph'
```

The other way to install BEMSimpleLineGraph, is to drag and drop the *Classes* folder into your Xcode project. When you do so, check the "*Copy items into destination group's folder*" box.

####Swift Projects
To use BEMSimpleLineGraph in a Swift project add the following to your bridging header:

    #import "BEMSimpleLineGraph.h"

### Setup
Setting up BEMSimpleLineGraph in your project is simple. If you're familiar with UITableView, then BEMSimpleLineGraph should be a breeze. Follow the steps below to get everything up and running.

 1. Import `"BEMSimpleLineGraphView.h"` to the header of your view controller:

<<<<<<< HEAD
         #import "BEMSimpleLineGraphView.h"

 2. Implement the `BEMSimpleLineGraphDelegate` and `BEMSimpleLineGraphDataSource` in the same view controller:

         @interface YourViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

=======
    ```objective-c
    #import "BEMSimpleLineGraphView.h"
    ```
 2. Implement the `BEMSimpleLineGraphDelegate` to the same view controller:

    ```objective-c
    @interface YourViewController : UIViewController <BEMSimpleLineGraphDelegate>
    ```
>>>>>>> FETCH_HEAD
 3.  BEMSimpleLineGraphView can be initialized in one of two ways. You can either add it directly to your interface (storyboard file) OR through code. Both ways provide the same initialization, just different ways to do the same thing. Use the method that makes sense for your app or project.

     **Interface Initialization**  
     1 - Add a UIView to your UIViewController  
     2 - Change the class type of the UIView to `BEMSimpleLineGraphView`  
     3 - Link the view to your code using an `IBOutlet`. You can set the property to `weak` and `nonatomic`.  
     4 - Select the `BEMSimpleLineGraphView` in your interface. Connect the **dataSource** property and then the **delegate** property to your ViewController.  

     **Code Initialization**  
     Just add the following code to your implementation (usually the `viewDidLoad` method).
<<<<<<< HEAD

         BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
         myGraph.dataSource = self;
         myGraph.delegate = self;
         [self.view addSubview:myGraph];

 4. Implement the two required data source methods: `numberOfPointsInLineGraph:` and `lineGraph:valueForPointAtIndex:`. See documentation below for more information

## Documentation
The essential parts of BEMSimpleLineGraph are documented below. For full documentation, see the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki). If you're using Xcode 5 with BEMSimpleLineGraph, documentation is available directly within Xcode (just Option-Click any method for Quick Help).
=======
    ```objective-c
    BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    myGraph.delegate = self;
    [self.view addSubview:myGraph];
    ```
 4. Implement the two required methods: `numberOfPointsInLineGraph:` and `lineGraph:valueForPointAtIndex:`. See documentation below for more information
>>>>>>> FETCH_HEAD

### Required Delegate / Data Source Methods

**Number of Points in Graph**  
Returns the number of points in the line graph. The line graph gets the value returned by this method from its data source and caches it.
```objective-c
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
		return X; // Number of points in the graph.
}
```
**Value for Point at Index**  
<<<<<<< HEAD
Informs the position of each point on the Y-Axis at a given index. This method is called for every point specified in the `numberOfPointsInLineGraph:` method. The parameter `index` is the position from left to right of the point on the X-Axis:

	- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    		return …; // The value of the point on the Y-Axis for the index.
	}

=======
Informs the position of each point on the Y-Axis at a given index. This method is called for every point specifed in the `numberOfPointsInLineGraph:` method. The parameter `index` is the position from left to right of the point on the X-Axis:
```objective-c
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
  		return …; // The value of the point on the Y-Axis for the index.
}
```
>>>>>>> FETCH_HEAD
### Reloading the Data Source
Similar to a UITableView's `reloadData` method, BEMSimpleLineGraph has a `reloadGraph` method. Call this method to reload all the data that is used to construct the graph, including points, axis, index arrays, colors, alphas, and so on. Calling this method will cause the line graph to call `layoutSubviews` on itself. The line graph will also call all of its data source and delegate methods again (to get the updated data).
```objective-c
- (void)anyMethodInYourOwnController {
    // Change graph properties
    // Update data source / arrays

    // Reload the graph
    [self.myGraph reloadGraph];
}
```

<<<<<<< HEAD
=======
### Retrieving the Data Source
The values submitted through the data source delegate methods are saved / recorded. You can retrieve the line graph's current data points and X-Axis with the two methods below.

```objective-c
// Retrieve current X-Axis values
NSArray *arrayOfXValues = [self.myGraph graphValuesForXAxis]; // The returned NSArray contains an array of NSString objects

// Retrieve the Data Points
NSArray *arrayOfDataPoints = [self.myGraph graphValuesForDataPoints]; // The returned NSArray contains an array of NSNumber objects (originally formatted as a float).
```

### Retrieving the Data Labels
The values submitted through the data source delegate methods are saved / recorded. You can retrieve the line graph's current labels and X-Axis with the method below.

```objective-c
// Retrieve current X-Axis labels
NSArray *arrayOfXLabels = [self.myGraph graphLabelsForXAxis]; // The returned NSArray contains an array of UILabel objects
```
### Data Source Calculations
In addition to recording and displaying data, BEMSimpleLineGraph can also perform advanced calculations with your data. All calculation methods are available publically and begin with `calculate`. BEMSimpleLineGraph can calculate Standard Deviation, Average, Median, Mode, Minimum, and Maximum values.

### Status Reporting
When the line graph starts or completes loading it will call a delegate method. When it begins reloading the `lineGraphDidBeginLoading:` method is called. When loading is finished, the `lineGraphDidFinishLoading:` method is called.

>>>>>>> FETCH_HEAD
### Interactive Graph
BEMSimpleLineGraph can react to the user touching the graph by two different ways: **Popup Reporting** and **Touch Reporting**.

<p align="center"><img src="http://s21.postimg.org/3lkbvgp53/GIF_Touch_Report.gif"/></p>
<p align="center"> On this example, both Popup Reporting and Touch Reporting are activated. </p>

<<<<<<< HEAD
=======
**Popup Reporting**  
When the user touches and drags his finger along the graph, a popup label will appear on top of the closest dot from the user's finger. The label will display the value of the point.  
To enable Popup Reporting, simply set the BOOL property `enablePopUpReport` to YES.
```objective-c
self.myGraph.enablePopUpReport = YES;
```
**Touch Reporting**  
When the user touches and drags his finger along the graph, it's possible to retrive the value of the closest point.  
To do so, first toggle the `enableTouchReport` property:
```objective-c
self.myGraph.enableTouchReport = YES;
```
Next, implement the two following methods: `lineGraph:didTouchGraphWithClosestIndex` and `lineGraph:didReleaseTouchFromGraphWithClosestIndex:`.

1. The `lineGraph:didTouchGraphWithClosestIndex` method gets called when the user touches the graph. The parameter `index` is the closest index (X-Axis) from the user's finger position.

    ```objective-c
    - (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    	// Here you could change the text of a UILabel with the value of the closest index for example.
    }
    ```
2. The `lineGraph:didReleaseTouchFromGraphWithClosestIndex:` method gets called when the user stops touching the graph. The parameter `index` is the closest index (X-Axis) from the user's last finger position.

    ```objective-c
    - (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    	// Set the UIlabel alpha to 0 for example.
    }
    ```
    
### X-Axis Labels
BEMSimpleLineGraph makes it possible to add labels along the X-Axis. To do so, simply implement the two followings methods: `numberOfGapsBetweenLabelsOnLineGraph:` and `lineGraph:labelOnXAxisForIndex:`.

**Gaps between labels**  
Informs how much empty space is needed between each displayed label. Returning 0 will display all of the labels. Returning the total number of labels will only display the first and last label. See the image below for clarification.
```objective-c
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
	 return X; // The number of hidden labels between each displayed label.
}
```
<p align="center"><img src="http://img838.imageshack.us/img838/9329/tz01.png"/></p>

<p align="center"> On the left, <tt>numberOfGapsBetweenLabelsOnLineGraph:</tt> returns 0, on the middle it returns 1 and on the right it returns the number of points in the graph. </p>

**Label on X Axis**  
The text to be displayed for each UILabel on the X-Axis at a given index. It should return as many strings as the number of points on the graph.
```objective-c
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
	return …;
}
```
**X-Axis Label Color**  
The property `colorXaxisLabel` controls the color of the text of the UILabels on the X-Axis:
```objective-c
@property (strong, nonatomic) UIColor *colorXaxisLabel;
```
>>>>>>> FETCH_HEAD
### Bezier Curves
<img align="left" width="237" height="141" src="http://s4.postimg.org/ucf4zsyd9/BEMSimple_Line_Graph_Bezier_Curve.png">

BEMSimpleLineGraph can be drawn with curved lines instead of directly connecting the dots with straight lines.  
<<<<<<< HEAD
To do so, set the property `enableBezierCurve` to YES. 

	self.myGraph.enableBezierCurve = YES;
   
### Properties
BEMSimpleLineGraphs can be customized by using various properties. A multitude of properties let you control the animation, colors, and alpha of the graph. Many of these properties can be set from Interface Build and the Attributes Inspector, others must be set in code.
=======
To do so, set the property `enableBezierCurve` to YES.
```objective-c
self.myGraph.enableBezierCurve = YES;
```
### Line Customization
Two delegate methods on the `BEMSimpleLineGraphDelegate` let you customize the color and alpha of a specifc line in the graph.

**Line Color**
Specify the color of the line at a specific index (the graph is made of multiple lines that appear as one).
```objective-c
- (UIColor *)lineGraph:(BEMSimpleLineGraphView *)graph lineColorForIndex:(NSInteger)index {
    return [UIColor color];
}
```
**Line Alpha**
Specify the alpha value of the line at a specific index (the graph is made of multiple lines that appear as one).
```objective-c
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph lineAlphaForIndex:(NSInteger)index {
    return 1.0;
}
```
### Properties
BEMSimpleLineGraphs can be customized by using various properties. A variety of properties let you control the animation, colors, and alpha of the graph.

**Entrance Animation**  
The `animationGraphEntranceSpeed` property controls the speed of the entrance animation. It is an NSInteger who's value should be between 0 and 10.

A value of 0 will disable the animation. A value of 1 will make the animation very slow. A value of 10 or more will make it fast.

<p align="center"><img src="http://img819.imageshack.us/img819/4290/3vs.gif"/></p>

**Custom Colors and Alpha**  
BEMSimpleLineGraphs are split into three parts - the top, the bottom, and the line. You can set the alpha and color of each of these parts separately.

 * Top Section. The `colorTop` and `alphaTop` properties control the color (UIColor) and alpha (float) of the top part of the graph.  
 * Bottom Section. The `colorBottom` and `alphaBottom` properties control the color (UIColor) and alpha (float) of the bottom part of the graph.  
 * Line. The `colorLine` and `alphaLine` properties control the color (UIColor) and alpha (float) of the line of the graph. The `widthLine` property controls the width of the line of graph (float that defaults to 1.0).
 * Point. The `colorPoint` property controls the color (UIColor) of the points of the graph. The `sizePoint` property controls the size (diameter) of the points of the graph (float that defaults to 10.0).

### Graph Snapshots
On iOS 7.0 and above you can take a snapshot of the line graph view and get a UIImage representation of the snapshot. To do so, simply call the method below at anytime in the graph's lifecycle. Note that the snapshot is not of the completed graph, but of the graph in its current state (whether it is in mid-animation or not). You can use the `lineGraphDidFinishLoading:` delegate method to find out when the graph has finished rendering and animating.
```objective-c
// Method Definition
- (UIImage *)graphSnapshotImage;

// Method Usage
UIImage *imageOfGraph = [self.myGraph graphSnapshotImage];
```
>>>>>>> FETCH_HEAD
