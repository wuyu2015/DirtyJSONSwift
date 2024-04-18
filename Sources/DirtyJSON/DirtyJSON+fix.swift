extension DirtyJSON {
    public static func fix(_ text: String) -> String {
        let iterator = StringIterator(text)
        let status = TokenStatus()
        
        while true {
            let token = nextToken(iterator)
            
            switch token {
            case "\"":
                encounterQuote(iterator, status)
            case "{":
                encounterOpenBrace(iterator, status)
            case "[":
                encounterOpenSquare(iterator, status)
            case "}", "]":
                encounterClosedToken(iterator, status)
            case ":":
                encounterColon(iterator, status)
            case ",":
                encounterComma(iterator, status)
            case nil:
                encounterEnd(iterator, status)
                // All Done. Return the fixed compact JSON string
                return iterator.toString()
            default:
                encounterLiteral(iterator, status, token!)
            }
        }
    }

    static func nextToken(_ iterator: StringIterator, deleteWhitespace: Bool = true) -> String? {
        while !iterator.done() {
            // delete whitespaces
            skipWhitespace(iterator, deleteWhitespace: true)
            // find a struct token
            let char = iterator.next()
            switch char {
            case "\"", "'", "`", "“", "”", "‘", "’", "「", "」", "﹁", "﹂", "『", "』", "﹃", "﹄":
                return "\""
            case "【", "〔":
                iterator.set("[")
                return "["
            case "】", "〕":
                iterator.set("]")
                return "]"
            case "：":
                iterator.set(":")
                return ":"
            case "，", "、":
                iterator.set(",")
                return ","
            case "/":
                switch iterator.peek() {
                case "/":
                    // Found '//' comment
                    iterator.set("")
                    while !iterator.done() && iterator.next() != "\n" {
                        iterator.set("") // delete comment
                    }
                    if iterator.get() == "\n" {
                        iterator.set("") // delete \n
                    }
                case "*":
                    // Found '/*' comment
                    iterator.set("") // delete '/'
                    iterator.next() // delete '*'
                    iterator.set("")
                    while !iterator.done() {
                        if iterator.next() == "*" && iterator.peek() == "/" {
                            iterator.set("") // delete '*'
                            iterator.next()
                            iterator.set("") // delete '/'
                            break
                        }
                        iterator.set("")
                    }
                default:
                    return char
                }
            case "":
                // char will be empty if we delete it before
                break
            default:
                return char
            }
        }
         // move iterator.index to iterator.array.length
        iterator.next()
        return nil
    }

    static func skipString(_ iterator: StringIterator) {
        // change token to '"'
        iterator.set("\"")
        let index = iterator.index
        // find the next '"'
        while !iterator.done() {
            let char = iterator.next()!
            switch char {
            case "\n":
                iterator.set("\\n")
            case "\t":
                iterator.set("\\t")
            case "\"":
                // encounter quote
                if (hasTrailingTokenOrEnd(iterator)) {
                    // string end
                    iterator.set("");
                    iterator.prev();
                    iterator.append("\"")
                    return
                }
                iterator.set("\\\"")
            case "'", "`", "“", "”", "‘", "’", "「", "」", "﹁", "﹂", "『", "』", "﹃", "﹄":
                // encounter abnormal quote, and there is a trailing token, change it to '"'
                if (hasTrailingTokenOrEnd(iterator)) {
                    iterator.set("");
                    iterator.prev();
                    iterator.append("\"")
                    return
                }
            case "\\":
                iterator.next()
                break
            default:
                // encounter invisible char, delete it
                if isInvisible(char) {
                    iterator.set("")
                }
            }
        }
        // not found
        if (index == iterator.index) {
            iterator.set("");
        } else {
            iterator.append("\"");
        }
    }

    static func skipWhitespace(_ iterator: StringIterator, deleteWhitespace: Bool = false) {
        while !iterator.done() {
            guard isWhitespace(iterator.peek()!) else {
                return
            }
            iterator.next()
            if deleteWhitespace {
                iterator.set("")
            }
        }
    }

    static func skipUntilQuotation(_ iterator: StringIterator) -> String {
        while !iterator.done() {
            let char = iterator.next()
            if char == ":" || char == "：" {
                return iterator.prev()!
            }
        }
        return iterator.prev()!
    }

    static func skipUntilToken(_ iterator: StringIterator) {
        while true {
            switch nextToken(iterator, deleteWhitespace: false) {
            case "{", "}", "[", "]", ":", ",", "\"", nil:
                // move iterator.index back to visible char
                iterator.prev()
                return
            default:
                continue
            }
        }
    }

    static func hasTrailingTokenOrEnd(_ iterator: StringIterator) -> Bool {
        for index in iterator.index + 1 ..< iterator.array.count {
            let value = iterator.array[index]
            if isWhitespace(value) {
                continue
            }
            switch value {
            case "}", "]", ":", ",":
                return true
            default:
                return false
            }
        }
        // end of iterator
        return true
    }
    
    static func encounterQuote(_ iterator: StringIterator, _ status: TokenStatus) {
        if !status.expectLiteral {
            iterator.set("")
            return
        }
        skipString(iterator)
        if !iterator.get().isEmpty {
            status.encounterLiteral()
        }
    }

    static func encounterOpenBrace(_ iterator: StringIterator, _ status: TokenStatus) {
        if !status.expectOpenToken {
            iterator.set("")
            return
        }
        status.encounterOpenBrace()
    }

    static func encounterOpenSquare(_ iterator: StringIterator, _ status: TokenStatus) {
        if !status.expectOpenToken {
            iterator.set("")
            return
        }
        status.encounterOpenSquare()
    }

    static func encounterClosedToken(_ iterator: StringIterator, _ status: TokenStatus) {
        if !status.expectClosedToken() {
            iterator.set("")
            return
        }
        let peekPrevResult = iterator.peekPrev()
        // delete trailing ','
        if peekPrevResult.lastChar == "," {
            iterator.array[peekPrevResult.index] = ""
        }
        if status.inObject() {
            // close token should be '}'
            iterator.set("}")
            if status.expectColon {
                iterator.array[peekPrevResult.index] += ":null"
            } else if peekPrevResult.lastChar == ":" {
                iterator.array[peekPrevResult.index] += "null"
            }
        } else {
            // close token should be ']'
            iterator.set("]")
        }
        status.encounterClosedToken()
    }

    static func encounterColon(_ iterator: StringIterator, _ status: TokenStatus) {
        if !status.expectColon {
            iterator.set("")
            return
        }
        status.encounterColon()
    }

    static func encounterComma(_ iterator: StringIterator, _ status: TokenStatus) {
        if !status.expectComma {
            iterator.set("")
            return
        }
        status.encounterComma()
    }

    static func encounterLiteral(_ iterator: StringIterator, _ status: TokenStatus, _ token: String) {
        if !status.expectLiteral {
            iterator.set("")
            return
        }

        if status.inObject() && !status.hasObjectKey {
            // encounter non-token char that must be quoted
            // add leading quote
            iterator.set("\"" + token)
            // add trailing quote
            iterator.set(skipUntilQuotation(iterator) + "\"")
            status.encounterLiteral()
            return
        }

        status.encounterLiteral()

        // not in object key field
        // prepare to get value from index
        let valueIndex0 = iterator.index
        skipUntilToken(iterator)
        let valueIndex1 = iterator.index
        // get value
        let value = iterator.array[valueIndex0...valueIndex1].joined()
        if isNumber(value) {
            // value is number
            // TODO: format number
            return
        }
        // value is not number
        switch value.lowercased() {
            case "true", "false", "null":
                for index in valueIndex0...valueIndex1 {
                    // lower case the bool or null value
                    iterator.array[index] = iterator.array[index].lowercased()
                }
            default:
                // value is string, must be quoted
                iterator.array[valueIndex0] = "\"" + token
                iterator.array[valueIndex1] = iterator.get() + "\""
        }
    }

    static func encounterEnd(_ iterator: StringIterator, _ status: TokenStatus) {
        let peekPrevResult = iterator.peekPrev()
        if status.hasObjectKey {
            if status.expectColon {
                iterator.array[peekPrevResult.index] += ":null"
            } else {
                iterator.array[peekPrevResult.index] += "null"
            }
        }
        if peekPrevResult.lastChar == "," {
            iterator.array[peekPrevResult.index] = ""
        }
        // empty `stack`
        while !status.stack.isEmpty {
            switch status.stack.popLast() {
                case "{":
                    iterator.array[iterator.array.count - 1] += "}"
                case "[":
                    iterator.array[iterator.array.count - 1] += "]"
                default:
                    break
            }
        }
    }
}
