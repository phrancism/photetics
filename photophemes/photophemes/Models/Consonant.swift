import Foundation

struct Consonant: Phone, Decodable {
    let letter: String
    let place: Place
    let manner: Manner
    let isVoiced: Bool
}
