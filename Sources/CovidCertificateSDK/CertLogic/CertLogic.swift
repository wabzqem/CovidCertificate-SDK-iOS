//
//  File.swift
//  
//
//  Created by Patrick Amrein on 11.06.21.
//

import Foundation
import JSON
import jsonlogic

public enum CertLogicCommonError: String, Error {
    case RULE_PARSING_FAILED
}

public enum CertLogicValidationError : Error {
    case JSON_ERROR
    case TESTS_FAILED(tests: [String:String])
    case TEST_COULD_NOT_BE_PERFORMED(test: String)
}

public class CertLogic {
    var rules: [JSON] = []
    var valueSets: JSON = []
    
    public init() {}
    public func updateData(rules: JSON, valueSets: JSON) -> Result<(), CertLogicCommonError> {
        guard let array = rules.array else {
            return .failure(.RULE_PARSING_FAILED)
        }
        self.rules = array
        self.valueSets = valueSets
        return .success(())
    }
    
    public func checkRules(hcert: EuHealthCert, validationClock: Date = Date()) -> Result<(), CertLogicValidationError> {
        var external = JSON(
            ["validationClock": ISO8601DateFormatter().string(from: validationClock),
             "validationClockAtStartOfDay": ISO8601DateFormatter().string(from: Calendar.current.startOfDay(for: validationClock)),
            ]
        )
        external["valueSets"] = valueSets
        var failedTests : [String: String] = [:]
        guard let dgcJson =  try? JSONEncoder().encode(hcert) else {
            return .failure(.JSON_ERROR)
        }
        let context = JSON(["external" : external, "payload" : JSON(dgcJson)])
        for rule in self.rules {
            let logic = rule["logic"]
            guard let result: Bool = try? applyRule(logic, to: context) else {
                return .failure(.TEST_COULD_NOT_BE_PERFORMED(test: rule["id"].string ?? "TEST_ID_UNKNOWN"))
            }
            if !result {
                failedTests.updateValue(rule["description"].string ?? "TEST_DESCRIPTION_UNKNOWN", forKey: rule["id"].string ?? "TEST_ID_UNKNOWN")
                // for now we break at the first occurence of an error
                break
            }
        }
        if failedTests.isEmpty {
            return .success(())
        } else {
            return .failure(.TESTS_FAILED(tests: failedTests))
        }
    }
}
