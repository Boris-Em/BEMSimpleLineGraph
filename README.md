# BEMSimpleLineGraph - Feature Branch
<p align="center"><img src="http://s29.postimg.org/57dn7ve3r/BEMSimple_Line_Graph_Main.png"/></p>	

<p align="center">
<b>BEMSimpleLineGraph</b> makes it easy to create and customize line graphs for iOS.
</p>

***

## Feature Branch Warning
You are currently viewing the feature branch of this GitHub repository. The feature branch contains bleeding edge commits / features, otherwise known as **alpha or beta** features. Content in this branch may be unstable, bug-ridden, non-working, and undocumented. The sole purpose of this branch is to test and improve on new features that may or may not be included in future (stable) versions.

It is not recommended that you use this branch in a production app of any kind. **For stable production ready code**, please refer to the [master branch](https://github.com/Boris-Em/BEMSimpleLineGraph/tree/master).

***

BEMSimpleLineGraph is a charting library that makes it easy to create beautiful line graphs for iOS. It is easy to set-up and to use in any iOS Project. It's focused on highly customizable and interactive line graphs. Plus, its lightweight and can be integrated in minutes (maybe even seconds). All of this while remaining familiar, because BEMSimpleLineGraph is modeled after UITableView and UICollectionView.

<p align = center><a href="https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Axis-Labels"><img src="http://s3.postimg.org/ub8vnbsdf/Axis_labels.png"></a></p>

***

<p align = center><a href="https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Bézier-Curves"><img src="http://s7.postimg.org/xz6qqo4vf/Bezier_Curves.gif"></a></p>

***

<p align = center><a href="https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Entrance-Animation"><img src="http://s27.postimg.org/48cpeql9v/Animation.gif"></a></p>

***

<p align = center><a href="https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Advanced-Calculations"><img src="http://s2.postimg.org/x95asiba1/Calculation.png"></a></p>

***

<p align = center><a href="https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Graph-Snapshots"><img src="http://s16.postimg.org/tn6qqn1kl/Snapshots.png"></a></p>

***

<p align = center><a href="default.asp"><img src="http://s2.postimg.org/fbbdx7xcp/Touch.gif"></a></p>

***

## Table of Contents

* [**Project Details**](#project-details)  
    * [Requirements](#requirements)
    * [License](#license)
    * [Sample App](#sample-app)
* [**Setup**](#setup)
    * [Installation](#installation)
    * [Setup](#setup)
* [**Documentation**](#documentation)
    * For full documentation, see the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki)
    * [Required Delegate / Data Source Methods](#required-delegate--data-source-methods)
    * [Reloading the Data Source](#reloading-the-data-source) 
    * [Bezier Curves](#bezier-curves)
    * [Interactive Graph](#interactive-graph)
    * [Properties](#properties)

***

## Project Details
Learn more about the BEMSimpleLineGraph project requirements, licensing, and contributions.

[![Gitter chat](https://badges.gitter.im/Boris-Em/BEMSimpleLineGraph.png)](https://gitter.im/Boris-Em/BEMSimpleLineGraph)  
Join us on [Gitter](https://gitter.im/Boris-Em/BEMSimpleLineGraph) if you need any help or want to talk about the project.

### Requirements
- Requires iOS 6 or later. The sample project is optimized for iOS 7.
- Requires Automatic Reference Counting (ARC).
- Optimized for ARM64 Architecture

Requires Xcode 5 for use in any iOS Project. Requires a minimum of iOS 6.0 as the deployment target. 

| Current Build Target 	| Earliest Supported Build Target 	| Earliest Compatible Build Target 	|
|:--------------------:	|:-------------------------------:	|:--------------------------------:	|
|       iOS 7.1        	|            iOS 7.0             	|             iOS 6.0              	|
|     Xcode 5.1.1      	|          Xcode 5.1            	|           Xcode 5.0            	|
|      LLVM 5.0        	|             LLVM 5.0            	|             LLVM 5.0             	|

> REQUIREMENTS NOTE  
*Supported* means that the library has been tested with this version. *Compatible* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.

### License
See the [License](https://github.com/Boris-Em/BEMSimpleLineGraph/blob/master/LICENSE). You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but it is appreciated. A little Thanks! (or something to that affect) would be much appreciated. If you use BEMSimpleLineGraph in your app, let us know.

### Sample App
The iOS Sample App included with this project demonstrates how to correctly setup and use BEMSimpleLineGraph. You can refer to the sample app for an understanding of how to use and setup BEMSimpleLineGraph.

## Setup
BEMSimpleLineGraph can be added to any project (big or small) in a matter of minutes (maybe even seconds if you're super speedy). Cocoapods is fully supported, and so are all the latest technologies (eg. ARC, Storyboards, Interface Builder Attributes, Modules, and more).

### Installation
The easiest way to install BEMSimpleLineGraph is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
	<pre><code>pod BEMSimpleLineGraph</code></pre>
	
The other way to install BEMSimpleLineGraph, is to drag and drop the *Classes* folder into your Xcode project. When you do so, check the "*Copy items into destination group's folder*" box.

####Swift Projects
To use BEMSimpleLineGraph in a Swift project add the following to your bridging header:

    #import "BEMSimpleLineGraph.h"

### Setup
Setting up BEMSimpleLineGraph in your project is simple. If you're familiar with UITableView, then BEMSimpleLineGraph should be a breeze. Follow the steps below to get everything up and running.

 1. Import `"BEMSimpleLineGraphView.h"` to the header of your view controller:

         #import "BEMSimpleLineGraphView.h"

 2. Implement the `BEMSimpleLineGraphDelegate` and `BEMSimpleLineGraphDataSource` in the same view controller:

         @interface YourViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

 3.  BEMSimpleLineGraphView can be initialized in one of two ways. You can either add it directly to your interface (storyboard file) OR through code. Both ways provide the same initialization, just different ways to do the same thing. Use the method that makes sense for your app or project.

     **Interface Initialization**  
     1 - Add a UIView to your UIViewController  
     2 - Change the class type of the UIView to `BEMSimpleLineGraphView`  
     3 - Link the view to your code using an `IBOutlet`. You can set the property to `weak` and `nonatomic`.  
     4 - Select the `BEMSimpleLineGraphView` in your interface. Connect the **dataSource** property and then the **delegate** property to your ViewController.  

     **Code Initialization**  
     Just add the following code to your implementation (usually the `viewDidLoad` method).

         BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
         myGraph.dataSource = self;
         myGraph.delegate = self;
         [self.view addSubview:myGraph];

 4. Implement the two required data source methods: `numberOfPointsInLineGraph:` and `lineGraph:valueForPointAtIndex:`. See documentation below for more information

## Documentation
The essential parts of BEMSimpleLineGraph are documented below. For full documentation, see the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki). If you're using Xcode 5 with BEMSimpleLineGraph, documentation is available directly within Xcode (just Option-Click any method for Quick Help).

### Required Delegate / Data Source Methods

**Number of Points in Graph**  
Returns the number of points in the line graph. The line graph gets the value returned by this method from its data source and caches it.

    - (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    		return X; // Number of points in the graph.
    }

**Value for Point at Index**  
Informs the position of each point on the Y-Axis at a given index. This method is called for every point specified in the `numberOfPointsInLineGraph:` method. The parameter `index` is the position from left to right of the point on the X-Axis:

	- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    		return …; // The value of the point on the Y-Axis for the index.
	}

### Reloading the Data Source
Similar to a UITableView's `reloadData` method, BEMSimpleLineGraph has a `reloadGraph` method. Call this method to reload all the data that is used to construct the graph, including points, axis, index arrays, colors, alphas, and so on. Calling this method will cause the line graph to call `layoutSubviews` on itself. The line graph will also call all of its data source and delegate methods again (to get the updated data).

    - (void)anyMethodInYourOwnController {
        // Change graph properties
        // Update data source / arrays
        
        // Reload the graph
        [self.myGraph reloadGraph];
    }

### Interactive Graph
BEMSimpleLineGraph can react to the user touching the graph by two different ways: **Popup Reporting** and **Touch Reporting**.

<p align="center"><img src="http://s21.postimg.org/3lkbvgp53/GIF_Touch_Report.gif"/></p>
<p align="center"> On this example, both Popup Reporting and Touch Reporting are activated. </p>

### Bezier Curves
<img align="left" width="237" height="141" src="http://s4.postimg.org/ucf4zsyd9/BEMSimple_Line_Graph_Bezier_Curve.png">

BEMSimpleLineGraph can be drawn with curved lines instead of directly connecting the dots with straight lines.  
To do so, set the property `enableBezierCurve` to YES. 

	self.myGraph.enableBezierCurve = YES;
   
### Properties
BEMSimpleLineGraphs can be customized by using various properties. A multitude of properties let you control the animation, colors, and alpha of the graph. Many of these properties can be set from Interface Build and the Attributes Inspector, others must be set in code.