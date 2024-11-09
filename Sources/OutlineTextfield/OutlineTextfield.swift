// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

@available(iOS 13.0, *)
public class OutlinedTextfield: UITextField{
    
    ///цвет обводки
    public var outlineColor: UIColor = .black { didSet { setNeedsDisplay() } }
    ///цвет placeholder
    public var placeholderColor: UIColor = .placeholderText { didSet { layoutSubviews() } }
    ///цвет текста, когда он в аутлайне
    public var outlinedPlaceholderColor: UIColor = .black
    ///ширина линии
    public var lineWidth: CGFloat = 2 { didSet { setNeedsDisplay() } }
    ///отступ текста слева
    public var leftTextInset: CGFloat = 3
    ///отступ текста справа
    public var rightTextInset: CGFloat = 3
    /**
     Поведение placeholder
     - Parameter .floating: уплывает наверх при редактировании
     - Parameter .hide: прячется при редактировании
     */
    public var placeholderBehavior: PlaceHolderBehaviour = .floating
    ///радиус скругления
    public var outlineCornerRadius: CGFloat = 7 {
            willSet { updateOutlineCorners(to: newValue) }
            didSet { if placeholderBehavior == .floating {
                constraintPlaceholderToTop()
            } }
        }
    ///шрифт placeholder
    public var placeholderFont = UIFont.systemFont(ofSize: 18)
    ///шрифт placeholder когда он outlined, только при .floating
    public var outlinedPlaceholderFont = UIFont.systemFont(ofSize: 12)
    
    public override var placeholder: String? { didSet { updatePlaceholder() } }
    public override var text: String? { didSet { textFieldDidChange() } }
    
    private var isOutlined = false
    private var outlineLayer = CAShapeLayer()
    private var placeholderLabel = UILabel()
    private var outlineStartStroke: CGFloat {
        guard (self.placeholder ?? "").isEmpty == false else { return 0 }
        placeholderLabel.setNeedsLayout()
        placeholderLabel.layoutIfNeeded()
        return (placeholderLabel.bounds.width + (outlineLayer.path?.currentPoint.x ?? 0) - outlineCornerRadius + 6) / (outlineLayer.path?.length ?? 0)
    }
    
    private var topPlaceholderConstraint: NSLayoutConstraint!
    private var centerYPlaceholderConstraint: NSLayoutConstraint!
    private var bottomPlaceholderConstraint: NSLayoutConstraint!
    private var leadingPlaceholderConstraint: NSLayoutConstraint!
    
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createPlaceHolderLabel()
        self.layer.addSublayer(outlineLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Implementation
    
    public override func draw(_ rect: CGRect) {
        let newRect = CGRect(x: lineWidth/2, y: lineWidth/2, width: rect.width - lineWidth, height: rect.height - lineWidth)
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: outlineCornerRadius)
        path.lineWidth = lineWidth
        outlineLayer.path = path.cgPath
        outlineLayer.lineWidth = lineWidth
        outlineLayer.fillColor = UIColor.clear.cgColor
        outlineLayer.strokeColor = outlineColor.cgColor
    }
    
    public override func drawPlaceholder(in rect: CGRect) {

    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: lineWidth + leftTextInset, bottom: 0, right: lineWidth + rightTextInset))
    }
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: lineWidth + leftTextInset, bottom: 0, right: lineWidth + rightTextInset))
    }
    
    //MARK: - Placeholder label
    
    private func createPlaceHolderLabel(){
        self.addSubview(placeholderLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        topPlaceholderConstraint = placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor)
        bottomPlaceholderConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        leadingPlaceholderConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leftTextInset+lineWidth)
        centerYPlaceholderConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: self.topAnchor)
        NSLayoutConstraint.activate([topPlaceholderConstraint, bottomPlaceholderConstraint, leadingPlaceholderConstraint])
        constraintPlaceholderToSelf()
        
        placeholderLabel.textAlignment = .left
        placeholderLabel.textColor = placeholderColor
    }
    
    private func updatePlaceholder(){
        let start = outlineStartStroke
        placeholderLabel.text = self.placeholder
        if isOutlined{
            placeholderLabel.setNeedsLayout()
            placeholderLabel.layoutIfNeeded()
        }
        let end = outlineStartStroke
        if isOutlined { resizeOutline(from: start, to: end) }
    }
    
    private func constraintPlaceholderToSelf(){
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            topPlaceholderConstraint.isActive = true
            bottomPlaceholderConstraint.isActive = true
            leadingPlaceholderConstraint.isActive = true
            centerYPlaceholderConstraint.isActive = false
            
            topPlaceholderConstraint.constant = 0
            bottomPlaceholderConstraint.constant = 0
            leadingPlaceholderConstraint.constant = lineWidth + leftTextInset + 7
            self.layoutIfNeeded()
        })
    }
    
    private func constraintPlaceholderToTop(){
        guard isOutlined else { return }
        let leading = outlineLayer.path?.currentPoint.x ?? 0 //точка начала пути
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            topPlaceholderConstraint.isActive = false
            centerYPlaceholderConstraint.isActive = true
            bottomPlaceholderConstraint.isActive = false
            leadingPlaceholderConstraint.isActive = true
        
            topPlaceholderConstraint.constant = -5
            centerYPlaceholderConstraint.constant = lineWidth/2
            bottomPlaceholderConstraint.constant = 0
            leadingPlaceholderConstraint.constant = leading + 2 * sqrt(outlineCornerRadius)
            self.layoutIfNeeded()
        })
    }
    
    
    
    //MARK: - Outline
    
    private func makeOutlined(animated: Bool = true){
        UIView.animate(withDuration: animated ? 0.2 : 0, animations: { [unowned self] in
            placeholderLabel.textColor = outlinedPlaceholderColor
        })
        placeholderLabel.font = outlinedPlaceholderFont
        placeholderLabel.setNeedsLayout()
        placeholderLabel.layoutIfNeeded()
        if !isOutlined { resizeOutline(from: 0, to: outlineStartStroke) }
        isOutlined = true
        constraintPlaceholderToTop()
    }

    private func resizeOutline(from start: CGFloat, to end: CGFloat){
        let anim = CABasicAnimation(keyPath: "strokeStart")
        anim.fromValue = start
        anim.toValue = end
        anim.duration = 0.2
        
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        outlineLayer.strokeStart = end
        outlineLayer.add(anim, forKey: "strokeStart")
    }
    
    private func updateOutlineCorners(to newCornerRadius: CGFloat){
        let oldPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: outlineCornerRadius).cgPath
        let newPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: newCornerRadius).cgPath
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = oldPath
        anim.toValue = newPath
        anim.duration = 0.2
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        outlineLayer.add(anim, forKey: "path")
        outlineLayer.path = newPath
    }
    //MARK: - TextField
    private func textFieldDidChange() {
        if placeholderBehavior == .hide{
            if let text = self.text, !text.isEmpty {
                placeholderLabel.isHidden = true
            }
            else{
                placeholderLabel.isHidden = false
            }
        }
        else{
            if isOutlined == false{
                makeOutlined(animated: false)
            }
        }
    }
    
    public override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if placeholderBehavior == .floating, self.text?.isEmpty ?? true{
            makeOutlined()
        }
        return result
    }
    
    public override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if placeholderBehavior == .floating, self.text?.isEmpty ?? false{
            
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                placeholderLabel.textColor = placeholderColor
            })
            placeholderLabel.font = placeholderFont
            placeholderLabel.setNeedsLayout()
            placeholderLabel.layoutIfNeeded()
            if isOutlined { resizeOutline(from: outlineStartStroke, to: 0) }
            isOutlined = false
            constraintPlaceholderToSelf()
        }
        return result
    }
}

extension CGPath {
    var length: CGFloat {
        var totalLength: CGFloat = 0
        var previousPoint: CGPoint?

        self.applyWithBlock { element in
            let points = element.pointee.points
            guard let prev = previousPoint else {
                return element.pointee.type == .moveToPoint ? previousPoint = points[0] : ()
            }

            switch element.pointee.type {
            case .addLineToPoint:
                totalLength += distance(from: prev, to: points[0])
                previousPoint = points[0]

            case .addCurveToPoint:
                totalLength += cubicCurveLength(from: prev, to: points[2], control1: points[0], control2: points[1])
                previousPoint = points[2]

            default: break
            }
        }
        return totalLength
    }

    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat { hypot(p2.x - p1.x, p2.y - p1.y) }

    private var subdivisions: Int { 50 }

    private func cubicCurveLength(from start: CGPoint, to end: CGPoint, control1: CGPoint, control2: CGPoint) -> CGFloat {
        var length: CGFloat = 0.0
        var previousPoint = start

        for i in 1...subdivisions {
            let t = CGFloat(i) / CGFloat(subdivisions)
            let x = pow(1.0 - t, 3) * start.x + 3.0 * pow(1.0 - t, 2) * t * control1.x + 3.0 * (1.0 - t) * pow(t, 2) * control2.x + pow(t, 3) * end.x
            let y = pow(1.0 - t, 3) * start.y + 3.0 * pow(1.0 - t, 2) * t * control1.y + 3.0 * (1.0 - t) * pow(t, 2) * control2.y + pow(t, 3) * end.y
            let currentPoint = CGPoint(x: x, y: y)
            length += distance(from: previousPoint, to: currentPoint)
            previousPoint = currentPoint
        }
        return length
    }
}

public enum PlaceHolderBehaviour{
    case floating
    case hide
}
