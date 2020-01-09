import XCTest

import SwiftyGraphQLTests

var tests = [XCTestCaseEntry]()
tests += AttributeTests.allTests()
tests += FragmentTests.allTests()
tests += GraphQLDecodeTests.allTests()
tests += GraphQLErrorTests.allTests()
tests += GraphQLTests.allTests()
tests += MutationTests.allTests()
tests += ParameterTests.allTests()
tests += QueryTests.allTests()
tests += RequestTests.allTests()
tests += VariableTests.allTests()
XCTMain(tests)
