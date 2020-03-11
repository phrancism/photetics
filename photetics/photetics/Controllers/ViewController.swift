import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!

    private let currentLanguage: Language = .tagalog
    private lazy var poem = Poem(language: currentLanguage).rawString

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapViewHandler(_:)))
        canvas.addGestureRecognizer(tapGestureRecognizer)

        let lines = poem.replacingOccurrences(of: " ", with: "").components(separatedBy: "\n")

        for n in 0...4 {
            // Make line view
            let oneFifthCanvasHeight = (canvas.frame.height / 5)
            let lineViewWidth = canvas.frame.width - Constants.horizontalPadding * 2
            let lineViewHeight = oneFifthCanvasHeight - 96
            let rect = CGRect(x: Constants.horizontalPadding,
                              y: oneFifthCanvasHeight * CGFloat(n) + 48,
                              width: lineViewWidth,
                              height: lineViewHeight
                        )
            let lineView = UIView(frame: rect)
            lineView.backgroundColor = UIColor.white

            // Make gradient layer for view
            let line = lines[n]
            let lineArray = line.map(String.init)
            let colors: [CGColor] = lineArray.map { char in
                guard let color = makeColor(for: char)
                    else { return Constants.defaultColor.cgColor }

                return color.cgColor
            }
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = lineView.bounds
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            lineView.layer.addSublayer(gradientLayer)

            canvas.addSubview(lineView)
        }
    }

    private func makeColor(for phoneString: String) -> UIColor? {
        guard let phone = PhoneMap.default[phoneString],
            let phoneHSL = phone as? HSBRepresentable
            else { return nil }

        return UIColor(
            hue: phoneHSL.hue.cgFloat,
            saturation: phoneHSL.saturation.cgFloat,
            brightness: phoneHSL.brightness.cgFloat,
            alpha: 1
        )
    }

    @objc
    func tapViewHandler(_ sender: UITapGestureRecognizer) {

        let poemNoSpaces = poem.replacingOccurrences(of: " ", with: "")
        let colors: [UIColor] = poemNoSpaces.map { letter in
            guard let color = makeColor(for: String(letter))
                else {
                    return UIColor.black
                }

            return color
        }

        guard let view = sender.view else { return }

        animateBeaconStyle(withColors: colors, onView: view)
    }

    func animateBeaconStyle(withColors colors: [UIColor], onView view: UIView) {
        let overallDuration = 45.0
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
