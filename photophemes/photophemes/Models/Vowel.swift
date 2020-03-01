import Foundation

struct Vowel: Phone, Decodable {
    let letter: String
    let backness: Backness
    let height: Height
    let isRounded: Bool
}
