//
//  QueryConvertible.swift
//  
//
//  Created by Swapnil Nandgave on 02/01/20.
//

import Foundation

/// OData Query Representation
public protocol QueryConvertible {
    
    var queryText: String { get }
    
}
