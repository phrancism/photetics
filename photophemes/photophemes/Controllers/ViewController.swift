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
//            guard let photopheme = createPhotopheme(for: char)
//                else { return defaultColor.cgColor }
//
//            return photopheme.cgColor
//        }
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = canvas.bounds
//        gradientLayer.colors = colors
//        canvas.layer.addSublayer(gradientLayer)
    }
    
    private func createPhotopheme(for phoneString: String) -> UIColor? {
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
            guard let photopheme = createPhotopheme(for: String(letter))
                else {
                    return UIColor.black
                }

            return photopheme
        }
        
        guard let view = sender.view else { return }
        
        animateBeaconStyle(withColors: colors, onView: view)
    }
    
    func animateBeaconStyle(withColors colors: [UIColor], onView view: UIView) {
        let overallDuration = Double(colors.count) + 5.0
        let colorDuration = 1.0 / overallDuration
        let lineBreakDuration = 2.0 / overallDuration
        let originalBackgroundColor = view.backgroundColor
        UIView.animateKeyframes(withDuration: overallDuration, delay: 0, options: [.calculationModeLinear], animations: {
                for (index, color) in colors.enumerated() {
                    let duration = color == UIColor.black ? colorDuration : lineBreakDuration
                    UIView.addKeyframe(withRelativeStartTime: Double(index) / overallDuration,
                                       relativeDuration: duration,
                                       animations: { view.backgroundColor = color })
                }
                UIView.addKeyframe(withRelativeStartTime: 1.0 - colorDuration,
                                   relativeDuration: colorDuration,
                                   animations: { view.backgroundColor = originalBackgroundColor })
        })
    }
}

extension ViewController {
    var defaultColor: UIColor { .black }
}

extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
}
