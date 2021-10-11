//
//  TimerAnimationView.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 10.09.2021.
//

import UIKit

class TimerAnimationView: UIView {
    
    private let innerView: SoftUIView = {
        let view = SoftUIView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
        view.cornerRadius = 110
        view.type = .normal
        return view
    }()
    
    private let outterView: SoftUIView = {
        let view = SoftUIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.cornerRadius = 150
        view.type = .normal
        view.isSelected = true
        return view
    }()
    
    private let shapeLayer = CAShapeLayer()
    var isAnimationStarted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(innerView)
        addSubview(outterView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawForegroundLayer()
        
        let center = CGPoint(x: width / 2, y: height / 2)
        
        outterView.center = center
        innerView.center = center
        bringSubviewToFront(innerView)
    }
    
    private func drawForegroundLayer() {
        let center = CGPoint(x: width / 2, y: height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 25
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = Colors.selectedTintColor.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    func startAnimation(with timeInterval: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = timeInterval
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "basicAnimation")
        isAnimationStarted = true
    }
    
    func pauseAnimation(){
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    func resetAnimation() {
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        shapeLayer.strokeEnd = 0.0
        shapeLayer.removeAllAnimations()
        isAnimationStarted = false
    }
}
