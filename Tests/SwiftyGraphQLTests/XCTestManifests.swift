import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArgumentTests.allTests),
        testCase(EncodingTests.allTests),
        testCase(FragmentTests.allTests),
        testCase(GQLTests.allTests),
        testCase(GraphQLDecodeTests.allTests),
        testCase(GraphQLErrorTests.allTests),
        testCase(GraphQLTests.allTests),
        testCase(HelpTests.allTests),
        testCase(MutationTests.allTests),
        testCase(NodeTests.allTests),
        testCase(QueryTests.allTests),
        testCase(RequestTests.allTests),
        testCase(VariableTests.allTests)
    ]
}
#endif
