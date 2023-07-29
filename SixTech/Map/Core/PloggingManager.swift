//
//  PloggingManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/28.
//

import CoreMotion

class PloggingManager: ObservableObject {
	private var pedometer = CMPedometer()
	@Published var steps: Int = 0
	@Published var time: TimeInterval?
	
	init() {
		startPedometer()
	}
	
	func startPedometer() {
		if CMPedometer.isStepCountingAvailable() {
			pedometer.startUpdates(from: Date()) { data, error in
				if let error = error {
					print(error.localizedDescription)
					return
				}
				DispatchQueue.main.async {
					self.steps = data?.numberOfSteps.intValue ?? 0
				}
			}
		} else {
			print("걸음수 카운트안됨")
		}
	}
}
