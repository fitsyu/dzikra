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
            let aSessionData = UserDefaults.standard.value(forKey: "session") as? Data,
            let session = try? JSONDecoder().decode(DzikrSession.self, from: aSessionData)
            else { handler(nil); return }
        
        
        var currentValue: Int = 0
        var maxValue: Int?
        var color: UIColor?
        
        currentValue = session.currentValue
        if let limit = session.limit {
            maxValue = limit
        }
        
        if let hex = session.color {
            color = UIColor(hex: hex)
        }
        
        // Common complicaton setup
        let textProvider = CLKSimpleTextProvider(text: "\(currentValue)")
        let fillFraction: Float
        if let limit = maxValue {
            fillFraction = Float(currentValue) / Float(limit)
        } else {
            fillFraction = 0
        }
        let ringStyle: CLKComplicationRingStyle = .closed
        let tintColor = color
        
        
        // The UI
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.textProvider = textProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeRingText()
            template.textProvider = textProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText()
            template.textProvider = textProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTable()
            
            
            template.headerTextProvider = CLKTextProvider(format: "%@", session.dzikrName)
            
            template.row1Column1TextProvider = CLKTextProvider(format: "%@", "\(session.currentValue)")
            template.row1Column2TextProvider = CLKTextProvider(format: "%@", "\(session.kalimahThoyyibah)")
            template.row2Column1TextProvider = CLKTextProvider(format: "%@", "\(session.limit ?? 0)")
            template.row2Column2TextProvider = CLKTextProvider(format: "%@ %%", "\(fillFraction*100)")
            
            
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = textProvider
            template.fillFraction = fillFraction
            template.ringStyle = ringStyle
            template.tintColor = tintColor
            
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            
            let prefix = session.kalimahThoyyibah.prefix(2)
            template.textProvider = CLKSimpleTextProvider(text: "\(currentValue) \(prefix)")
            template.tintColor = tintColor
            
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
            
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            
            template.textProvider = CLKSimpleTextProvider(text: "\(fillFraction*100)% \(session.kalimahThoyyibah)")
            template.tintColor = tintColor
            let entry = CLKComplicationTimelineEntry(date: Date(),
                                                     complicationTemplate: template)
            handler(entry)
            
            
        default:
            handler(nil)
        }
        
        
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
