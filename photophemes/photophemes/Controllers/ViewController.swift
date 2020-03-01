import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!
    
    let currentLanguage: Language = .italian
    
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
        guard let phoneme = PhonemeMap.default[phonemeString] else { return nil }
        
        let values = HSBValueFactory.createValues(for: phoneme, language: currentLanguage)
        
        return UIColor(
                hue: values.hue.cgFloat,
            saturation: values.saturation.cgFloat,
            brightness: values.brightness.cgFloat,
            alpha: 1
        )
    }
}

extension ViewController {
    var defaultColor: UIColor { .black }
}

fileprivate protocol HSLRepresentable {
    var hue: CGFloat { get }
    var saturation: CGFloat { get }
    var brightness: CGFloat { get }
}

extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
}
