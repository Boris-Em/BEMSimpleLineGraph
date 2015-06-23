# BEMSimpleLineGraph    
[![Build Status](https://travis-ci.org/Boris-Em/BEMSimpleLineGraph.svg?branch=master)](https://travis-ci.org/Boris-Em/BEMSimpleLineGraph)
[![Version](https://img.shields.io/cocoapods/v/BEMSimpleLineGraph.svg?style=flat)](http://cocoadocs.org/docsets/BEMSimpleLineGraph)
[![License](https://img.shields.io/cocoapods/l/BEMSimpleLineGraph.svg?style=flat)](http://cocoadocs.org/docsets/BEMSimpleLineGraph)
[![Platform](https://img.shields.io/cocoapods/p/BEMSimpleLineGraph.svg?style=flat)](http://cocoadocs.org/docsets/BEMSimpleLineGraph)
<p align = right><a target="_blank" href="https://twitter.com/intent/tweet?hashtags=iosdev&original_referer=https%3A%2F%2Fabout.twitter.com%2Fresources%2Fbuttons&text=BEMSimpleLineGraph,%20beautiful%20graphs%20for%20iOS!%20Open%20Source%20Library%20on%20GitHub&tw_p=tweetbutton&url=http%3A%2F%2Fgoo.gl%2FzgB6GL&via=Boris_Em"><img src="http://s30.postimg.org/j2q6ql27h/Tweet.png"></a>
<a target="_blank" href="https://twitter.com/Boris_Em"> <img src="http://s29.postimg.org/avb82kvv7/Follow_Twitter.png"></a>
</p>
<p align="center"><img src="http://s27.postimg.org/txboc1peb/BEMSimple_Line_Graph_Main.png"/></p>	

<p align="center">
<b>BEMSimpleLineGraph</b> makes it easy to create and customize line graphs for iOS.
</p>

**BEMSimpleLineGraph** is a charting library that makes it easy to create beautiful line graphs for iOS. It is easy to set-up and to use in any iOS Project. It's focused on highly customizable and interactive line graphs. Plus, it is lightweight and can be integrated in minutes (maybe even seconds). 

**BEMSimpleLineGraph's** implementation, data source, and delegate are all modeled off of UITableView and UICollectionView. If you're familiar with using a UITableView, UITableViewController, or UICollectionView, using BEMSimpleLineGraph should be a breeze!

The full documentation of the project is available on its [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki).

## Table of Contents

* [**Project Details**](#project-details)  
    * [Requirements](#requirements)
    * [License](#license)
    * [Support](#support)
    * [Sample App](#sample-app)
    * [Apps Using This Project](#apps-using-this-project)
* [**Getting Started**](#getting-started)
    * [Installation](#installation)
    * [Setup](#setup)
* [**Documentation**](#documentation)
    * [Full documentation (wiki)](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki)
    * [Required Delegate / Data Source Methods](#required-delegate--data-source-methods)
    * [Reloading the Data Source](#reloading-the-data-source) 
    * [Bezier Curves](#bezier-curves)
    * [Interactive Graph](#interactive-graph)
    * [Properties](#properties)

## Project Details
Learn more about the **BEMSimpleLineGraph** project requirements, licensing, and contributions.

### Requirements
*See the full article on the wiki [here](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Requirements).*

- Requires iOS 7 or later. The sample project is optimized for iOS 8.
- Requires Automatic Reference Counting (ARC).
- Optimized for ARM64 Architecture

Requires Xcode 6 for use in any iOS Project. Requires a minimum of iOS 7.0 as the deployment target. 

| Current Build Target 	| Earliest Supported Build Target 	| Earliest Compatible Build Target 	|
|:--------------------:	|:-------------------------------:	|:--------------------------------:	|
|       iOS 8.0        	|            iOS 7.0             	|             iOS 6.1              	|
|     Xcode 6.3      	|          Xcode 6.1.1            	|           Xcode 6.0            	|
|      LLVM 6.1        	|             LLVM 6.1            	|             LLVM 5.0             	|

> REQUIREMENTS NOTE  
*Supported* means that the library has been tested with this version. *Compatible* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.

### License
See the [License](https://github.com/Boris-Em/BEMSimpleLineGraph/blob/master/LICENSE). You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but it is appreciated. A little Thanks! (or something to that affect) would be much appreciated. If you use BEMSimpleLineGraph in your app, let us know.

###Support
[![Gitter chat](https://badges.gitter.im/Boris-Em/BEMSimpleLineGraph.png)](https://gitter.im/Boris-Em/BEMSimpleLineGraph)  
Join us on [Gitter](https://gitter.im/Boris-Em/BEMSimpleLineGraph) if you need any help or want to talk about the project.

Ask questions and get answers from a massive community or programmers on StackOverflow when you use the [BEMSimpleLineGraph tag](http://stackoverflow.com/questions/tagged/bemsimplelinegraph).

### Sample App
The iOS Sample App included with this project demonstrates how to correctly setup and use BEMSimpleLineGraph. You can refer to the sample app for an understanding of how to use and setup BEMSimpleLineGraph.

### Apps Using This Project
Dozens of production apps available on the iOS App Store use **BEMSimpleLineGraph**. You can view a full list of the [known App Store apps using this project on the wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Apps-Using-This-Project), read their descriptions, get links, pricing, featured status, and screenshots of graph usage.

Add your **BEMSimpleLineGraph** app to the wiki page for a chance to get showcased in the Readme and / or the wiki. We can't wait to see what you create with **BEMSimpleLineGraph**.

## Getting Started
*See the full article on the wiki [here](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Getting-Started).*

**BEMSimpleLineGraph** can be added to any project (big or small) in a matter of minutes (maybe even seconds if you're super speedy). Cocoapods is fully supported, and so are all the latest technologies (eg. ARC, Storyboards, Interface Builder Attributes, Modules, and more).

### Installation
The easiest way to install BEMSimpleLineGraph is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
	<pre><code>pod 'BEMSimpleLineGraph'</code></pre>
	
The other way to install **BEMSimpleLineGraph**, is to drag and drop the *Classes* folder into your Xcode project. When you do so, check the "*Copy items into destination group's folder*" box.

####Swift Projects
To use **BEMSimpleLineGraph** in a Swift project add the following to your bridging header:

    #import "BEMSimpleLineGraphView.h"

### Setup
Setting up **BEMSimpleLineGraph** in your project is simple. If you're familiar with UITableView, then **BEMSimpleLineGraph **should be a breeze. Follow the steps below to get everything up and running.

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
     5 - Select the `BEMSimpleLineGraphView` and open the Attributes Inspector. Most of the line graph's customizable properties can easily be set from the Attributes Inspector. The Sample App demonstrates this capability. Note that graph data will not be loaded in Interface Builder.  

     **Code Initialization**  
     Just add the following code to your implementation (usually the `viewDidLoad` method).

         BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
         myGraph.dataSource = self;
         myGraph.delegate = self;
         [self.view addSubview:myGraph];

 4. Implement the two required data source methods: `numberOfPointsInLineGraph:` and `lineGraph:valueForPointAtIndex:`. See documentation below for more information

## Documentation
The essential parts of **BEMSimpleLineGraph** are documented below. For full documentation, see the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki). Documentation is available directly within Xcode (just Option-Click any method for Quick Help).

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
**BEMSimpleLineGraph** can react to the user touching the graph by two different ways: **Popup Reporting** and **Touch Reporting**.

<p align="center"><img src="http://s21.postimg.org/3lkbvgp53/GIF_Touch_Report.gif"/></p>
<p align="center"> On this example, both Popup Reporting and Touch Reporting are activated. </p>

### Bezier Curves
<img align="left" width="237" height="141" src="http://s4.postimg.org/ucf4zsyd9/BEMSimple_Line_Graph_Bezier_Curve.png">

**BEMSimpleLineGraph** can be drawn with curved lines instead of directly connecting the dots with straight lines.  
To do so, set the property `enableBezierCurve` to YES. 

	self.myGraph.enableBezierCurve = YES;
   
### Properties
**BEMSimpleLineGraphs** can be customized by using various properties. A multitude of properties let you control the animation, colors, and alpha of the graph. Many of these properties can be set from Interface Build and the Attributes Inspector, others must be set in code.

## Contributing
To contribute to **BEMSimpleLineGraph** please see the `CONTRIBUTING.md` file, which lays out exactly how you can contribute to this project.
