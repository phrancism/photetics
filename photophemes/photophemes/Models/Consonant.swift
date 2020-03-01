import Foundation

struct Consonant: Phoneme, Decodable {
    let letter: String
    let place: Place
    let manner: Manner
    let isVoiced: Bool
}
