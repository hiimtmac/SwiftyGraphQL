import XCTest

import SwiftyGraphQLTests

var tests = [XCTestCaseEntry]()
tests += ArgumentTests.allTests()
tests += EncodingTests.allTests()
tests += FragmentTests.allTests()
tests += GQLTests.allTests()
tests += GraphQLDecodeTests.allTests()
tests += GraphQLErrorTests.allTests()
tests += GraphQLTests.allTests()
tests += HelpTests.allTests()
tests += MutationTests.allTests()
tests += NodeTests.allTests()
tests += QueryTests.allTests()
tests += RequestTests.allTests()
tests += VariableTests.allTests()
XCTMain(tests)
