//
//  CoreChartEntry.swift
//  CoreCharts
//
//  Created by cgcolak on 14.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit


/// BarChart'da gösterilecek veri modeli
@objc public class CoreChartEntry:NSObject {
    
    /// gönderilen veriye ait uniq veri
    public var id: String
    
    /// bar rengi
    public var barColor: UIColor
    
    /// bar yüksekliği
    public var barHeight: Double
    
    public var barTitle: String
    
    internal var barHeightText: String = "0.0"
    
    public init(id: String, barTitle:String,barHeight:Double,barColor:UIColor) {
        self.id = id
        self.barTitle = barTitle
        self.barHeight = barHeight
        self.barColor = barColor
    }
    
}
