//
//  BasicBarChart.swift
//  CoreCharts
//


import UIKit

public class VCoreBarChart: BarChartCore {
    
    private var bottomPosition: CGFloat = 0
    
    override func onCreate(entries: [CoreChartEntry]) {
                        
        if entries.count > 0 {
            scrollView.contentSize = CGSize(width: ((displayConfig.barWidth)! + (displayConfig.barSpace)! + 2)*CGFloat(entries.count), height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            drawHorizontalLines(entries: entries)
            
            
            for i in 0..<entries.count {
                showEntry(index: i, entry: entries[i])
            }
            
            drawBottomLine()
            
        }
    }
   
    
    private func showEntry(index: Int, entry: CoreChartEntry) {
        
        /// Starting x postion of the bar
        let xPos: CGFloat = (displayConfig.barSpace)! + CGFloat(index) * ((displayConfig.barWidth)! + (displayConfig.barSpace)!)
        
        /// Starting y postion of the bar
        let yPos: CGFloat = translateHeightValueToYPosition(value: Float(entry.barHeight))
                
        drawBar(xPos: xPos, yPos: yPos, entry: entry)
        
        /// Draw text above the bar
        drawTextValue(xPos: xPos, yPos: yPos, textValue: entry.barHeightText, color: entry.barColor)
        
        /// Draw text below the bar
        drawTitle(xPos: xPos, yPos: bottomPosition, title: entry.barTitle, color: entry.barColor)
    }
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat, entry: CoreChartEntry) {
        let barLayer = CALayer()
        barLayer.cornerRadius = 2
        barLayer.backgroundColor = entry.barColor.cgColor

        barLayer.frame = CGRect(
            x: xPos,
            y: yPos + valueTextHeight,
            width: (displayConfig.barWidth)!,
            height: ((scrollView.frame.height - (displayConfig.bottomSpace)!)) - yPos - valueTextHeight
        )
        
        layers.append((barLayer, entry))
        
        mainLayer.addSublayer(barLayer)
        
        if bottomPosition == 0 {
            bottomPosition = ((scrollView.frame.height - (displayConfig.bottomSpace)!))
        }
        
    }
   
    
    private func drawHorizontalLines(entries: [CoreChartEntry]) {
        
        func drawHorizontalLine(entry: CoreChartEntry){
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = entry.barColor.cgColor
            shapeLayer.lineCap = kCALineCapRound
            shapeLayer.lineWidth = 0.5
            shapeLayer.lineDashPattern = [1,8]
            
            let translatedBarHeight = translateHeightValueToYPosition(value: Float(entry.barHeight)) + valueTextHeight
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: translatedBarHeight),CGPoint(x: frame.maxX, y: translatedBarHeight)])
            
            shapeLayer.path = path
            
            layer.insertSublayer(shapeLayer, at: 0)
            
        }
        
        for entry in entries{
            drawHorizontalLine(entry: entry)
        }
        
    }
    
    private func drawBottomLine(){
        
        let shapeLayerLine = CAShapeLayer()
        shapeLayerLine.strokeColor = UIColor.gray.cgColor
        shapeLayerLine.lineWidth = 0.5
        
        let pathLine = CGMutablePath()
        pathLine.addLines(between: [CGPoint(x: 0, y: bottomPosition),CGPoint(x: frame.maxX, y: bottomPosition)])
        
        shapeLayerLine.path = pathLine
        
        layer.insertSublayer(shapeLayerLine, at: 0)
        
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String, color: UIColor) {
        
        let valueFontSize = displayConfig.titleFontSize ?? 15
        
        let font = displayConfig.titleFont ?? UIFont.systemFont(ofSize: valueFontSize)
        
        let textSize = getTextSize(text: textValue, font: font)
        
        let textLayer = CATextLayer()
        
        textLayer.frame = CGRect(
            x: xPos + (((displayConfig.barWidth)! / 2) - textSize.width / 2),
            y: yPos,
            width: textSize.width,
            height: textSize.height
        )
        
        textLayer.foregroundColor = color.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(font.fontName as CFString, 0, nil)
        
        textLayer.fontSize = valueFontSize
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String, color: UIColor) {
        
        let titleFontSize = displayConfig.titleFontSize ?? 15
        
        let font = displayConfig.titleFont ?? UIFont.systemFont(ofSize: titleFontSize)
        
        let textSize = getTextSize(text: title, font: font)
        
        let textLayer = CATextLayer()
        
        textLayer.frame = CGRect(
            x: xPos + (((displayConfig.barWidth)! / 2) - textSize.width / 2) ,
            y: yPos,
            width: textSize.width,
            height: textSize.height
        )
        
        textLayer.foregroundColor = color.cgColor
        
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(font.fontName as CFString, 0, nil)
        textLayer.fontSize = titleFontSize
        textLayer.string = convertTitleText(title: title)
        mainLayer.addSublayer(textLayer)
    }
    
    private func convertTitleText(title: String) -> String{
        
        let titleLength = displayConfig.titleLength ?? 5
        
        var newTitle = ""
        
        if title.count > titleLength {
            newTitle = title.prefix(titleLength) + ".."
        }else {
            newTitle = title
        }
        
        return newTitle
    }
    
    private func translateHeightValueToYPosition(value: Float) -> CGFloat {
        let height: CGFloat = CGFloat(value) * (mainLayer.frame.height - (displayConfig.bottomSpace)! - (displayConfig.topSpace)!)
        return mainLayer.frame.height - (displayConfig.bottomSpace)! - height - valueTextHeight
    }
    
}
