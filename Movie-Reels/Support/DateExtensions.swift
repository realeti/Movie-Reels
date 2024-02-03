//
//  DateExtensions.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation

extension DateFormatter {
    static func formattedString(from dateString: String, inputFormat: String, outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputFormat
            
            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
