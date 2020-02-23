import UIKit

class SketchView: UIView {
    
    var drawColor:UIColor = .black
    var lineWidth: CGFloat = 2.0
    var canvasRect: CGRect?
    var tmpImage: UIImage?
    var imageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.image = makeCanvas()
        self.tmpImage = self.imageView.image
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView!)
    }
    
    private func makeCanvas() -> UIImage {
        
        let canvasSize = CGSize(width: self.frame.width, height: self.frame.height)
        let canvasRect = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        UIColor.white.setFill()
        UIRectFill(canvasRect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    private func drawStroke(context: CGContext, touch: UITouch) {
        
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)

        drawColor.setStroke()
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context.addLine(to: CGPoint(x: location.x, y: location.y))
        context.strokePath()
        
    }
    
    private func drawStrokeByBzr(context: CGContext, touch: UITouch) {
        
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)

        let bzrPth = UIBezierPath()
        bzrPth.lineCapStyle = .round
        bzrPth.lineWidth = lineWidth
        bzrPth.move(to: previousLocation)
        
        let middlePoint = CGPoint(x: (previousLocation.x + location.x) / 2, y: (previousLocation.y + location.y) / 2)
        
        bzrPth.addQuadCurve(to: middlePoint, controlPoint: previousLocation)
        bzrPth.addQuadCurve(to: location, controlPoint: middlePoint)
        bzrPth.stroke()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        guard let canvas = self.imageView.image else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(canvas.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let imgCanvasRect = CGRect(x: 0, y: 0, width: canvas.size.width, height: canvas.size.height)
        
        tmpImage?.draw(in: imgCanvasRect)
        
        var touches = [UITouch]()
        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }
        for touch in touches {
            drawStrokeByBzr(context: context, touch: touch)
        }
        
        tmpImage = UIGraphicsGetImageFromCurrentImageContext()
        if let predictedTouches = event?.predictedTouches(for: touch) {
          for touch in predictedTouches {
            drawStrokeByBzr(context: context, touch: touch)
          }
        }
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.imageView.image = self.tmpImage
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.imageView.image = self.tmpImage
    }

}
