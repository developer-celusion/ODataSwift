//
//  Order.swift
//  
//
//  Created by Swapnil Nandgave on 02/01/20.
//

import Foundation

public enum OrderType: String, QueryConvertible {
    
    /// ascending order
    case asc = "asc"
    
    /// descending order
    case desc = "desc"
    
    public var queryText: String {
        return self.rawValue
    }
    
}

/**
 The $orderby system query option allows clients to request resources in either ascending order using asc or descending order using desc. If asc or desc not specified, then the resources will be ordered in ascending order. The request below orders Trips on property EndsAt in descending order.
 
 ~~~
 serviceRoot/People('scottketchum')/Trips?$orderby=EndsAt desc
 ~~~
 */

public class Order: QueryConvertible {
    
    private var property: String
    private var orderType = OrderType.asc
    
    public convenience init(_ property:String) {
        self.init(property,orderType: .asc)
    }
    
    public init(_ property:String, orderType:OrderType) {
        self.property = property
        self.orderType = orderType
    }
    
    public var queryText: String {
        var temp = property
        temp += " "
        temp += String(describing: orderType)
        return temp
    }
    
}
