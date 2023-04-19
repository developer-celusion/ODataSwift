//
//  File.swift
//  
//
//  Created by Swapnil Nandgave on 06/01/20.
//

import Foundation

/// OData Functions
public enum Function: String, QueryConvertible {
    
    case length = "length"
    case tolower = "tolower"
    case toupper = "toupper"
    case trim = "trim"
    case indexof = "indexof"
    case substring = "substring"
    case year = "year"
    case month = "month"
    case day = "day"
    case hour = "hour"
    case minute = "minute"
    case second = "second"
    case fractionalseconds = "fractionalseconds"
    case totaloffsetminutes = "totaloffsetminutes"
    
    public var hasArgs: Bool {
        return (self == .indexof || self == .substring)
    }
    
    public var queryText: String {
        return self.rawValue
    }
    
}

/// Logicial OData operators used along with $filter. Adding Any / All support to the protocol will greatly improve the expressiveness of OData queries.
public enum LogicalOperator: String, QueryConvertible {
    
    case any = "any"
    case all = "all"
    
    public var queryText: String {
        return "/" + self.rawValue
    }
    
}

/**
 Adding Any / All support to the protocol will greatly improve the expressiveness of OData queries.
 
 ~~~
 ~/Movies/?$filter=any(Name eq 'John Belushi')
 ~/Orders/?$filter=any(Product/Name eq 'kinect')
 ~~~
 
 */
public class OperatorFunc: QueryConvertible {
    
    /// Property of operator like Name
    private var property: String
    
    /// All or Any
    private var propertyOps: LogicalOperator
    /// Predicate
    private var filterOption: Predicate

    /// Value of predicate expression
    private var _value: String?
    
    /// String presentation of Property Function. Use queryText or String(describing: ) to get the string presentation
    private var propertyFunc: String? = nil
    
    public init(_ property: String, _ propertyOps: LogicalOperator, _ filterOption: Predicate) {
        self.property = property
        self.propertyOps = propertyOps
        self.filterOption = filterOption
    }

    public func add(_ propertyFunc: String, value: Any)-> Self {
        self.propertyFunc = propertyFunc
        if filterOption == .eq {
          nestedPropertyFunc(with: value)
        } else {
          self.value(value)
        }
        return self
    }

    public func nestedPropertyFunc(with values: Any) {
      guard let propertyFunc,
            let values = values as? [Any] else { return }
      var temp = ""
      for (index, value) in values.enumerated() {
        self.value(value)
        temp += propertyFunc + filterOption.queryText + (_value ?? "")
        if index != values.count - 1 {
          temp += " or "
        }
      }
      self._value = temp
    }

    private func value(_ value: Any) {
      if value is String {
        self._value = "'" + String(describing: value) + "'"
      } else {
        self._value = String(describing: value)
      }
    }

    public var queryText: String {
      var temp = property + propertyOps.queryText
      if let propertyFunc = self.propertyFunc,
         let _value {
        if filterOption == .in {
          temp += "(" + propertyFunc + ":" + propertyFunc + filterOption.queryText + _value + ")"
        } else {
          temp += "(" + propertyFunc + ":" + _value + ")"
        }
      }
      return temp
    }
}

/**
 It is the part of OperatorFunc to generate inclined property expression. e.g **Name eq 'John Belushi'**
 
 ~~~
 ~/Movies/?$filter=any(Name eq 'John Belushi')
 ~/Orders/?$filter=any(Product/Name eq 'kinect')
 ~~~
 
 */
public class PropertyFunc: QueryConvertible, CustomStringConvertible {
    
    private var name: String
    private var function: Function
    private var _value: String? = nil
    
    public init(_ name:String,_ function: Function) {
        self.name = name
        self.function = function
    }
    
    public func value(_ value: Any)->Self {
        if value is String {
            self._value = "'" + String(describing: value) + "'"
        } else {
            self._value = String(describing: value)
        }
        return self
    }
    
    public var queryText: String {
        var temp = function.queryText
        temp += "(" + name
        if let value = self._value, function.hasArgs {
            temp += ", " + value
        }
        temp += ")"
        return temp
    }
    
    public var description: String {
        return queryText
    }
    
}
