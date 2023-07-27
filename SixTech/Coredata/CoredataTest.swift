//
//  CoredataTest.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

/*
    머스크가 Coredata를 열심히 삽질하기 위해 만든 뷰 입니다. 무시해도 상관없으나 어떻게 쓰는건지 예제를 여기에 둘테니 참고하시면 좋을듯.
    imageURL은 임의로 넣었으나 어처피 저희 실제 앱에선 자동으로 들어가니 ㄱㅊ
 */
import SwiftUI

struct CoredataTest: View {
    //생성하거나 그럴떈 꼭 Enviromet를 해줘야 함
    @Environment (\.managedObjectContext) var managedObjContext
    @State private var date: Date = Date()
    @State private var kilometer: String = ""
    @State private var steps: String = ""
    @State private var trash: String = ""
    @State private var kcal: Int16 = 0
    @State private var image: URL? = URL(string: "file:///Users/a_mcflurry/Library/Developer/Xcode/UserData/Previews/Simulator%20Devices/9C22CA36-B077-4ADB-AE51-F31615D8E474/data/Containers/Data/Application/EB164961-9917-422D-867E-1D8A093325CB/Documents/F3174D90-0F91-41F7-A3E4-A70F91269D53.png")
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                
                TextField("Kilometer", text: $kilometer)
                TextField("Steps", text: $steps)
                TextField("Trash", text: $trash)
                TextField("Kcal", value: $kcal, formatter: NumberFormatter())
                
                NavigationLinkView(text: "PrintTestView"
                                   , isdisable: Binding.constant(false)
                                   , destination: CoredataFetchTestView())
                .simultaneousGesture(TapGesture().onEnded {
                    CoredataManager().addHistory(date: date, image: image!, trash: trash, steps: steps, kilometer: kilometer, kcal: kcal, context: managedObjContext)
                })
                
                NavigationLinkView(text: "ListTestView"
                                   , isdisable: Binding.constant(false)
                                   , destination: CoredataListView())
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

// 선택하기 누르면 나오는 뷰
struct CoredataFetchTestView: View {
// 불러오기만 할떄는 환경 변수 말고 이렇게 CoredataManager만 대리고 오면 됩니다.
    let coredataManager = CoredataManager()
    
    var body: some View {
        VStack {
            Button("Fetch Data") {
                let targetDate = coredataManager.createDate(year: 2023, month: 8, days: 15)
                let historyForDate = coredataManager.fetchHistory(targetDate: targetDate)
                
                if historyForDate.isEmpty {
                    print("No data")
                } else {
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
            }
            
            Button("Fetch ALL Data") {
                let allHistory = coredataManager.fetchAllHistory()
                
                if allHistory.isEmpty {
                    print("No data")
                } else {
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
            }
            
            Button("Delete Data") {
                coredataManager.deleteAllData()
            }
        }
    }
}

struct CoredataListView: View {
    let coredataManager = CoredataManager()

//  date는 요롷게
    var targetDate: Date {
        coredataManager.createDate(year: 2023, month: 8, days: 15)
        }
    
    var body: some View {
        let historyForDate = coredataManager.fetchHistory(targetDate: targetDate)
        List {
            if historyForDate.isEmpty {
                Text("No data")
            } else {
                ForEach(historyForDate, id: \.self) { history in
                    // 옵셔널이 아닌데 옵셔널 아니면 안됨. 이유 아시는분...?
                    VStack(alignment: .leading) {
                        Text("Date: \(history.date ?? Date())")
                        Text("Image URL: \(history.image ?? URL(string: "")!)")
                        Text("Trash: \(history.trash ?? "")")
                        Text("Steps: \(history.steps ?? "")")
                        Text("Kilometer: \(history.kilometer ?? "")")
                        Text("Kcal: \(history.kcal)")
                    }
                    .padding()
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                }
            }
        }
    }
}
