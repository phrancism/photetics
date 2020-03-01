import Foundation

struct Vowel: Phoneme, Decodable {
    let letter: String
    let backness: Backness
    let height: Height
    let isRounded: Bool
}
