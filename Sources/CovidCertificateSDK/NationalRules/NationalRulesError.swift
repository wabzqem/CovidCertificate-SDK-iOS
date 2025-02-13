//
/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation

public enum NationalRulesError: Error, Equatable {
    case NO_VALID_PRODUCT
    case WRONG_DISEASE_TARGET
    case WRONG_TEST_TYPE
    case POSITIVE_RESULT
    case NOT_FULLY_PROTECTED
    case NO_VALID_DATE
    case NETWORK_ERROR(errorCode: String)
    case NETWORK_PARSE_ERROR
    case NETWORK_NO_INTERNET_CONNECTION(errorCode: String)
    case UNKNOWN_TEST_FAILURE
    case TOO_MANY_VACCINE_ENTRIES
    case TOO_MANY_TEST_ENTRIES
    case TOO_MANY_RECOVERY_ENTRIES

    public var errorCode: String {
        switch self {
        case .NO_VALID_PRODUCT: return "N|NVP"
        case .WRONG_DISEASE_TARGET: return "N|WDT"
        case .WRONG_TEST_TYPE: return "N|WTT"
        case .POSITIVE_RESULT: return "N|PR"
        case .NOT_FULLY_PROTECTED: return "N|NFP"
        case .NO_VALID_DATE: return "N|NVD"
        case let .NETWORK_ERROR(code): return code.count > 0 ? "NE|\(code)" : "NE"
        case .NETWORK_PARSE_ERROR: return "NE|PE"
        case let .NETWORK_NO_INTERNET_CONNECTION(code): return code.count > 0 ? "NE|\(code)" : "NE|NIC"
        case .UNKNOWN_TEST_FAILURE: return "N|UKN"
        case .TOO_MANY_VACCINE_ENTRIES: return "N|TMVE"
        case .TOO_MANY_TEST_ENTRIES: return "N|TMTE"
        case .TOO_MANY_RECOVERY_ENTRIES: return "N|TMRE"
        }
    }
}

public enum NationalRulesDateError: Error, Equatable {
    case NOT_YET_VALID
    case EXPIRED
    case NO_VALID_DATE
}
