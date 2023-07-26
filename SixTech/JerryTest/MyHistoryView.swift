//
//  MyHistoryView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/26.
//

import SwiftUI

struct MyHistoryView: View {
    
    @State var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("2023년 7월의 소모 칼로리")
                    Text("9013 kcal")
                    Text("라멘 20그릇")
                    Text("🍜🍜🍜🍜🍜🍜🍜🍜🍜🍜🍜🍜🍜🍜🍜\n🍜🍜🍜🍜🍜")
                    Text("만큼 칼로리를 소비했어요.")
                }
                VStack {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                        .padding(.horizontal)
                        .datePickerStyle(CustomGraphicalDatePickerStyle())
                    Divider()
                }
                .padding(.vertical, 100)
                
            }
            
        }
        //        .navigationBarBackButtonHidden()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct MyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MyHistoryView()
    }
}
