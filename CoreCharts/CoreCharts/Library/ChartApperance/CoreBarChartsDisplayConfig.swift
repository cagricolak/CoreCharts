//
//  VBarChartUISettings.swift
//  CoreCharts
//
//  Created by Kemal Türk on 15.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit

public class CoreBarChartsDisplayConfig {
    
    /// the width of each bar
    var barWidth: CGFloat?
    
    /// space between each bar
    var barSpace: CGFloat?
    
    /// space at the bottom of the bar to show the title
    var bottomSpace: CGFloat?
    
    /// space at the top of each bar to show the value
    var topSpace: CGFloat?
    
    var backgroundColor: UIColor = UIColor.clear
    
    var titleFontSize:CGFloat?
    var valueFontSize:CGFloat?
    
    var titleFont: UIFont?
    var valueFont: UIFont?
    
    var titleLength: Int?
    
    public init(){}
    
    public init(barWidth:CGFloat?, barSpace:CGFloat?, bottomSpace:CGFloat?, topSpace:CGFloat?, backgroundColor: UIColor?,
                titleFontSize: CGFloat?, valueFontSize: CGFloat?, titleFont: UIFont?, valueFont: UIFont?, titleLength: Int?) {
        
        self.barWidth = barWidth
        self.barSpace = barSpace
        self.bottomSpace = bottomSpace
        self.topSpace = topSpace
        self.backgroundColor = backgroundColor ?? UIColor.clear
        self.titleFontSize = titleFontSize
        self.valueFontSize = valueFontSize
        self.titleFont = titleFont
        self.valueFont = valueFont
        self.titleLength = titleLength
        
    }
    
}
