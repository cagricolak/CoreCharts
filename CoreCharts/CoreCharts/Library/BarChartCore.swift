//
//  BarChart.swift
//  Grafix
//
//  Created by Kemal Türk on 15.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit


public class BarChartCore: UIView {
    
    
    /// contain all layers of the chart
    internal let mainLayer: CALayer = CALayer()
    
    /// contain mainLayer to support scrolling
    internal let scrollView: MScrollView = MScrollView()
    
    public var dataSource: CoreChartViewDataSource? = nil {
        didSet{
            //When onClickListener set, we declaring the scrollView's onclick.
            scrollView.onClick = scrollViewClickListener
        }
    }

    public let displayConfig: CoreBarChartsDisplayConfig = CoreBarChartsDisplayConfig()
    
    private var drawSwitch = false
    
    private var maxValue: Double = 0
    
    internal var maxBarHeight: Double = 0
    internal var minBarHeight: Double = 0
    
    internal var titleTextHeight: CGFloat = 0
    internal var valueTextHeight: CGFloat = 0
        
    internal var layers: [(CALayer,CoreChartEntry)] = []

    //Abstract function
    internal func onCreate(entries: [CoreChartEntry]) {}
    
    //Abstract function
    internal func getOrientation() -> CoreChartOrientation {
        return CoreChartOrientation.Vertical
    }
    
    private var dataEntries: [CoreChartEntry]? = nil {
        didSet {

            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            //Clean layers
            layers.removeAll()

            onCreate(entries: dataEntries ?? [CoreChartEntry]())
            
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    convenience public init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func scrollViewClickListener(point: CGPoint?){
                
        if layers.count > 0 {
            
            for layer in layers {
                
                if point != nil && layer.0.frame.contains(point!) {
                    
                    dataSource?.didTouch?(entryData: layer.1)
                    
                }
                
            }
            
        }
        
    }
    
    private func setupView() {
        
        self.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.addSublayer(mainLayer)
        
        self.addSubview(scrollView)
        
    }
    
    
    private func draw(){
        
        autoScale()
        
        if let entries = dataSource?.loadCoreChartData() {
            
            let ch = calculateHeights(entries: entries)
            if ch != nil {
                dataEntries = ch
            }
        }
    }
    
    override public func draw(_ rect: CGRect) {
        if !drawSwitch{
            draw()
            drawSwitch = true
        }
    }
    
    
    private func calculateHeights(entries: [CoreChartEntry]) -> [CoreChartEntry]? {
        
        //Bu fonksiyon entry value'ları en yüksek value değerine bölerek 0 ile 1 arasında bir değer oluşturuyor.
        //Bu sayede en üst nokta olarak en yüksek value değerini kabul ediyoruz ve diğer value verilerini bu değere göre düzenliyoruz.
        
        if entries.count == 0 {
            return nil
        }
        var peakValues: [Double] = [Double]()
        
        for entry in entries {
            peakValues.append(entry.barHeight)
        }
        
        maxValue = peakValues.max() ?? Double(scrollView.frame.height)
        var minValue = peakValues.min() ?? Double(scrollView.frame.height / 3)
        
        if (entries.count == 1){
            minValue = Double(scrollView.frame.height / 3)
        }
        
        // Fixed 2018/10/23
        if maxValue > 0 {
            maxBarHeight = maxValue / maxValue
            minBarHeight = minValue / maxValue
        }
        
        for index in 0...entries.count - 1 {
            
            let entry = entries[index]
            
            let barHeight = entry.barHeight
            entry.barHeightText = String(barHeight.description.split(separator: ".")[0])
            // Fixed 2018/10/23
            if maxValue > 0 {
                entry.barHeight = entry.barHeight / maxValue
            }
            
        }
        
        return entries
    }
    
    
    private func autoScale() {
        
        //Bu fonksiyon displayConfig kullanıcı tarafından verilmediğinde devreye girerek boyutların default olarak en uygun şekilde ayarlanmasını sağlıyor.
        
        print("AutoScale gıdıklandı.")
        
        displayConfig.titleLength = displayConfig.titleLength ?? 8
        
        let orientation = getOrientation()
        
        var p: CGFloat = 0
        //var pReverse: CGFloat = 0
        
        switch orientation {
        case CoreChartOrientation.Horizontal:
            p = scrollView.frame.height
            //pReverse = scrollView.frame.width
        case CoreChartOrientation.Vertical:
            p = scrollView.frame.width
            //pReverse = scrollView.frame.height
        }
        
        displayConfig.barWidth = displayConfig.barWidth ?? p / 10
        displayConfig.barSpace = displayConfig.barSpace ?? p / 14
        
        displayConfig.valueFontSize = displayConfig.valueFontSize ?? ((displayConfig.barWidth)! + (displayConfig.barSpace)!) / 4
        
        
        displayConfig.titleFontSize = displayConfig.titleFontSize ?? ((displayConfig.barWidth)! + (displayConfig.barSpace)!) / 5
        
        displayConfig.titleFont = displayConfig.titleFont ?? UIFont.systemFont(ofSize: (displayConfig.titleFontSize)!)
        displayConfig.valueFont = displayConfig.valueFont ?? UIFont.systemFont(ofSize: (displayConfig.valueFontSize)!)
        
        displayConfig.topSpace = displayConfig.topSpace ?? 0
        displayConfig.bottomSpace = displayConfig.bottomSpace ?? 0
        
        calculateMinPaddings(orientation: orientation)
        
    }
    
    private func calculateMinPaddings(orientation: CoreChartOrientation){
        titleTextHeight = getTextSize(text: "X", font: (displayConfig.titleFont)!).height
        valueTextHeight = getTextSize(text: "X", font: (displayConfig.valueFont)!).height
        let valueTextWidth = getTextSize(text: "XXXX", font: (displayConfig.valueFont)!).width
        
        let topSpace = displayConfig.topSpace ?? 0
        let bottomSpace = displayConfig.bottomSpace ?? 0
        
        print("Calculate")
        
        switch orientation {
        case CoreChartOrientation.Vertical:
            print("Vertical")
            if topSpace < valueTextHeight {
                displayConfig.topSpace = valueTextHeight
            }
            
            if bottomSpace < titleTextHeight {
                displayConfig.bottomSpace = titleTextHeight
            }
        case CoreChartOrientation.Horizontal:
            print("Horizontal")
            if topSpace < valueTextWidth {
                displayConfig.topSpace = valueTextWidth
            }
        }
        
        
    }
    
    
    override public func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        if backgroundColor != displayConfig.backgroundColor {
            backgroundColor = displayConfig.backgroundColor
        }
    }
    
    func getTextSize(text: String, font: UIFont) -> CGSize {
        //Yazı boyutunu almak için
        return (text as NSString).size(withAttributes: [NSAttributedStringKey.font : font])
    }
    
    public func reload() {
        drawSwitch = false
        self.setNeedsDisplay()
    }
    

}

class MScrollView: UIScrollView {
    
    var onClick: ((CGPoint?) -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        
        
        onClick?(point)
    }
    
}



