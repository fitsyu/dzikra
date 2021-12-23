//
//  ComplicationController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 20/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: Properties
    
    let activeSessionManager = ActiveSessionManager()
    
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
        
        activeSessionManager.load(completion: { activeSession in
            
            guard let session = activeSession else {
                let noSessionEntry = self.makeNoSessionTemplateEntry(for: complication)
                handler(noSessionEntry)
                return
            }
            
            let entry = self.makeTimelineEntry(for: session, complication: complication)
            handler(entry)
        })
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

// MARK: Helper

extension ComplicationController {
    
    func makeTimelineEntry(for session: DzikrSession, complication: CLKComplication) -> CLKComplicationTimelineEntry {
        
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
            let template = CLKComplicationTemplateCircularSmallRingText(
                textProvider: currentValueTextProvider,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeRingText(
                textProvider: currentValueTextProvider,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText(
                textProvider: currentValueTextProvider,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            
            template.textProvider = currentValueTextProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .modularLarge:
            let left = maxValue-currentValue
            let message = left == 0 ? "Selesai" : "\(left) lagi"
            
            let template = CLKComplicationTemplateModularLargeTable(
                headerTextProvider: CLKSimpleTextProvider(text: session.dzikrName),
                row1Column1TextProvider: CLKSimpleTextProvider(text: percent),
                row1Column2TextProvider: CLKSimpleTextProvider(text: session.kalimahThoyyibah),
                row2Column1TextProvider: CLKSimpleTextProvider(text: "\(currentValue)/\(maxValue)"),
                row2Column2TextProvider: CLKSimpleTextProvider(text: message)
            )
            
            theTemplate = template
            
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText(
                textProvider: currentValueTextProvider,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .utilitarianSmallFlat:
            let prefix = session.kalimahThoyyibah.prefix(2)
            let template = CLKComplicationTemplateUtilitarianSmallFlat(
                textProvider: CLKSimpleTextProvider(text: "\(currentValue) \(prefix)")
            )
            
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat(
                textProvider: CLKSimpleTextProvider(text: "\(percent) \(session.kalimahThoyyibah)")
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .fill, gaugeColor: tintColor, fillFraction: fillFraction),
                leadingTextProvider: currentValueTextProvider,
                trailingTextProvider: CLKSimpleTextProvider(text: "\(maxValue)"),
                outerTextProvider: CLKSimpleTextProvider(text: session.kalimahThoyyibah)
            )
            
            theTemplate = template
            
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .ring,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction),
                centerTextProvider: currentValueTextProvider
            )
            
            theTemplate = template
            
        case .graphicBezel:
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .ring,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction),
                centerTextProvider: currentValueTextProvider
            )
            
            let topTextProvider = CLKSimpleTextProvider(text: "\(percent) - \(session.kalimahThoyyibah)")
            topTextProvider.tintColor = tintColor
            
            let template = CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: circularTemplate,
                textProvider: topTextProvider
            )
            
            theTemplate = template
            
        case .graphicRectangular:
            let header = session.kalimahThoyyibah
            let lagi = "\((maxValue )-currentValue) Lagi"
            let template = CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: CLKSimpleTextProvider(text: header),
                body1TextProvider: CLKSimpleTextProvider(text: "\(percent), \(lagi)."),
                gaugeProvider: CLKSimpleGaugeProvider(style: .fill,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction)
            )
            
            theTemplate = template
            
        case .graphicExtraLarge:
            fallthrough
        @unknown default:
            return CLKComplicationTimelineEntry()
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: theTemplate)
        return entry
    }
    
    func makeNoSessionTemplateEntry(for complication: CLKComplication) -> CLKComplicationTimelineEntry {
        
        let theDzikrOneLetterBrand = CLKSimpleTextProvider(text: "ذ")
        let theDzikrLetterBrand = CLKSimpleTextProvider(text: "Dzikra")
        let noActiveSessionText = CLKSimpleTextProvider(text: "No active session")
        let fillFraction: Float = 0
        let ringStyle = CLKComplicationRingStyle.closed
        let tintColor = UIColor.white
        
        
        
        var theTemplate: CLKComplicationTemplate
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText(
                textProvider: theDzikrOneLetterBrand,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeRingText(
                textProvider: theDzikrOneLetterBrand,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText(
                textProvider: theDzikrOneLetterBrand,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTable(
                headerTextProvider: theDzikrOneLetterBrand,
                row1Column1TextProvider: theDzikrOneLetterBrand,
                row1Column2TextProvider: noActiveSessionText,
                row2Column1TextProvider: theDzikrOneLetterBrand,
                row2Column2TextProvider: noActiveSessionText
            )
            
            theTemplate = template
            
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText(
                textProvider: theDzikrOneLetterBrand,
                fillFraction: fillFraction,
                ringStyle: ringStyle
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat(
                textProvider: theDzikrOneLetterBrand
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat(
                textProvider: noActiveSessionText
            )
            template.tintColor = tintColor
            
            theTemplate = template
            
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .fill,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction),
                leadingTextProvider: theDzikrOneLetterBrand,
                trailingTextProvider: theDzikrOneLetterBrand,
                outerTextProvider: noActiveSessionText
            )
            
            theTemplate = template
            
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .ring,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction),
                centerTextProvider: theDzikrOneLetterBrand
            )
            
            
            
            theTemplate = template
            
        case .graphicBezel:
            let topTextProvider = noActiveSessionText
            topTextProvider.tintColor = tintColor
            
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .ring,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction),
                centerTextProvider: theDzikrOneLetterBrand
            )
            
            let template = CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: circularTemplate,
                textProvider: topTextProvider
            )
            
            theTemplate = template
            
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: theDzikrLetterBrand,
                body1TextProvider: noActiveSessionText,
                gaugeProvider: CLKSimpleGaugeProvider(style: .fill,
                                                      gaugeColor: tintColor,
                                                      fillFraction: fillFraction)
            )
            theTemplate = template
        default:
            theTemplate = CLKComplicationTemplateModularSmallSimpleText(
                textProvider: theDzikrOneLetterBrand
            )
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: theTemplate)
        return entry
    }
}
