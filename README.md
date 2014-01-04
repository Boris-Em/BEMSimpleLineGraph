# BEMSimpleLineGraph

<p align="center"><img src="http://img843.imageshack.us/img843/3821/ru8f.png"/></p>	

<p align="center">
<b>BEMSimpleLineGraph</b> makes it easy to create and customize line graphs for iOS.
</p>

## Requirements

- Requires iOS 6 or later. (The sample project is optimized for iOS 7.)
- Requires Automatic Reference Counting (ARC).

## Installation

To install BEMSimpleLineGraph to your project, just drag and drop the *BEMSimpleLineGraph* folder into your Xcode project. When you do so, make sure to check the box *'Copy items into destination group's folder (if needed)'*.

## Usage

#### 1. Import the header

First, import `"BEMSimpleLineGraphView.h"` to the .h of your view controller:

	#import "BEMSimpleLineGraphView.h"

#### 2. Implement the delegate
    
Implement the `BEMSimpleLineGraphDelegate` to the same view controller:

	@interface YourViewController : UIViewController <BEMSimpleLineGraphDelegate>

#### 3. Initialize BEMSimpleLineGraphView

BEMSimpleLineGraphView can be initialized in one of two ways. You can either add it directly to your interface (storyboard file) OR through code. Both ways provide the same initialization, just different ways to do the same thing. Use the method that makes sense for your app or project.

**Interface Initialization**  
Add a UIView to your UIViewController. Change the class type of the UIView to `BEMSimpleLineGraphView`. Link the view to your code using an `IBOutlet`. You can set the property to `weak` and `nonatomic`. Then set the delegate in your code:

    myGraph.delegate = self;

**Code Initialization**  
Initialize a BEMSimpleLineGraph view with the following code:

	BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	myGraph.delegate = self;
	[self.view addSubview:myGraph];

#### 4. Implement the two required methods.

Finally, you need to implement these two required methods:

1 - Informs how many points are in the graph:

	- (int)numberOfPointsInGraph {
    		return …; // Number of points in the graph.
	}

2 - Informs the position of each point on the Y-Axis at a given index. This method is called for every point specifed in the `numberOfPointsInGraph` method. The parameter `index` is the position from left to right of the point on the X-Axis:

	- (float)valueForIndex:(NSInteger)index {
    		return …; // The value of the point on the Y-Axis for the index.
	}

## Customization

### Enable touch report

BEMSimpleLineGraph makes it possible to react to the user touching the graph.

To do so, first toggle the property <i> enableTouchReport </i>:

	self.myGraph.enableTouchReport = YES;

Next, implement the two following methods:

1 - This method gets called when the user touches the graph. The parameter `index` is the closest index (X-Axis) from the user's finger position.

	- (void)didTouchGraphWhithClosestIndex:(int)index {
		// Here you could change the text of a UILabel with the value of the closest index for example.
	}

2 - This method gets called when the user stops touching the graph. The parameter `index` is the closest index (X-Axis) from the user's last finger position.

	- (void)didReleaseGraphWithClosestIndex:(float)index {
		// Set the UIlabel alpha to 0 for example.
	}

<p align="center"><img src="http://img30.imageshack.us/img30/4479/gt3s.png"/></p>
<p align="center">
When the user touches and moves his finger along the graph, the labels on top of the graph indicate the value of the closest point.
</p>

### Enable Labels on X-Axis

BEMSimpleLineGraph makes it possible to add labels along the X-Axis.

To do so, simply implement the two followings methods:

1 - Informs how much empty space is needed between each displayed label. Returning 0 will display all of the labels. Returning the total number of labels will only display the first and last label. <i> (See the image bellow for clarification.) </i>

	- (int)numberOfGapsBetweenLabels {
		return …; // The number of hidden labels between each displayed label.
	}

2 - The text to be displayed for each UILabel on the X-Axis at a given index. Please note that it should return as many strings as the number of points on the graph.

	- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
		return …; // 
	}

The property `colorXaxisLabel` controls the color of the text of the UILabels on the X-Axis:

	@property (strong, nonatomic) UIColor *colorXaxisLabel;


<p align="center"><img src="http://img838.imageshack.us/img838/9329/tz01.png"/></p>	

<p align="center">
On the left, `numberOfGapsBetweenLabels` returns 0, on the middle it returns 1 and on the right it returns the number of points in the graph.
</p>

### Properties

#### Entrance animation.

The following property controls the speed of the entrance animation.
A value of 0 will disable the animation.
A value of 1 will make the animation very slow.
A value of 10 or more will make it fast.

	@property (nonatomic) NSInteger animationGraphEntranceSpeed;

<p align="center"><img src="http://img819.imageshack.us/img819/4290/3vs.gif"/></p>

#### Custom colors & alpha.

The two following properties control the color and alpha of the top part of the graph:

	@property (strong, nonatomic) UIColor *colorTop;

	@property (nonatomic) float alphaTop;


The two following properties control the color and alpha of the bottom part of the graph:

	@property (strong, nonatomic) UIColor *colorBottom;

	@property (nonatomic) float alphaBottom;

The two following properties control the color and alpha of the line of the graph:

	@property (strong, nonatomic) UIColor *colorLine;

	@property (nonatomic) float alphaLine;

## License

See <a href="https://github.com/Boris-Em/BEMSimpleLineGraph/blob/master/LICENSE.md" target="_blank">License</a>.
