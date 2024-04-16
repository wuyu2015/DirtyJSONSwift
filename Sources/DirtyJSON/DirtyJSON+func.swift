import Foundation
extension DirtyJSON {
    static func isWhitespace(_ char: String) -> Bool {
        // \x20: Space
        // \x7F: DEL
        // \xA0: Non-breaking Space
        // \u2000-\u200A: En Quad, Em Quad, En Space, Em Space, Three-Per-Em Space, Four-Per-Em Space, Six-Per-Em Space, Figure Space, Punctuation Space, Thin Space, Hair Space
        // \u2028: Line Separator
        // \u205F: Medium Mathematical Space
        // \u3000: Ideographic Space
        return char.range(of: "[\\x00-\\x20\\x7F\\xA0\\u2000-\\u200A\\u2028\\u205F\\u3000]", options: .regularExpression) != nil
    }
    
    static func isInvisible(_ char: String) -> Bool {
        // \x09: \t
        // \x0A: \n
        // \x7F: DEL
        return char.range(of: "[\\x00-\\x08\\x0B-\\x1F\\x7F]", options: .regularExpression) != nil
    }
    
    static func isNumber(_ str: String) -> Bool {
        return str.range(of: "^[-+]?([0-9]+(\\.[0-9]*)?|\\.[0-9]+)([eE][-+]?[0-9]+)?$", options: .regularExpression) != nil
    }
}
