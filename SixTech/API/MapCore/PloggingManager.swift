//
//  PloggingManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/28.
//

import CoreMotion
import SwiftUI

class PloggingManager: ObservableObject {
	private var pedometer = CMPedometer()
	private var timer: Timer?
	
	@Published var snapshottedMap: UIImage = UIImage()
	@Published var totalStep: Int = 0
	@Published var currentStep: Int = 0
	@Published var elapsedTime: TimeInterval = 0.0
	@Published var pickedCount: Int = 100

	var formattedElapsedTime: String {
		let hours = Int(elapsedTime) / 3600
		let minutes = Int(elapsedTime) / 60 % 60
		let seconds = Int(elapsedTime) % 60
		return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
	}
		
	func startPedometer() {
		if CMPedometer.isStepCountingAvailable() {
			pedometer.startUpdates(from: Date()) { data, error in
				if let error = error {
					print(error.localizedDescription)
					return
				}
				DispatchQueue.main.async {
					self.currentStep = data?.numberOfSteps.intValue ?? 0
				}
			}
		} else {
			print("StepCounting is not Available.")
		}
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			self.elapsedTime += 1.0
		}
	}
	
	func stopPedometer() {
		self.currentStep = 0
		pedometer.stopUpdates()
		self.timer?.invalidate()
		self.timer = nil
	}
}
