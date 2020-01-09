//
//  File.swift
//  
//
//  Created by Swapnil Nandgave on 06/01/20.
//

import Foundation

/**
 The $search system query option restricts the result to include only those entities matching the specified search expression. The definition of what it means to match is dependent upon the implementation. The request below get all People who has 'Boise' in their contents.
 
 ~~~
 serviceRoot/People?$search=Boise
 ~~~
 
 */

public class Search: QueryConvertible {
    
    private var expression = QueryOption.search.queryText
    
    private var property: String
    
    public init(_ property: String) {
        self.property = property
    }
    
    public var queryText: String {
        return self.expression + self.property
    }
    
}
