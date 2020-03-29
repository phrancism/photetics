import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!

    private let currentLanguage: Language = .english
    private lazy var poem = Poem(language: currentLanguage).rawString

    override func viewDidLoad() {
        super.viewDidLoad()

//      For an 'oral' representation
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(speechStyleTapHandler(_:)))
//        canvas.addGestureRecognizer(tapGestureRecognizer)

//      For a 'written' representation'
//        drawStanza()

//      For another 'oral' representation
//        drawDots()
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flowerStyleTapHandler(_:)))
//        canvas.addGestureRecognizer(tapGestureRecognizer)
    }

    private func drawStanza() {
        let lines = poem.replacingOccurrences(of: " ", with: "").components(separatedBy: "\n")

        for n in 0..<lines.count {
            let lineView = makeLineViewForLineAt(index: n)
            let gradientLayer = makeGradientLayerFor(line: lines[n], view: lineView)
            lineView.layer.addSublayer(gradientLayer)
            canvas.addSubview(lineView)
        }
    }

    private func makeColorFor(phoneString: String) -> UIColor {
        guard let phone = PhoneMap.default[phoneString],
            let phoneHSB = phone as? HSBRepresentable
            else { return Constants.defaultColor }

        return makeColorFor(phone: phoneHSB)
    }

    private func makeColorFor(phone: HSBRepresentable) -> UIColor {
        return UIColor(
            hue: phone.hue.cgFloat,
            saturation: phone.saturation.cgFloat,
            brightness: phone.brightness.cgFloat,
            alpha: 1
        )
    }
    
    private func makeLineViewForLineAt(index: Int) -> UIView {
        let oneFifthCanvasHeight = (canvas.frame.height / 5)
        let lineViewWidth = canvas.frame.width - Constants.horizontalPadding * 2
        let lineViewHeight = oneFifthCanvasHeight - 96
        let rect = CGRect(x: Constants.horizontalPadding,
                          y: oneFifthCanvasHeight * CGFloat(index) + 48,
                          width: lineViewWidth,
                          height: lineViewHeight
                    )
        let lineView = UIView(frame: rect)

        return lineView
    }
    
    private func makeGradientLayerFor(line: String, view: UIView) -> CAGradientLayer {
        let colors: [CGColor] = line.map { makeColorFor(phoneString: String($0)).cgColor }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        return gradientLayer
    }

    @objc
    func speechStyleTapHandler(_ sender: UITapGestureRecognizer) {

        let poemNoSpaces = poem.replacingOccurrences(of: " ", with: "")
        let colors: [UIColor] = poemNoSpaces.map { makeColorFor(phoneString: String($0)) }

        guard let view = sender.view else { return }

        animateSpeechStyleWith(colors: colors, onView: view)
    }

    func animateSpeechStyleWith(colors: [UIColor], onView view: UIView) {
        let overallDuration = 30.0
        let relativeDuration = colors.count.asDouble.reciprocal
        UIView.animateKeyframes(withDuration: overallDuration, delay: 0, options: [.calculationModePaced], animations: {
                for (index, color) in colors.enumerated() {
                    UIView.addKeyframe(withRelativeStartTime: index.asDouble * relativeDuration,
                                       relativeDuration: relativeDuration,
                                       animations: { view.backgroundColor = color })
                }
        })
    }

    @objc
    func flowerStyleTapHandler(_ sender: UITapGestureRecognizer) {
        let poemNoWhitespace = poem.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")

        guard let view = sender.view else { return }

        animateFlowerStyleWith(text: poemNoWhitespace, onView: view)
    }

    func drawDots() {
        let radius: CGFloat = Constants.flowerRadius
        let strideIncrement = Constants.flowerAngleInterval

        for (i, angle) in stride(from: -CGFloat.pi / 2, to: 3 * CGFloat.pi / 2, by: strideIncrement).enumerated() {
            let positionX = (canvas.bounds.midX) + radius * cos(angle)
            let positionY = (canvas.bounds.midY) + radius * sin(angle)
            let dotViewRect = CGRect(
                x: positionX,
                y: positionY,
                width: Constants.dotDiameter,
                height: Constants.dotDiameter
            )
            let dotView = UIView(frame: dotViewRect)
            dotView.backgroundColor = Constants.dotDefaultColor
            dotView.layer.cornerRadius = Constants.dotRadius
            canvas.addSubview(dotView)
        }
    }

    func animateFlowerStyleWith(text: String, onView view: UIView) {
        let overallDuration = 15.0
        let relativeDuration = text.count.asDouble.reciprocal

        UIView.animateKeyframes(withDuration: overallDuration, delay: 0, options: [.calculationModeLinear], animations: {
            for (letterIndex, letter) in text.enumerated() {
                guard let phone = PhoneMap.default[String(letter)],
                    let phoneHSB = phone as? HSBRepresentable
                    else { continue }

                let color = self.makeColorFor(phone: phoneHSB)
                let viewIndex = Int(phoneHSB.hue * 12)
                let dotView = view.subviews[viewIndex]

                UIView.addKeyframe(withRelativeStartTime: letterIndex.asDouble * relativeDuration,
                                   relativeDuration: relativeDuration,
                                   animations: { dotView.backgroundColor = color })

                UIView.addKeyframe(withRelativeStartTime: (letterIndex.asDouble + 0.5) * relativeDuration,
                                   relativeDuration: relativeDuration,
                                   animations: { dotView.backgroundColor = Constants.dotDefaultColor })
            }
        })
    }
}

extension ViewController {
    enum Constants {
        static let dotDefaultColor: UIColor = .init(white: 0.2, alpha: 0.5)
        static let dotPadding: CGFloat = 10.0
        static let dotRadius: CGFloat = 20.0
        static var dotDiameter: CGFloat { dotRadius * 2 }
        static let flowerRadius: CGFloat = 150.0
        static let flowerAngleInterval: CGFloat = 8 * CGFloat.pi / 44
        static let defaultColor: UIColor = .black
        static let horizontalPadding: CGFloat = 48.0
    }
}

extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
    var reciprocal: Double { 1 / self }
}

extension Int {
    var asDouble: Double { Double(self) }
}
