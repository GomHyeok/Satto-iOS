//
//  ScoreArcView.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/12/25.
//

import UIKit
import DesignSystem

final class ScoreArcView: UIView {
    
    var score: CGFloat = 75 { // 0 ~ 100
        didSet {
            setNeedsLayout()
        }
    }
    
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let backgroundLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backgroundLayer)
        
        fillLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(fillLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insetBounds = bounds.inset(by: contentInsets)
        
        let centerPoint = CGPoint(x: insetBounds.midX, y: insetBounds.maxY)
        let radius = insetBounds.width / 2 - backgroundLayer.lineWidth / 2

        let startAngle = CGFloat.pi
        let endAngle = 0.0
        
        let backgroundPath = UIBezierPath(arcCenter: centerPoint,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: true)
        backgroundLayer.path = backgroundPath.cgPath

        let scoreRatio = score / 100.0
        let fillEndAngle = startAngle * (scoreRatio-1)
        
        let fillPath = UIBezierPath(arcCenter: centerPoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: fillEndAngle,
                                    clockwise: true)
        fillLayer.path = fillPath.cgPath
    }
    
    public func update(background : UIColor, fill: UIColor, lineWidth: CGFloat, lineCap: CAShapeLayerLineCap ) {
        backgroundLayer.strokeColor = background.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = lineCap
        
        fillLayer.strokeColor = fill.cgColor
        fillLayer.lineWidth = (lineWidth + 2)
        backgroundLayer.lineCap = lineCap
    }
}
