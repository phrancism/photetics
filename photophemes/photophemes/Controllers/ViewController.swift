import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!
    
    let currentLanguage: Language = .english
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let line = getPoemLines(language: currentLanguage)[4].replacingOccurrences(of: " ", with: "")
        let lineArray = line.map { String($0) }
        print(lineArray)
        let colors: [CGColor] = lineArray.map { char in
            guard let photopheme = createPhotopheme(for: char)
                else { return defaultColor.cgColor }

            return photopheme.cgColor
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = colors
        self.view.layer.addSublayer(gradientLayer)
    }
    
    private func getPoemLines(language: Language) -> [String] {
        let poem = Poem(language: currentLanguage)
        let lines = poem.rawString.components(separatedBy: "\n")
        
        return lines
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
}

extension ViewController {
    var defaultColor: UIColor { .black }
}

extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
}
