import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!
    
    let currentLanguage: Language = .tagalog
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let line = getPoemLines(language: currentLanguage)[0].replacingOccurrences(of: " ", with: "")
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
    
    private func createPhotopheme(for phonemeString: String) -> UIColor? {
        guard let phoneme = PhonemeMap.default[phonemeString],
            let phonemeHSL = phoneme as? HSBRepresentable
            else { return nil }
        
        return UIColor(
            hue: phonemeHSL.hue.cgFloat,
            saturation: phonemeHSL.saturation.cgFloat,
            brightness: phonemeHSL.brightness.cgFloat,
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
