//
//  Expand.swift
//  
//
//  Created by Swapnil Nandgave on 02/01/20.
//

import Foundation

/**
 # Expand
 The $expand system query option specifies the related resources to be included in line with retrieved resources.
 e.g The request below returns people with navigation property Friends of a Person
 
 ~~~
 serviceRoot/People('keithpinckney')?$expand=Friends
 ~~~
 
 [See Tutorial](https://www.odata.org/getting-started/basic-tutorial/#expand)
 
 */

public class Expand: QueryConvertible {
    
    /// Navigational Properties
    private var properties = [String]()
    
    /// Filter block within expand
    private var filter: FilterExp?
    
    /// Select odata properties
    private var selects = [String]()
    
    /// Nested Expand
    private var expand: Expand?
    
    /**
     Initializes new Expand with provided navigational property or properties
     - Parameter property: Navigational property Name
     */
    
    public init(_ property: String) {
        self.properties = [property]
    }
    
    /**
    Initializes new Expand with provided navigational property or properties
    - Parameter properties: Navigational property Names
    */
    public init(_ properties: [String]) {
        self.properties = properties
    }
    
    /**
    Append new filter
     
     ~~~
     $expand=NavProperty($filter=name eq 'martin')
     ~~~
     
    - Parameter filter: instance of filter class
    */
    public func filter(_ filter: FilterExp)-> Self {
        self.filter = filter
        return self
    }
    
    /**
    Append new select
     
     ~~~
     $expand=NavProperty($select=Name)
     ~~~
     
    - Parameter select: $select property name of string type
    */
    public func select(_ select: String)-> Self {
        return self.selects([select])
    }
    
    /**
    Append new select
     
     ~~~
     $expand=NavProperty($select=Name,Mobile)
     ~~~
     
    - Parameter selects: $select property name of String data type
    */
    public func selects(_ selects: [String])-> Self {
        self.selects = selects
        return self
    }
    
    /**
    Append nested expand
     
     ~~~
     $expand=NavProperty($expand=NestedExpand)
     ~~~
     
    - Parameter expand: $expand inside expand
    */
    public func expand(_ expand:Expand)-> Self {
        self.expand = expand
        return self
    }
    
    public var queryText: String {
        var temp = "";
        temp += properties.joined(separator: ",")
        var part = "";
        if(selects.count > 0) {
            part += QueryOption.select.queryText
            part += selects.joined(separator: ",")
        }
        if let filter = self.filter {
            requestPart(part: &part)
            part += QueryOption.filter.queryText
            part += filter.queryText
        }
        if let expand = self.expand {
            requestPart(part: &part)
            part += QueryOption.expand.queryText
            part += expand.queryText
        }
        if(part.count > 0) {
            temp += "(" + part + ")"
        }
        return temp
    }
    
    private func requestPart(part: inout String) {
        if(part.count > 0) {
            part += ";"
        }
    }
    
}
