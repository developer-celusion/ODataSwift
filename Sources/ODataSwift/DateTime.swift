//
//  File.swift
//  
//
//  Created by Swapnil Nandgave on 06/01/20.
//

import Foundation

/**
 # DateTime
 Enum declaration for OData DateTime functions
 */
public enum DateTime:String, QueryConvertible {
    /// Compares with current date and time on OData server
    case now = "now()"
    
    /// It returns OData mindatetime functions
    case mindatetime = "mindatetime()"
    
    public var queryText: String {
        return self.rawValue
    }
    
}
