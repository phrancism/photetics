import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!
    
    private let currentLanguage: Language = .english
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapViewHandler(_:)))
        canvas.addGestureRecognizer(tapGestureRecognizer)

//        let line = getPoemLines(language: currentLanguage)[4].replacingOccurrences(of: " ", with: "")
//        let lineArray = line.map { String($0) }
//        print(lineArray)
//        let colors: [CGColor] = lineArray.map { char in
//            guard let color = makeColor(for: char)
//                else { return defaultColor.cgColor }
//
//            return color.cgColor
//        }
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = canvas.bounds
//        gradientLayer.colors = colors
//        canvas.layer.addSublayer(gradientLayer)
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

        let poem = Poem(language: currentLanguage).rawString
        let poemNoSpaces = poem.replacingOccurrences(of: " ", with: "")
        let colors: [UIColor] = poemNoSpaces.map { letter in
            guard let color = makeColor(for: String(letter))
                else {
                    return UIColor.black
                }

            return color
        }
        print(poemNoSpaces)
        guard let view = sender.view else { return }
        
        animateBeaconStyle(withColors: colors, onView: view)
    }
    
    func animateBeaconStyle(withColors colors: [UIColor], onView view: UIView) {
        let overallDuration = 60.0
        let relativeDuration = colors.count.asDouble.reciprocal
        UIView.animateKeyframes(withDuration: overallDuration, delay: 0, options: [.calculationModeLinear], animations: {
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
    }
}

extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
    var reciprocal: Double { 1 / self }
}

extension Int {
    var asDouble: Double { Double(self) }
}
