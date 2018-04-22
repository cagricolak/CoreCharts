//
//  HBarChart.swift
//  Grafix
//
//  Created by Kemal Türk on 15.04.2018.
//  Copyright © 2018 Çağrı ÇOLAK. All rights reserved.
//

import UIKit

public class HCoreBarChart: BarChartCore {
    
    private var viewHeight: CGFloat = 0
    private var viewWidth: CGFloat = 0
    
    override func onCreate(entries: [CoreChartEntry]) {
        
        backgroundColor = UIColor.red
        
        viewHeight = scrollView.frame.height
        viewWidth = scrollView.frame.width
        
        if entries.count > 0 {
            
            scrollView.contentSize = CGSize(
                width: scrollView.frame.width,
                height: (((displayConfig.barWidth)! + (displayConfig.barSpace)! + 2) * CGFloat(entries.count)) + (displayConfig.barSpace)!)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            //drawStartLine()
            
            // drawVerticalLines(entries: entries)
            
            for i in 0..<entries.count {
                showEntry(index: i, entry: entries[i])
            }
        }
        
    }
    
    
    private func showEntry(index: Int, entry: CoreChartEntry) {
        /// Starting x postion of the bar
        let xPos: CGFloat = (displayConfig.bottomSpace)!

        /// Starting y postion of the bar
        let yPos: CGFloat = CGFloat(index) * ((displayConfig.barWidth)! + (displayConfig.barSpace)!) + (displayConfig.barSpace)!
        
//        if index == 0 {
//            yPos -= (displayConfig.space)!
//        }
        
        
        
        let barWidth = drawBar(xPos: xPos, yPos: yPos, entry: entry)
        
        drawTitle(xPos: xPos, yPos: yPos, title: entry.barTitle, color: entry.barColor)

        drawTextValue(barWidth: barWidth, yPos: yPos, textValue: entry.barHeightText, color: entry.barColor)

    }
    
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat, entry: CoreChartEntry) -> CGFloat{
        
        let width = CGFloat(entry.barHeight) * (mainLayer.frame.width - (displayConfig.bottomSpace)! - (displayConfig.topSpace)!)
        
        let barLayer = CALayer()
        barLayer.cornerRadius = 2
        barLayer.backgroundColor = entry.barColor.cgColor
        
        barLayer.frame = CGRect(
            x: xPos,
            y: yPos,
            width: width,
            height: (displayConfig.barWidth)!
        )

        mainLayer.addSublayer(barLayer)
        
        layers.append((barLayer, entry))
        
        return width
        
    }
    
    
    private func drawVerticalLines(entries: [CoreChartEntry]) {
        
        func drawVerticalLine(entry: CoreChartEntry){
            
            let barEnd = CGFloat(entry.barHeight) * (viewWidth - (displayConfig.bottomSpace)! - (displayConfig.topSpace)!) + (displayConfig.bottomSpace)!
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = entry.barColor.cgColor
            shapeLayer.lineCap = kCALineCapRound
            shapeLayer.lineWidth = 0.5
            shapeLayer.lineDashPattern = [4,4]
            
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: barEnd, y: 0),CGPoint(x: barEnd, y: viewHeight)])
            
            shapeLayer.path = path
            
            layer.insertSublayer(shapeLayer, at: 0)
            
        }
        
        for entry in entries{
            drawVerticalLine(entry: entry)
        }
        
    }
    
    
    private func drawStartLine(){
        
        let shapeLayerLine = CAShapeLayer()
        shapeLayerLine.strokeColor = UIColor.gray.cgColor
        shapeLayerLine.lineWidth = 0.5
        
        let pathLine = CGMutablePath()
        pathLine.addLines(between: [CGPoint(x: (displayConfig.bottomSpace)!, y: 0),CGPoint(x: (displayConfig.bottomSpace)!, y: viewHeight)])
        
        shapeLayerLine.path = pathLine
        
        layer.insertSublayer(shapeLayerLine, at: 0)
        
    }
    
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String, color: UIColor) {
        
        let titleFontSize = displayConfig.titleFontSize ?? 15

        let font = displayConfig.titleFont ?? UIFont.systemFont(ofSize: titleFontSize)

        let textSize = getTextSize(text: title, font: font)
        
        let textLayer = CATextLayer()
        
        textLayer.frame = CGRect(
            x: xPos + 1,
            y: (yPos - titleFontSize) - (viewHeight / 200),
            width: textSize.width,
            height: textSize.height
        )
        
        textLayer.foregroundColor = color.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(font.fontName as CFString, 0, nil)
        textLayer.fontSize = titleFontSize
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
        
    }
    
    
    private func drawTextValue(barWidth: CGFloat, yPos: CGFloat, textValue: String, color: UIColor) {
        
        let valueFontSize = displayConfig.valueFontSize ?? 15
        
        let font = displayConfig.valueFont ?? UIFont.systemFont(ofSize: valueFontSize)
        
        let textSize = getTextSize(text: textValue, font: font)
        
        let textLayer = CATextLayer()
        
        textLayer.frame = CGRect(
            x: barWidth + (textSize.width / CGFloat(textValue.count)) + (displayConfig.bottomSpace)!,
            y: yPos + (((displayConfig.barWidth)! / 2) - (textSize.height / 2)),
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
    
    override func getOrientation() -> CoreChartOrientation {
        return CoreChartOrientation.Horizontal
    }
    
}
