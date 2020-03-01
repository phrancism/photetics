import Foundation

final class PhonemeMap {
    static let `default` = PhonemeMap()
    
    private let map: [String: Phoneme]
    
    private init() {
        
        guard let url = Bundle.main.url(forResource: "phonemes", withExtension: "json")
            else { fatalError("Phonemes JSON file could not be found") }

        guard let data = try? Data(contentsOf: url)
            else { fatalError("Phonemes JSON file could not be read") }

        guard let phonemesData = try? JSONDecoder().decode(Phonemes.self, from: data)
            else { fatalError("Phonemes JSON file could not be decoded") }

        var map: [String: Phoneme] = [:]
        phonemesData.consonants.forEach{ map[$0.letter] = $0 }
        phonemesData.vowels.forEach{ map[$0.letter] = $0 }
        
        self.map = map
    }
    
    subscript(phonemeString: String) -> Phoneme? {
        return map[phonemeString]
    }
}

fileprivate struct Phonemes: Decodable {
    let consonants: [Consonant]
    let vowels: [Vowel]
}
