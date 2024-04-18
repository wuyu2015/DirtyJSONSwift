extension DirtyJSON {
    class TokenStatus {
        var stack: [Character]
        var expectLiteral: Bool
        var expectOpenToken: Bool
        var expectColon: Bool
        var expectComma: Bool
        var hasObjectKey: Bool

        init() {
            self.stack = []
            self.expectLiteral = true
            self.expectOpenToken = true
            self.expectColon = false
            self.expectComma = false
            self.hasObjectKey = false
        }

        func lastStack() -> Character? {
            return self.stack.last
        }

        func inObject() -> Bool {
            return self.lastStack() == "{"
        }

        func inArray() -> Bool {
            return self.lastStack() == "["
        }

        func expectClosedToken() -> Bool {
            return !self.stack.isEmpty
        }

        // {
        func encounterOpenBrace() {
            self.stack.append("{")
            self.expectLiteral = true
            self.expectOpenToken = false
            self.expectColon = false
            self.expectComma = false
            self.hasObjectKey = false
        }

        // [
        func encounterOpenSquare() {
            self.stack.append("[")
            self.expectLiteral = true
            self.expectOpenToken = true
            self.expectColon = false
            self.expectComma = false
            self.hasObjectKey = false
        }

        // } or ]
        func encounterClosedToken() {
            _ = self.stack.popLast()
            self.expectLiteral = false
            self.expectOpenToken = !self.inObject()
            self.expectColon = false
            self.expectComma = true
            self.hasObjectKey = false
        }

        // :
        func encounterColon() {
            self.expectLiteral = true
            self.expectOpenToken = true
            self.expectColon = false
            self.expectComma = false // not allow: ':,'
            self.hasObjectKey = true
        }

        // ,
        func encounterComma() {
            self.expectLiteral = true
            self.expectOpenToken = !self.inObject()
            self.expectColon = false
            self.expectComma = false
            self.hasObjectKey = false
        }

        func encounterLiteral() {
            self.expectLiteral = false
            self.expectOpenToken = false
            if self.inObject() {
                self.hasObjectKey = !self.hasObjectKey
                self.expectColon = self.hasObjectKey
                self.expectComma = !self.expectColon
            } else {
                self.expectColon = false
                self.expectComma = true
                self.hasObjectKey = false
            }
        }
    }
}
