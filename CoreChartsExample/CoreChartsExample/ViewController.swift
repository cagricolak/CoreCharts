//
//  ViewController.swift
//  CoreChartsExample
//
//  Created by cgcolak on 22.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit
import CoreCharts

class DemoViewController: UIViewController,CoreChartViewDataSource {

    @IBOutlet weak var barChart: VCoreBarChart!
    
    
    func didTouch(entryData: CoreChartEntry) {
        print(entryData.barTitle)
    }
    
    func loadCoreChartData() -> [CoreChartEntry] {
        
        return getTurkeyFamouseCityList()
        
    }
    
    
    func getTurkeyFamouseCityList()->[CoreChartEntry] {
        var allCityData = [CoreChartEntry]()
        let cityNames = ["Istanbul","Antalya","Ankara","Trabzon","İzmir"]
        let plateNumber = [34,07,06,61,35]
        
        for index in 0..<cityNames.count {
            
            let newEntry = CoreChartEntry(id: "\(plateNumber[index])", barTitle: cityNames[index], barHeight: Double(plateNumber[index]), barColor: rainbowColor())
            allCityData.append(newEntry)
            
        }
        
        return allCityData
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

