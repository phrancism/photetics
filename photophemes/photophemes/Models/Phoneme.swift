import Foundation

protocol Phoneme: Decodable {
    var letter: String { get }
}
