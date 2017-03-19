//
//  MasterViewController.m
//  TestBed2
//
//  Created by Hugh Mackworth on 5/18/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ARFontPickerViewController.h"

//some convenience extensions for setting and reading
@interface UITextField (Numbers)
@property (nonatomic) CGFloat floatValue;
@property (nonatomic) NSUInteger intValue;

@end

@implementation UITextField (Numbers)

-(void) setFloatValue:(CGFloat) num {
    if (num < 0.0) {
        self.text = @"";
    } else if (num >= NSNotFound ) {
            self.text = @"oopsf";
    } else {
        self.text = [NSString stringWithFormat:@"%0.1f",num];
    }
}

-(void) setIntValue:(NSUInteger) num {
    if (num == NSNotFound ) {
        self.text = @"";
    } else if (num == (NSUInteger)-1 ) {
        self.text = @"oops";
    }else {
        self.text = [NSString stringWithFormat:@"%d",(int)num];
    }
}

-(CGFloat) floatValue {
    if (self.text.length ==0) {
        return -1.0;
    } else {
        return (CGFloat) self.text.floatValue;
    }
}

-(NSUInteger) intValue {
    if (self.text.length ==0) {
        return NSNotFound;
    } else {
        return (NSUInteger) self.text.integerValue;
    }

}

@end

@interface UIButton (Switch)
@property (nonatomic) BOOL on;
@end\

@implementation UIButton (Switch)
static NSString * checkOff = @"☐";
static NSString * checkOn = @"☒";

-(void) setOn: (BOOL) on {
    [self setTitle: (on ? checkOn : checkOff) forState:UIControlStateNormal];
}

-(BOOL) on  {
    if (!self.currentTitle) return NO;
    return [checkOff isEqualToString: ( NSString * _Nonnull )self.currentTitle ];
}

@end


@interface MasterViewController () <ARFontPickerViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSDictionary <NSString *, id> *methodList;

@property (strong, nonatomic) IBOutlet UITextField *widthLine;
@property (strong, nonatomic) IBOutlet UITextField *staticPaddingField;
@property (strong, nonatomic) IBOutlet UISwitch *bezierSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *interpolateNullValuesSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *xAxisSwitch;
@property (strong, nonatomic) IBOutlet UITextField *numberOfGapsBetweenLabelsField;
@property (strong, nonatomic) IBOutlet UITextField *baseIndexForXAxisField;
@property (strong, nonatomic) IBOutlet UITextField *incrementIndexForXAxisField;
@property (strong, nonatomic) IBOutlet UISwitch *arrayOfIndicesForXAxis;

@property (strong, nonatomic) IBOutlet UISwitch *yAxisSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *yAxisRightSwitch;
@property (strong, nonatomic) IBOutlet UITextField *minValueField;
@property (strong, nonatomic) IBOutlet UITextField *maxValueField;
@property (strong, nonatomic) IBOutlet UITextField *numberofYAxisField;
@property (strong, nonatomic) IBOutlet UITextField *yAxisPrefixField;
@property (strong, nonatomic) IBOutlet UITextField *yAxisSuffixField;
@property (strong, nonatomic) IBOutlet UITextField *baseValueForYAxis;
@property (strong, nonatomic) IBOutlet UITextField *incrementValueForYAxis;

@property (strong, nonatomic) IBOutlet UISwitch *enableAverageLineSwitch;
@property (strong, nonatomic) IBOutlet UITextField *averageLineTitleField;
@property (strong, nonatomic) IBOutlet UITextField *averageLineWidthField;

@property (strong, nonatomic) IBOutlet UITextField *widthReferenceLinesField;
@property (strong, nonatomic) IBOutlet UISwitch *xRefLinesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *yRefLinesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableReferenceAxisSwitch;
@property (strong, nonatomic) IBOutlet CustomTableViewCell *frameReferenceAxesCell;
@property (strong, nonatomic) IBOutlet UIButton *leftFrameButton;
@property (strong, nonatomic) IBOutlet UIButton *rightFrameButton;
@property (strong, nonatomic) IBOutlet UIButton *topFrameButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomFrameButton;

@property (strong, nonatomic) IBOutlet UISwitch *displayDotsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *displayDotsOnlySwitch;
@property (strong, nonatomic) IBOutlet UITextField *sizePointField;
@property (strong, nonatomic) IBOutlet UISwitch *displayLabelsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *popupReportSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *testDisplayPopupCallBack;
@property (strong, nonatomic) IBOutlet UITextField *labelTextFormat;
@property (strong, nonatomic) IBOutlet UITextField *popupLabelPrefix;
@property (strong, nonatomic) IBOutlet UITextField *poupLabelSuffix;
@property (strong, nonatomic) IBOutlet UISwitch *enableCustomViewSwitch;
@property (strong, nonatomic) IBOutlet UITextField *noDataLabelTextField;
@property (strong, nonatomic) IBOutlet UISwitch *enableNoDataLabelSwitch;

@property (strong, nonatomic) IBOutlet UIButton *animationGraphStyleButton;
@property (strong, nonatomic) IBOutlet UITextField *animationEntranceTime;
@property (strong, nonatomic) IBOutlet UISwitch *dotsWhileAnimateSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *touchReportSwitch;
@property (strong, nonatomic) IBOutlet UITextField *widthTouchInputLineField;

@property (strong, nonatomic) IBOutlet UIButton *fontNameButton;
@property (strong, nonatomic) IBOutlet UITextField *fontSizeField;
@property (strong, nonatomic) IBOutlet UITextField *numberFormatField;


@end

@implementation MasterViewController

static NSString * enableTouchReport = @"enableTouchReport";
static NSString * lineChartPrefix = @"lineChart";

/*-(void) loadDefaults {
    //shorthands
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BEMSimpleLineGraphView * myGraph = self.myGraph;

    NSString * fontName = [defaults stringForKey: @"labelFontName"];
    self.fontSizeField.text = [defaults stringForKey: @"labelFontSize"];
    [self updateFont:fontName];
    //  myGraph.labelFont =  [self fontNamed: fontName ofSize: self.fontSize];
    
    // Set Animation Values
    myGraph.animationGraphEntranceTime = [defaults floatForKey: @"animationGraphEntranceTime"];

//    // Set Color Values
//    myGraph.colorXaxisLabel = [defaults colorForKey: @"colorXaxisLabel"];
//    myGraph.colorYaxisLabel = [defaults colorForKey: @"colorYaxisLabel"];
//    myGraph.colorTop = [defaults colorForKey: @"colorTop"];
//    myGraph.colorLine = [defaults colorForKey: @"colorLine"];
//    myGraph.colorBottom = [defaults colorForKey: @"colorBottom"];
//    myGraph.colorPoint = [defaults colorForKey: @"colorPoint"];
//    myGraph.colorTouchInputLine = [defaults colorForKey: @"colorTouchInputLine"];
//    myGraph.colorBackgroundPopUplabel = [defaults colorForKey: @"colorBackgroundPopUplabel"];
//    myGraph.colorBackgroundYaxis = [defaults colorForKey: @"colorBackgroundYaxis"];
//    myGraph.colorBackgroundXaxis = [defaults colorForKey: @"colorBackgroundXaxis"];
//    myGraph.averageLine.color = [defaults colorForKey: @"averageLine.color"];

    // Set Alpha Values
    myGraph.alphaTop = [defaults floatForKey: @"alphaTop"];
    myGraph.alphaBottom = [defaults floatForKey: @"alphaBottom"];
    myGraph.alphaLine = [defaults floatForKey: @"alphaLine"];
    myGraph.alphaTouchInputLine = [defaults floatForKey: @"alphaTouchInputLine"];
    myGraph.alphaBackgroundXaxis = [defaults floatForKey: @"alphaBackgroundXaxis"];
    myGraph.alphaBackgroundYaxis = [defaults floatForKey: @"alphaBackgroundYaxis"];
    myGraph.averageLine.alpha = [defaults floatForKey: @"alpha"];

    // Set Size Values
    myGraph.widthLine = [defaults floatForKey: @"widthLine"];
    myGraph.widthReferenceLines = [defaults floatForKey: @"widthReferenceLines"];
    myGraph.sizePoint = [defaults floatForKey: @"sizePoint"];
    myGraph.widthTouchInputLine = [defaults floatForKey: @"widthTouchInputLine"];

    // Set Default Feature Values
    myGraph.enableTouchReport = [defaults boolForKey: @"enableTouchReport"];
    myGraph.enablePopUpReport = [defaults boolForKey: @"enablePopUpReport"];
    myGraph.enableBezierCurve = [defaults boolForKey: @"enableBezierCurve"];
    myGraph.enableXAxisLabel = [defaults boolForKey: @"enableXAxisLabel"];
    myGraph.enableYAxisLabel = [defaults boolForKey: @"enableYAxisLabel"];
    myGraph.autoScaleYAxis = [defaults boolForKey: @"autoScaleYAxis"];
    myGraph.alwaysDisplayDots = [defaults boolForKey: @"alwaysDisplayDots"];
    myGraph.alwaysDisplayPopUpLabels = [defaults boolForKey: @"alwaysDisplayPopUpLabels"];
    myGraph.enableLeftReferenceAxisFrameLine = [defaults boolForKey: @"enableLeftReferenceAxisFrameLine"];
    myGraph.enableBottomReferenceAxisFrameLine = [defaults boolForKey: @"enableBottomReferenceAxisFrameLine"];
    myGraph.interpolateNullValues = [defaults boolForKey: @"interpolateNullValues"];
    myGraph.displayDotsOnly = [defaults boolForKey: @"displayDotsOnly"];
    myGraph.displayDotsWhileAnimating = [defaults boolForKey: @"displayDotsWhileAnimating"];

    myGraph.touchReportFingersRequired = [defaults integerForKey: @"touchReportFingersRequired"];
    myGraph.formatStringForValues = [defaults stringForKey: @"formatStringForValues"];

    // Initialize BEM Objects
    //   myGraph.averageLine = [defaults boolForKey: @"averageLine"];
    
    

}


-(void) saveDefaults {
    //shorthands
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BEMSimpleLineGraphView * myGraph = self.myGraph;

    [defaults setObject: self.fontNameButton.titleLabel.text forKey: @"labelFontName"];
    [defaults setObject: self.fontSizeField.text forKey: @"labelFontSize"];

    // Set Animation Values
    [defaults setFloat: myGraph.animationGraphEntranceTime forKey: @"animationGraphEntranceTime"];

//    // Set Color Values
//    [defaults setColor: myGraph.colorXaxisLabel forKey: @"colorXaxisLabel"];
//    [defaults setColor: myGraph.colorYaxisLabel forKey: @"colorYaxisLabel"];
//    [defaults setColor: myGraph.colorTop forKey: @"colorTop"];
//    [defaults setColor: myGraph.colorLine forKey: @"colorLine"];
//    [defaults setColor: myGraph.colorBottom forKey: @"colorBottom"];
//    [defaults setColor: myGraph.colorPoint forKey: @"colorPoint"];
//    [defaults setColor: myGraph.colorTouchInputLine forKey: @"colorTouchInputLine"];
//    [defaults setColor: myGraph.colorBackgroundPopUplabel forKey: @"colorBackgroundPopUplabel"];
//    [defaults setColor: myGraph.colorBackgroundYaxis forKey: @"colorBackgroundYaxis"];
//    [defaults setColor: myGraph.colorBackgroundXaxis forKey: @"colorBackgroundXaxis"];
//    myGraph.averageLine.color = [defaults colorForKey: @"averageLine.color"];

    // Set Alpha Values
    [defaults setFloat: myGraph.alphaTop forKey: @"alphaTop"];
    [defaults setFloat: myGraph.alphaBottom forKey: @"alphaBottom"];
    [defaults setFloat: myGraph.alphaLine forKey: @"alphaLine"];
    [defaults setFloat: myGraph.alphaTouchInputLine forKey: @"alphaTouchInputLine"];
    [defaults setFloat: myGraph.alphaBackgroundXaxis forKey: @"alphaBackgroundXaxis"];
    [defaults setFloat: myGraph.alphaBackgroundYaxis forKey: @"alphaBackgroundYaxis"];
    myGraph.averageLine.alpha = [defaults floatForKey: @"alpha"];

    // Set Size Values
    [defaults setFloat: myGraph.widthLine forKey: @"widthLine"];
    [defaults setFloat: myGraph.widthReferenceLines forKey: @"widthReferenceLines"];
    [defaults setFloat: myGraph.sizePoint forKey: @"sizePoint"];
    [defaults setFloat: myGraph.widthTouchInputLine forKey: @"widthTouchInputLine"];

    // Set Default Feature Values
    [defaults setBool: myGraph.enableTouchReport forKey: @"enableTouchReport"];
    [defaults setBool: myGraph.enablePopUpReport forKey: @"enablePopUpReport"];
    [defaults setBool: myGraph.enableBezierCurve forKey: @"enableBezierCurve"];
    [defaults setBool: myGraph.enableXAxisLabel forKey: @"enableXAxisLabel"];
    [defaults setBool: myGraph.enableYAxisLabel forKey: @"enableYAxisLabel"];
    [defaults setBool: myGraph.autoScaleYAxis forKey: @"autoScaleYAxis"];
    [defaults setBool: myGraph.alwaysDisplayDots forKey: @"alwaysDisplayDots"];
    [defaults setBool: myGraph.alwaysDisplayPopUpLabels forKey: @"alwaysDisplayPopUpLabels"];
    [defaults setBool: myGraph.enableLeftReferenceAxisFrameLine forKey: @"enableLeftReferenceAxisFrameLine"];
    [defaults setBool: myGraph.enableBottomReferenceAxisFrameLine forKey: @"enableBottomReferenceAxisFrameLine"];
    [defaults setBool: myGraph.interpolateNullValues forKey: @"interpolateNullValues"];
    [defaults setBool: myGraph.displayDotsOnly forKey: @"displayDotsOnly"];
    [defaults setBool: myGraph.displayDotsWhileAnimating forKey: @"displayDotsWhileAnimating"];
    //    [defaults setBool: myGraph.averageLine != nil forKey:<#(nonnull NSString *)#>]

    [defaults setInteger: myGraph.touchReportFingersRequired forKey: @"touchReportFingersRequired"];
    [defaults setObject: myGraph.formatStringForValues forKey: @"formatStringForValues"];
}
*/

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];

    #define RestoreProperty(property, type) \
    if ([coder containsValueForKey:@#property]) { \
    self.myGraph.property = [coder decode ## type ##ForKey:@#property ]; \
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullable-to-nonnull-conversion"

    RestoreProperty (labelFont, Object);
    RestoreProperty (animationGraphEntranceTime, Double);
    RestoreProperty (animationGraphStyle, Integer);

    RestoreProperty (colorBottom, Object);
    RestoreProperty (colorTop, Object);
    RestoreProperty (colorLine, Object);
    RestoreProperty (colorReferenceLines, Object);
    RestoreProperty (colorPoint, Object);
    RestoreProperty (colorTouchInputLine, Object);
    RestoreProperty (colorXaxisLabel, Object);
    RestoreProperty (colorYaxisLabel, Object);
    RestoreProperty (colorBackgroundYaxis, Object);
    RestoreProperty (colorBackgroundXaxis, Object);
    RestoreProperty (colorBackgroundPopUplabel, Object);
    RestoreProperty (noDataLabelColor, Object);
    RestoreProperty(noDataLabelFont, Object);
    //Can't handle: gradientBottom, gradientTop, gradientLine
    RestoreProperty (gradientLineDirection, Float);

    RestoreProperty (alphaBottom, Double);
    RestoreProperty (alphaTop, Double);
    RestoreProperty (alphaLine, Double);
    RestoreProperty (alphaTouchInputLine, Double);
    RestoreProperty (alphaBackgroundXaxis, Double);
    RestoreProperty (alphaBackgroundYaxis, Double);

    RestoreProperty (widthLine, Double);
    RestoreProperty (widthReferenceLines, Double);
    RestoreProperty (sizePoint, Double);
    RestoreProperty (widthTouchInputLine, Double);

    RestoreProperty (enableTouchReport, Bool);
    RestoreProperty (enablePopUpReport, Bool);
    RestoreProperty (enableBezierCurve, Bool);
    RestoreProperty (enableXAxisLabel, Bool);
    RestoreProperty (enableYAxisLabel, Bool);
    RestoreProperty (autoScaleYAxis, Bool);
    RestoreProperty (alwaysDisplayDots, Bool);
    RestoreProperty (alwaysDisplayPopUpLabels, Bool);
    RestoreProperty (enableReferenceXAxisLines, Bool);
    RestoreProperty (enableReferenceYAxisLines, Bool);
    RestoreProperty (enableReferenceAxisFrame, Bool);
    RestoreProperty (enableLeftReferenceAxisFrameLine, Bool);
    RestoreProperty (enableBottomReferenceAxisFrameLine, Bool);
    RestoreProperty (enableTopReferenceAxisFrameLine, Bool);
    RestoreProperty (enableRightReferenceAxisFrameLine, Bool);
    [self updateReferenceAxisFrame:self.myGraph.enableReferenceAxisFrame];
    RestoreProperty (interpolateNullValues, Bool);
    RestoreProperty (displayDotsOnly, Bool);
    RestoreProperty (displayDotsWhileAnimating, Bool);

    RestoreProperty (touchReportFingersRequired, Int);
    RestoreProperty (formatStringForValues, Object);
    RestoreProperty (lineDashPatternForReferenceXAxisLines, Object);
    RestoreProperty (lineDashPatternForReferenceYAxisLines, Object);

    if ([coder containsValueForKey:@"averageLine.enableAverageLine"  ]) {
        self.myGraph.averageLine = [[BEMAverageLine alloc] initWithCoder:coder];
        RestoreProperty (averageLine.enableAverageLine, Bool);
        RestoreProperty (averageLine.color, Object);
        RestoreProperty (averageLine.yValue, Double);
        RestoreProperty (averageLine.alpha, Double);
        RestoreProperty (averageLine.width, Double);
        RestoreProperty (averageLine.dashPattern, Object);
        RestoreProperty (averageLine.title, Object);
    }
#define RestoreVCProperty(property, type) \
if ([coder containsValueForKey:@#property]) { \
self.detailViewController.property = [coder decode ## type ##ForKey:@#property ]; \
}
    RestoreVCProperty(popUpText, Object);
    RestoreVCProperty(popUpPrefix, Object);
    RestoreVCProperty(popUpSuffix, Object);
    RestoreVCProperty(testAlwaysDisplayPopup, Bool);
    RestoreVCProperty(maxValue, Double);
    RestoreVCProperty(minValue, Double);
    RestoreVCProperty(noDataLabel, Bool);
    RestoreVCProperty(noDataText, Object);
    RestoreVCProperty(staticPaddingValue, Double);
    RestoreVCProperty(provideCustomView, Bool);
    RestoreVCProperty(numberOfGapsBetweenLabels, Integer);
    RestoreVCProperty(baseIndexForXAxis, Integer);
    RestoreVCProperty(incrementIndexForXAxis, Integer);
    RestoreVCProperty(provideIncrementPositionsForXAxis, Bool);
    RestoreVCProperty(numberOfYAxisLabels, Integer);
    RestoreVCProperty(yAxisPrefix, Object);
    RestoreVCProperty(yAxisSuffix, Object);
    RestoreVCProperty(baseValueForYAxis, Double);
    RestoreVCProperty(incrementValueForYAxis, Double);
}
#pragma clang diagnostic pop

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];

#define EncodeProperty(property, type) [coder encode ## type: self.myGraph.property forKey:@#property]

    if (self.myGraph.labelFont && ![self.myGraph.labelFont isEqual:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]] ) {
        EncodeProperty (labelFont, Object);
    }
    EncodeProperty (animationGraphEntranceTime, Float);
    EncodeProperty (animationGraphStyle, Integer);

    EncodeProperty (colorBottom, Object);
    EncodeProperty (colorTop, Object);
    EncodeProperty (colorLine, Object);
    EncodeProperty (colorReferenceLines, Object);
    EncodeProperty (colorPoint, Object);
    EncodeProperty (colorTouchInputLine, Object);
    EncodeProperty (colorXaxisLabel, Object);
    EncodeProperty (colorYaxisLabel, Object);
    EncodeProperty (colorBackgroundYaxis, Object);
    EncodeProperty (colorBackgroundXaxis, Object);
    EncodeProperty (colorBackgroundPopUplabel, Object);
    EncodeProperty (noDataLabelColor, Object);
    EncodeProperty(noDataLabelFont, Object);
    //Can't handle: gradientBottom, gradientTop, gradientLine
    EncodeProperty (gradientLineDirection, Float);

    EncodeProperty (alphaBottom, Float);
    EncodeProperty (alphaTop, Float);
    EncodeProperty (alphaLine, Float);
    EncodeProperty (alphaTouchInputLine, Float);
    EncodeProperty (alphaBackgroundXaxis, Float);
    EncodeProperty (alphaBackgroundYaxis, Float);

    EncodeProperty (widthLine, Float);
    EncodeProperty (widthReferenceLines, Float);
    EncodeProperty (sizePoint, Float);
    EncodeProperty (widthTouchInputLine, Float);

    EncodeProperty (enableTouchReport, Bool);
    EncodeProperty (enablePopUpReport, Bool);
    EncodeProperty (enableBezierCurve, Bool);
    EncodeProperty (enableXAxisLabel, Bool);
    EncodeProperty (enableYAxisLabel, Bool);
    EncodeProperty (autoScaleYAxis, Bool);
    EncodeProperty (alwaysDisplayDots, Bool);
    EncodeProperty (alwaysDisplayPopUpLabels, Bool);
    EncodeProperty (enableReferenceXAxisLines, Bool);
    EncodeProperty (enableReferenceYAxisLines, Bool);
    EncodeProperty (enableReferenceAxisFrame, Bool);
    EncodeProperty (enableLeftReferenceAxisFrameLine, Bool);
    EncodeProperty (enableBottomReferenceAxisFrameLine, Bool);
    EncodeProperty (enableTopReferenceAxisFrameLine, Bool);
    EncodeProperty (enableRightReferenceAxisFrameLine, Bool);
    EncodeProperty (interpolateNullValues, Bool);
    EncodeProperty (displayDotsOnly, Bool);
    EncodeProperty (displayDotsWhileAnimating, Bool);

    EncodeProperty (touchReportFingersRequired, Integer);
    EncodeProperty (formatStringForValues, Object);
    EncodeProperty (lineDashPatternForReferenceXAxisLines, Object);
    EncodeProperty (lineDashPatternForReferenceYAxisLines, Object);

    if (self.myGraph.averageLine) {
        EncodeProperty (averageLine.enableAverageLine, Bool);
        EncodeProperty (averageLine.color, Object);
        EncodeProperty (averageLine.yValue, Float);
        EncodeProperty (averageLine.alpha, Float);
        EncodeProperty (averageLine.width, Float);
        EncodeProperty (averageLine.dashPattern, Object);
        EncodeProperty (averageLine.title, Object);
    }

#define EncodeVCProperty(property, type) [coder encode ## type: self.detailViewController.property forKey:@#property]

    EncodeVCProperty(popUpText, Object);
    EncodeVCProperty(popUpPrefix, Object);
    EncodeVCProperty(popUpSuffix, Object);
    EncodeVCProperty(testAlwaysDisplayPopup, Bool);
    EncodeVCProperty(maxValue, Float);
    EncodeVCProperty(minValue, Float);
    EncodeVCProperty(noDataLabel, Bool);
    EncodeVCProperty(noDataText, Object);
    EncodeVCProperty(staticPaddingValue, Float);
    EncodeVCProperty(provideCustomView, Bool);
    EncodeVCProperty(numberOfGapsBetweenLabels, Integer);
    EncodeVCProperty(baseIndexForXAxis, Integer);
    EncodeVCProperty(incrementIndexForXAxis, Integer);
    EncodeVCProperty(provideIncrementPositionsForXAxis, Bool);
    EncodeVCProperty(numberOfYAxisLabels, Integer);
    EncodeVCProperty(yAxisPrefix, Object);
    EncodeVCProperty(yAxisSuffix, Object);
    EncodeVCProperty(baseValueForYAxis, Float);
    EncodeVCProperty(incrementValueForYAxis, Float);
    
}

//- (void)saveGraphView{
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.myGraph];
//    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"graphView"];
//}
//
//- (BEMSimpleLineGraphView *)loadGraphView {
//    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"graphView"];
//    BEMSimpleLineGraphView *graphView = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
//    return graphView;
//}
//
CGGradientRef createGradient () {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    CGGradientRef result =  CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGColorSpaceRelease(colorspace);
    return result;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.detailViewController loadViewIfNeeded];
    self.myGraph = self.detailViewController.myGraph;
    if (!self.myGraph.averageLine) {   // Draw an average line
        self.myGraph.averageLine.enableAverageLine = YES;
        self.myGraph.averageLine.alpha = 0.6;
        self.myGraph.averageLine.color = [UIColor darkGrayColor];
        self.myGraph.averageLine.width = 2.5;
        self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
        self.myGraph.averageLine.title = @"Average";
    }
    // Apply the gradient to the bottom portion of the graph
    CGGradientRef gradient = createGradient();
    self.myGraph.gradientBottom = gradient;
    CGGradientRelease(gradient);

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(saveGraphView)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
    self.widthLine.floatValue = self.myGraph.widthLine;
    self.staticPaddingField.floatValue = self.detailViewController.staticPaddingValue;
    self.bezierSwitch.on = self.myGraph.enableBezierCurve;
    self.interpolateNullValuesSwitch.on = self.myGraph.interpolateNullValues;

    self.xAxisSwitch.on = self.myGraph.enableXAxisLabel;
    self.numberOfGapsBetweenLabelsField.intValue = self.detailViewController.numberOfGapsBetweenLabels;
    self.baseIndexForXAxisField.floatValue = self.detailViewController.baseValueForYAxis;
    self.incrementIndexForXAxisField.intValue = self.detailViewController.incrementIndexForXAxis;
    self.arrayOfIndicesForXAxis.on = self.detailViewController.provideIncrementPositionsForXAxis;

    self.yAxisSwitch.on = self.myGraph.enableYAxisLabel;
    self.yAxisRightSwitch.on = self.myGraph.positionYAxisRight;
    self.minValueField.floatValue = self.detailViewController.minValue;
    self.maxValueField.floatValue = self.detailViewController.maxValue;
    self.numberofYAxisField.intValue = self.detailViewController.numberOfYAxisLabels;
    self.yAxisPrefixField.text = self.detailViewController.yAxisPrefix;
    self.yAxisSuffixField.text = self.detailViewController.yAxisSuffix;
    self.baseValueForYAxis.floatValue = self.detailViewController.baseValueForYAxis;
    self.incrementIndexForXAxisField.floatValue = self.detailViewController.incrementValueForYAxis;

    self.enableAverageLineSwitch.on = self.myGraph.averageLine.enableAverageLine;
    self.averageLineTitleField.text = self.myGraph.averageLine.title;
    self.averageLineWidthField.floatValue = self.myGraph.averageLine.width;

    self.widthReferenceLinesField.floatValue = self.myGraph.widthReferenceLines;
    self.xRefLinesSwitch.on = self.myGraph.enableReferenceXAxisLines;
    self.yRefLinesSwitch.on = self.myGraph.enableReferenceYAxisLines;
    self.enableReferenceAxisSwitch.on = self.myGraph.enableReferenceAxisFrame;
    [self updateReferenceAxisFrame:self.myGraph.enableReferenceAxisFrame];
    self.leftFrameButton.on = self.myGraph.enableLeftReferenceAxisFrameLine;
    self.rightFrameButton.on = self.myGraph.enableRightReferenceAxisFrameLine;
    self.topFrameButton.on = self.myGraph.enableTopReferenceAxisFrameLine;
    self.bottomFrameButton.on = self.myGraph.enableBottomReferenceAxisFrameLine;

    self.displayDotsSwitch.on = self.myGraph.alwaysDisplayDots;
    self.displayDotsOnlySwitch.on = self.myGraph.displayDotsOnly;
    self.sizePointField.floatValue = self.myGraph.sizePoint;
    self.popupReportSwitch.on = self.myGraph.enablePopUpReport;
    self.displayLabelsSwitch.on = self.myGraph.alwaysDisplayPopUpLabels;
    self.testDisplayPopupCallBack.on = self.detailViewController.testAlwaysDisplayPopup;
    self.labelTextFormat.text = self.detailViewController.popUpText;
    self.poupLabelSuffix.text = self.detailViewController.popUpSuffix;
    self.popupLabelPrefix.text = self.detailViewController.popUpPrefix;
    self.enableCustomViewSwitch.on  = self.detailViewController.provideCustomView;
    self.enableNoDataLabelSwitch.on = self.detailViewController.noDataLabel;
    self.noDataLabelTextField.text = self.detailViewController.noDataText;

    [self updateAnimationGraphStyle];
    self.animationEntranceTime.floatValue = self.myGraph.animationGraphEntranceTime;
    self.dotsWhileAnimateSwitch.on = self.myGraph.displayDotsWhileAnimating;
    self.touchReportSwitch.on = self.myGraph.enableTouchReport;
    self.widthTouchInputLineField.floatValue = self.myGraph.widthTouchInputLine;

    //    self.fontNameButton = self.myGraph.xx;
    //    self.fontSizeField = self.myGraph.xx;
    self.numberFormatField.text = self.myGraph.formatStringForValues;



}

/* properties/methods not implemented:
     touchReportFingersRequired,
     autoScaleYAxis

 Colors/Gradients

    averageLine: Color/alpha/dashPashpattern
    Top: Color/Alpha/Gradient
    Line: Color/alpha/gradient/gradientLineDirection
    ReferenceLines
    Point: color
    touchInputLine: color/alopha
    XAxis: color/colorBackground, alphaBackground, lineDashPattern
    Yaxis: color/colorBackground, alphaBackground, lineDashPattern
    noDataLabel: color/Font
 */


#pragma mark Main Line
- (IBAction)widthLineDidChange:(UITextField *)sender {
    float value = sender.text.floatValue;
    if (value > 0.0f) {
        self.myGraph.widthLine = sender.text.doubleValue;
    }
    [self.myGraph reloadGraph];
}

- (IBAction)staticPaddingDidChange:(UITextField *)sender {
   self.detailViewController.staticPaddingValue = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}

- (IBAction)enableBezier:(UISwitch *)sender {
    self.myGraph.enableBezierCurve = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)interpolateNullValues:(UISwitch *)sender {
    self.myGraph.interpolateNullValues = sender.on;
    [self.myGraph reloadGraph];
}

#pragma mark Axes and Reference Lines

- (IBAction)enableXAxisLabel:(UISwitch *)sender {
    self.myGraph.enableXAxisLabel = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)numberOfGapsBetweenLabelDidChange:(UITextField *)sender {
    self.detailViewController.numberOfGapsBetweenLabels = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}

- (IBAction)baseIndexForXAxisDidChange:(UITextField *)sender {
    self.detailViewController.baseIndexForXAxis = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}
- (IBAction)incrementIndexForXAxisDidChange:(UITextField *)sender {
    self.detailViewController.incrementIndexForXAxis = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}
- (IBAction)enableArrayOfIndicesForXAxis:(UISwitch *)sender {
    self.detailViewController.provideIncrementPositionsForXAxis = sender.on;
    [self.myGraph reloadGraph];

}

#pragma mark Axes and Reference Lines

- (IBAction)enableYAxisLabel:(UISwitch *)sender {
    self.myGraph.enableYAxisLabel = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)positionYAxisRight:(UISwitch *)sender {
    self.myGraph.positionYAxisRight = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)minValueDidChange:(UITextField *)sender {
    self.detailViewController.minValue = sender.text.doubleValue;
    [self.myGraph reloadGraph];

}

- (IBAction)maxValueDidChange:(UITextField *)sender {
    self.detailViewController.maxValue = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}

- (IBAction)numberofYAxisDidChange:(UITextField *)sender {
    if (sender.text.integerValue <= 0) {
        sender.text = @"1.0";
    }
    self.detailViewController.numberOfYAxisLabels = sender.text.integerValue;
    [self.myGraph reloadGraph];
}

- (IBAction)yAxisPrefixDidChange:(UITextField *)sender {
    self.detailViewController.yAxisPrefix = sender.text;
    [self.myGraph reloadGraph];
}

- (IBAction)yAxisSuffixDidChange:(UITextField *)sender {
    self.detailViewController.yAxisSuffix = sender.text;
    [self.myGraph reloadGraph];
}
- (IBAction)baseValueForYAxisDidChange:(UITextField *)sender {
    self.detailViewController.baseValueForYAxis = sender.text.doubleValue;
    [self.myGraph reloadGraph];

}
- (IBAction)incrementValueForYAxisDidChange:(UITextField *)sender {
    self.detailViewController.incrementValueForYAxis = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}

#pragma mark Average Line
- (IBAction)enableAverageLine:(UISwitch *)sender {
    self.myGraph.averageLine.enableAverageLine = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)averageLineTitleDidChange:(UITextField *)sender {
    self.myGraph.averageLine.title = sender.text;
    [self.myGraph reloadGraph];
}

- (IBAction)averageLineWidthDidChange:(UITextField *)sender {
    if (sender.text.floatValue <= 0) {
        sender.text = @"1.0";
    }
    self.myGraph.averageLine.width = sender.text.doubleValue;
    [self.myGraph reloadGraph];
}

#pragma mark Reference Lines

- (IBAction)widthReferenceLines:(UITextField *)sender {
    if (sender.text.floatValue <= 0) {
        sender.text = @"1.0";
    }
    self.myGraph.widthReferenceLines = (CGFloat) sender.text.doubleValue;
    [self.myGraph reloadGraph];
}

- (IBAction)enableReferenceXAxisLines:(UISwitch *)sender {
    self.myGraph.enableReferenceXAxisLines = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)enableReferenceYAxisLines:(UISwitch *)sender {
    self.myGraph.enableReferenceYAxisLines = sender.on;
    [self.myGraph reloadGraph];
}

-(void) updateReferenceAxisFrame: (BOOL) newState {
    self.myGraph.enableReferenceAxisFrame = newState;
    self.frameReferenceAxesCell.alpha = newState ? 1.0 : 0.5 ;
    self.frameReferenceAxesCell.userInteractionEnabled = newState;
}

- (IBAction)enableReferenceAxisFrame:(UISwitch *)sender {
    [self updateReferenceAxisFrame:sender.on];
    [self.myGraph reloadGraph];
}

- (IBAction)enableLeftReferenceAxisFrameLine:(UIButton *)button {
    BOOL newState = button.on;
    self.myGraph.enableLeftReferenceAxisFrameLine = newState;
    button.on = newState;
    [self.myGraph reloadGraph];
}

- (IBAction)enableRightReferenceAxisFrameLine:(UIButton *)button {
    BOOL newState = button.on;
    self.myGraph.enableRightReferenceAxisFrameLine = newState;
    button.on = newState;
    [self.myGraph reloadGraph];
}

- (IBAction)enableTopReferenceAxisFrameLine:(UIButton *)button {
    BOOL newState = button.on;
    self.myGraph.enableTopReferenceAxisFrameLine = newState;
    button.on = newState;
    [self.myGraph reloadGraph];
}

- (IBAction)enableBottomReferenceAxisFrameLine:(UIButton *)button {
    BOOL newState = button.on;
    self.myGraph.enableBottomReferenceAxisFrameLine = newState;
    button.on = newState;
    [self.myGraph reloadGraph];
}

#pragma mark Dots & Labels section

- (IBAction)alwaysDisplayDots:(UISwitch *)sender {
    self.myGraph.alwaysDisplayDots = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)displayDotsOnly:(UISwitch *)sender {
    self.myGraph.displayDotsOnly = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)sizePointDidChange:(UITextField *)sender {
    if (sender.text.floatValue <= 0) {
        sender.text = @"1.0";
    }
    self.myGraph.sizePoint = (CGFloat) sender.text.floatValue;
    [self.myGraph reloadGraph];
}

- (IBAction)enablePopUpReport:(UISwitch *)sender {
    self.myGraph.enablePopUpReport = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)alwaysDisplayPopUpLabels:(UISwitch *)sender {
    self.myGraph.alwaysDisplayPopUpLabels = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)enableTestDisplayPopups:(UISwitch *)sender {
    self.detailViewController.testAlwaysDisplayPopup = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)labelTextDidChange:(UITextField *)sender {
    self.detailViewController.popUpText = sender.text;
    [self.myGraph reloadGraph];
}

- (IBAction)labelPrefixDidChange:(UITextField *)sender {
    self.detailViewController.popUpPrefix = sender.text;
    [self.myGraph reloadGraph];
}

- (IBAction)labelSuffixDidChange:(UITextField *)sender {
    self.detailViewController.popUpSuffix = sender.text;
    [self.myGraph reloadGraph];
}

- (IBAction)enableCustomView:(UISwitch *)sender {
    self.detailViewController.provideCustomView = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)enableNoDataLabel:(UISwitch *)sender {
    self.detailViewController.noDataLabel = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)noDataLabelTextDidChange:(UITextField *)sender {
    self.detailViewController.noDataText = sender.text;
    [self.myGraph reloadGraph];
}

#pragma mark Animation section
//
//typedef NS_ENUM(NSInteger, BEMLineAnimation) {
//    /// The draw animation draws the lines from left to right and bottom to top.
//    BEMLineAnimationDraw,
//    /// The fade animation fades in the lines from 0% opaque to 100% opaque (based on the \p lineAlpha property).
//    BEMLineAnimationFade,
//    /// The expand animation expands the lines from a small point to their full width (based on the \p lineWidth property).
//    BEMLineAnimationExpand,
//    /// No animation is used to display the graph
//    BEMLineAnimationNone
//};
//
-(void) updateAnimationGraphStyle {
    NSString * newTitle = @"";
    switch (self.myGraph.animationGraphStyle) {
        case BEMLineAnimationDraw:
            newTitle = @"Draw";
            break;
        case BEMLineAnimationFade:
            newTitle = @"Fade";
            break;
        case BEMLineAnimationExpand:
            newTitle = @"Expand";
            break;
        case BEMLineAnimationNone:
            newTitle = @"None";
            break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcovered-switch-default"
        default:
            newTitle = @"N/A";
                break;
#pragma clang diagnostic pop
    }
    [self.animationGraphStyleButton setTitle:newTitle forState:UIControlStateNormal];
}

- (IBAction)animationGraphStyle:(UIButton *)sender {
    if (self.myGraph.animationGraphStyle == BEMLineAnimationNone) {
        self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    } else {
        self.myGraph.animationGraphStyle ++;
    }
    [self updateAnimationGraphStyle];
    [self.myGraph reloadGraph];
}

- (IBAction)animationGraphEntranceTimeDidChange:(UITextField *)sender {
    self.myGraph.animationGraphEntranceTime = (CGFloat) sender.text.floatValue;
    [self.myGraph reloadGraph];
}

- (IBAction)displayDotsWhileAnimating:(UISwitch *)sender {
    self.myGraph.displayDotsWhileAnimating = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)enableTouchReport:(UISwitch *)sender {
    self.myGraph.enableTouchReport = sender.on;
    [self.myGraph reloadGraph];
}

- (IBAction)widthTouchInputLineDidChange:(UITextField *)sender {
    if (sender.text.floatValue <= 0) {
        sender.text = @"1.0";
    }
    self.myGraph.widthTouchInputLine = (CGFloat) sender.text.floatValue;
    [self.myGraph reloadGraph];
}


#pragma mark TextFormatting

- (IBAction)fontFamily:(UIButton *)sender {
    // done in IB: [self performSegueWithIdentifier:@"FontPicker" sender:self];
}

-(void) updateFont: (NSString *) fontName {
    if (!fontName) fontName = self.fontNameButton.titleLabel.text;
    CGFloat fontSize = (CGFloat)self.fontSizeField.text.floatValue;
    if (fontSize < 1.0) fontSize = 14.0;
    UIFont * newFont = nil;
    if ([@"System" isEqualToString:fontName]) {
        newFont = [UIFont systemFontOfSize:fontSize];
    } else {
        newFont = [UIFont fontWithName:fontName size:fontSize];
    }
    if (newFont) {
        self.myGraph.labelFont = newFont;
        self.fontNameButton.titleLabel.font = newFont;
        [self.myGraph reloadGraph];
    }
}

- (void)fontPickerViewController:(ARFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName {
    [fontPicker dismissViewControllerAnimated:YES completion:nil];
    self.fontNameButton.enabled = NO;
    [self.fontNameButton setTitle:fontName forState:UIControlStateNormal];
    self.fontNameButton.enabled = YES;
    [self updateFont: fontName];
}

- (IBAction)fontSizeFieldChanged:(UITextField *)sender {
    [self updateFont:nil];

}

- (IBAction)numberFormatChanged:(UITextField *)sender {
    NSString * newFormat = sender.text ?: @"";
    self.myGraph.formatStringForValues = newFormat;
    [self.myGraph reloadGraph];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    } else if ([[segue identifier] isEqualToString:@"FontPicker"]) {
        ARFontPickerViewController * controller = (ARFontPickerViewController*) [segue destinationViewController];
        controller.delegate = self;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //static sections
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //static cells
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static cells
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark TextDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end

