//
//  Numeric+Format.swift
//  SixTech
//
//  Created by Junyoo on 2023/08/01.
//

import Foundation

extension Int {
	var formatWithDot: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
}

extension Double {
	var formatWithDot: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
}
