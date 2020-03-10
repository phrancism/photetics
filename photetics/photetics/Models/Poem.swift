import Foundation

class Poem {
    let rawString: String
    
    init(language: Language) {
        let fileName = "poem-\(language.rawValue)"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt")
            else { fatalError("\(fileName.uppercased()) poem file not found") }
        
        guard let poem = try? String(contentsOf: url, encoding: .utf8)
            else { fatalError("Error converting file to string") }
        
        self.rawString = poem
    }
}
