//
//  VBarChartViewDelegate.swift
//  CoreCharts
//
//  Created by cgcolak on 14.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit

@objc public protocol CoreChartViewDataSource:class {
    
    func loadCoreChartData()->[CoreChartEntry]
    @objc optional func didTouch(entryData:CoreChartEntry)
}

