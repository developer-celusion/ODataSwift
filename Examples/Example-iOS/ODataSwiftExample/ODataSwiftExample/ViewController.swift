//
//  ViewController.swift
//  ODataSwiftExample
//
//  Created by Swapnil Nandgave on 02/01/20.
//  Copyright © 2020 Celusion Technologies. All rights reserved.
//

import UIKit
import ODataSwift

class ViewController: UIViewController {

    @IBOutlet weak var labelGenQuery: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelGenQuery.text = ""
        ODataQueryBuilder.configure(url: "https://services.odata.org/V4")
    }
    
    @IBAction func selectDidPressed(_ sender: Any) {
        let str = ODataQueryBuilder().entity("Airports").selects(["Name","IcaoCode"]).build()
        labelGenQuery.text = str
    }
    
    @IBAction func filterDidPressed(_ sender: Any) {
        let filter = FilterExp("FirstName").eq().value("Scott").and([FilterExp("FirstName").eq().value("Scott")])
        var str = ODataQueryBuilder().entity("People").filter(filter).build()
        str += "\n" + ODataQueryBuilder().entity("People").filter(FilterExp("username").contains().value("7")).build()
        str += "\n" + ODataQueryBuilder().entity("Team").filter(FilterExp("Id").in().value([1234,2345])).build()
      str += "\n" + ODataQueryBuilder().entity("Test").filter(FilterExp(OperatorFunc("Teams", .any, .in).add("team", value: [2345,3432]))).build()
      let operatorFunc = OperatorFunc("Teams", .any, .eq).add("team", value: [2345,1234])
      str += "\n" + operatorFunc.queryText
        labelGenQuery.text = str
    }

    @IBAction func orderWithinExpandDidPressed(_ sender: Any) {
        let order = Order("EndsAt", orderType: .desc)
        let expand = Expand("Trips").order(order).selects(["FirstName", "LastName"])
        let str = ODataQueryBuilder().entity("People").expand(expand).build()
        labelGenQuery.text = str
    }

    @IBAction func expandDidPressed(_ sender: Any) {
        let filter = FilterExp("FirstName").eq().value("Scott").and([FilterExp("FirstName").eq().value("Scott")])
        let expand = Expand("Trips").filter(filter)
        let str = ODataQueryBuilder().entity("People").expand(expand).build()
        labelGenQuery.text = str
    }
    
    @IBAction func orderDidPressed(_ sender: Any) {
        let order = Order("EndsAt", orderType: .desc)
        let str = ODataQueryBuilder().entity("People").id("scottketchum", "Trips").order(order).build()
        labelGenQuery.text = str
    }
    
    @IBAction func topDidPressed(_ sender: Any) {
        let str = ODataQueryBuilder().entity("People").top(2).build()
        labelGenQuery.text = str
    }
    
    @IBAction func skipDidPressed(_ sender: Any) {
        let str = ODataQueryBuilder().entity("People").skip(18).build()
        labelGenQuery.text = str
    }
    
    @IBAction func countDidPressed(_ sender: Any) {
        var str = "Count Only: " + ODataQueryBuilder().entity("People").onlyCount().build()
        str += "\nWith Count: " + ODataQueryBuilder().entity("People").withCount().build()
        str += "\nInline Count: " + ODataQueryBuilder().entity("People").inlineCount("Name").build()
        labelGenQuery.text = str
    }
    
    @IBAction func searchDidPressed(_ sender: Any) {
        let str = ODataQueryBuilder().entity("People").search(Search("Name")).build()
        labelGenQuery.text = str
    }
    
    @IBAction func funcDidPressed(_ sender: Any) {
        var str = ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("name", Function.length)).eq().value(30)).build()
        str += "\n" + ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("designation", .tolower)).eq().value("director")).build()
        str += "\n" + ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("designation", .substring).value(1)).eq().value("di")).build()
        str += "\n" + ODataQueryBuilder().entity("People").filter(FilterExp(PropertyFunc("CreatedOn", .year)).eq().value(2018)).build()
        str += "\n" + ODataQueryBuilder().entity("People").filter(FilterExp("CreatedOn").lt().date(DateTime.now)).build()
        labelGenQuery.text = str
    }

}

