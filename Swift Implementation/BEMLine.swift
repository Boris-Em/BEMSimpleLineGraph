//
//  BEMLine.swift
//  SimpleLineGraph
//
//  Created by Sam Spencer on 7/31/17.
//  Copyright © 2017 Samuel Spencer. All rights reserved.
//

import UIKit
import CoreGraphics
import Foundation


/// The type of animation used to display the graph
public enum LineAnimation: String {
    /// The draw animation draws the lines from left to right and bottom to top.
    case draw = "strokeEnd"
    /// The fade animation fades in the lines from 0% opaque to 100% opaque (based on the \p lineAlpha property).
    case fade = "opacity"
    /// The expand animation expands the lines from a small point to their full width (based on the \p lineWidth property).
    case expand = "lineWidth"
    /// No animation is used to display the graph
    case none
}

private enum LayerToAnimate {
    case mainLine
    case referenceLine
    case referenceFrame
    case averageLine
}

/// The drawing direction of the gradient used to draw the graph line (if any)
public enum LineGradientDirection {
    /// The gradient is drawn from left to right
    case horizontal
    /// The gradient is drawn from top to bottom
    case vertical
}


/// Class to draw the line of the graph (Swift)
public class BEMLine_Swift: UIView {
    
    var points: Points
    private var allPointValues: [NSValue]
    public struct Points {
        var values: [NSNumber]? = []
        var interpolateNullValues: Bool = true
        
        var xAxisReferenceLines: [Int]? = []
        var yAxisReferenceLines: [Int]? = []
        
        init(values: [NSNumber]? = [], 
             interpolateNullValues: Bool, 
             xAxisReferenceLines: [Int]? = [],
             yAxisReferenceLines: [Int]? = []) {
            self.values = values
            self.interpolateNullValues = interpolateNullValues
            self.xAxisReferenceLines = xAxisReferenceLines
            self.yAxisReferenceLines = yAxisReferenceLines
        }
    }
    
    var mainLineEnabled: Bool = true
    var mainLine: MainLine
    public struct MainLine {
        enum Curve {
            case quadraticBezier
            case cubicBezier
            case straight
        }
        
        struct Gradient {
            var value: CGGradient
            var direction: LineGradientDirection
        }
        
        var curve: Curve? = .quadraticBezier
        var color: UIColor? = .white
        var alpha: Float? = 1.0
        var width: Float? = 3.0
        var gradient: Gradient? = Gradient(value: CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])!, direction: .vertical)
        
        init(curve: Curve? = .quadraticBezier, 
             color: UIColor? = .white, 
             alpha: Float? = 1.0,
             width: Float? = 3.0,
             gradient: Gradient? = Gradient(value: CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])!, direction: .vertical)) {
            self.curve = curve
            self.color = color
            self.alpha = alpha
            self.width = width
            self.gradient = gradient
        }
    }
    
    var averageLineEnabled: Bool = false
    var averageLine: BEMAverageLine_Swift
    
    var referenceLinesEnabled: Bool = true
    var referenceLine: ReferenceLine?
    public struct ReferenceLine {
        var color: UIColor? = .white
        
        fileprivate static let minThresholdLevel: Float = 0.05
        var alpha: Float? = 0.5 {
            didSet {
                if alpha! < ReferenceLine.minThresholdLevel {
                    // Cap the alpha value to the threshold level
                    alpha = ReferenceLine.minThresholdLevel
                }
            }
        }
        
        var width: Float? = 1.0 {
            didSet {
                if width! < ReferenceLine.minThresholdLevel {
                    // Cap the width value to the threshold level
                    width = ReferenceLine.minThresholdLevel
                }
            }
        }
        
        var horizontalDashPattern: [NSNumber]? = []
        var verticalDashPattern: [NSNumber]? = []
        
        var verticalFringeNegation: Float? = 0.0
        
        init(color: UIColor? = .white, 
             alpha: Float? = 0.5,
             width: Float? = 1.0,
             horizontalDashPattern: [NSNumber]? = [],
             verticalDashPattern: [NSNumber]? = [],
             verticalFringeNegation: Float? = 0.0) {
            self.color = color
            self.alpha = alpha
            self.width = width
            self.horizontalDashPattern = horizontalDashPattern
            self.verticalDashPattern = verticalDashPattern
            self.verticalFringeNegation = verticalFringeNegation
        }
    }
    
    var referenceFrame: ReferenceFrame?
    public struct ReferenceFrame {
        var left: Bool = true
        var right: Bool = false
        var top: Bool = false
        var bottom: Bool = true
        
        init() {
            self.left = true
            self.right = false
            self.top = false
            self.bottom = true
        }
    }
    
    var backgroundArea: BackgroundArea
    public struct BackgroundArea {
        struct Top {
            var color: UIColor? = .white
            var alpha: Float? = 1.0
            var gradient: CGGradient? = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])
            
            init(color: UIColor? = .white, 
                 alpha: Float? = 1.0,
                 gradient: CGGradient? = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])) {
                self.color = color
                self.alpha = alpha
                self.gradient = gradient
            }
        }
        
        struct Bottom {
            var color: UIColor? = .white
            var alpha: Float? = 1.0
            var gradient: CGGradient? = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])
            
            init(color: UIColor? = .white, 
                 alpha: Float? = 1.0,
                 gradient: CGGradient? = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray, locations: [0.0, 1.0])) {
                self.color = color
                self.alpha = alpha
                self.gradient = gradient
            }
        }
        
        var top: Top
        var bottom: Bottom
        
        init(top: Top, 
             bottom: Bottom) {
            self.top = top
            self.bottom = bottom
        }
    }
    
    var animation: Animation? = Animation(time: 0.4, type: LineAnimation.draw)
    public struct Animation {
        var time: Float
        var type: LineAnimation
    }
    
    public override init(frame: CGRect) {
        points = Points(interpolateNullValues: true)
        mainLine = MainLine()
        averageLine = BEMAverageLine_Swift(enableAverageLine: false)
        referenceLine = ReferenceLine()
        referenceFrame = ReferenceFrame()
        backgroundArea = BackgroundArea(top: .init(), bottom: .init())
        allPointValues = []
        
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        points = Points(interpolateNullValues: true)
        mainLine = MainLine()
        averageLine = BEMAverageLine_Swift(enableAverageLine: false)
        referenceLine = ReferenceLine()
        referenceFrame = ReferenceFrame()
        backgroundArea = BackgroundArea(top: .init(), bottom: .init())
        allPointValues = []
        
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    override public func draw(_ rect: CGRect) {
        // Drawing code
        layer.sublayers = nil
        
        let verticalReferenceLinesPath = UIBezierPath()
        let horizontalReferenceLinesPath = UIBezierPath()
        let referenceFramePath = UIBezierPath()
        
        verticalReferenceLinesPath.lineCapStyle = CGLineCap.butt
        verticalReferenceLinesPath.lineWidth = 0.7
        horizontalReferenceLinesPath.lineCapStyle = CGLineCap.butt
        horizontalReferenceLinesPath.lineWidth = 0.7
        referenceFramePath.lineCapStyle = CGLineCap.butt
        referenceFramePath.lineWidth = 0.7
        
        // Moves framing ref line slightly into view
        let offset: CGFloat = CGFloat(self.referenceLine!.width! / 4)
        
        // Bottom Line
        if self.referenceFrame!.bottom == true {
            referenceFramePath.move(to: CGPoint.init(x: 0, y: self.frame.size.height - offset))
            referenceFramePath.addLine(to: CGPoint.init(x: self.frame.size.width, y: self.frame.size.height - offset))
        }
        
        // Left Line 
        if self.referenceFrame!.left == true {
            referenceFramePath.move(to: CGPoint.init(x: 0 + offset, y: self.frame.size.height))
            referenceFramePath.addLine(to: CGPoint.init(x: 0 + offset, y: 0))
        }
        
        // Top Line
        if self.referenceFrame!.top == true {
            referenceFramePath.move(to: CGPoint.init(x: 0, y: offset))
            referenceFramePath.addLine(to: CGPoint.init(x: self.frame.size.width, y: offset))
        }
        
        // Right Line
        if self.referenceFrame!.right == true {
            referenceFramePath.move(to: CGPoint.init(x: self.frame.size.width - offset, y: self.frame.size.height))
            referenceFramePath.addLine(to: CGPoint.init(x: self.frame.size.width - offset, y: 0))
        }
        
        if referenceFrame!.right || referenceFrame!.left || referenceFrame!.top || referenceFrame!.bottom {
            if self.points.xAxisReferenceLines!.count > 0 {
                for xNumber: Int in self.points.xAxisReferenceLines! {
                    var xValue = Float(xNumber)
                    if referenceLine!.verticalFringeNegation! != 0.0 {
                        let index = self.points.xAxisReferenceLines!.index(of: xNumber)
                        if index == 0 {
                            // far left reference line
                            xValue += referenceLine!.verticalFringeNegation!
                        }
                        else if index == self.points.xAxisReferenceLines!.count - 1 {
                            // far right reference line
                            xValue -= referenceLine!.verticalFringeNegation!
                        }
                    }
                    let initialPoint = CGPoint.init(x: CGFloat(xValue), y: self.frame.size.height)
                    let finalPoint = CGPoint.init(x: CGFloat(xValue), y: 0)
                    verticalReferenceLinesPath.move(to: initialPoint)
                    verticalReferenceLinesPath.addLine(to: finalPoint)
                }
            }
            
            if self.points.yAxisReferenceLines!.count > 0 {
                for yNumber: Int in self.points.yAxisReferenceLines! {
                    let initialPoint = CGPoint.init(x: 0, y: CGFloat(yNumber))
                    let finalPoint = CGPoint.init(x: self.frame.size.width, y: CGFloat(yNumber))
                    horizontalReferenceLinesPath.move(to: initialPoint)
                    horizontalReferenceLinesPath.addLine(to: finalPoint)
                }
            }
        }
        
        var line = UIBezierPath()
        var fillTop: UIBezierPath!
        var fillBottom: UIBezierPath!
        let xIndexScale: CGFloat = self.frame.size.width / (CGFloat(self.points.values!.count) - 1)
        self.allPointValues = self.points.values!
        
        for index in 0 ... self.points.values!.count {
            var value = CGFloat(self.points.values![index].floatValue)
            if value >= BEMNullGraphValue && self.points.interpolateNullValues {
                // Need to interpolate. For midpoints, just don't add a point...
                if (index == 0) {
                    // Extrapolate a left edge point from next two actual values
                    var firstPos: Int = 1
                    
                    // Look for first real value
                    while firstPos < self.points.values!.count && CGFloat(self.points.values![firstPos].floatValue) >= BEMNullGraphValue {
                        firstPos += 1
                    }
                    
                    if firstPos >= self.points.values!.count {
                        break
                    }
                    
                    let firstValue: CGFloat = CGFloat(self.points.values![firstPos].floatValue)
                    var secondPos: Int = firstPos + 1
                    // Look for second real value
                    while secondPos < self.points.values!.count && CGFloat(self.points.values![secondPos].floatValue) >= BEMNullGraphValue {
                        secondPos += 1
                    }

                    if secondPos >= self.points.values!.count {
                        // Only one real number
                        value = firstValue
                    } else {
                        let delta: CGFloat = firstValue - CGFloat(self.points.values![secondPos].floatValue)
                        value = firstValue + CGFloat(firstPos) * delta / CGFloat(secondPos - firstPos)
                    }
                } else if index == self.points.values!.count-1 {
                    var firstPos: Int = index - 1
                    
                    // Look for first real value
                    while firstPos >= 0 && CGFloat(self.points.values![firstPos].floatValue) >= BEMNullGraphValue {
                        firstPos -= 1
                    }
                    
                    if firstPos < 0 {
                        // All NaNs?? =>don't create any line; should already be gone
                        continue
                    }
                    
                    let firstValue: CGFloat = CGFloat(self.points.values![firstPos].floatValue)
                    var secondPos: Int = firstPos - 1
                    
                    // Look for second real value
                    while secondPos >= 0 && CGFloat(self.points.values![secondPos].floatValue) >= BEMNullGraphValue {
                        secondPos -= 1
                    }
                    
                    if secondPos < 0 {
                        // only one real number
                        value = firstValue
                    } else {
                        let delta: CGFloat = firstValue - CGFloat(self.points.values![secondPos].floatValue)
                        value = firstValue + (CGFloat(self.points.values!.count - firstPos) - 1) * delta / CGFloat(firstPos - secondPos)
                    }
                    
                } else {
                    // Skip this (middle Null) point, let graphics handle interpolation
                    continue
                }
            }
            
            let newPoint = CGPoint(x: xIndexScale * CGFloat(index), y: value)
            self.allPointValues.append(NSValue(cgPoint: newPoint))
        }
        
        if self.mainLineEnabled == true && self.mainLine.curve! == MainLine.Curve.quadraticBezier {
            line = quadCurvedPathWithPoints(points: self.allPointValues, open: true)
            fillBottom = quadCurvedPathWithPoints(points: bottomPointsArray, open: false)
            fillTop = quadCurvedPathWithPoints(points: topPointsArray, open: false)
        } else if self.mainLineEnabled == true && self.mainLine.curve! == MainLine.Curve.straight {
            line = linesToPoints(points: self.allPointValues, open: true)
            fillBottom = linesToPoints(points: bottomPointsArray, open: false)
            fillTop = linesToPoints(points: topPointsArray, open: false)
        } else {
            fillBottom = linesToPoints(points: bottomPointsArray, open: false)
            fillTop = linesToPoints(points: topPointsArray, open: false)
        }
        
        //----------------------------//
        //----- Draw Fill Colors -----//
        //----------------------------//
        self.backgroundArea.top.color?.set()
        if let alphaValue = self.backgroundArea.top.alpha {
            fillTop.fill(with: CGBlendMode.normal, alpha: CGFloat(alphaValue))
        } else {
            fillTop.fill(with: CGBlendMode.normal, alpha: 1.0)
        }
        
        self.backgroundArea.bottom.color?.set()
        if let alphaValue = self.backgroundArea.bottom.alpha {
            fillBottom.fill(with: CGBlendMode.normal, alpha: CGFloat(alphaValue))
        } else {
            fillBottom.fill(with: CGBlendMode.normal, alpha: 1.0)
        }
        
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            if let topGradient = self.backgroundArea.top.gradient {
                context.saveGState()
                context.addPath(fillTop.cgPath)
                context.clip()
                context.drawLinearGradient(topGradient, start: CGPoint.zero, end: CGPoint(x: 0, y: fillTop.bounds.maxY), options: [])
                context.restoreGState()
            }
            
            if let bottomGradient = self.backgroundArea.bottom.gradient {
                context.saveGState()
                context.addPath(fillBottom.cgPath)
                context.clip()
                context.drawLinearGradient(bottomGradient, start: CGPoint.zero, end: CGPoint(x: 0, y: fillBottom.bounds.maxY), options: [])
                context.restoreGState()
            }
        }
        
        //----------------------------//
        //------ Animate Drawing -----//
        //----------------------------//
        if self.referenceLinesEnabled == true {
            let verticalReferenceLinesPathLayer = CAShapeLayer()
            verticalReferenceLinesPathLayer.frame = bounds
            verticalReferenceLinesPathLayer.path = verticalReferenceLinesPath.cgPath
            
            let horizontalReferenceLinesPathLayer = CAShapeLayer()
            horizontalReferenceLinesPathLayer.frame = bounds
            horizontalReferenceLinesPathLayer.path = horizontalReferenceLinesPath.cgPath
            
            if let lineAlpha = self.referenceLine?.alpha {
                verticalReferenceLinesPathLayer.opacity = lineAlpha
                horizontalReferenceLinesPathLayer.opacity = lineAlpha
            } else {
                verticalReferenceLinesPathLayer.opacity = 0.5
                horizontalReferenceLinesPathLayer.opacity = 0.5
            }
            
            if let lineColor = self.referenceLine?.color {
                verticalReferenceLinesPathLayer.strokeColor = lineColor.cgColor
                horizontalReferenceLinesPathLayer.strokeColor = lineColor.cgColor
            } else {
                verticalReferenceLinesPathLayer.strokeColor = UIColor.white.cgColor
                horizontalReferenceLinesPathLayer.strokeColor = UIColor.white.cgColor
            }
            
            if let lineWidth = self.referenceLine?.width {
                verticalReferenceLinesPathLayer.lineWidth = CGFloat(lineWidth)
                horizontalReferenceLinesPathLayer.lineWidth = CGFloat(lineWidth)
            } else {
                verticalReferenceLinesPathLayer.lineWidth = 0.5
                horizontalReferenceLinesPathLayer.lineWidth = 0.5
            }
            
            if let lineDashPattern = self.referenceLine?.verticalDashPattern {
                verticalReferenceLinesPathLayer.lineDashPattern = lineDashPattern
            }
            
            if let lineDashPattern = self.referenceLine?.horizontalDashPattern {
                horizontalReferenceLinesPathLayer.lineDashPattern = lineDashPattern
            }
            
            if let animationType = self.animation?.type {
                animate(shapeLayer: verticalReferenceLinesPathLayer, animationType: animationType, layerToAnimate: .referenceLine)
                animate(shapeLayer: horizontalReferenceLinesPathLayer, animationType: animationType, layerToAnimate: .referenceLine)
            }
            
            layer.addSublayer(verticalReferenceLinesPathLayer)
            layer.addSublayer(horizontalReferenceLinesPathLayer)
        }

        let referenceLinesPathLayer = CAShapeLayer()
        referenceLinesPathLayer.frame = bounds
        referenceLinesPathLayer.path = referenceFramePath.cgPath
        referenceLinesPathLayer.fillColor = nil
        
        if let lineAlpha = self.referenceLine?.alpha {
            referenceLinesPathLayer.opacity = lineAlpha
        } else {
            referenceLinesPathLayer.opacity = 0.5
        }
        
        if let lineWidth = self.referenceLine?.width {
            referenceLinesPathLayer.lineWidth = CGFloat(lineWidth)
        } else {
            referenceLinesPathLayer.lineWidth = 0.5
        }
        
        if let lineColor = self.referenceLine?.color {
            referenceLinesPathLayer.strokeColor = lineColor.cgColor
        } else {
            referenceLinesPathLayer.strokeColor = UIColor.white.cgColor
        }
        
        if let animationType = self.animation?.type {
            animate(shapeLayer: referenceLinesPathLayer, animationType: animationType, layerToAnimate: .referenceFrame)
        }
        
        layer.addSublayer(referenceLinesPathLayer)
        
        if self.mainLineEnabled == false {
            let pathLayer = CAShapeLayer()
            pathLayer.frame = bounds
            pathLayer.path = line.cgPath
            
            if let lineAlpha = self.mainLine.alpha {
                pathLayer.opacity = lineAlpha
            } else {
                pathLayer.opacity = 0.5
            }
            
            if let lineColor = self.mainLine.color {
                pathLayer.strokeColor = lineColor.cgColor
            } else {
                pathLayer.strokeColor = UIColor.white.cgColor
            }
            
            if let lineWidth = self.mainLine.width {
                pathLayer.lineWidth = CGFloat(lineWidth)
            } else {
                pathLayer.lineWidth = 0.5
            }
            
            pathLayer.fillColor = nil
            pathLayer.lineJoin = kCALineJoinBevel
            pathLayer.lineCap = kCALineCapRound
            
            if let animationType = self.animation?.type {
                animate(shapeLayer: pathLayer, animationType: animationType, layerToAnimate: .mainLine)
            }
            
            if self.mainLine.gradient != nil {
                layer.addSublayer(backgroundGradientLayer(shapeLayer: pathLayer))
            } else {
                layer.addSublayer(pathLayer)
            }
        }
        
        if self.averageLine.enableAverageLine == true {
            let averageLinePathLayer = CAShapeLayer()
            averageLinePathLayer.frame = self.bounds
            averageLinePathLayer.path = averageLinePath.cgPath
            averageLinePathLayer.fillColor = nil
            
            if let lineAlpha = self.averageLine.alpha {
                averageLinePathLayer.opacity = Float(lineAlpha)
            } else {
                averageLinePathLayer.opacity = 0.5
            }
            
            if let lineWidth = self.averageLine.width {
                averageLinePathLayer.lineWidth = CGFloat(lineWidth)
            } else {
                averageLinePathLayer.lineWidth = 0.5
            }
            
            if let lineDashPattern = self.averageLine.dashPattern {
                averageLinePathLayer.lineDashPattern = lineDashPattern
            }
            
            if let lineColor = self.averageLine.color {
                averageLinePathLayer.strokeColor = lineColor.cgColor   
            } else {
                averageLinePathLayer.strokeColor = UIColor.white.cgColor 
            }
            
            if let animationType = self.animation?.type {
                animate(shapeLayer: averageLinePathLayer, animationType: animationType, layerToAnimate: .averageLine)
            }
            
            self.layer.addSublayer(averageLinePathLayer)
        }
    }
    
    private var averageLinePath: UIBezierPath {
        let averageLinePath = UIBezierPath()
        if self.averageLine.enableAverageLine == true {
            averageLinePath.lineCapStyle = CGLineCap.butt
            averageLinePath.lineWidth = self.averageLine.width!
            let initialPoint = CGPoint.init(x: 0, y: self.averageLine.yValue!)
            let finalPoint = CGPoint.init(x: self.frame.size.width, y: self.averageLine.yValue!)
            averageLinePath.move(to: initialPoint)
            averageLinePath.addLine(to: finalPoint)
        }
        return averageLinePath
    }
    
    private var topPointsArray: [NSValue] {
        let topPointZero = CGPoint.init(x: 0, y: 0)
        let topPointFull = CGPoint.init(x:self.frame.size.width, y: 0)
        var topPoints = self.allPointValues
        topPoints.insert(NSValue(cgPoint: topPointZero), at: 0)
        topPoints.append(NSValue(cgPoint: topPointFull))
        return topPoints
    }
    
    private var bottomPointsArray: [NSValue] {
        let bottomPointZero = CGPoint.init(x:0, y: self.frame.size.height)
        let bottomPointFull = CGPoint.init(x:self.frame.size.width, y: self.frame.size.height)
        var bottomPoints = self.allPointValues
        bottomPoints.insert(NSValue(cgPoint: bottomPointZero), at: 0)
        bottomPoints.append(NSValue(cgPoint: bottomPointFull))
        return bottomPoints
    }
    
    private func linesToPoints(points: [NSValue], open: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let value = points[0]
        var p1 = value.cgPointValue
        
        path.move(to: p1)
        
        for point: NSValue in points {
            if point == value {
                // Already at first point
                continue
            }
            
            let p2 = point.cgPointValue
            if open && (p1.y >= BEMNullGraphValue || p2.y >= BEMNullGraphValue) {
                path.move(to: p2)
            } else {
                path.addLine(to: p2)
            }
            
            p1 = p2
        }
        
        return path
    }
    
    private func quadCurvedPathWithPoints(points: [NSValue], open: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let value = points[0]
        var p1 = value.cgPointValue
        
        path.move(to: p1)
        
        for point: NSValue in points {
            if point == value {
                // Already at first point
                continue
            }
            
            let p2 = point.cgPointValue
            if open && (p1.y >= BEMNullGraphValue || p2.y >= BEMNullGraphValue) {
                path.move(to: p2)
            } else {
                let middlePoint = midPoint(firstPoint: p1, secondPoint: p2)
                path.addQuadCurve(to: middlePoint, controlPoint: controlPoint(firstPoint: middlePoint, secondPoint: p1))
                path.addQuadCurve(to: p2, controlPoint: controlPoint(firstPoint: middlePoint, secondPoint: p2))
            }
            
            p1 = p2
        }
        
        return path
    }
    
    private func midPoint(firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
        var averageYValue = (firstPoint.y + secondPoint.y) / 2.0
        let averageXValue = (firstPoint.x + secondPoint.x) / 2.0
        if averageYValue.isInfinite == true {
            averageYValue = BEMNullGraphValue
        }
        return CGPoint.init(x: averageXValue, y: averageYValue)
    }
    
    private func controlPoint(firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
        var controlPoint = midPoint(firstPoint: firstPoint, secondPoint: secondPoint)
        let differenceY = CGFloat(fabs(secondPoint.y - controlPoint.y))
        
        if firstPoint.y < secondPoint.y {
            controlPoint.y += differenceY
        } else if firstPoint.y > secondPoint.y {
            controlPoint.y -= differenceY;
        }
        
        return controlPoint
    }
    
    private func animate(shapeLayer: CAShapeLayer, animationType: LineAnimation, layerToAnimate: LayerToAnimate) {
        switch animationType {
        case .none:
            return
        case .fade:
            let pathAnimation = CABasicAnimation(keyPath: LineAnimation.fade.rawValue)
            
            if let duration = self.animation?.time {
                pathAnimation.duration = Double(duration)
            } else {
                pathAnimation.duration = Double(0.4)
            }
            
            pathAnimation.fromValue = Int(0.0)
            
            var toValue = 1.0
            
            switch layerToAnimate {
            case .referenceFrame, .referenceLine:
                if let endValue = self.referenceLine?.alpha {
                    toValue = Double(endValue)
                }
            case .mainLine:
                if let endValue = self.mainLine.alpha {
                    toValue = Double(endValue)
                }
            case .averageLine:
                if let endValue = self.averageLine.alpha {
                    toValue = Double(endValue)
                }
            }
            
            pathAnimation.toValue = toValue
            
            shapeLayer.add(pathAnimation, forKey: LineAnimation.fade.rawValue)
            return
        case .draw:
            let pathAnimation = CABasicAnimation(keyPath: LineAnimation.draw.rawValue)
            
            if let duration = animation?.time {
                pathAnimation.duration = Double(duration)
            } else {
                pathAnimation.duration = Double(0.4)
            }
            
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            
            shapeLayer.add(pathAnimation, forKey: LineAnimation.draw.rawValue)
            
            return
        case .expand:
            let pathAnimation = CABasicAnimation(keyPath: LineAnimation.expand.rawValue)
            
            if let duration = animation?.time {
                pathAnimation.duration = Double(duration)
            } else {
                pathAnimation.duration = Double(0.4)
            }
            
            pathAnimation.fromValue = Int(0.0)
            pathAnimation.toValue = shapeLayer.lineWidth
            
            shapeLayer.add(pathAnimation, forKey: LineAnimation.expand.rawValue)
            
            return
        }

    }
    
    func backgroundGradientLayer(shapeLayer: CAShapeLayer) -> CALayer {
        if let gradient = self.mainLine.gradient {
            UIGraphicsBeginImageContext(self.bounds.size)
            let imageContext = UIGraphicsGetCurrentContext()
            var start: CGPoint
            var end: CGPoint
            if gradient.direction == LineGradientDirection.horizontal {
                start = CGPoint.init(x: 0, y: shapeLayer.bounds.midY)
                end = CGPoint.init(x: shapeLayer.bounds.maxX, y: shapeLayer.bounds.midY)
            } else {
                start = CGPoint.init(x: shapeLayer.bounds.midX, y: 0)
                end = CGPoint.init(x: shapeLayer.bounds.midX, y: shapeLayer.bounds.maxY)
            }
            
            imageContext!.drawLinearGradient(gradient.value, start: start, end: end, options: CGGradientDrawingOptions(rawValue: 0))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let gradientLayer = CALayer.init()
            gradientLayer.frame = self.bounds
            gradientLayer.contents = image!.cgImage
            gradientLayer.mask = shapeLayer
            return gradientLayer
        }
        
        return shapeLayer
    }
}
