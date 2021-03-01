//
//  TimeInterval+Date.swift
//  callloop
//
//  Created by Su on 2021/3/1.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation

extension TimeInterval {
	
	static let dateFormatter = DateFormatter()
	
    func toDate(format: String) -> String {
        let date = Date(timeIntervalSince1970: self)
		let dateformat = TimeInterval.dateFormatter
        dateformat.dateFormat = format
        let timeZone = TimeZone.current
        dateformat.timeZone = timeZone
        return dateformat.string(from: date)
    }
}
