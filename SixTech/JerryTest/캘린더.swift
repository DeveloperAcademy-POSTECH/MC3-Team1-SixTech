//
//  캘린더.swift
//  SixTech
//
//  Created by 주환 on 2023/07/26.
//

import SwiftUI

struct CustomGraphicalDatePickerStyle: DatePickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            DatePicker(
                "",
                selection: configuration.$selection,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(GraphicalDatePickerStyle())

            // Customize the selected date's circle color
            if let dateRect = getDateRect(configuration: configuration) {
                Circle()
                    .foregroundColor(.yellow)
                    .frame(width: dateRect.size.width + 8, height: dateRect.size.width + 8)
                    .position(x: dateRect.midX, y: dateRect.midY)
            }

            // Customize the position of the year and month view
            if let yearMonthRect = getYearMonthRect(configuration: configuration) {
                configuration.label
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                    .position(x: yearMonthRect.midX, y: yearMonthRect.midY + 50)
            }
        }
    }

    private func getDateRect(configuration: Configuration) -> CGRect? {
        // Modify this function to get the CGRect of the selected date in the DatePicker
        // For example, you can use `GeometryReader` to get the frame of the DatePicker and then calculate the selected date's CGRect.
        // If you are using a custom DatePicker, you should provide a way to get the selected date's CGRect.
        return nil
    }

    private func getYearMonthRect(configuration: Configuration) -> CGRect? {
        // Modify this function to get the CGRect of the year and month view in the DatePicker
        // Similar to the previous function, you need to provide a way to get the year and month view's CGRect.
        return nil
    }
}
