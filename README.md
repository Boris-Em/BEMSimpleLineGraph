# BEMSimpleLineGraph - Swift Implementation    
Hi there! You've found the Swift branch of BEMSimpleLineGraph. This implementation is **not** currently supported or ready for production use. However, we would appreciate any and all contributions towards this branch.

<p align="center"><img src="https://raw.githubusercontent.com/Boris-Em/BEMSimpleLineGraph/swift/SwiftPreview.png"/></p>

**BEMSimpleLineGraph** is a charting library that makes it easy to create beautiful line graphs for iOS. It is easy to set-up and to use in any iOS Project. It's focused on highly customizable and interactive line graphs. Plus, it is lightweight and can be integrated in minutes (maybe even seconds).

Full documentation of the Objective-C implementation of this project is available on the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki).

## Table of Contents

* [**Project Details**](#project-details)  
    * [Requirements](#requirements)
    * [Sample App](#sample-app)
* [**Contributing**](#contributing)
* [**Getting Started**](#getting-started)
    * [Installation](#installation)
    * [Setup](#setup)
* [**Documentation**](#documentation)
    * [Full documentation (wiki)](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki)
    * [Required Delegate / Data Source Methods](#required-delegate--data-source-methods)
    * [Reloading the Data Source](#reloading-the-data-source) 

## Project Details
Learn more about the **BEMSimpleLineGraph** project requirements, licensing, and contributions.

### Requirements
*The requirements for the Swift implementation are markedly different from the Objective-C implementation (see the master and feature branches for Objective-C). Please refer to the table below to understand exactly what is required.*

| Current Build Target 	| Earliest Supported Build Target 	| Earliest Compatible Build Target |
|:--------------------:	|:-------------------------------:	|:--------------------------------:       |
|       iOS 11.0b4        	|            iOS 10.0             	        |             iOS 9.0              	         |
|     Xcode 9.0b4      	|          Xcode 8.3            	|                     Xcode 8.0                         |
|      LLVM 9.0         	|           LLVM 8.1            	|                     LLVM 8.0                          |
|      Swift Compiler        |           Swift Compiler          |            Swift Compiler                           |
|      Swift v4.0                |           Swift v3.2                  |            Swift v3.2                                  |

> REQUIREMENTS NOTE  
*Supported* means that the library has been tested with this version. *Compatible* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.

### Sample App
Because the implementation of the Swift version of this project is incomplete, a functional sample app is unavailable at this time.

## Contributing
We need help implementing this project in Swift and migrating it over from Objective-C. If you are interested in contributing towards this, please fork this branch of the repository, make changes, and submit pull requests (make sure you submit PRs to *this* branch, **not** the master or feature branch).

Key differences between the current implementation and the Objective-C implementation:  
- All Swift classes are suffixed with `_Swift` to avoid compatibility issues (until the Swift implementation is usable)
- Some objects, which were defined as `classes` in Objective-C are now defined, more appropriately, as Swift `structs`
- Most values have been transitioned over to Swift types (i.e. `Int`, `Float`, `String`, etc.). Remaining Objective-C types are for compatibility purposes.
- Some new classes and structs have been created (spun-off) in order to develop a better development structure / model

Here's what's left to do:  
- [x] Transition `BEMLine` and refactor key properties and components
- [ ] Refactor some internal `BEMLine` functions  
- [x] Spin-off and rewrite `BEMAverageLine` as a `struct`  
- [x] Transition `BEMCircle`  
- [ ] Refactor `BEMCircle` as a `struct`  
- [x] Transition `BEMPermanentPopupView` and `BEMPermanentPopupLabel`  
- [x] Transition `BEMGraphCalculator` and refactor some internal calculation functions  
- [ ] Transition `BEMSimpleLineGraphView` and refactor some components by spinning off into separate `classes` and `structs`  
 
## Getting Started
*See the full article on the wiki [here](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki/Getting-Started).*

**BEMSimpleLineGraph** can be added to any project (big or small) in a matter of minutes (maybe even seconds if you're super speedy). CocoaPods is fully supported, and so are all the latest technologies (eg. ARC, Storyboards, Interface Builder Attributes, Modules, and more).

### Installation
CocoaPods is not currently supported on this branch. Please do a manual install until CocoaPods becomes available.
	
 1. Drag and drop the *Swift Implementation* and *Objective-C Implementation* folder into your Xcode project. When you do so, check the "*Copy items into destination group's folder*" box.  
 2. A Bridging header is included by default in the *Swift Implementation* folder because not all content has been implemented in Swift and thus Objective-C is still needed. You can either add the import statements from the bridging header to your own bridging header, or set the included one as your project's bridging header.

#### Swift Projects
To use **BEMSimpleLineGraph** in a Swift project add the following to your bridging header:

    #import "BEMSimpleLineGraphView.h"
    
Although a good chunk of the project has been implemented in Swift, the core of it has not - thus Objective-C is still required.

### Setup
Setting up **BEMSimpleLineGraph** in your project is simple. If you're familiar with UITableView, then **BEMSimpleLineGraph** should be a breeze. Follow the steps below to get everything up and running.

 1. Import `"BEMSimpleLineGraphView.h"` to the header of your view controller:

         // Objective-C
         #import "BEMSimpleLineGraphView.h"
         
         // Swift
         // No import necessary

 2. Implement `BEMSimpleLineGraphDelegate` and `BEMSimpleLineGraphDataSource` in the same view controller:

         // Objective-C
         @interface YourViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
         
         // Swift
         class YourViewController : UIViewController, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate

 3.  BEMSimpleLineGraphView can be initialized in one of two ways. You can either add it directly to your interface (storyboard file) OR through code. Both ways provide the same initialization, just different ways to do the same thing. Use the method that makes sense for your app or project.

     **Interface Initialization**  
     1 - Add a UIView to your UIViewController  
     2 - Change the class type of the UIView to `BEMSimpleLineGraphView`  
     3 - Link the view to your code using an `IBOutlet`. You can set the property to `weak` (and `nonatomic` in Objective-C).  
     4 - Select the `BEMSimpleLineGraphView` in your interface. Connect the **dataSource** property and then the **delegate** property to your ViewController.  
     5 - Select the `BEMSimpleLineGraphView` and open the Attributes Inspector. Most of the line graph's customizable properties can easily be set from the Attributes Inspector. The Sample App demonstrates this capability. Note that graph data will not be loaded in Interface Builder.  

     **Code Initialization**  
     Just add the following code to your implementation (usually the `viewDidLoad` method).

         // Objective-C
         BEMSimpleLineGraphView *graph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
         graph.dataSource = self;
         graph.delegate = self;
         [self.view addSubview:graph];
         
         // Swift
         let graph = BEMSimpleLineGraphView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 200))
         graph.dataSource = self
         graph.delegate = self
         view.addSubview(graph)

 4. Implement the two required data source methods: `numberOfPointsInLineGraph:` and `lineGraph:valueForPointAtIndex:`. See documentation below for more information

## Documentation
The essential parts of **BEMSimpleLineGraph** are documented below. For full Objective-C documentation, see the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki). Documentation is also available directly within Xcode (just Option-Click any method for Quick Help).

### Required Delegate / Data Source Methods

**Number of Points in Graph**  
Returns the number of points in the line graph. The line graph gets the value returned by this method from its data source and caches it.

    // Objective-C
    - (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    		return X; // Number of points in the graph.
    }
    
    // Swift
    func numberOfPoints(inLineGraph graph: BEMSimpleLineGraphView) -> UInt {
        return 5
    }

**Value for Point at Index**  
Informs the position of each point on the Y-Axis at a given index. This method is called for every point specified in the `numberOfPointsInLineGraph:` method. The parameter `index` is the position from left to right of the point on the X-Axis:

    // Objective-C
    - (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
        return ...; // The value of the point on the Y-Axis for the index.
    }
    
    // Swift
    let dataSource = [5, 16, 8, 3, 10]
    func lineGraph(_ graph: BEMSimpleLineGraphView, valueForPointAt index: UInt) -> CGFloat {
        return CGFloat(dataSource[Int(index)])
    }

### Reloading the Data Source
Similar to a UITableView's `reloadData` method, BEMSimpleLineGraph has a `reloadGraph` method. Call this method to reload all the data that is used to construct the graph, including points, axis, index arrays, colors, alphas, and so on. Calling this method will cause the line graph to call `layoutSubviews` on itself. The line graph will also call all of its data source and delegate methods again (to get the updated data).

    // Objective-C
    [self.graph reloadGraph];
    
    // Swift
    graph.reloadGraph()

