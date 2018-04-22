//
//  Extensions.swift
//  CoreCharts
//
//  Created by Kemal Türk on 19.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit

extension CoreChartViewDataSource {
    
    public func rainbowColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

