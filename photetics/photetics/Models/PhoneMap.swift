import Foundation

final class PhoneMap {
    static let `default` = PhoneMap()

    private let map: [String: Phone]

    private init() {

        guard let url = Bundle.main.url(forResource: "phones", withExtension: "json")
            else { fatalError("Phones JSON file could not be found") }

        guard let data = try? Data(contentsOf: url)
            else { fatalError("Phones JSON file could not be read") }

        guard let phonesData = try? JSONDecoder().decode(Phones.self, from: data)
            else { fatalError("Phones JSON file could not be decoded") }

        var map: [String: Phone] = [:]
        phonesData.consonants.forEach{ map[$0.letter] = $0 }
        phonesData.vowels.forEach{ map[$0.letter] = $0 }

        self.map = map
    }

    subscript(phoneString: String) -> Phone? {
        return map[phoneString]
    }
}

fileprivate struct Phones: Decodable {
    let consonants: [Consonant]
    let vowels: [Vowel]
}
