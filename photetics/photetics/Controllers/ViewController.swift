import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!

    private let currentLanguage: Language = .english
    private lazy var poem = Poem(language: currentLanguage).rawString

    override func viewDidLoad() {
        super.viewDidLoad()

//      For an 'oral' representation
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapViewHandler(_:)))
//        canvas.addGestureRecognizer(tapGestureRecognizer)

//      For a 'written' representation'
//        drawStanza()
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
            let phoneHSL = phone as? HSBRepresentable
            else { return Constants.defaultColor }

        return UIColor(
            hue: phoneHSL.hue.cgFloat,
            saturation: phoneHSL.saturation.cgFloat,
            brightness: phoneHSL.brightness.cgFloat,
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
    func tapViewHandler(_ sender: UITapGestureRecognizer) {

        let poemNoSpaces = poem.replacingOccurrences(of: " ", with: "")
        let colors: [UIColor] = poemNoSpaces.map { makeColorFor(phoneString: String($0)) }

        guard let view = sender.view else { return }

        animateSpeechStyle(withColors: colors, onView: view)
    }

    func animateSpeechStyle(withColors colors: [UIColor], onView view: UIView) {
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
}

extension ViewController {
    enum Constants {
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
