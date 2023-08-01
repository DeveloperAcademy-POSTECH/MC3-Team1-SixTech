//
//  캘린더.swift
//  SixTech
//
//  Created by 주환 on 2023/07/26.
//

import SwiftUI

struct CalenderView: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @State var clickedDates: Set<Date> = []
    
    var body: some View {
        VStack {
            headerView.padding()
            calendarGridView.padding([.leading, .trailing, .bottom])
        }.background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
        )
        .padding()
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
    }
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            HStack(spacing: 12) {
                Text(month, formatter: Self.dateFormatter)
                    .font(.Jamsil.regular.font(size: 20))
                    .kerning(2)
                    .padding([.leading], 37)
                Image(systemName: "calendar")
                    .foregroundColor(.beforeImagePickTextColor)
                    .padding([.trailing], 5)
                    .padding([.top, .bottom], 5)

            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.init(hexCode: "#F5F5F5"))
            ).padding(.bottom)
                .overlay {
                    HStack {
                        Spacer().frame(width: 270)
                        
                        NavigationLink {
//                            SelectFoodView()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.beforeImagePickTextColor)
                                .fontWeight(.medium)
                                .padding(.all, 7)
                                .background(
                                    Circle().fill(Color.background2Color)
                                )
                        }.padding(.bottom)
                    }
                }
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol.uppercased())
                        .font(.Jamsil.regular.font(size: 13))
                        .foregroundColor(.beforeImagePickTextColor)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        let clicked = clickedDates.contains(date)
                        
                        CellView(day: day, clicked: clicked)
                            .onTapGesture {
                                if clicked {
                                    clickedDates.remove(date)
                                } else {
                                    clickedDates.insert(date)
                                }
                            }
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var day: Int
    var isData: Bool = false
    
    init(day: Int, clicked: Bool) {
        self.day = day
        self.isData = clicked
    }
    
    var body: some View {
        VStack {
            ZStack {
                if isData {
                    Circle()
                        .fill(Color.calendarNumberBackground)
                        .frame(width: 30, height: 30)
                        .zIndex(-1)
                        
                    Text(String(day))
                        .font(.Jamsil.light.font(size: 20))
                        
                } else {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 30, height: 30)
                        .zIndex(-1)
                    Text(String(day))
                        .font(.Jamsil.light.font(size: 20))
                        
                }
                
            }.padding(.bottom)

        }
    }
}

// MARK: - 내부 메서드
private extension CalenderView {
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
}

// MARK: - Static 프로퍼티
extension CalenderView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
}
