//
//  QueryOption.swift
//  
//
//  Created by Swapnil Nandgave on 02/01/20.
//

import Foundation

/**
 OData supports various kinds of query options for querying data. This section will help you go through the common scenarios for these query options.
 */

public enum QueryOption: String, QueryConvertible {
    
    case select = "$select="
    case filter = "$filter="
    case expand = "$expand="
    case order = "$orderby="
    case skip = "$skip="
    case top = "$top="
    case urlCount = "/$count"
    case count = "$count=true"
    case inlineCount = "$inlinecount="
    case search = "$search="
    
    public var queryText: String {
        return self.rawValue
    }
    
}
