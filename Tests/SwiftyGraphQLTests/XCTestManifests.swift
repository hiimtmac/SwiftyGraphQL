import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AttributeTests.allTests),
        testCase(FragmentTests.allTests),
        testCase(GraphQLDecodeTests.allTests),
        testCase(GraphQLErrorTests.allTests),
        testCase(GraphQLTests.allTests),
        testCase(MutationTests.allTests),
        testCase(ArgumentTests.allTests),
        testCase(QueryTests.allTests),
        testCase(VariableTests.allTests)
    ]
}
#endif
