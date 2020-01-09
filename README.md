# ODataSwift

ODataSwift is simple utility swift wrapper to generate OData Query V4 that works on iOS and OS X. Makes using ODataSwift builder pattern APIs extremely easy 
and much more palatable to use in Swift

## :bulb: Features

- Used builder pattern to generate query
- Support $select, $expand, $filter
- Support odata pagination like $top, $skip
- Support unbound and bound functions
- Support almost all predicates like eq, lt, gt
- Support date time funtions like now()

## :book: Usage

### :key: Basics

#### Setting OData URL
```swift
ODataQueryBuilder.configure(url: "https://services.odata.org/V4")
```

### :key: Querying Data

#### $filter
The `$filter` system query option allows clients to filter a collection of resources that are addressed by a request URL
```swift
let filter = FilterExp("FirstName").eq().value("Scott").and([FilterExp("FirstName").eq().value("Scott")])
print(ODataQueryBuilder().entity("People").filter(filter).build())
```
#### $orderby
The `$orderby` system query option allows clients to request resources in either ascending order using asc or descending order using desc
```swift
let order = Order("EndsAt", orderType: .desc)
print(ODataQueryBuilder().entity("People").order(order).build())
```
#### $top
The `$top` system query option requests the number of items in the queried collection to be included in the result
```swift
print(ODataQueryBuilder().entity("People").top(2).build())
```
#### $skip
The `$skip` query option requests the number of items in the queried collection that are to be skipped and not included in the result
```swift
print(ODataQueryBuilder().entity("People").skip(18).build())
```
#### $count
The `$count` system query option allows clients to request a count of the matching resources included with the resources in the response
It is available in three as per odata request `.onlyCount()` `.withCount()` `inlineCount(property)`
```swift
print(ODataQueryBuilder().entity("People").withCount().build())
```
#### $expand
The `$expand` system query option specifies the related resources to be included in line with retrieved resources along with `$select`, `$filter` like system query options 
```swift
let filter = FilterExp("FirstName").eq().value("Scott").and([FilterExp("FirstName").eq().value("Scott")])
let expand = Expand("Trips").filter(filter)
print(ODataQueryBuilder().entity("People").expand(expand).build())
```
#### $select
The `$select` system query option allows the clients to requests a limited set of properties for each entity
```swift
print(ODataQueryBuilder().entity("Airports").selects(["Name","IcaoCode"]).build())
```
#### $search
The `$search` system query option restricts the result to include only those entities matching the specified search expression
```swift
print(ODataQueryBuilder().entity("People").search(Search("Name")).build())
```
#### Advanced Query Generation by OData Functions
```swift
let url = ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("name", .length)).eq().value(30)).build()
print(url)
```
```swift
let url = ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("designation", .substring).value(1)).eq().value("di")).build()
print(url)
```
```swift
let url = ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("CreatedOn", .year)).eq().value(2020)).build()
print(url)
```

#### URL Encode
Use default `.encode()` method to get string presentation of OData URL for network calls
```swift
let urlEncoded = ODataQueryBuilder().entity("People").search(Search("Name")).encode()
print(urlEncoded)
```

## Requirements

**v1.0.0**
It is designed in Swift 5 and supports iOS, macOS, watchOS, tvOS

### CocoaPods

ODataSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
use_frameworks!
pod 'ODataSwift'
```
### Swift Package Manager

ODataSwift is also available through [Swift Package Manager](https://github.com/apple/swift-package-manager/).

#### Xcode

Select `File > Swift Packages > Add Package Dependency...`,  

<img src="https://user-images.githubusercontent.com/40610/67627000-2833b580-f88f-11e9-89ef-18819b1a6c67.png" width="800px" />

#### CLI

First, create `Package.swift` that its package declaration includes:

```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MyLibrary",
    products: [
        .library(name: "MyLibrary", targets: ["MyLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "MyLibrary", dependencies: ["ODataSwift"]),
    ]
)
```

Then, type

```shell
$ swift build
```

### To manually add to your project

1. Add `Lib/ODataSwift.xcodeproj` to your project
2. Link `ODataSwift.framework` with your target
3. Add `Copy Files Build Phase` to include the framework to your application bundle

_See [iOS Example Project](https://github.com/kishikawakatsumi/KeychainAccess/tree/master/Examples/Example-iOS) as reference._

<img src="https://raw.githubusercontent.com/kishikawakatsumi/KeychainAccess/master/Screenshots/Installation.png" width="800px" />

## Author

Swapnil Nandgave, developer@celusion.com

## License

ODataSwift is available under the MIT license. See the LICENSE file for more info.




