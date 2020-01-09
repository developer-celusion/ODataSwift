//
//  Count.swift
//  
//
//  Created by Swapnil Nandgave on 02/01/20.
//

/*
 Count is system query option allows clients to request a count of matching resources included with the resources in the response
 There are 3 options available
 1. $count in URL - e.g serviceRoot/People/$count
 2. $count in resource response - e.g serviceRoot/People?$count=true
 3. $inlinecount in resource response - serviceRoot/People?$inlinecount=<Property>
 */

import Foundation

/**
 # URLCount
 Count is system query option allows clients to request a count of matching resources included with the url
 e.g `serviceRoot/People?$count=true`
 ~~~
 ODataQueryBuilder().entity("People").onlyCount().build()
 ~~~
 - Returns: A URL Count instance which will append in OData URL
 */

public class URLCount: QueryConvertible {
    
    private var expression = QueryOption.urlCount.queryText
    
    public var queryText: String {
        return expression
    }
    
}

/**
# Count
Count is system query option allows clients to request a count of matching resources included with the resources in the response
e.g `serviceRoot/People?$count=true`
 ~~~
 ODataQueryBuilder().entity("People").withCount().build()
 ~~~
- Returns: A Count instance which will include in OData Response
*/

public class Count: QueryConvertible {
    
    private var expression = QueryOption.count.queryText
    
    public var queryText: String {
        return expression
    }
    
}

/**
# InlineCount
Count is system query option allows clients to request a count of matching resources included with the resources in the response
e.g `serviceRoot/People?$inlinecount=name`
 
 ~~~
 ODataQueryBuilder().entity("People").inlineCount("Name").build()
 ~~~
 
- Parameter property: Property of entity which is to be inlined for count
- Returns: A InlineCount instance which will include in OData Response
*/

public class InlineCount: QueryConvertible {
    
    private var expression = QueryOption.inlineCount.queryText
    
    private var property: String
    
    /// Property of entity
    public init(_ property: Any) {
        self.property = String(describing: property)
    }
    
    public var queryText: String {
        return self.expression + self.property
    }
    
}
