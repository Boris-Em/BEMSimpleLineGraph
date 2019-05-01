//
//  BEMGraphCalculator.swift
//  SimpleLineGraph
//
//  Created by Sam Spencer on 7/31/17.
//  Copyright © 2017 Samuel Spencer. All rights reserved.
//

import UIKit
import Foundation


/// There are multiple ways to find the area under the curve of a graph. `BEMIntegrationMethod` describes available methods for calculating this area.
/// - remark: Finding the area under the curve of a graph becomes especially useful when charting rate over time. For example, finding the area of a graph that displays the speed of a cyclist at certain times would produce the total distance the cyclist traveled.
/// - important: Integration is a concept in calculus allowing one to find the area under a curve. However, integration requires manipulating the function of a graph. Because `BEMSimpleLineGraphView` objects rely on data points and not functions, other area-finding methods (with varying levels of accuracy) are employed here.
/// - complexity: As a general rule, the more accurate an integration method, the more computationally intense it may be.
public enum IntegrationMethod {
    /// Calculates area by finding the sum of all left–hand rectangles under each data point. This method gives the exact area when the graph's curve is constant. Low intensity computation.
    case leftReimannSum
    /// Calculates area by finding the sum of all right–hand rectangles under each data point. This method gives the exact area when the graph's curve is constant. Low intensity computation.
    case rightReimannSum
    /// Calculates area by finding the sum of all trapezoids under each data point. This method gives the exact area when the graph's curve is constant or linear. Moderate intensity computation.
    case trapezoidalSum
    /// Calculates area by finding the sum of all parabolas under each data point. This method gives the exact area when the graph's curve is constant, linear, quadratic, or cubic. Moderate intensity computation.
    case parabolicSimpsonSum
}


/// There are multiple methods to determine the correlation between points on a graph; `BEMCorrelationMethod` describes available methods for determining this coefficient.
/// - complexity: The greater the number of points on the given graph, the longer it may take to determine a correlation for those points.
public enum CorrelationMethod {
    /// Calculates the correlation coefficent for the graph using the common Pearson Correlation Method.
    case pearson
}


/// When calculating a correlation coefficient with the Pearson Correlation Method, `BEMGraphCalculator` can provide more general feedback as to the strength of the correlation.
public enum PearsonCorrelationStrength {
    /// Positive correlation value: 1.00 : 0.95
    case perfectPositive
    /// Positive correlation value: 0.94 : 0.50
    case strongPositive
    /// Positive correlation value: 0.49 : 0.06
    case weakPositive
    /// Positive correlation value: 0.05 : -0.05
    case none
    /// Positive correlation value: -0.06 : -0.49
    case weakNegative
    /// Positive correlation value: -0.50 : -0.94
    case strongNegative
    /// Positive correlation value: -0.95 : -1.00
    case perfectNegative
}


/// Calculation type to perform on the given data set or graph.
public enum Calculation {
    case sum
    case average
    case median
    case mode
    case minimum
    case maximum
    case standardDeviation
}



/** Makes calculations given for a specific graph object. 

Supply a graph object to the calculator to perform operations with that graph's data. Calculations may include the following:  
  - Average value of points  
  - Sum of points  
  - Median of points  
  - Mode of points  
  - Graph standard deviation  
  - Minimum point value on graph  
  - Maximum point value on graph  
  - Area under the curve of a graph  
  - Correlation of data points */
public class BEMGraphCalculator_Swift: NSObject {
    
    
    public static let sharedCalculator = BEMGraphCalculator_Swift()
    
    private var calculationQueue: OperationQueue = OperationQueue()
    
    
    // MARK: - Object Lifecycle - 
    
    
    private override init() {
        super.init()
        
        calculationQueue = OperationQueue()
        calculationQueue.qualityOfService = QualityOfService.userInitiated
    }
    
    
    // MARK: - Essential Calculations -
    
    private func dataPoints(_ graph: LineGraph) -> [NSNumber] {
        let filter = NSPredicate.init { (evaluatedObject: Any?, bindings: [String : Any]?) -> Bool in
            let value: NSNumber = evaluatedObject as! NSNumber
            let retValue: Bool = !(value.isEqual(to: NSNumber(value: Float(NullGraphValue))))
            return retValue
        }
        
        let graphPoints: NSArray = graph.graphValuesForDataPoints as NSArray
        let filteredPoints = graphPoints.filtered(using: filter)
        return filteredPoints as! [NSNumber]
    }
    
    public func perform(simpleCalculation: Calculation, graph: LineGraph) -> NSNumber {
        switch simpleCalculation {
        case .average:
            return calculatePointValueAverage(graph)
        case .sum:
            return calculatePointValueSum(graph)
        case .median:
            return calculatePointValueMedian(graph)
        case .mode:
            return calculatePointValueMode(graph)
        case .minimum:
            return calculateMinimumPointValue(graph)
        case .maximum:
            return calculateMaximumPointValue(graph)
        case .standardDeviation:
            return calculateStandardDeviation(graph)
        }
    }
    
    
    // MARK: - Basic Statistics -
    
    
    /** Calculates the average (mean) of all points on the line graph.
     - returns: The average (mean) number of the points on the graph. Originally a float. */
    private func calculatePointValueAverage(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "average:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil)
        
        if value != nil {
            return value as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    /** Calculates the sum of all points on the line graph.
     - returns: The sum of the points on the graph. Originally a float. */
    private func calculatePointValueSum(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "sum:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil)
        
        if value != nil {
            return value as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    /** Calculates the median of all points on the line graph.
     - returns: The median number of the points on the graph. Originally a float. */
    private func calculatePointValueMedian(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "median:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil)
        
        if value != nil {
            return value as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    /** Calculates the mode of all points on the line graph.  
     - returns: The mode number of the points on the graph. Originally a float. */
    private func calculatePointValueMode(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "mode:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil) as! NSArray
        
        if value.firstObject != nil {
            return value.firstObject as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    // MARK: - Minimum / Maximum -
    
    
    /** Calculates the minimum value of all points on the line graph.
     - returns: The minimum number of the points on the graph. Originally a float. */
    private func calculateMinimumPointValue(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "min:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil)
        
        if value != nil {
            return value as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    /** Calculates the maximum value of all points on the line graph.
     - returns: The maximum value of the points on the graph. Originally a float. */
    private func calculateMaximumPointValue(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "max:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil)
        
        if value != nil {
            return value as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    // MARK: - Standard Deviation -
    
    
    /** Calculates the standard deviation of all points on the line graph.
     - returns: The standard deviation of the points on the graph. Originally a float. */
    private func calculateStandardDeviation(_ graph: LineGraph) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        let expression = NSExpression.init(forFunction: "stddev:", arguments: [[NSExpression.init(forConstantValue: filteredPoints)]])
        let value = expression.expressionValue(with: nil, context: nil)
        
        if value != nil {
            return value as! NSNumber
        } else {
            return NSNumber(value: 0)
        }
    }
    
    
    // MARK: - Integration -
    
    
    /** Calculates the area under the curve of the graph.
     - returns: The area under the curve of the graph. Accuracy varies based on selected integration method. Originally a float. */
    public func calculateArea(integrationMethod: IntegrationMethod, graph: LineGraph, xAxisScale: NSNumber) -> NSNumber {
        let filteredPoints = dataPoints(graph)
        if filteredPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        switch integrationMethod {
        case .leftReimannSum:
            return leftReimannSumIntegration(points: filteredPoints, scale: xAxisScale)
        case .rightReimannSum:
            return rightReimannSumIntegration(points: filteredPoints, scale: xAxisScale)
        case .trapezoidalSum:
            return trapezoidalSumIntegration(points: filteredPoints, scale: xAxisScale)
        case .parabolicSimpsonSum:
            return parabolicSimpsonSumIntegration(points: filteredPoints, scale: xAxisScale)
        }
    }
    
    private func leftReimannSumIntegration(points: [NSNumber], scale: NSNumber) -> NSNumber {
        var totalArea = NSNumber(value: 0)
        
        var newPoints = points
        newPoints.removeLast()
        
        for yValue: NSNumber in newPoints {
            let newAreaUnit = NSNumber(value: yValue.floatValue * scale.floatValue)
            totalArea = NSNumber(value: totalArea.floatValue + newAreaUnit.floatValue)
        }
        
        return totalArea
    }
    
    private func rightReimannSumIntegration(points: [NSNumber], scale: NSNumber) -> NSNumber {
        var totalArea = NSNumber(value: 0)
        
        var newPoints = points
        newPoints.removeFirst()
        
        for yValue: NSNumber in newPoints {
            let newAreaUnit = NSNumber(value: yValue.floatValue * scale.floatValue)
            totalArea = NSNumber(value: totalArea.floatValue + newAreaUnit.floatValue)
        }
        
        return totalArea
    }
    
    private func trapezoidalSumIntegration(points: [NSNumber], scale: NSNumber) -> NSNumber {
        let left = leftReimannSumIntegration(points: points, scale: scale)
        let right = rightReimannSumIntegration(points: points, scale: scale)
        let trapezoidal = NSNumber(value: (left.floatValue + right.floatValue)/2)
        
        return trapezoidal
    }
    
    private func parabolicSimpsonSumIntegration(points: [NSNumber], scale: NSNumber) -> NSNumber {
        // If there are two or fewer points on the graph, no parabolic curve can be created. Thus, the next most accurate method will be employed: a trapezoidal summation
        if points.count <= 2 {
            return trapezoidalSumIntegration(points: points, scale: scale)
        }
        
        // If there are only three points in the array, do a simple single parabolic calculation
        if points.count == 3 {
            let firstPoint = points.first
            let thirdPoint = points.last
            let midPoint = points[1]
            
            let graphArea = NSNumber(value:((firstPoint!.floatValue + (midPoint.floatValue * thirdPoint!.floatValue) + thirdPoint!.floatValue)/3) * scale.floatValue)
            return graphArea
        }
        
        // The submitted graph has not met the above two conditions and thus has more than three points
        var totalArea = NSNumber(value: 0)
        
        // Get all the points from the graph into a mutable array
        var mutablePoints = points
        
        // Because the parabolic calculation works in sets of threes, we need to check if the data set has any remainders after dividing by three
        if (mutablePoints.count % 3) == 1 {
            let firstPoint = mutablePoints.first
            
            let newAreaUnit = NSNumber(value:firstPoint!.floatValue * scale.floatValue)
            totalArea = NSNumber(value:totalArea.floatValue + newAreaUnit.floatValue)
            
            mutablePoints.removeFirst()
        } else if (mutablePoints.count % 3) == 2 {
            let firstPoint = mutablePoints.first
            let secondPoint = mutablePoints[1]
            
            let newAreaUnit = NSNumber(value:((firstPoint!.floatValue + secondPoint.floatValue) * scale.floatValue)/2)
            totalArea = NSNumber(value:totalArea.floatValue + newAreaUnit.floatValue)
            
            mutablePoints.removeFirst(2)
        }
        
        let first = 0
        let last = mutablePoints.count
        let interval = 3
        
        let sequence = stride(from: first, to: last, by: interval)
        
        for index in sequence {
            let firstPoint = mutablePoints[index]
            let secondPoint = mutablePoints[index+1]
            let thirdPoint = mutablePoints[index+2]
            
            let parabolaArea = NSNumber(value:((firstPoint.floatValue + (secondPoint.floatValue * thirdPoint.floatValue) + thirdPoint.floatValue)/3) * scale.floatValue)
            totalArea = NSNumber(value:totalArea.floatValue + parabolaArea.floatValue)
        }
        
        return totalArea
    }
    
    
    // MARK: - Correlation -
    
    
    /** Calculates a correlation coefficient for the data points on the graph.
     - returns: A correlation coefficient, calculated from the graph's data points. Float value between -1.0 and 1.0. A value of -1.0 is a perfect negative correlation. A value of 1.0 is a perfect positive correlation. A value of 0.0 means that no correlation exists. */
    public func calculateCorrelationCoefficient(correlationMethod: CorrelationMethod, graph: LineGraph, xAxisScale: NSNumber) -> NSNumber {
        // Grab the x and y points
        // Because a BEMSimpleLineGraph object simply increments X-Values, we must calculate the values here
        let yPoints = dataPoints(graph)
        if yPoints.count <= 0 {
            return NSNumber(value: 0)
        }
        
        var xPoints = yPoints
        
        if xAxisScale == 0 {
            for index in 1...yPoints.count {
                xPoints.append(NSNumber(value:index))
            }
        } else {
            for index in 1...yPoints.count {
                xPoints.append(NSNumber(value:(Float(index) * xAxisScale.floatValue)))
            }
        }
        
        // Set the initial values of our sum counts
        let pointsCount = yPoints.count
        var sumY: Float = 0.0
        var sumX: Float = 0.0
        var sumXY: Float = 0.0
        var sumX2: Float = 0.0
        var sumY2: Float = 0.0
        
        var iterationCount = 0
        for yPoint in yPoints {
            let xPoint = xPoints[iterationCount]
            iterationCount += 1
            
            // Sum up x, y, x2, y2 and xy
            sumX = sumX + xPoint.floatValue
            sumY = sumY + yPoint.floatValue
            sumXY = sumXY + (xPoint.floatValue * yPoint.floatValue)
            sumX2 = sumX2 + (xPoint.floatValue * xPoint.floatValue)
            sumY2 = sumY2 + (yPoint.floatValue * yPoint.floatValue)
        }
        
        // Calculate the correlational value
        let numeratorFirstChunk = (Float(pointsCount) * sumXY)
        let numeratorSecondChunk = (sumX * sumY)
        let denomenatorFirstChunk = sqrt(Float(pointsCount) * sumX2 - (sumX * sumX))
        let denomenatorSecondChunk = sqrt(Float(pointsCount) * sumY2 - (sumY * sumY))
        let correlation = (numeratorFirstChunk - numeratorSecondChunk) / (denomenatorFirstChunk * denomenatorSecondChunk)
        
        return NSNumber(value:correlation)
    }
    
    
    /** Calculates a correlation coefficient and returns the general strength of the correlation, based on the data points on the given graph object.
     @return The strength of the calculated correlation coefficient; calculated from the graph's data points. This method assumes the Pearson Correlation Method. */
    public func calculatePearsonCorrelationStrength(graph: LineGraph, xAxisScale: NSNumber) -> PearsonCorrelationStrength {
        let correlationCoefficient = calculateCorrelationCoefficient(correlationMethod: .pearson, graph: graph, xAxisScale: xAxisScale)
        let actualRValue = correlationCoefficient.floatValue
        
        if actualRValue >= 0.95 {
            return .perfectPositive
        } else if actualRValue < 0.95 && actualRValue >= 0.50 {
            return .strongPositive
        } else if actualRValue < 0.50 && actualRValue > 0.05 {
            return .weakPositive
        } else if actualRValue <= 0.05 && actualRValue >= -0.05 {
            return .none
        } else if actualRValue < -0.05 && actualRValue > -0.50 {
            return .weakNegative
        } else if actualRValue <= -0.50 && actualRValue > -0.95 {
            return .strongNegative
        } else if actualRValue <= -0.95 {
            return .perfectNegative
        } else {
            return .none
        }
    }
    
    
    /** Calculates a correlation coefficient and returns the general strength of the correlation, based on the data points on the given graph object.
     - returns: The strength of the calculated correlation coefficient; calculated from the graph's data points. This method assumes the Pearson Correlation Method. */
    public func calculatePearsonCorrelationStrength(graph: LineGraph) -> PearsonCorrelationStrength {
        return calculatePearsonCorrelationStrength(graph: graph, xAxisScale: NSNumber(value:0))
    }
    
    
    /** Calculates a correlation coefficient for the data points between two sets of data; one set to be assigned as the X values and the other as Y values.
     - returns: A correlation coefficient, calculated from the graph's data points. Float value between -1.0 and 1.0. A value of -1.0 is a perfect negative correlation. A value of 1.0 is a perfect positive correlation. A value of 0.0 means that no correlation exists. */
    public func calculateCorrelationCoefficient(correlationMethod: CorrelationMethod, graph: LineGraph, xAxisData: [NSNumber], yAxisData: [NSNumber]) -> NSNumber {
        // Set the initial values of our sum counts
        let pointsCount = yAxisData.count
        var sumY: Float = 0.0
        var sumX: Float = 0.0
        var sumXY: Float = 0.0
        var sumX2: Float = 0.0
        var sumY2: Float = 0.0
        
        var iterationCount = 0
        for yPoint in yAxisData {
            let xPoint = xAxisData[iterationCount]
            iterationCount += 1
            
            // Sum up x, y, x2, y2 and xy
            sumX = sumX + xPoint.floatValue
            sumY = sumY + yPoint.floatValue
            sumXY = sumXY + (xPoint.floatValue * yPoint.floatValue)
            sumX2 = sumX2 + (xPoint.floatValue * xPoint.floatValue)
            sumY2 = sumY2 + (yPoint.floatValue * yPoint.floatValue)
        }
        
        // Calculate the correlational value
        let numeratorFirstChunk = (Float(pointsCount) * sumXY)
        let numeratorSecondChunk = (sumX * sumY)
        let denomenatorFirstChunk = sqrt(Float(pointsCount) * sumX2 - (sumX * sumX))
        let denomenatorSecondChunk = sqrt(Float(pointsCount) * sumY2 - (sumY * sumY))
        let correlation = (numeratorFirstChunk - numeratorSecondChunk) / (denomenatorFirstChunk * denomenatorSecondChunk)
        
        return NSNumber(value:correlation)
    }
    
    public func calculatePearsonCorrelationStrength(graph: LineGraph, xAxisData: [NSNumber], yAxisData: [NSNumber]) -> PearsonCorrelationStrength {
        let correlationCoefficient = calculateCorrelationCoefficient(correlationMethod: .pearson, graph: graph, xAxisData: xAxisData, yAxisData: yAxisData)
        let actualRValue = correlationCoefficient.floatValue
        
        if actualRValue >= 0.95 {
            return .perfectPositive
        } else if actualRValue < 0.95 && actualRValue >= 0.50 {
            return .strongPositive
        } else if actualRValue < 0.50 && actualRValue > 0.05 {
            return .weakPositive
        } else if actualRValue <= 0.05 && actualRValue >= -0.05 {
            return .none
        } else if actualRValue < -0.05 && actualRValue > -0.50 {
            return .weakNegative
        } else if actualRValue <= -0.50 && actualRValue > -0.95 {
            return .strongNegative
        } else if actualRValue <= -0.95 {
            return .perfectNegative
        } else {
            return .none
        }
    }
}
