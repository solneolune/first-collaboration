//
//  ArrowView.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 18.05.24.
//

import UIKit

class ArrowView: UIView {
    
    private let arrowLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        arrowLayer.strokeColor = UIColor.systemGray4.cgColor
        arrowLayer.fillColor = UIColor.systemGray4.cgColor
        arrowLayer.lineWidth = 2
        arrowLayer.lineCap = .round
        layer.addSublayer(arrowLayer)
        drawArrow()
    }
    
    private func drawArrow() {
        let path = UIBezierPath()
        
        let arrowBottomY = bounds.maxY
        path.move(to: CGPoint(x: bounds.midX - 5, y: arrowBottomY - 10))
        path.addLine(to: CGPoint(x: bounds.midX, y: arrowBottomY))
        path.addLine(to: CGPoint(x: bounds.midX + 5, y: arrowBottomY - 10))
        
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.midX, y: arrowBottomY - 10))
        
        let circleRadius: CGFloat = 3
        let circleCenter = CGPoint(x: bounds.midX, y: bounds.minY + circleRadius)
        path.addArc(withCenter: circleCenter,
                    radius: circleRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        
        arrowLayer.path = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawArrow()
    }
    
    func rotate(to angle: CGFloat) {
        let radians = angle * CGFloat.pi / 180
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}
