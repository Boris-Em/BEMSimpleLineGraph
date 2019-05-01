//
//  BEMGraph.swift
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 4/30/19.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2019 Sam Spencer.
//

import CoreGraphics
import Foundation
import UIKit

var BEMNullGraphValue: CGFloat {
    get {
        return 0
    }
}

fileprivate let NullLineGraphValue: CGFloat = CGFloat.greatestFiniteMagnitude
fileprivate enum BEMInternalTags : Int {
    case dotFirstTag100 = 100
}

public enum GraphError: Error {
    case dataSourceInvalid(String)
}

/// Simple line graph / chart UIView subclass for iOS apps. Creates beautiful line graphs (without huge memory impacts) using QuartzCore.
@IBDesignable public class LineGraph: UIView, UIGestureRecognizerDelegate { // TODO: Codable Conformance
    
    /** The object that acts as the delegate of the receiving line graph.
     
     The delegate must adopt the `LineGraphDelegate` protocol.
     
     The LineGraph delegate object plays a key role in changing the appearance of the graph and receiving graph events. Use the delegate to provide appearance changes, receive touch events, and receive graph events. */
    public var delegate: LineGraphDelegate?
    
    /** The object that acts as the data source of the receiving line graph.
     
     The data source must adopt the `LineGraphDataSource` protocol. The data source is not retained. The LineGraph data source object is essential to the line graph. Use the data source to provide the graph with data (data points and x-axis labels). */
    public var dataSource: LineGraphDataSource?
    
    /// The graph's label font used on various axis.
    public var labelFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    
    /// Time of the animation when the graph appears in seconds.
    public var animationGraphEntranceTime: TimeInterval = 1.5
    
    /** Animation style used when the graph appears.
     - seealso: Refer to `LineAnimation` for a complete list of animation styles. */
    public var animationGraphStyle: LineAnimation = .draw { 
        didSet {
            switch animationGraphStyle {
            case .none:
                animationGraphEntranceTime = 0
            default:
                break
            }
        }
    }
    
    public var interactionGuide = InteractiveGuide()
    public struct InteractiveGuide {
        /// If set to true, the graph will report the value of the closest point from the user current touch location.
        public var touchReportEnabled = false
        
        /** The number of fingers required to report touches to the graph's delegate?. The default value is 1.
         Setting this value to greater than 1 might be beneficial in interfaces that allow the graph to scroll and still want to use touch reporting. */
        public var touchReportFingersRequired: Int = 1 {
            didSet {
                if touchReportFingersRequired <= 0 {
                    touchReportFingersRequired = 0
                    touchReportEnabled = false
                } else {
                    touchReportEnabled = true
                }
            }
        }
        
        public var touchReportLine = TouchReportLine()
        public struct TouchReportLine {
            fileprivate var view: UIView = UIView.init()
            
            /// The color of the line that appears when the user touches the graph.
            public var color: UIColor = .white
            
            /// The alpha of the line that appears when the user touches the graph.
            public var alpha: CGFloat = 0.3
            
            /// The width of the line that appears when the user touches the graph.
            public var width: CGFloat = 1.0
        }
        
        /// If set to true, a label will pop up on the graph when the user touches it. It will be displayed on top of the closest point from the user current touch location. Default value is false.
        public var popupsEnabled = false
        
        /// If set to true, pop up labels with the Y-value of the point will always be visible. Default value is false.
        public var popupsDisplayPersistently = false
        
        /// Color of the popup label's background displayed when the user touches the graph.
        public var popupsBackgroundColor: UIColor = .white
        
        /// The gesture recognizer picking up the pan in the graph view
        fileprivate var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer.init()
        fileprivate var panView: UIView = UIView.init()
        
        /// This gesture recognizer picks up the initial touch on the graph view
        fileprivate var longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init()
        
        /// The label displayed when enablePopUpReport is set to YES
        fileprivate var popupLabel: UILabel = UILabel.init()
        
        fileprivate var permanentPopups: [UILabel] = []
        
        /// Possible custom View displayed instead of popupLabel
        public var customPopupView: LineGraphPopupView = LineGraphPopupView.init()
    }
    
    /// Line fill style
    public var fill: FillType = .solid
    
    /// Gradient of the top part of the graph (between the line and the X-axis).
    var gradientTop: CGGradient?
    
    /// Gradient of the bottom part of the graph (between the line and the X-axis).
    var gradientBottom: CGGradient?
    
    /// Color of the bottom part of the graph (between the line and the X-axis).
    @IBInspectable var colorBottom: UIColor = .white
    
    /// Alpha of the bottom part of the graph (between the line and the X-axis).
    @IBInspectable var alphaBottom: CGFloat = 1.0
    
    /// Color of the top part of the graph (between the line and the top of the view the graph is drawn in).
    @IBInspectable var colorTop: UIColor = .white
    
    /// Alpha of the top part of the graph (between the line and the top of the view the graph is drawn in).
    @IBInspectable var alphaTop: CGFloat = 1.0
    
    /// Label to display when there is no data
    private var noDataLabel: UILabel = UILabel.init()
    
    /// Color to be used for the no data label on the chart
    public var noDataLabelColor: UIColor = .black
    
    /// Font to be used for the no data label on the chart
    public var noDataLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    
    /// Float format string to be used when formatting popover and y axis values
    public var formatStringForValues = ""
    
    /// If a null value is present, interpolation would draw a best fit line through the null point bound by its surrounding points.
    public var interpolateNullValues = true
    
    private var numberOfPoints: Int = 0
    
    public var graphValuesForDataPoints: [NSNumber] {
        get {
            return points.data
        }
    }
    
    // MARK: - Properties
    
    public struct Points {
        /// All of the data points
        fileprivate var data: [NSNumber] = []
        
        /// All of the view objects representing data points
        fileprivate var views: [BEMCircle] = []
        
        /// Cirle to display when there's only one datapoint
        fileprivate var oneDot: BEMCircle?
        
        /// If set to true, the views representing the points on the graph will always be visible. Default value is false.
        public var displayPersistently = false
        
        /// When set to true, points will be drawn during animation. If false, points won't show up for the animation as long as displayPersistently is false. Default value is true.
        public var displayWhileAnimating = true
        
        /// The diameter of the circles in points (screen dimension) that represent each data point. Default is 10 points.
        public var diameter: CGFloat = 10 {
            didSet {
                if diameter < 0 {
                    diameter = abs(diameter)
                }
            }
        }
        
        /// The color of the circles that represent each point. Default is white at 70% alpha.
        var color: UIColor = UIColor.init(white: 1, alpha: 0.7)
    }
    
    public enum LineType {
        case bezierCurve
        case linear
        case dot
    }
    
    public enum FillType {
        case gradient
        case solid
    }
    
    public struct Line {
        /// The line itself
        fileprivate var master: BEMLine = BEMLine.init() {
            didSet {
                master.setNeedsDisplay()
            }
        }
        
        /// The style the line shopuld adopt when drawing
        public var lineType: LineType = .bezierCurve
        
        /// Line fill style
        public var fill: FillType = .solid
        
        /// Fill gradient of the line of the graph, which will be scaled to the length of the graph
        public var gradient: CGGradient?
        
        /// Drawing direction of the line gradient color
        public var gradientDirection: LineGradientDirection = .horizontal
        
        /// Color of the line
        public var color: UIColor = .white
        
        /// Alpha of the line
        public var alpha: CGFloat = 1 {
            didSet {
                if alpha > 1 {
                    alpha = 1
                } else if alpha < 0 {
                    alpha = 0
                }
            }
        }
        
        /// Width of the line
        public var width: CGFloat = 1 {
            didSet {
                if width < 0 {
                    width = abs(width)
                }
            }
        }
    }
    
    public struct Axis {
        public var labels = Labels()
        public struct Labels {
            /// Determines whether or not labels should be enabled on the Y-Axis
            public var areEnabled: Bool = false
            
            /// All of the Y-Axis labels representing graph deliniation points
            fileprivate var labels: [UILabel] = []
            
            /// All of the Y-Axis strings representing graph deliniation points
            fileprivate var strings: [String] = []
            
            /// All of points at which a string appears on the graph marking a segement
            fileprivate var labelPoints: [NSNumber] = []
            
            /// Color of the label's text displayed on the X-Axis. Defaut value is black.
            public var color: UIColor = .black
        }
        
        public var background = Background()
        public struct Background {
            fileprivate var view: UIView = UIView.init()
            public var color: UIColor = .white
            public var alpha: CGFloat = 1 {
                didSet {
                    if alpha > 1 {
                        alpha = 1
                    } else if alpha < 0 {
                        alpha = 0
                    }
                }
            }
        }
        
        /// Draws a translucent vertical lines along the graph for each value when set to true. Default value is false.
        public var enableReferenceLine = false
        
        /// A line dash pattern to be applied to axis reference lines. This allows you to draw a dotted or hashed line
        public var referenceLineDashPattern: [NSNumber] = []
        
        fileprivate var labelOffset: CGFloat = 0.0
    }
    
    public struct ReferenceLines {
        /// Draws a translucent frame between the graph and any enabled axis, when set to a non-empty array
        public var allowedFramePositions: [SquarePositioning] = [.left, .bottom]
        
        /// Color of the reference lines
        public var color: UIColor = .white
        
        /// Width of the reference lines
        public var width: CGFloat = 0.5 {
            didSet {
                if width < 0 {
                    width = abs(width)
                }
            }
        }
    }
    
    public enum SquarePositioning {
        case top
        case bottom
        case left
        case right
        case none
    }
    
    public enum DiametricPositioning {
        case left
        case right
    }
    
    public var points: Points = Points()
    public var line: Line = Line()
    public var xAxis: Axis = Axis()
    public var yAxis: Axis = Axis()
    public var referenceLines: ReferenceLines = ReferenceLines()
    
    /// The horizontal line across the graph at the average value.
    public var averageLine: BEMAverageLine = BEMAverageLine.init()
    
    /// Position of the y-Axis in relation to the chart
    public var yAxisPosition: DiametricPositioning = .left
    
    /// What the hell is this?
    private var xAxisHorizontalFringeNegationValue: CGFloat = 0.0
    
    /// Stores the current view size to detect whether a redraw is needed in layoutSubviews
    private var currentViewSize = CGSize.zero
    
    /// Find which point is currently the closest to the vertical line
    private func closestDot(fromTouchInputLine touchInputLine: UIView) -> BEMCircle {
        var closestDot: BEMCircle = BEMCircle.init()
        var currentlyCloser = CGFloat.greatestFiniteMagnitude
        for point in points.views {
            if point.superview == nil {
                continue
            }
            if points.displayPersistently == false && line.lineType != .dot {
                point.alpha = 0
            }
            let distance = CGFloat(fabs(point.center.x - interactionGuide.touchReportLine.view.center.x))
            if distance < currentlyCloser {
                currentlyCloser = distance
                closestDot = point
            }
        }
        return closestDot
    }
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func drawGraph() {
        // Let the delegate know that the graph began layout updates
        delegate?.lineGraphDidBeginLoading(self)
        
        // Get the number of points in the graph
        layoutNumberOfPoints()
        if numberOfPoints <= 1 {
            return
        } else {
            // Draw the graph
            drawEntireGraph()
            
            // Setup the touch report
            layoutTouchReport()
            
            // Let the delegate know that the graph finished updates
            delegate?.lineGraphDidFinishLoading(self)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if currentViewSize.equalTo(bounds.size) {
            return
        }
        currentViewSize = bounds.size
        drawGraph()
    }
    
    func clearGraph() {
        for subvView in subviews {
            subvView.removeFromSuperview()
        }
    }
    
    func layoutNumberOfPoints() {
        // Get the total number of data points from the delegate
        #if !TARGET_INTERFACE_BUILDER
        numberOfPoints = dataSource?.numberOfPoints(inLineGraph: self) ?? 0
        #else
        numberOfPoints = 10
        #endif
        noDataLabel.removeFromSuperview()
        points.oneDot?.removeFromSuperview()
        if numberOfPoints == 0 {
            // There are no points to load
            clearGraph()
            guard let noDataText = delegate?.noDataLabelText(forLineGraph: self) else {
                return
            }
            
            print("[LineGraph] Data source contains no data. A no data label will be displayed and drawing will stop. Add data to the data source and then reload the graph.")
            noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: forFirstBaselineLayout.frame.size.width, height: forFirstBaselineLayout.frame.size.height))
            noDataLabel.backgroundColor = UIColor.clear
            noDataLabel.textAlignment = .center
            noDataLabel.text = noDataText
            noDataLabel.font = noDataLabelFont 
            noDataLabel.textColor = noDataLabelColor 
            forFirstBaselineLayout.addSubview(noDataLabel)
            
            // Let the delegate know that the graph finished layout updates
            delegate?.lineGraphDidFinishLoading(self)
        } else if numberOfPoints == 1 {
            print("[LineGraph] Data source contains only one data point. Add more data to the data source and then reload the graph.")
            clearGraph()
            let circleDot = BEMCircle(frame: CGRect(x: 0, y: 0, width: points.diameter, height: points.diameter))
            circleDot.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            circleDot.color = points.color
            circleDot.alpha = 1.0
            forFirstBaselineLayout.addSubview(circleDot)
            points.oneDot = circleDot
            
            // Let the delegate know that the graph finished layout updates
            delegate?.lineGraphDidFinishLoading(self)
        }
    }
    
    func layoutTouchReport() {
        // If the touch report is enabled, set it up
        guard interactionGuide.touchReportEnabled == true || interactionGuide.popupsEnabled == true else { return }
        
        // Initialize the vertical gray line that appears where the user touches the graph.
        interactionGuide.touchReportLine.view.removeFromSuperview()
        interactionGuide.touchReportLine.view = UIView(frame: CGRect(x: 0, y: 0, width: interactionGuide.touchReportLine.width, height: frame.size.height))
        interactionGuide.touchReportLine.view.alpha = interactionGuide.touchReportLine.alpha
        interactionGuide.touchReportLine.view.backgroundColor = interactionGuide.touchReportLine.color
        addSubview(interactionGuide.touchReportLine.view)
        
        interactionGuide.panView.removeFromSuperview()
        interactionGuide.panView = UIView(frame: CGRect(x: 10, y: 10, width: forFirstBaselineLayout.frame.size.width, height: forFirstBaselineLayout.frame.size.height))
        interactionGuide.panView.backgroundColor = UIColor.clear
        
        interactionGuide.panView.removeGestureRecognizer(interactionGuide.panGesture)
        interactionGuide.panGesture = UIPanGestureRecognizer(target: self, action: #selector(LineGraph.handleGestureAction(_:)))
        interactionGuide.panGesture.delegate = self
        interactionGuide.panGesture.maximumNumberOfTouches = 1
        interactionGuide.panView.addGestureRecognizer(interactionGuide.panGesture)
        
        interactionGuide.panView.removeGestureRecognizer(interactionGuide.longPressGesture)
        interactionGuide.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LineGraph.handleGestureAction(_:)))
        interactionGuide.longPressGesture.minimumPressDuration = 0.1
        interactionGuide.panView.addGestureRecognizer(interactionGuide.longPressGesture)
        
        addSubview(interactionGuide.panView)
    }
    
    
    // MARK: - Drawing
    
    func didFinishDrawing(includingYAxis yAxisFinishedDrawing: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(animationGraphEntranceTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            if self.yAxis.labels.areEnabled == false {
                // Let the delegate know that the graph finished rendering
                self.delegate?.lineGraphDidFinishDrawing(self)
                return
            } else {
                if yAxisFinishedDrawing == true {
                    // Let the delegate know that the graph finished rendering
                    self.delegate?.lineGraphDidFinishDrawing(self)
                    return
                }
            }
        })
    }
    
    func drawEntireGraph() {
        // The following method calls are in this specific order for a reason
        // Changing the order of the method calls below can result in drawing glitches and even crashes
        averageLine.yValue = .nan
        
        // Set the Y-Axis Offset if the Y-Axis is enabled. The offset is relative to the size of the longest label on the Y-Axis.
        if yAxis.labels.areEnabled {
            yAxis.labelOffset = 2.0 + calculateWidestLabel()
        } else {
            yAxis.labelOffset = 0
        }
        
        // Draw the X-Axis
        drawXAxis()
        
        // Draw the data points
        drawDots()
        
        // Draw line with bottom and top fill
        drawLine()
        
        // Draw the Y-Axis
        drawYAxis()
    }
    
    func labelWidth(forValue value: CGFloat) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: labelFont]
        let valueString = yAxisText(forValue: value)
        let labelString = valueString.replacingOccurrences(of: "[0-9-]", with: "N", options: .regularExpression, range: NSRange(location: 0, length: valueString.count))
        return labelString.size(withAttributes: attributes).width
    }
    
    func calculateWidestLabel() -> CGFloat {
        let attributes = [NSAttributedString.Key.font: labelFont]
        let widestNumber: CGFloat = max(labelWidth(forValue: maximumValue), labelWidth(forValue: minimumValue))
        if averageLine.enableAverageLine {
            return max(widestNumber, averageLine.title?.size(withAttributes: attributes).width ?? 10)
        } else {
            return widestNumber
        }
    }
    
    func circleDot(at index: Int, forValue dotValue: CGFloat, reuseNumber: Int) -> BEMCircle {
        var positionOnXAxis = numberOfPoints > 1 ? (((frame.size.width - yAxis.labelOffset) / CGFloat((numberOfPoints - 1))) * CGFloat(index)) : frame.size.width / 2
        if yAxisPosition == .left {
            positionOnXAxis += yAxis.labelOffset
        }
        let positionOnYAxis = yPosition(forDotValue: dotValue)
        yAxis.labels.labelPoints.append(NSNumber(value: Float(positionOnYAxis)))
        let dotFrame = CGRect(x: 0, y: 0, width: points.diameter, height: points.diameter)
        var circleDot: BEMCircle = BEMCircle.init()
        if reuseNumber < points.views.count {
            circleDot = points.views[reuseNumber]
            circleDot.frame = dotFrame
            circleDot.setNeedsDisplay()
        } else {
            circleDot = BEMCircle(frame: dotFrame)
            points.views.append(circleDot)
        }
        if dotValue >= BEMNullGraphValue {
            // If we're dealing with an null value, don't draw the dot (but leave it in yAxis to interpolate line)
            circleDot.removeFromSuperview()
            return circleDot
        }
        circleDot.center = CGPoint(x: positionOnXAxis, y: positionOnYAxis)
        circleDot.tag = index + BEMInternalTags.dotFirstTag100.rawValue
        circleDot.absoluteValue = dotValue
        circleDot.color = points.color
        return circleDot
    }
    
    func drawDots() {
        // Remove all data points before adding them to the array
        points.data.removeAll()
        // Remove all yAxis values before adding them to the array
        yAxis.labels.labelPoints.removeAll()
        // Loop through each point and add it to the graph
        for index in 0..<numberOfPoints {
            #if !TARGET_INTERFACE_BUILDER
            guard let dotValue = dataSource?.lineGraph(self, valueForPointAt: index) else {
                // throw GraphError.dataSourceInvalid("Data Source returned invalid or nil value for point at index. Must provide non-nil values.")
                return
            }
            #else
            dotValue = CGFloat(Int(arc4random() % 10000))
            #endif
            points.data.append(NSNumber(value: Float(dotValue)))
            let circleDot: BEMCircle = self.circleDot(at: index, forValue: dotValue, reuseNumber: index)
            var label = UILabel.init()
            if index < interactionGuide.permanentPopups.count {
                label = interactionGuide.permanentPopups[index]
            } else {
                label = UILabel(frame: CGRect.zero)
                interactionGuide.permanentPopups.append(label)
            }
            
            addSubview(circleDot)
            if interactionGuide.popupsDisplayPersistently == true {
                label = configureLabel(label, forPoint: circleDot)
                adjustXLoc(forLabel: label, avoidingDot: circleDot.frame)
                let leftNeighbor = (index >= 1 && (interactionGuide.permanentPopups[index - 1].superview != nil)) ? interactionGuide.permanentPopups[index - 1] : nil
                let secondNeighbor = (index >= 2 && (interactionGuide.permanentPopups[index - 2].superview != nil)) ? interactionGuide.permanentPopups[index - 2] : nil
                if let showLabel = adjustYLoc(forLabel: label, avoidingDot: circleDot.frame, andNeighbors: leftNeighbor?.frame, and: secondNeighbor?.frame) {
                    label = showLabel
                    addSubview(label)
                } else {
                    label.removeFromSuperview()
                }
            } else {
                // not showing labels this time, so remove if any
                label.removeFromSuperview()
            }
            // Dot and/or label entrance animation
            circleDot.alpha = 0.0
            label.alpha = 0.0
            if animationGraphEntranceTime <= 0 {
                if line.lineType == .dot || points.displayPersistently {
                    circleDot.alpha = 1.0
                }
            } else if points.displayWhileAnimating {
                UIView.animate(withDuration: TimeInterval(animationGraphEntranceTime / Double(numberOfPoints)), delay: TimeInterval(Double(index) * (animationGraphEntranceTime / Double(numberOfPoints))), options: .curveLinear, animations: {
                    circleDot.alpha = 1.0
                    label.alpha = 1.0
                }) { finished in
                    if self.points.displayPersistently == false && self.line.lineType != .dot {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            circleDot.alpha = 0
                        })
                    }
                }
            }
            
            UIView.animate(withDuration: 0.5, delay: animationGraphEntranceTime, options: .curveLinear, animations: {
                label.alpha = 1
            })
        }
        var i = points.views.count - 1
        while i >= numberOfPoints {
            interactionGuide.permanentPopups.last?.removeFromSuperview() //no harm if not showing
            interactionGuide.permanentPopups.removeLast()
            points.views.last?.removeFromSuperview()
            points.views.removeLast()
            i -= 1
        }
    }
    
    func drawLine() {
        line.master = BEMLine(frame: drawableGraphArea())
        line.master.setNeedsDisplay()
        addSubview(line.master)
        
        line.master.isOpaque = false
        line.master.alpha = 1
        line.master.backgroundColor = UIColor.clear
        line.master.topColor = colorTop
        line.master.bottomColor = colorBottom
        line.master.topAlpha = alphaTop
        line.master.bottomAlpha = alphaBottom
        line.master.topGradient = gradientTop
        line.master.bottomGradient = gradientBottom
        line.master.lineWidth = line.width
        line.master.referenceLineWidth = referenceLines.width > 0.0 ? referenceLines.width : (line.width / 2)
        line.master.lineAlpha = line.alpha
        line.master.bezierCurveIsEnabled = line.lineType == .bezierCurve ? true : false
        line.master.arrayOfPoints = yAxis.labels.labelPoints
        line.master.arrayOfValues = graphValuesForDataPoints
        line.master.lineDashPatternForReferenceYAxisLines = yAxis.referenceLineDashPattern
        line.master.lineDashPatternForReferenceXAxisLines = xAxis.referenceLineDashPattern
        line.master.interpolateNullValues = interpolateNullValues
        for allowedPosition in referenceLines.allowedFramePositions {
            switch allowedPosition {
            case .bottom:
                line.master.enableReferenceFrame = true
                line.master.enableBottomReferenceFrameLine = true
            case .top:
                line.master.enableReferenceFrame = true
                line.master.enableTopReferenceFrameLine = true
            case .right:
                line.master.enableReferenceFrame = true
                line.master.enableRightReferenceFrameLine = true
            case .left:
                line.master.enableReferenceFrame = true
                line.master.enableLeftReferenceFrameLine = true
            case .none:
                line.master.enableReferenceFrame = false
                line.master.enableLeftReferenceFrameLine = false
                line.master.enableRightReferenceFrameLine = false
                line.master.enableTopReferenceFrameLine = false
                line.master.enableBottomReferenceFrameLine = false
            default:
                break
            }
        }
        if xAxis.enableReferenceLine || yAxis.enableReferenceLine {
            line.master.enableReferenceLines = true
            line.master.referenceLineColor = referenceLines.color
            line.master.verticalReferenceHorizontalFringeNegation = xAxisHorizontalFringeNegationValue
            line.master.arrayOfVerticalReferenceLinePoints = xAxis.enableReferenceLine ? xAxis.labels.labelPoints : []
            line.master.arrayOfHorizontalReferenceLinePoints = yAxis.enableReferenceLine ? yAxis.labels.labelPoints : []
        } else {
            line.master.enableReferenceLines = false
        }
        line.master.color = line.color
        line.master.lineGradient = line.gradient
        line.master.lineGradientDirection = line.gradientDirection == .horizontal ? BEMLineGradientDirection.horizontal : BEMLineGradientDirection.vertical 
        line.master.animationTime = CGFloat(animationGraphEntranceTime)
        switch animationGraphStyle {
        case .draw:
            line.master.animationType = .draw
        case .expand:
            line.master.animationType = .expand
        case .fade:
            line.master.animationType = .fade
        case .none:
            line.master.animationType = .none
        default:
            line.master.animationType = .draw
        }
        if averageLine.enableAverageLine == true {
            if averageLine.yValue.isNaN {
                averageLine.yValue = averageValue
            }
            line.master.averageLineYCoordinate = yPosition(forDotValue: averageLine.yValue)
        }
        line.master.averageLine = averageLine
        line.master.disableMainLine = line.lineType == .dot ? true : false
        sendSubview(toBack: line.master)
        sendSubview(toBack: xAxis.background.view)
        didFinishDrawing(includingYAxis: false)
    }
    
    func drawXAxis() {
        if xAxis.labels.areEnabled == false {
            xAxis.background.view.removeFromSuperview()
            for label in xAxis.labels.labels {
                label.removeFromSuperview()
            }
            xAxis.labels.labels = []
            return
        }
        
        if !dataSource?.responds(to: #selector(LineGraph.lineGraph(_:labelOnXAxisForIndex:))) {
            return
        }
        
        xAxis.labels.labels.removeAll()
        xAxis.labels.labelPoints.removeAll()
        xAxisHorizontalFringeNegationValue = 0.0
        
        // Draw X-Axis Background Area
        xAxis.background.view.frame = drawableXAxisArea()
        addSubview(xAxis.background.view)
        
        if xAxis.background.color != nil {
            xAxis.background.view.backgroundColor = xAxis.background.color
            xAxis.background.view.alpha = xAxis.background.alpha
        } else {
            xAxis.background.view.backgroundColor = colorBottom
            xAxis.background.view.alpha = alphaBottom
        }
        var axisIndices: [NSNumber]? = nil
        if delegate?.responds(to: #selector(LineGraph.incrementPositionsForXAxis(onLineGraph:))) {
            axisIndices = delegate?.incrementPositionsForXAxis(onLineGraph: self)
        } else {
            var baseIndex: Int = 0
            var increment: Int = 1
            if delegate?.responds(to: #selector(LineGraph.baseIndexForXAxis(onLineGraph:))) && delegate?.responds(to: #selector(LineGraph.incrementIndexForXAxis(onLineGraph:))) {
                baseIndex = delegate?.baseIndexForXAxis(onLineGraph: self)
                increment = delegate?.incrementIndexForXAxis(onLineGraph: self)
            } else if delegate?.responds(to: #selector(LineGraph.numberOfGapsBetweenLabels(onLineGraph:))) {
                increment = delegate?.numberOfGapsBetweenLabels(onLineGraph: self) + 1
                if increment >= numberOfPoints - 1 {
                    // need at least two points
                    baseIndex = 0
                    increment = numberOfPoints - 1
                } else {
                    let leftGap: Int = increment - 1
                    let rightGap: Int = numberOfPoints % increment
                    let offset: Int = (leftGap - rightGap) / 2
                    baseIndex = increment - 1 - offset
                }
            }
            if increment == 0 {
                increment = 1
            }
            var values: [NSNumber] = []
            var index: Int = baseIndex
            while index < numberOfPoints {
                values.append(NSNumber(value: index))
                index += increment
            }
            axisIndices = values
        }
        var xAxisLabelNumber: Int = 0
        autoreleasepool {
            for indexNum in axisIndices ?? [] {
                var index = Int(indexNum.uintValue)
                if index > numberOfPoints {
                    continue
                }
                let xAxisLabelText = xAxisText(for: index)
                let labelXAxis: UILabel? = xAxisLabel(withText: xAxisLabelText, at: index, reuseNumber: xAxisLabelNumber)
                xAxis.labels.labelPoints.append(NSNumber(value: Float((labelXAxis?.center.x ?? 0.0) - (yAxisPosition == .right ? 0.0 : yAxis.labelOffset))))
                if let labelXAxis = labelXAxis {
                    addSubview(labelXAxis)
                }
                xAxisValues.append(xAxisLabelText)
                xAxisLabelNumber += 1
            }
        }
        var i = xAxis.labels.labels.count
        while i > xAxisLabelNumber {
            xAxis.labels.labels.last?.removeFromSuperview()
            xAxis.labels.labels.removeLast()
            i -= 1
        }
        var prevLabel: UILabel?
        var overlapLabels = [AnyHashable](repeating: 0, count: xAxis.labels.labels.count) as? [UILabel]
        (xAxis.labels.labels as NSArray).enumerateObjects({ label, idx, stop in
            if idx == 0 {
                prevLabel = label // always show first label
            } else if label.superview != nil {
                // only look at active labels
                if prevLabel?.frame.intersection(label.frame).isNull() && self.xAxis.background.view?.frame.contains(label?.frame) {
                    prevLabel = label // no overlap and inside frame, so show this one
                } else {
                    if let label = label {
                        overlapLabels?.append(label)
                    } // Overlapped
                }
            }
        })
        for l in overlapLabels ?? [] {
            l.removeFromSuperview()
        }
    }
    
    fileprivate func xAxisText(for index: Int) -> String {
        var xAxisLabelText = ""
        if let text = dataSource?.lineGraph(self, labelOnXAxisFor: index) {
            xAxisLabelText = text
        } else {
            xAxisLabelText = ""
        }
        return xAxisLabelText
    }
    
    fileprivate func xAxisLabel(withText text: String?, at index: Int, reuseNumber xAxisLabelNumber: Int) -> UILabel? {
        var labelXAxis: UILabel?
        if xAxisLabelNumber < xAxis.labels.labels.count {
            labelXAxis = xAxis.labels.labels[xAxisLabelNumber]
        } else {
            labelXAxis = UILabel()
            if let labelXAxis = labelXAxis {
                xAxis.labels.labels.append(labelXAxis)
            }
        }
        labelXAxis?.text = text
        labelXAxis?.font = labelFont
        if let unwrappedVar = NSTextAlignment(rawValue: 1) {
            labelXAxis?.textAlignment = unwrappedVar
        }
        labelXAxis?.textColor = xAxis.labels.color
        labelXAxis?.backgroundColor = UIColor.clear
        // Add support multi-line, but this might overlap with the graph line if text have too many lines
        labelXAxis?.numberOfLines = 0
        var lRect: CGRect? = nil
        if let font = labelXAxis?.font {
            lRect = labelXAxis?.text?.boundingRect(with: forFirstBaselineLayout.frame.size, options: .usesLineFragmentOrigin, attributes: [
                NSAttributedString.Key.font: font
                ], context: nil)
        }
        // Determine the horizontal translation to perform on the far left and far right labels
        // This property is negated when calculating the position of reference frames
        var horizontalTranslation: CGFloat = 0
        if index == 0 {
            horizontalTranslation = (lRect?.size.width ?? 0.0) / 2
        } else if index + 1 == numberOfPoints {
            horizontalTranslation = -(lRect?.size.width ?? 0.0) / 2
        }
        xAxisHorizontalFringeNegationValue = horizontalTranslation
        // Determine the final x-axis position
        var positionOnXAxis = (((frame.size.width - yAxis.labelOffset) / CGFloat((numberOfPoints - 1))) * CGFloat(index)) + horizontalTranslation
        if yAxisPosition == .left {
            positionOnXAxis += yAxis.labelOffset
        }
        labelXAxis?.frame = lRect ?? CGRect.zero
        labelXAxis?.center = CGPoint(x: positionOnXAxis, y: frame.size.height - (lRect?.size.height ?? 0.0) / 2.0 - 1.0)
        return labelXAxis
    }
    
    fileprivate func yAxisText(forValue value: CGFloat) -> String {
        let yAxisSuffix = delegate?.yAxisSuffix(onLineGraph: self) ?? ""
        let yAxisPrefix = delegate?.yAxisPrefix(onLineGraph: self) ?? ""
        let formattedValue = String(format: formatStringForValues, value)
        return "\(yAxisPrefix)\(formattedValue)\(yAxisSuffix)"
    }
    
    fileprivate func yAxisLabel(withText text: String?, atValue value: CGFloat, reuseNumber: Int) -> UILabel? {
        // provide a Y-Axis Label with text at Value, reusing reuseNumber'd label if it exists
        // special case: use self.Averageline.label if reuseNumber = NSIntegerMax
        let labelHeight: CGFloat = labelFont.pointSize + 7.0
        var frameForLabelYAxis = CGRect(x: 1.0, y: 0.0, width: yAxis.labelOffset - 1.0, height: labelHeight)
        var xValueForCenterLabelYAxis: CGFloat = (yAxis.labelOffset - 1.0) / 2.0
        let textAlignmentForLabelYAxis: NSTextAlignment = .right
        if yAxisPosition == .right {
            frameForLabelYAxis.origin = CGPoint(x: frame.size.width - yAxis.labelOffset - 1.0, y: 0.0)
            xValueForCenterLabelYAxis = frame.size.width - xValueForCenterLabelYAxis - 2.0
        }
        var labelYAxis: UILabel?
        if reuseNumber == NSInteger.max {
            if averageLine.label == nil {
                averageLine.label = UILabel(frame: frameForLabelYAxis)
            }
            labelYAxis = averageLine.label
        } else if reuseNumber < yAxis.labels.labels.count {
            labelYAxis = yAxis.labels.labels[reuseNumber]
        } else {
            labelYAxis = UILabel(frame: frameForLabelYAxis)
            if let labelYAxis = labelYAxis {
                yAxis.labels.labels.append(labelYAxis)
            }
        }
        labelYAxis?.frame = frameForLabelYAxis
        labelYAxis?.text = text
        labelYAxis?.textAlignment = textAlignmentForLabelYAxis
        labelYAxis?.font = labelFont
        labelYAxis?.textColor = yAxis.labels.color
        labelYAxis?.backgroundColor = UIColor.clear
        let yAxisOrigin = yPosition(forDotValue: value)
        labelYAxis?.center = CGPoint(x: xValueForCenterLabelYAxis, y: yAxisOrigin)
        let yAxisLabelCoordinate = NSNumber(value: Float(labelYAxis?.center.y ?? 0.0))
        yAxis.labels.labelPoints.append(yAxisLabelCoordinate)
        return labelYAxis
    }
    
    private func drawYAxis() {
        if !yAxis.labels.areEnabled {
            yAxis.background.view.removeFromSuperview()
            averageLine.label?.removeFromSuperview()
            averageLine.label = nil
            for label in yAxis.labels.labels {
                label.removeFromSuperview()
            }
            yAxis.labels.labels = []
            return
        }
        
        // Make Background for Y Axis
        let frameForBackgroundYAxis = CGRect(x: yAxisPosition == .right ? frame.size.width - yAxis.labelOffset - 1.0 : 0.0, y: 0, width: yAxis.labelOffset, height: frame.size.height)
        yAxis.background.view.frame = frameForBackgroundYAxis
        addSubview(yAxis.background.view)
        
        if yAxis.background.color {
            yAxis.background.view.backgroundColor = yAxis.background.color
            yAxis.background.view.alpha = yAxis.background.alpha
        } else {
            yAxis.background.view.backgroundColor = colorTop
            yAxis.background.view.alpha = alphaTop
        }
        
        yAxis.labels.labelPoints.removeAll()
        var numberOfLabels: Int = 3
        if delegate?.responds(to: #selector(LineGraph.numberOfYAxisLabels(onLineGraph:))) {
            numberOfLabels = delegate?.numberOfYAxisLabels(onLineGraph: self)
            if numberOfLabels <= 0 {
                return
            }
        }
        
        // Now calculate baseValue and increment for all scenarios
        var value: CGFloat
        var increment: CGFloat
        // Plot according to min-max range
        if numberOfLabels == 1 {
            value = (minimumValue + maximumValue) / 2.0
            increment = 0 // NA
        } else {
            value = minimumValue
            increment = (maximumValue - minimumValue) / CGFloat((numberOfLabels - 1))
            if delegate?.responds(to: #selector(LineGraph.baseValueForYAxis(onLineGraph:))) && delegate?.responds(to: #selector(LineGraph.incrementValueForYAxis(onLineGraph:))) {
                value = delegate?.baseValueForYAxis(onLineGraph: self)
                increment = delegate?.incrementValueForYAxis(onLineGraph: self)
                if increment <= 0 {
                    increment = 1
                }
                numberOfLabels = Int((maximumValue - value) / increment) + 1
                if numberOfLabels > 100 {
                    print("[LineGraph] Increment does not properly lay out Y axis, bailing early")
                    return
                }
            }
        }
        
        var dotValues = [AnyHashable](repeating: 0, count: numberOfLabels) as? [NSNumber]
        for i in 0..<numberOfLabels {
            dotValues?.append(NSNumber(value: Float(value)))
            value += increment
        }
        
        var yAxisLabelNumber: Int = 0
        autoreleasepool {
            for dotValueNum in dotValues ?? [] {
                let dotValue = CGFloat(dotValueNum.floatValue)
                let labelText = yAxisText(forValue: dotValue)
                let labelYAxis: UILabel? = yAxisLabel(withText: labelText, atValue: dotValue, reuseNumber: yAxisLabelNumber)
                if let labelYAxis = labelYAxis {
                    addSubview(labelYAxis)
                }
                yAxisLabelNumber += 1
            }
        }
        
        var i = yAxis.labels.labels.count - 1
        while i >= yAxisLabelNumber {
            yAxis.labels.labels.last?.removeFromSuperview()
            yAxis.labels.labels.removeLast()
            i -= 1
        }
        // Detect overlapped labels
        var prevLabel: UILabel? = nil
        var overlapLabels = [AnyHashable](repeating: 0, count: 0) as? [UILabel]
        (yAxis.labels.labels as NSArray).enumerateObjects({ label, idx, stop in
            if idx == 0 {
                prevLabel = label // always show first label
            } else if label.superview != nil {
                // only look at active labels
                if prevLabel?.frame.intersection(label.frame).isNull() && self.backgroundYAxis?.frame.contains(label.frame) {
                    prevLabel = label // no overlap and inside frame, so show this one
                } else {
                    if let label = label {
                        overlapLabels?.append(label)
                    }
                }
            }
        })
        if averageLine.enableAverageLine && averageLine.title?.count > 0 {
            let averageLabel: UILabel = yAxisLabel(withText: averageLine.title, atValue: averageLine.yValue, reuseNumber: NSInteger.max)
            if let averageLabel = averageLabel {
                addSubview(averageLabel)
            }
            // Check for overlap; Average wins
            for label in yAxis.labels.labels {
                if !averageLabel.frame.intersection(label.frame).isNull() {
                    overlapLabels?.append(label)
                }
            }
        }
        for label in overlapLabels ?? [] {
            label.removeFromSuperview()
        }
        didFinishDrawing(includingYAxis: true)
    }
    
    /// Area on the graph that doesn't include the axes
    fileprivate func drawableGraphArea() -> CGRect {
        //  CGRectMake(xAxisXPositionFirstOffset, self.frame.size.height-20, viewWidth/2, 20);
        let xAxisHeight: CGFloat = xAxis.labels.areEnabled ? labelFont.pointSize + 8.0 : 0.0
        let xOrigin: CGFloat = yAxisPosition == .right ? 0 : yAxis.labelOffset
        let viewWidth: CGFloat = frame.size.width - yAxis.labelOffset
        let adjustedHeight: CGFloat = bounds.size.height - xAxisHeight
        let rect = CGRect(x: xOrigin, y: 0, width: viewWidth, height: adjustedHeight)
        return rect
    }
    
    fileprivate func drawableXAxisArea() -> CGRect {
        let xAxisHeight: CGFloat = labelFont.pointSize + 8.0
        let xAxisWidth: CGFloat = drawableGraphArea().size.width + 1
        let xAxisXOrigin: CGFloat = yAxisPosition == .right ? 0 : yAxis.labelOffset
        let xAxisYOrigin: CGFloat = bounds.size.height - xAxisHeight
        return CGRect(x: xAxisXOrigin, y: xAxisYOrigin, width: xAxisWidth, height: xAxisHeight)
    }
    
    fileprivate func configureLabel(_ oldLabel: UILabel, forPoint circleDot: BEMCircle) -> UILabel {
        let newPopUpLabel: UILabel = oldLabel
        newPopUpLabel.textAlignment = .center
        newPopUpLabel.numberOfLines = 0
        newPopUpLabel.font = labelFont
        newPopUpLabel.backgroundColor = UIColor.clear
        newPopUpLabel.layer.backgroundColor = interactionGuide.popupsBackgroundColor.withAlphaComponent(0.7).cgColor
        newPopUpLabel.layer.cornerRadius = 6
        
        let index = Int(circleDot.tag) - BEMInternalTags.dotFirstTag100.rawValue
        
        // Populate the popup label text with values
        newPopUpLabel.text = delegate?.popUpTextForlineGraph(self, at: index)
        
        // If the supplied popup label text is nil we can proceed to fill out the text using suffixes, prefixes, and the graph's data source.
        if newPopUpLabel.text == nil {
            let prefix = delegate?.popUpPrefixForlineGraph(self) ?? ""
            let suffix = delegate?.popUpSuffixForlineGraph(self) ?? ""
            
            var value: CGFloat = 0
            if index <= points.data.count {
                value = CGFloat(truncating: points.data[index])
            }
            
            let formattedValue = String(format: formatStringForValues, value)
            newPopUpLabel.text = "\(prefix)\(formattedValue)\(suffix)"
        }
        
        let requiredSize = newPopUpLabel.sizeThatFits(CGSize(width: 100.0, height: CGFloat.greatestFiniteMagnitude))
        newPopUpLabel.frame = CGRect(x: 10, y: 10, width: requiredSize.width + 10.0, height: requiredSize.height + 10.0)
        return newPopUpLabel
    }
    
    fileprivate func adjustXLoc(forLabel popUpLabel: UIView?, avoidingDot circleDotFrame: CGRect) {
        // Now fixup left/right layout issues
        var xCenter = circleDotFrame.midX
        let halfLabelWidth: CGFloat = (popUpLabel?.frame.size.width ?? 0.0) / 2
        if yAxis.labels.areEnabled && yAxisPosition == .left && ((xCenter - halfLabelWidth) <= yAxis.labelOffset) {
            // When bumping into left Y axis
            xCenter = halfLabelWidth + yAxis.labelOffset + 4.0
        } else if yAxis.labels.areEnabled && yAxisPosition == .right && (xCenter + halfLabelWidth >= frame.size.width - yAxis.labelOffset) {
            // When bumping into right Y axis
            xCenter = frame.size.width - halfLabelWidth - yAxis.labelOffset - 4.0
        } else if xCenter - halfLabelWidth <= 0 {
            // When over left edge
            xCenter = halfLabelWidth + 4.0
        } else if xCenter + halfLabelWidth >= frame.size.width {
            // When over right edge
            xCenter = frame.size.width - halfLabelWidth
        }
        popUpLabel?.center = CGPoint(x: xCenter, y: popUpLabel?.center.y ?? 0.0)
    }
    
    @discardableResult
    fileprivate func adjustYLoc(forLabel popUpLabel: UIView, avoidingDot dotFrame: CGRect, andNeighbors leftNeightbor: CGRect, and secondNeighbor: CGRect) -> Bool {
        // returns YES if it can avoid those neighbors
        // note: nil.frame == CGRectZero
        // check for bumping into top OR overlap with left neighbors
        // default Y is above point
        let halfLabelHeight: CGFloat = (popUpLabel.frame.size.height ) / 2.0
        popUpLabel.center = CGPoint(x: popUpLabel.center.x , y: dotFrame.minY - 12.0 - halfLabelHeight)
        if popUpLabel.frame.minY < 2.0 || (!popUpLabel.frame.intersection(leftNeightbor).isEmpty()) || (!popUpLabel.frame.intersection(secondNeighbor).isEmpty()) {
            // if so, try below point instead
            var frame = popUpLabel.frame
            frame.origin.y = dotFrame.maxY + 12.0
            popUpLabel.frame = frame 
            // check for bottom and again for overlap with neighbor and even neighbor second to the left
            if frame.maxY > (self.frame.size.height - xAxis.labelOffset) || (!popUpLabel.frame.intersection(leftNeightbor).isEmpty()) || (!popUpLabel?.frame.intersection(secondNeighbor).isEmpty()) {
                return false
            }
        }
        return true
    }
    
    /** Takes a snapshot of the graph while the app is in the foreground.
     - returns: The snapshot of the graph as a UIImage object. */
    public func graphSnapshotImage() -> UIImage? {
        return graphSnapshotImageRenderedWhile(inBackground: false)
    }
    
    /** Takes a snapshot of the graph.
     - parameter appIsInBackground: If your app is currently in the background state, pass true to `appIsInBackground`. Otherwise, when your app is in the foreground you should take advantage of more efficient APIs by passing false to `appIsInBackground`.
     - returns: The snapshot of the graph as a UIImage object. */
    public func graphSnapshotImageRenderedWhile(inBackground appIsInBackground: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, _: false, _: UIScreen.main.scale)
        if appIsInBackground == false {
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        } else {
            let context = UIGraphicsGetCurrentContext()
            if context != nil {
                if let context = context {
                    layer.render(in: context)
                }
            }
        }
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    // MARK: - Data Source
    
    /// Reload the graph, all delegate methods are called again and the graph is reloaded.
    public func reloadGraph() {
        drawGraph()
    }
    
    
    // MARK: - Touch Gestures
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(interactionGuide.panGesture) {
            if gestureRecognizer.numberOfTouches >= interactionGuide.touchReportFingersRequired {
                let translation: CGPoint? = interactionGuide.panGesture.velocity(in: interactionGuide.panView)
                return fabs(Float(translation?.y ?? 0.0)) < fabs(Float(translation?.x ?? 0.0))
            } else {
                return false
            }
            return true
        } else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    @objc func handleGestureAction(_ recognizer: UIGestureRecognizer?) {
        let translation: CGPoint? = recognizer?.location(in: forFirstBaselineLayout)
        if !(((translation?.x ?? 0.0) + frame.origin.x) <= frame.origin.x) && !(((translation?.x ?? 0.0) + frame.origin.x) >= frame.origin.x + frame.size.width) {
            // To make sure the vertical line doesn't go beyond the frame of the graph.
            interactionGuide.touchReportLine.view.frame = CGRect(x: (translation?.x ?? 0.0) - interactionGuide.touchReportLine.width / 2, y: 0, width: interactionGuide.touchReportLine.width, height: frame.size.height)
        }
        interactionGuide.touchReportLine.view.alpha = interactionGuide.touchReportLine.alpha
        let closestDot: BEMCircle = self.closestDot(fromTouchInputLine: interactionGuide.touchReportLine.view)
        var index: Int = 0
        let tag = closestDot.tag
        if tag > BEMInternalTags.dotFirstTag100.rawValue {
            index = tag - BEMInternalTags.dotFirstTag100.rawValue
        } else {
            if numberOfPoints == 0 {
                return // something's very wrong
            }
        }
        
        closestDot.alpha = 0.8
        if recognizer?.state != .ended {
            // ON START OR MOVE
            if interactionGuide.popupsEnabled == true && interactionGuide.popupsDisplayPersistently == false {
                if let customPopup = delegate?.popUpView(forLineGraph: self) {
                    interactionGuide.customPopupView = customPopup
                    addSubview(interactionGuide.customPopupView)
                    adjustXLoc(forLabel: interactionGuide.customPopupView, avoidingDot: closestDot.frame)
                    adjustYLoc(forLabel: interactionGuide.customPopupView, avoidingDot: closestDot.frame, andNeighbors: CGRect.zero, and: CGRect.zero)
                    delegate?.lineGraph(self, modifyPopupView: interactionGuide.customPopupView, for: index)
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                        self.interactionGuide.customPopupView.alpha = 1.0
                    })
                } else {
                    let newLabel = UILabel(frame: CGRect.zero)
                    addSubview(newLabel)
                    interactionGuide.popupLabel = configureLabel(newLabel, forPoint: closestDot)
                    adjustXLoc(forLabel: interactionGuide.popupLabel, avoidingDot: closestDot.frame)
                    adjustYLoc(forLabel: interactionGuide.popupLabel, avoidingDot: closestDot.frame, andNeighbors: CGRect.zero, and: CGRect.zero)
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                        self.interactionGuide.popupLabel.alpha = 1.0
                    })
                }
            }
            
            if interactionGuide.touchReportEnabled {
                delegate?.lineGraph(self, didTouchGraphWithClosestIndex: index)
            }
        } else {
            // ON RELEASE
            if interactionGuide.touchReportEnabled {
                delegate?.lineGraph(self, didReleaseTouchFromGraphWithClosestIndex: index)
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                if self.points.displayPersistently == false && self.line.lineType != .dot {
                    closestDot.alpha = 0
                }
                self.interactionGuide.touchReportLine.view.alpha = 0
                self.interactionGuide.popupLabel.alpha = 0
                self.interactionGuide.customPopupView.alpha = 0
            }) { finished in
                self.interactionGuide.customPopupView.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: - Graph Calculations
    
    public var maximumValue: CGFloat {
        get {
            if let max = delegate?.maxValue(forLineGraph: self) {
                return max
            } else {
                var maxValue = CGFloat(-Float.greatestFiniteMagnitude)
                for i in 0..<numberOfPoints {
                    guard let dotValue = dataSource?.lineGraph(self, valueForPointAt: i) else { return maxValue }
                    if dotValue >= BEMNullGraphValue {
                        continue
                    }
                    if dotValue > maxValue {
                        maxValue = dotValue
                    }
                }
                return maxValue
            }
        }
    }
    
    public var minimumValue: CGFloat {
        get {
            if let min = delegate?.minValue(forLineGraph: self) {
                return min
            } else {
                var minValue: CGFloat = .infinity
                for i in 0..<numberOfPoints {
                    guard let dotValue = dataSource?.lineGraph(self, valueForPointAt: i)  else { return minValue }
                    if dotValue >= BEMNullGraphValue {
                        continue
                    }
                    if dotValue < minValue {
                        minValue = dotValue
                    }
                }
                return minValue
            }
        }
    }
    
    public var averageValue: CGFloat {
        get {
            if let average = delegate?.averageValue(forLineGraph: self) {
                return average
            } else {
                var sumValue: CGFloat = 0.0
                var numPoints: Int = 0
                for i in 0..<numberOfPoints {
                    guard let dotValue = dataSource?.lineGraph(self, valueForPointAt: i)  else { 
                        // throw GraphError.dataSourceInvalid("Data Source not implemented. Need valueForPointAt:")
                        return .nan
                    }
                    if dotValue >= BEMNullGraphValue {
                        continue
                    }
                    sumValue += dotValue
                    numPoints += 1
                }
                
                if numPoints > 0 {
                    return sumValue / CGFloat(numPoints)
                } else {
                    return .nan
                }
            }
        }
    }
    
    func yPosition(forDotValue dotValue: CGFloat) -> CGFloat {
        if dotValue.isNaN || dotValue >= BEMNullGraphValue {
            return BEMNullGraphValue
        }
        var positionOnYAxis: CGFloat // The position on the Y-axis of the point currently being created.
        var padding = min(90.0, frame.size.height / 2)
        if let pad = delegate?.staticPadding(forLineGraph: self) {
            padding = pad
        }
        xAxis.labelOffset = xAxis.labels.areEnabled ? xAxis.background.view.frame.size.height : 0.0
        
        if minimumValue >= maximumValue {
            positionOnYAxis = frame.size.height / 2.0
        } else {
            let percentValue: CGFloat = (dotValue - minimumValue) / (maximumValue - minimumValue)
            let topOfChart: CGFloat = frame.size.height - padding / 2.0
            let sizeOfChart: CGFloat = frame.size.height - padding
            positionOnYAxis = topOfChart - percentValue * sizeOfChart + xAxis.labelOffset
        }
        
        positionOnYAxis -= xAxis.labelOffset
        return positionOnYAxis
    }
    
}

