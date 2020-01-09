//
//  Error.swift
//  
//
//  Created by Swapnil Nandgave on 09/01/20.
//

import Foundation

public enum ODataError: Error {
    
    case urlNotSet
    
}

extension ODataError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .urlNotSet:
            return "OData Url is not set. Use ODataQueryBuilder.configure method to set url"
        default:
            return ""
        }
    }
    
}
