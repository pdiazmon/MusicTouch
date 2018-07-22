//
//  MTAudioEqualizer.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/7/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class MTAudioEqualizer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// Color of activity indicator view.
    @IBInspectable public var color: UIColor = UIColor.white
    
    /// Padding of activity indicator view.
    @IBInspectable public var padding: CGFloat = 0
    
    /// Current status of animation, read-only.
    private(set) public var isAnimating: Bool = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }

    public init(frame: CGRect, color: UIColor? = nil, padding: CGFloat? = nil) {
        self.color   = color   ?? UIColor.clear
        self.padding = padding ?? 0
        super.init(frame: frame)
        isHidden = true
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public override var bounds: CGRect {
        didSet {
            // setup the animation again for the new bounds
            if oldValue != bounds && isAnimating {
                setUpAnimation()
            }
        }
    }
    
    /**
     Start animating.
     */
    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
    }
    
    /**
     Stop animating.
     */
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }

    private final func setUpAnimation() {
        layer.sublayers = nil

        setUpAnimation(size: frame.size, color: color, number: 6)
    }
    
    func randomStep() -> Double { return Double.random(in: -0.2...0.2) }
    
    func durations(_ number: Int) -> [CFTimeInterval] {
        var ret: [CFTimeInterval] = []
        let max = 2.5
        let min = 4.5
        let step = Double((min - max) / Double(number / 2))
        
        if (number % 2 == 1) {
            let center = abs(number/2) + 1
            
            var left: [CFTimeInterval] = []
            var right: [CFTimeInterval] = []
            for i in 0..<(center-1) {
                let value = Double(min - Double(i) * step)
                left  = left + [ value + randomStep() ]
                right = [ value + randomStep() ] + right
            }

            ret = left + [max + randomStep()] + right
            
        }
        else {
            let center = (centerl: number/2, centerr: number/2+1)
            
            var left: [CFTimeInterval] = []
            var right: [CFTimeInterval] = []
            for i in 0..<(center.centerl-1) {
                let value = Double(min - Double(i) * step)
                left  = left + [ value + randomStep() ]
                right = [ value + randomStep() ] + right
            }
            
            ret = left + [max + randomStep(), max + randomStep()] + right
            
        }
        
        return ret
    }
    
    
    func setUpAnimation(size: CGSize, color: UIColor, number: Int) {
        let lineSize = (size.width / CGFloat(number))
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        
        let duration: [CFTimeInterval] = durations(number)
        
        // Height animation values
        let values = [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.9, 0.4, 0.15, 0.18, 0.75, 0.01]
        
        // Draw lines
        for i in 0 ..< number {
            // An object that provides keyframe animation capabilities for a layer object.
            let animation = CAKeyframeAnimation()
            
            animation.keyPath = "path"
            // If true, the value specified by the animation will be added to the current render tree value of the property to produce the new render tree value. The addition function is type-dependent, e.g. for affine transforms the two matrices are concatenated
            animation.isAdditive = true
            animation.values = []
            
            // For any bar and any height animation value
            for j in 0 ..< values.count {
                let heightFactor = values[j]
                // Bar max height
                let height = size.height * CGFloat(heightFactor)
                // Upper bar point
                let point = CGPoint(x: 0, y: size.height - height)
                // A path that consists of straight and curved line segments that you can render in your custom views.
                let path = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: lineSize, height: height)))
                
                // For any height animation, add it
                animation.values?.append(path.cgPath)
            }
            
            // Set bar animation duration
            animation.duration = duration[i]
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false

            // Get a new CALayer for the bar
            let line = layerWith(size: CGSize(width: lineSize, height: size.height), color: color)
            
            // Set the bar frame within the view
            let frame = CGRect(x: x + lineSize * CGFloat(i), // PD: Coloca en el eje X
                y: y, // PD -
                width: lineSize, // PD - Anchura de la barra
                height: size.height) // PD - Altura será la máxima de una barra
            
            line.frame = frame
            line.add(animation, forKey: "animation")
            
            layer.addSublayer(line)
        }
    }
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath  = UIBezierPath()

        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                            cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor
        layer.opacity = 0.4

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        layer.shadowColor   = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset  = CGSize.zero
        layer.shadowRadius  = 5
        
        return layer
    }
}
