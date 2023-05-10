//
//  FilterExp.swift
//  
//
//  Created by Swapnil Nandgave on 02/01/20.
//

import Foundation

/// Mode to combine two expressions
public enum BasicOperator: String, QueryConvertible {
    
    case none = ""
    
    /**
     Add two odata expressions or filter blocks by basic and
     
     ~~~
    $filter=Name eq 'martin' and usercode eq '0000'
     ~~~
     */
    case and = " and "
    
    /**
     Add two odata expressions or filter blocks by basic or
     
     ~~~
    $filter=Name eq 'martin' or usercode eq '0000'
     ~~~
     */
    case or = " or "
    
    public var queryText: String {
        return self.rawValue
    }
    
}

/// OData predicate to create expression
public enum Predicate: String, QueryConvertible {
    
    /**
     Create expression with Equal **eq**
     
     ~~~
    $filter=Name eq 'martin'
     ~~~
     */
    case eq = " eq "

    /**
     Create expression with Not Equal **ne**

     */
    case ne = " ne "
    /**
     Create expression with Less Than **lt**
     
     ~~~
    $filter=Age lt 65
     ~~~
     */
    case lt = " lt "
    
    /**
     Create expression with Greater than **gt**
     
     ~~~
    $filter=Age gt 18
     ~~~
     */
    case gt = " gt "
    
    /**
     Create expression with Less than equal to **le**
     
     ~~~
    $filter=Age le 65
     ~~~
     */
    case le = " le "
    
    /**
     Create expression with Greater than equal to **ge**
     
     ~~~
    $filter=Age ge 18
     ~~~
     */
    case ge = " ge "
    
    /**
     Create expression with contains operator **contains**
     
     ~~~
    $filter=contains('name','marti')
     ~~~
     */
    case contains = "contains"
    
    /**
     Create expression with endswith operator **endswith**
     
     ~~~
    $filter=endswith('name','marti')
     ~~~
     */
    case endswith = "endswith"
    
    /**
     Create expression with startswith operator **startswith**
     
     ~~~
    $filter=startswith('name','marti')
     ~~~
     */
    case startswith = "startswith"

    /**
     Create expression with in operator **in []**
     */
    case `in` = " in "


    public var queryText: String {
        return self.rawValue
    }
    
    public var expFirst: Bool {
        return (self == .contains || self == .endswith || self == .startswith)
    }
    
}

/**
 # FilterExp
 The $filter system query option allows clients to filter a collection of resources that are addressed by a request URL. The expression specified with $filter is evaluated for each resource in the collection, and only items where the expression evaluates to true are included in the response.
 
 ~~~
 serviceRoot/People?$filter=FirstName eq 'Scott'
 ~~~
 
 [See Tutorial](https://www.odata.org/getting-started/basic-tutorial/#filter)
 
 */
public class FilterExp: QueryConvertible {
    
    /// Predicate property name
    private var property:String
    
    /// Predicate
    private var filterOption: Predicate?
    
    /// Value of predicate expression
    private var _value:String?
    
    // MARK: Concating Expression
    private var conjection: BasicOperator = .none
    
    /// Nested Grouped filter which does come under **( )**
    private var expression: FilterExp? = nil
    
    /// Nested Grouped filters which does come under **( )**
    private var expressions: [FilterExp] = [FilterExp]()
    
    /// Initiazes with entity property
    public init(_ property:String) {
        self.property = property
    }
    
    /// Initializes with property function
    public init(_ propertyFunc:PropertyFunc) {
        self.property = propertyFunc.queryText
    }

    public init(_ operatorFunc:OperatorFunc) {
      self.property = operatorFunc.queryText
    }
    /**
     Any value data type. It add ' when type is String otherwise set directly
     e.g age eq 10 and name eq 'martin'
     */
    public func value(_ value: Any)-> Self {
        if value is String {
            self._value = "'" + String(describing: value) + "'"
        } else {
            self._value = String(describing: value)
        }
        return self
    }
    
    /// Set Date time function as value
    public func date(_ dateTime:DateTime)->Self {
        self._value = dateTime.queryText
        return self
    }
    
    /**
     Set formatted date string as value by calling this function. Convert date to string by using DateFormatter and pass as argument
     e.g $filter=CreatedOn eq 2020-12-12T10:10:10
     */
    public func date(_ value: String)-> Self {
        self._value = String(describing: value)
        return self
    }
    
    /// Greater than equal to predicate
    public func ge()->Self {
        self.filterOption = .ge
        return self
    }

    /// Not equal to predicate
    public func ne()->Self {
      self.filterOption = .ne
      return self
    }

    /// less than equal to predicate
    public func le()->Self {
        self.filterOption = .le
        return self
    }

    /// in to predicate
    public func `in`()->Self {
      self.filterOption = .in
      return self
    }

    /// greater than predicate
    public func gt()->Self {
        self.filterOption = .gt
        return self
    }
    
    /// equal to predicate
    public func eq()->Self {
        self.filterOption = .eq
        return self
    }
    
    /// less than predicate
    public func lt()->Self {
        self.filterOption = .lt
        return self
    }
    
    /// contains predicate
    public func contains()->Self {
        self.filterOption = .contains
        return self
    }
    
    /// endswith predicate
    public func endswith()->Self {
        self.filterOption = .endswith
        return self
    }
    
    /// startswith predicate
    public func startswith()->Self {
        self.filterOption = .startswith
        return self
    }
    
    /**
     Add filter by Basic Operator **AND**
     e.g $filter=Age lt 65 and Name eq 'martin'
     */
    public func and(_ expression: FilterExp)->Self {
        self.conjection = .and
        self.expression = expression
        return self
    }
    
    /**
    Add filters by Basic Operator **AND**. It will group the array into bracket
    e.g $filter=Age lt 65 and (Name eq 'martin')
    */
    public func and(_ expressions: [FilterExp])->Self {
        self.conjection = .and
        self.expressions = expressions
        return self
    }
    
    /**
    Add filter by Basic Operator **OR**
    e.g $filter=Age lt 65 or Name eq 'martin'
    */
    public func or(_ expression: FilterExp)->Self {
        self.conjection = .or
        self.expression = expression
        return self
    }
    
    /**
    Add filters by Basic Operator **OR**. It will group the array into bracket
    e.g $filter=Age lt 65 or (Name eq 'martin')
    */
    public func or(_ expressions: [FilterExp])->Self {
        self.conjection = .or
        self.expressions = expressions
        return self
    }
    
    public var queryText: String {
        var temp = ""
        if let filterOption = filterOption {
            if filterOption.expFirst {
                temp += filterOption.queryText
                temp += "(" + property + "," + (_value ?? "") + ")"
            } else {
                temp += property
                temp += filterOption.queryText
                temp += _value ?? ""
            }
            if let expression = expression {
                temp += conjection.queryText + expression.queryText
            }
            if self.expressions.count > 0 {
              temp += conjection.queryText + " ("
              for (index, expression) in expressions.enumerated() {
                if index != expressions.count - 1, expressions.count > 1 {
                  temp += expression.queryText + conjection.queryText
                } else {
                  temp += expression.queryText
                }
              }
              temp += ")"
            }
        } else {
          temp += property
        }
        return temp
    }
    
}
