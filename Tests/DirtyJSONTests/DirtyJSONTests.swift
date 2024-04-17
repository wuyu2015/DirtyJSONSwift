import XCTest
@testable import DirtyJSON

final class DirtyJSONTests: XCTestCase {
    func testFixChar0() {
        XCTAssertEqual(DirtyJSON.fix(""), "")
    }
    
    func testFixChar1() {
        XCTAssertEqual(DirtyJSON.fix(" "), "");
        XCTAssertEqual(DirtyJSON.fix("{"), "{}");
        XCTAssertEqual(DirtyJSON.fix("["), "[]");
        XCTAssertEqual(DirtyJSON.fix("}"), "");
        XCTAssertEqual(DirtyJSON.fix("]"), "");
        XCTAssertEqual(DirtyJSON.fix(":"), "");
        XCTAssertEqual(DirtyJSON.fix(","), "");
        XCTAssertEqual(DirtyJSON.fix("'"), "");
        XCTAssertEqual(DirtyJSON.fix("\""), "");
        XCTAssertEqual(DirtyJSON.fix("`"), "");
        XCTAssertEqual(DirtyJSON.fix("0"), "0");
        XCTAssertEqual(DirtyJSON.fix("9"), "9");
        XCTAssertEqual(DirtyJSON.fix("-"), "\"-\"");
        XCTAssertEqual(DirtyJSON.fix("."), "\".\"");
        XCTAssertEqual(DirtyJSON.fix("a"), "\"a\"");
        XCTAssertEqual(DirtyJSON.fix("e"), "\"e\"");
        XCTAssertEqual(DirtyJSON.fix("【"), "[]");
        XCTAssertEqual(DirtyJSON.fix("】"), "");
        XCTAssertEqual(DirtyJSON.fix("："), "");
    }
    
    func testFixChar2() {
        // start from {
        XCTAssertEqual(DirtyJSON.fix("{{"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{]"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{:"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{,"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{\""), "{}")
        XCTAssertEqual(DirtyJSON.fix("{'"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{`"), "{}")
        
        // start from [
        XCTAssertEqual(DirtyJSON.fix("[{"), "[{}]")
        XCTAssertEqual(DirtyJSON.fix("[}"), "[]")
        XCTAssertEqual(DirtyJSON.fix("[]"), "[]")
        XCTAssertEqual(DirtyJSON.fix("[:"), "[]")
        XCTAssertEqual(DirtyJSON.fix("[,"), "[]")
        XCTAssertEqual(DirtyJSON.fix("[\""), "[]")
        XCTAssertEqual(DirtyJSON.fix("['"), "[]")
        XCTAssertEqual(DirtyJSON.fix("[`"), "[]")
        XCTAssertEqual(DirtyJSON.fix("[0"), "[0]")
        XCTAssertEqual(DirtyJSON.fix("[9"), "[9]")
        XCTAssertEqual(DirtyJSON.fix("[-"), "[\"-\"]")
        XCTAssertEqual(DirtyJSON.fix("[."), "[\".\"]")
        XCTAssertEqual(DirtyJSON.fix("[a"), "[\"a\"]")
        XCTAssertEqual(DirtyJSON.fix("[【"), "[[]]")
        XCTAssertEqual(DirtyJSON.fix("[："), "[]")
        
        // start from }
        XCTAssertEqual(DirtyJSON.fix("}{"), "{}")
        XCTAssertEqual(DirtyJSON.fix("}}"), "")
        XCTAssertEqual(DirtyJSON.fix("}]"), "")
        XCTAssertEqual(DirtyJSON.fix("}:"), "")
        XCTAssertEqual(DirtyJSON.fix("},"), "")
        XCTAssertEqual(DirtyJSON.fix("}\""), "")
        XCTAssertEqual(DirtyJSON.fix("}'"), "")
        XCTAssertEqual(DirtyJSON.fix("}`"), "")
        XCTAssertEqual(DirtyJSON.fix("}0"), "0")
        XCTAssertEqual(DirtyJSON.fix("}9"), "9")
        XCTAssertEqual(DirtyJSON.fix("}-"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("}."), "\".\"")
        XCTAssertEqual(DirtyJSON.fix("}a"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("}【"), "[]")
        XCTAssertEqual(DirtyJSON.fix("}："), "")
        
        // start from ]
        XCTAssertEqual(DirtyJSON.fix("]{"), "{}")
        XCTAssertEqual(DirtyJSON.fix("]}"), "")
        XCTAssertEqual(DirtyJSON.fix("]]"), "")
        XCTAssertEqual(DirtyJSON.fix("]:"), "")
        XCTAssertEqual(DirtyJSON.fix("],"), "")
        XCTAssertEqual(DirtyJSON.fix("]\""), "")
        XCTAssertEqual(DirtyJSON.fix("}'"), "")
        XCTAssertEqual(DirtyJSON.fix("]`"), "")
        XCTAssertEqual(DirtyJSON.fix("]0"), "0")
        XCTAssertEqual(DirtyJSON.fix("]9"), "9")
        XCTAssertEqual(DirtyJSON.fix("]-"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("]."), "\".\"")
        XCTAssertEqual(DirtyJSON.fix("]a"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("]【"), "[]")
        XCTAssertEqual(DirtyJSON.fix("]："), "")
        
        // start from :
        XCTAssertEqual(DirtyJSON.fix(":{"), "{}")
        XCTAssertEqual(DirtyJSON.fix(":}"), "")
        XCTAssertEqual(DirtyJSON.fix(":]"), "")
        XCTAssertEqual(DirtyJSON.fix("::"), "")
        XCTAssertEqual(DirtyJSON.fix(":,"), "")
        XCTAssertEqual(DirtyJSON.fix(":\""), "")
        XCTAssertEqual(DirtyJSON.fix("}'"), "")
        XCTAssertEqual(DirtyJSON.fix(":`"), "")
        XCTAssertEqual(DirtyJSON.fix(":0"), "0")
        XCTAssertEqual(DirtyJSON.fix(":9"), "9")
        XCTAssertEqual(DirtyJSON.fix(":-"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix(":."), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(":a"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix(":【"), "[]")
        XCTAssertEqual(DirtyJSON.fix(":："), "")
        
        // start from ,
        XCTAssertEqual(DirtyJSON.fix(",{"), "{}")
        XCTAssertEqual(DirtyJSON.fix(",}"), "")
        XCTAssertEqual(DirtyJSON.fix(",]"), "")
        XCTAssertEqual(DirtyJSON.fix("::"), "")
        XCTAssertEqual(DirtyJSON.fix(",:"), "")
        XCTAssertEqual(DirtyJSON.fix(",'"), "")
        XCTAssertEqual(DirtyJSON.fix("}'"), "")
        XCTAssertEqual(DirtyJSON.fix(",:`"), "")
        XCTAssertEqual(DirtyJSON.fix(",0"), "0")
        XCTAssertEqual(DirtyJSON.fix(",9"), "9")
        XCTAssertEqual(DirtyJSON.fix(",-"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix(",."), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(",a"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix(",【"), "[]")
        XCTAssertEqual(DirtyJSON.fix(",："), "")
        
        // start from "
        XCTAssertEqual(DirtyJSON.fix("\"{"), "\"{\"")
        XCTAssertEqual(DirtyJSON.fix("\"}"), "\"}\"")
        XCTAssertEqual(DirtyJSON.fix("\"]"), "\"]\"")
        XCTAssertEqual(DirtyJSON.fix("\":"), "\":\"")
        XCTAssertEqual(DirtyJSON.fix("\","), "\",\"")
        XCTAssertEqual(DirtyJSON.fix("\"\""), "\"\"")
        XCTAssertEqual(DirtyJSON.fix("\"'"), "\"\"")
        XCTAssertEqual(DirtyJSON.fix("\"`"), "\"\"")
        XCTAssertEqual(DirtyJSON.fix("\"0"), "\"0\"")
        XCTAssertEqual(DirtyJSON.fix("\"9"), "\"9\"")
        XCTAssertEqual(DirtyJSON.fix("\"-"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("\"."), "\".\"")
        XCTAssertEqual(DirtyJSON.fix("\"a"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("\"【"), "\"【\"")
        XCTAssertEqual(DirtyJSON.fix("\"："), "\"：\"")
        
        // start from `
        XCTAssertEqual(DirtyJSON.fix("`{"), "\"{\"")
        XCTAssertEqual(DirtyJSON.fix("`}"), "\"}\"")
        XCTAssertEqual(DirtyJSON.fix("`]"), "\"]\"")
        XCTAssertEqual(DirtyJSON.fix("`:") , "\":\"")
        XCTAssertEqual(DirtyJSON.fix("`,"), "\",\"")
        XCTAssertEqual(DirtyJSON.fix("`\""), "\"\"")
        XCTAssertEqual(DirtyJSON.fix("`\'"), "\"\"")
        XCTAssertEqual(DirtyJSON.fix("``"), "\"\"")
        XCTAssertEqual(DirtyJSON.fix("`0"), "\"0\"")
        XCTAssertEqual(DirtyJSON.fix("`9"), "\"9\"")
        XCTAssertEqual(DirtyJSON.fix("`-"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("`.`"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix("`a"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("`【"), "\"【\"")
        XCTAssertEqual(DirtyJSON.fix("`："), "\"：\"")
        
        // start from 0
        XCTAssertEqual(DirtyJSON.fix("0{"), "0")
        XCTAssertEqual(DirtyJSON.fix("0}"), "0")
        XCTAssertEqual(DirtyJSON.fix("0]"), "0")
        XCTAssertEqual(DirtyJSON.fix("0:"), "0")
        XCTAssertEqual(DirtyJSON.fix("0,"), "0")
        XCTAssertEqual(DirtyJSON.fix("0\""), "0")
        XCTAssertEqual(DirtyJSON.fix("0'"), "0")
        XCTAssertEqual(DirtyJSON.fix("0`"), "0")
        XCTAssertEqual(DirtyJSON.fix("00"), "00") // TODO: should be 0
        XCTAssertEqual(DirtyJSON.fix("09"), "09") // TODO: should be 9
        XCTAssertEqual(DirtyJSON.fix("0-"), "\"0-\"")
        XCTAssertEqual(DirtyJSON.fix("0."), "0.") // TODO: should be 0
        XCTAssertEqual(DirtyJSON.fix("0a"), "\"0a\"")
        XCTAssertEqual(DirtyJSON.fix("0【"), "0")
        XCTAssertEqual(DirtyJSON.fix("0:"), "0")
        
        // start from 9
        XCTAssertEqual(DirtyJSON.fix("90"), "90")
        XCTAssertEqual(DirtyJSON.fix("99"), "99")
        
        // start from -
        XCTAssertEqual(DirtyJSON.fix("-{"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-}"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-]"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-:"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-,"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-\""), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-'"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-`"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-0"), "-0") // TODO: should be 0
        XCTAssertEqual(DirtyJSON.fix("-9"), "-9")
        XCTAssertEqual(DirtyJSON.fix("--"), "\"--\"")
        XCTAssertEqual(DirtyJSON.fix("-."), "\"-.\"")
        XCTAssertEqual(DirtyJSON.fix("-a"), "\"-a\"")
        XCTAssertEqual(DirtyJSON.fix("-【"), "\"-\"")
        XCTAssertEqual(DirtyJSON.fix("-:"), "\"-\"")
        
        // start from .
        XCTAssertEqual(DirtyJSON.fix(".{"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".}"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".]"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".:"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".,") , "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".\""), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".'"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".."), "\"..\"")
        XCTAssertEqual(DirtyJSON.fix(".0"), ".0") // TODO: should be 0
        XCTAssertEqual(DirtyJSON.fix(".9"), ".9") // TODO: should be 0.9
        XCTAssertEqual(DirtyJSON.fix(".-"), "\".-\"")
        XCTAssertEqual(DirtyJSON.fix(".a"), "\".a\"")
        XCTAssertEqual(DirtyJSON.fix(".【"), "\".\"")
        XCTAssertEqual(DirtyJSON.fix(".:"), "\".\"")
        
        // start from a
        XCTAssertEqual(DirtyJSON.fix("a{"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a}"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a]"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a:"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a,"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a\""), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a'"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a."), "\"a.\"")
        XCTAssertEqual(DirtyJSON.fix("a0"), "\"a0\"")
        XCTAssertEqual(DirtyJSON.fix("a9"), "\"a9\"")
        XCTAssertEqual(DirtyJSON.fix("a-"), "\"a-\"")
        XCTAssertEqual(DirtyJSON.fix("a."), "\"a.\"")
        XCTAssertEqual(DirtyJSON.fix("aa"), "\"aa\"")
        XCTAssertEqual(DirtyJSON.fix("a【"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a:"), "\"a\"")
        XCTAssertEqual(DirtyJSON.fix("a"), "\"a\"")


    }
    
    func test1() {
        XCTAssertEqual(DirtyJSON.fix("tRue"), "true")
        XCTAssertEqual(DirtyJSON.fix("FalSE"), "false")
        XCTAssertEqual(DirtyJSON.fix("nULl"), "null")
        XCTAssertEqual(DirtyJSON.fix("{"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{  "), "{}")
        XCTAssertEqual(DirtyJSON.fix("  {"), "{}")
        XCTAssertEqual(DirtyJSON.fix("  {  "), "{}")
        XCTAssertEqual(DirtyJSON.fix("{{}}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("[[]]"), "[[]]")
        XCTAssertEqual(DirtyJSON.fix("[[], []]"), "[[],[]]")
        XCTAssertEqual(DirtyJSON.fix("{[]}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{[], []}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{[}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{]}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{:}"), "{}")
        XCTAssertEqual(DirtyJSON.fix("{,}"), "{}")
        
        XCTAssertEqual(DirtyJSON.fix("{a:}"), "{\"a\":null}")

        XCTAssertEqual(DirtyJSON.fix("{\"a\": 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{'a': 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{`a`: 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{”a”: 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{'a\": 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{「a」: 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{「a「: 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{‘a’: 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{'\"a\"': 1}"), "{\"\\\"a\\\"\":1}")
        XCTAssertEqual(DirtyJSON.fix("{\"\"a\"\": 1}"), "{\"\\\"a\\\"\":1}")
        
        XCTAssertEqual(DirtyJSON.fix("{\"1\": 1}"), "{\"1\":1}")
        XCTAssertEqual(DirtyJSON.fix("{12: 3}"), "{\"12\":3}")
        XCTAssertEqual(DirtyJSON.fix("{'an \"example\"\t\u{10}\u{15}\n word': 1}"), "{\"an \\\"example\\\"\\t\\n word\":1}")
        XCTAssertEqual(DirtyJSON.fix("{\"an \"example\" word\": 1}"), "{\"an \\\"example\\\" word\":1}")
        XCTAssertEqual(DirtyJSON.fix("{a: 1}"), "{\"a\":1}")
        XCTAssertEqual(DirtyJSON.fix("{a: 1, c: d}"), "{\"a\":1,\"c\":\"d\"}")
        XCTAssertEqual(DirtyJSON.fix(
            "[1, 2, 3, \"a\", \"b\", \"c\", abc, TrUe, False, NULL, 1.23e10, 123abc, { 123:123 },]"),
            "[1,2,3,\"a\",\"b\",\"c\",\"abc\",true,false,null,1.23e10,\"123abc\",{\"123\":123}]")
        XCTAssertEqual(DirtyJSON.fix("{\"a\": 1, {\"b\": 2]]"), "{\"a\":1,\"b\":2}")
        XCTAssertEqual(DirtyJSON.fix("{,,,\"a\",,:, 1,,, {,,,\"b\",: 2,,,],,,],,,"), "{\"a\":1,\"b\":2}")
        XCTAssertEqual(DirtyJSON.fix("{\"a\": 1, b: [2, “3”:}]"), "{\"a\":1,\"b\":[2,\"3\"]}")
        XCTAssertEqual(DirtyJSON.fix("},{「a」:1,,b:[2,,“3”:},]},"), "{\"a\":1,\"b\":[2,\"3\"]}")
        XCTAssertEqual(DirtyJSON.fix("[\"quotes in \"quotes\" in quotes\"]"), "[\"quotes in \\\"quotes\\\" in quotes\"]")
        XCTAssertEqual(DirtyJSON.fix("{\"a\": 1, b:: [2, “3\":}] // this is a comment"), "{\"a\":1,\"b\":[2,\"3\"]}")
        XCTAssertEqual(DirtyJSON.fix("},{,key:：/*multiline\ncomment\nhere*/ “//value\",】， // this is an abnormal JSON"), "{\"key\":\"//value\"}")
    }
    
    func testIncomplete() {
        XCTAssertEqual(DirtyJSON.fix("{a: "), "{\"a\":null}")
    }
    
    func testFix1() {
        XCTAssertEqual(DirtyJSON.fix("{ test: 'this is a test', 'number': 1.23e10 }"), "{\"test\":\"this is a test\",\"number\":1.23e10}")
    }
    
    func testFix2() {
        XCTAssertEqual(DirtyJSON.fix("{ \"test\": \"some text \"a quote\" more text\"} "), "{\"test\":\"some text \\\"a quote\\\" more text\"}")
    }
    
    func testFix3() {
        XCTAssertEqual(DirtyJSON.fix("{\"test\": \"each \n on \n new \n line\"}"), "{\"test\":\"each \\n on \\n new \\n line\"}")
    }
    
    func testJsonDataWithComments() {
        let jsonDataWithComments = """
            {
                // This is a comment
                "name": "John",
                "age": 30
            }
        """
        XCTAssertEqual(DirtyJSON.fix(jsonDataWithComments), "{\"name\":\"John\",\"age\":30}")
    }
    
    func testJsonDataWithTrailingCommas() {
        let jsonDataWithTrailingCommas = """
            {
                "name": "John",
                "age": 30, // Notice this trailing comma
            }
        """
        XCTAssertEqual(DirtyJSON.fix(jsonDataWithTrailingCommas), "{\"name\":\"John\",\"age\":30}")
    }
    
    func testJsonDataWithMismatch() {
        let jsonDataWithMismatch = """
            {
                "name": "John",
                "age": 30,
                "friends": [
                    "Alice",
                    "Bob",
                } // this '}' should be ']'
            】// this abnormal square bracket  should be '}'
        """
        XCTAssertEqual(DirtyJSON.fix(jsonDataWithMismatch), "{\"name\":\"John\",\"age\":30,\"friends\":[\"Alice\",\"Bob\"]}")
    }
    
    func testUnfinishedJsonData() {
        let unfinishedJsonData = """
            {
                "name": "John",
                "age": 30,
                "friends": [
                    "Alice",
                    "Bob",
        """
        XCTAssertEqual(DirtyJSON.fix(unfinishedJsonData), "{\"name\":\"John\",\"age\":30,\"friends\":[\"Alice\",\"Bob\"]}")
    }
    
    func testImproperlyWrittenJSON() {
        let improperlyWrittenJSON = "},{「a」:1,,b:[2,,“3”:},]},"
        XCTAssertEqual(DirtyJSON.fix(improperlyWrittenJSON), "{\"a\":1,\"b\":[2,\"3\"]}")
    }

    static var allTests = [
        ("testFixChar0", testFixChar0),
        ("testFixChar1", testFixChar1),
        ("testFixChar2", testFixChar2),
        ("test1", test1),
        ("testIncomplete", testIncomplete),
        ("testFix1", testFix1),
        ("testFix2", testFix2),
        ("testFix3", testFix3),
        ("testJsonDataWithComments", testJsonDataWithComments),
        ("testJsonDataWithCommas", testJsonDataWithTrailingCommas),
        ("testJsonDataWithMismatch", testJsonDataWithMismatch),
        ("testUnfinishedJsonData", testUnfinishedJsonData),
        ("testImproperlyWrittenJSON", testImproperlyWrittenJSON),
    ]
}
