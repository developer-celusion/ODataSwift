//
//  ODataQueryBuilder.swift
//  ODataQueryBuilder
//
//  Created by Celusion Technologies on 16/03/18.
//

import Foundation

/**
 # ODataQueryBuilder
 
 OData (Open Data Protocol) is an ISO/IEC approved, OASIS standard that defines a set of best practices for building and consuming RESTful APIs. OData helps you focus on your business logic while building RESTful APIs without having to worry about the various approaches to define request and response headers, status codes, HTTP methods, URL conventions, media types, payload formats, query options, etc. OData also provides guidance for tracking changes, defining functions/actions for reusable procedures, and sending asynchronous/batch requests.

 OData RESTful APIs are easy to consume. The OData metadata, a machine-readable description of the data model of the APIs, enables the creation of powerful generic client proxies and tools.
 
 ODataQueryBuilder is utility class to generate OData Queries and providing almost all the operators and functions like $filter, $expand, $select, $search etc. You can build the oData query and execute
 on OData server to get required resource results
 
 [Basic Tutorial](https://www.odata.org/getting-started/basic-tutorial/)
 
 */

public class ODataQueryBuilder: QueryConvertible {
    
    public typealias ODQueBuilder = ODataQueryBuilder
    
    private static var url: String? = nil
    
    private static let INVALID = -990
    private var entityName: String? = nil
    private var selects = [String]()
    private var filters = [FilterExp]()
    private var expands = [Expand]()
    private var orders = [Order]()
    private var search: Search? = nil
    private var urlCount: URLCount? = nil
    private var count: Count? = nil
    private var inlineCount: InlineCount? = nil
    private var skip : Int = INVALID
    private var top : Int = INVALID
    private var id = ""
    private var unboundFunc = ""
    private var boundFunc = ""
    
    private var skipMultiplier = -1;
    private var interval = ODataQueryBuilder.INVALID
    
    public static func configure(url: String) {
        ODataQueryBuilder.url = url
    }
    
    public init() {
        self.entityName = nil
        self.selects = [String]()
        self.filters = [FilterExp]()
        self.expands = [Expand]()
        self.orders = [Order]()
        self.urlCount = nil
        self.skip = Self.INVALID
        self.top = Self.INVALID
        self.id = ""
    }
    
    /// Append Entity e.g serviceRoot/People
    public func entity(_ value: String) -> Self {
        self.entityName = value
        return self
    }
    
    /**
     Append Select query option
     
     ~~~
     serviceRoot/People?$select=Name
     ~~~
     
     */
    public func select(_ value: String)-> Self {
        self.selects([value])
    }
    
    /**
    Append Select query option
    
    ~~~
    serviceRoot/People?$select=ID, Name
    ~~~
    
    */
    public func selects(_ values:[String]) -> Self {
        if(values.count > 0) {
            self.selects = values
        }
        return self
    }
    
    /**
    Append Filter query option
    
    ~~~
    serviceRoot/People?$filter=Name eq 'Martin'
    ~~~
    
    */
    
    public func filter(_ value: FilterExp)-> Self {
        self.filters = [value]
        return self
    }
    
    /**
    Append Filter query option
    
    ~~~
    serviceRoot/People?$search=Boise
    ~~~
    
    */
    
    public func search(_ value: Search)-> Self {
        self.search = value
        return self
    }
    
    /**
    Append Expand query option
    
    ~~~
    serviceRoot/People?$expand=Address
    ~~~
    
    */
    
    public func expand(_ value: Expand)-> Self {
        self.expands.append(value)
        return self
    }
    
    /**
    Append Expand query option
    
    ~~~
    serviceRoot/People?$expand=Address, ContactDetail
    ~~~
    
    */
    
    public func expands(_ values: [Expand])-> Self {
        if(values.count > 0) {
            self.expands.append(contentsOf: values);
        }
        return self
    }
    
    /**
    Append Order query option
    
    ~~~
    serviceRoot/People?$orderby=ID desc
    ~~~
    
    */
    
    public func order(_ value: Order)-> Self {
        return self.orders([value])
    }
    
    /**
    Append Order query option
    
    ~~~
    serviceRoot/People?$orderby=ID desc, name asc
    ~~~
    
    */
    
    public func orders(_ values: [Order])-> Self {
        if(values.count > 0) {
            self.orders = values
        }
        return self
    }
    
    /**
    Append Skip query option
    
    ~~~
    serviceRoot/People?$skip=10
    ~~~
    
    */
    
    public func skip(_ value: Int)-> Self {
        self.skip = value
        return self
    }
    
    /**
    Append Skip query option
    
    ~~~
    serviceRoot/People?$top=10
    ~~~
    
    */
    
    public func top(_ value: Int)-> Self {
        self.top = value
        return self
    }
    
    /**
    Append ID query option. ID is Primary key of Entity
    
    ~~~
    serviceRoot/People('Martin')
    serviceRoot/Address(10)
    ~~~
    
    */
    
    public func id(_ id:Any,_ segmentProperty: String? = nil)-> Self {
        if let str = id as? String {
            self.id = "('"+String(describing:str)+"')";
        } else {
            self.id = "("+String(describing: id)+")"
        }
        if let segmentProperty = segmentProperty {
            if !segmentProperty.hasPrefix("/") {
                self.id += "/"
            }
            self.id += segmentProperty
        }
        return self
    }
    
    /**
    Append bound OData function e.g Need to pass **Microsoft.OData.SampleService.Models.TripPin.GetFavoriteAirline()** along with /
    
    ~~~
    serviceRoot/People('russellwhyte')/Microsoft.OData.SampleService.Models.TripPin.GetFavoriteAirline()
    ~~~
    
    */
    public func boundFunction(_ name: String)->Self {
        self.boundFunc = name
        return self
    }
    
    /**
    Append unbound OData function. e.g Need to pass **GetNearestAirport(lat = 33, lon = -118)** along with /
    
    ~~~
    serviceRoot/GetNearestAirport(lat = 33, lon = -118)
    ~~~
    
    */
    public func unboundFunction(_ name: String)->Self {
        self.unboundFunc = name
        return self
    }
    
    /// Appends /$count in OData Query URL
    public func onlyCount()-> Self {
        self.urlCount = URLCount()
        return self
    }
    
    /// Appends $count=true as params
    public func withCount()-> Self {
        self.count = Count()
        return self
    }
    
    /// Appends $inlinecount=name as params
    public func inlineCount(_ property: String)-> Self {
        self.inlineCount = InlineCount(property)
        return self
    }
    
    /// Forms url and return in plain String. .encode will return encoded url which you can use in network calls
    public func build()-> String {
        var temp = queryUrlPart()
        if self.unboundFunc.count > 0 {
            temp += self.unboundFunc
        }
        temp += idPart()
        if self.boundFunc.count > 0 {
            temp += self.boundFunc
        }
        if urlCount != nil {
            temp += urlCount!.queryText
        }
        if(isExp()) {
            temp += expPart()
            temp += userQueryPart()
        }
        return temp
    }
    
    /// Returns url in plain text
    public var queryText: String {
        return build()
    }
    
    /// Returns encoded url which can be used in Network calls
    public func encode()->String {
        var temp = build()
        temp = temp.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "+", with: "%2B")
        return temp
    }
    
    /// Use this method to initialize pagination
    public func paginate(interval: Int)->Self {
        skipMultiplier = -1;
        self.interval = interval
        return self
    }
    
    /// Use this method to get next page and call build or encode to get next page OData URL
    public func nextPage() {
        if(interval != Self.INVALID) {
            skipMultiplier += 1
            self.top = self.interval
            self.skip = skipMultiplier * self.interval
        } else {
            print("Interval is missing")
        }
    }
    
    private func queryUrlPart()-> String {
        if let base = Self.url, let entity = entityName {
            var temp = base
            temp += temp.hasSuffix("/") ? "" : "/"
            temp += entity
            return temp
        } else {
            return ""
        }
    }
    
    private func idPart()-> String {
        return id
    }
    
    private func expPart() -> String {
        if(isExp()) {
            return "?"
        } else {
            return ""
        }
    }
    
    private func userQueryPart() -> String {
        var temp = "";
        if let count = self.count {
            temp += count.queryText
        }
        if let inlineCount = inlineCount {
            temp += inlineCount.queryText
        }
        if let search = self.search {
            temp += search.queryText
        }
        if(selects.count > 0) {
            temp += QueryOption.select.rawValue
            temp += selects.joined(separator: ",")
        }
        if(filters.count > 0) {
            requestPart(part: &temp)
            temp += QueryOption.filter.rawValue
            filters.forEach { item in
                temp += item.queryText
            }
        }
        if(expands.count > 0) {
            requestPart(part: &temp)
            temp += QueryOption.expand.rawValue
            var list = [String]()
            expands.forEach { order in
                list.append(order.queryText)
            }
            temp += list.joined(separator: ",")
        }
        if(orders.count > 0) {
            requestPart(part: &temp)
            temp += QueryOption.order.rawValue
            var list = [String]()
            orders.forEach { order in
                list.append(order.queryText)
            }
            temp += list.joined(separator: ",")
        }
        if(skip != Self.INVALID) {
            requestPart(part: &temp)
            temp += QueryOption.skip.rawValue
            temp += String(skip)
        }
        if(top != Self.INVALID) {
            requestPart(part: &temp)
            temp += QueryOption.top.rawValue
            temp += String(top)
        }
        return temp
    }
    
    private func requestPart(part : inout String) {
        if(part.count > 0) {
            part += "&"
        }
    }

    private func isExp() -> Bool {
        if(selects.count > 0 || filters.count > 0 || search != nil || expands.count > 0 || orders.count > 0 || skip != Self.INVALID || top != Self.INVALID || count != nil || inlineCount != nil) {
            return true
        } else {
            return false
        }
    }
    
}
