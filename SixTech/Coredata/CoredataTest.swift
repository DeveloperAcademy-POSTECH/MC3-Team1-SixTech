//
//  CoredataTest.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

import SwiftUI

struct CoredataTest: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @State private var date: Date = Date()
    @State private var kilometer: String = ""
    @State private var steps: String = ""
    @State private var trash: String = ""
    @State private var kcal: Int16 = 0
    @State private var image: URL? = URL(string: "file:///Users/a_mcflurry/Library/Developer/Xcode/UserData/Previews/Simulator%20Devices/9C22CA36-B077-4ADB-AE51-F31615D8E474/data/Containers/Data/Application/EB164961-9917-422D-867E-1D8A093325CB/Documents/F3174D90-0F91-41F7-A3E4-A70F91269D53.png")
    
    var body: some View {
        NavigationView{
            VStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                
                TextField("Kilometer", text: $kilometer)
                TextField("Steps", text: $steps)
                TextField("Trash", text: $trash)
                TextField("Kcal", value: $kcal, formatter: NumberFormatter())
                
                // 이미지를 추가하는 버튼 또는 필드를 구현해야 할 수도 있습니다.
                // ImagePicker 등을 사용하여 이미지를 선택하고, 해당 이미지의 URL을 image에 할당하는 방법 등이 있습니다.
                
                NavigationLinkView(text: "선택하기"
                                   , isdisable: Binding.constant(false)
                                   , destination: CoredataFetchTestView())
                .simultaneousGesture(TapGesture().onEnded {
                    CoredataManager().addHistory(date: date, image: image!, trash: trash, steps: steps, kilometer: kilometer, kcal: kcal, context: managedObjContext)
                })
            }
        }
    }
}

struct CoredataTest_Previews: PreviewProvider {
    static var previews: some View {
        CoredataTest()
    }
}

struct CoredataFetchTestView: View {
    // Create an instance of CoredataManager
    @Environment (\.managedObjectContext) var managedObjContext
    let coredataManager = CoredataManager()
    //    @State private var fetchedData: [History] = []
    
    var body: some View {
        VStack {
            Button("Fetch Data") {
                let targetDate = coredataManager.createDate(year: 2023, month: 8, days: 15)
                let historyForDate = coredataManager.fetchHistory(targetDate: targetDate)
                    for history in historyForDate {
                            // Process the history objects
                            print("-----------------")
                            print("Date: \(history.date ?? Date())")
                            print("Image URL: \(history.image ?? URL(string: "")!)")
                            print("Trash: \(history.trash ?? "")")
                            print("Steps: \(history.steps ?? "")")
                            print("Kilometer: \(history.kilometer ?? "")")
                            print("Kcal: \(history.kcal)")
                            print("-----------------")
                        }
            }
            
            Button("Fetch ALL Data") {
                let allHistory = coredataManager.fetchAllHistory()
                
                for history in allHistory {
                    // Process the history objects
                    print("-----------------")
                    print("Date: \(history.date ?? Date())")
                    print("Image URL: \(history.image ?? URL(string: "")!)")
                    print("Trash: \(history.trash ?? "")")
                    print("Steps: \(history.steps ?? "")")
                    print("Kilometer: \(history.kilometer ?? "")")
                    print("Kcal: \(history.kcal)")
                    print("-----------------")
                }
            }
            
            Button("Delete Data") {
                coredataManager.deleteAllData()
            }
        }
    }
    

}
