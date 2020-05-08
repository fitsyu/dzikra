//
//  ComplicationController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 20/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        
        
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        
        // The data to show up there
        guard
            let aSessionData = UserDefaults.standard.value(forKey: KEY_ACTIVE_SESSION) as? Data,
            let session = try? JSONDecoder().decode(DzikrSession.self, from: aSessionData)
        else { handler(nil); return }
        
        
        let currentValue: Int = session.currentValue
        let maxValue: Int = session.limit ?? 0
        let color: UIColor
        
        if let hex = session.color {
            color = UIColor(hex: hex) ?? UIColor.white
        } else {
            color = UIColor.white
        }
        
        // Common complicaton setup
        let currentValueTextProvider = CLKSimpleTextProvider(text: "\(currentValue)")
        let fillFraction: Float = Float(currentValue) / Float(maxValue)
        let percent = String(format: "%.0f%%", fillFraction*100)
        
        let ringStyle: CLKComplicationRingStyle = .closed
        let tintColor = color
        
        // The UI
        var theTemplate: CLKComplicationTemplate
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText()
            
            template.textProvider = currentValueTextProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeRingText()
            
            template.textProvider = currentValueTextProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText()
            
            template.textProvider = currentValueTextProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTable()
            
            template.headerTextProvider = CLKSimpleTextProvider(text: session.dzikrName)
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: percent)
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: session.kalimahThoyyibah)
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "\(currentValue)/\(maxValue)")
            
            let left = maxValue-currentValue
            let message = left == 0 ? "Selesai" : "\(left) lagi"
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: message)
  
            theTemplate = template
            
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            
            template.textProvider = currentValueTextProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            
            let prefix = session.kalimahThoyyibah.prefix(2)
            template.textProvider = CLKSimpleTextProvider(text: "\(currentValue) \(prefix)")
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            
            template.textProvider = CLKSimpleTextProvider(text: "\(percent) \(session.kalimahThoyyibah)")
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerGaugeText()
            
            template.outerTextProvider = CLKSimpleTextProvider(text: session.kalimahThoyyibah)
            template.leadingTextProvider = currentValueTextProvider
            template.trailingTextProvider = CLKSimpleTextProvider(text: "\(maxValue)")
            
            let gaugeColor = tintColor
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: gaugeColor, fillFraction: fillFraction)
            
            theTemplate = template
            
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            
            template.centerTextProvider = currentValueTextProvider
            let gaugeColor = tintColor
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .ring,
                                                            gaugeColor: gaugeColor,
                                                            fillFraction: fillFraction)
            
            theTemplate = template
            
        case .graphicBezel:
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            
            let topTextProvider = CLKSimpleTextProvider(text: "\(percent) - \(session.kalimahThoyyibah)")
            topTextProvider.tintColor = tintColor
            template.textProvider = topTextProvider
            
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            
            circularTemplate.centerTextProvider = currentValueTextProvider
            let gaugeColor = tintColor
            circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .ring,
                                                                    gaugeColor: gaugeColor,
                                                                    fillFraction: fillFraction)
            template.circularTemplate = circularTemplate
            
            theTemplate = template
            
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularTextGauge()
            
            let header = session.kalimahThoyyibah
            template.headerTextProvider = CLKSimpleTextProvider(text: header)
            
            let lagi = "\((maxValue )-currentValue) Lagi"
            template.body1TextProvider = CLKSimpleTextProvider(text: "\(percent), \(lagi).")
            
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                            gaugeColor: tintColor,
                                                            fillFraction: fillFraction)
            theTemplate = template
            
        @unknown default:
            handler(nil)
            return
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: theTemplate)
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        handler(nil)
    }
    
}
