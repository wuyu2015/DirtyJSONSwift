import XCTest

import DirtyJSONTests

var tests = [XCTestCaseEntry]()
tests += DirtyJSONTests.allTests()
XCTMain(tests)
