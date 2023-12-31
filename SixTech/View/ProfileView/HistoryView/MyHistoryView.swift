//
//  MyHistoryView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/26.
//

import SwiftUI

struct MyHistoryView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var ploggingManager: PloggingManager
	@EnvironmentObject var locationManager: LocationManager
	
	let coredataManager = CoredataManager()
	@State var selectedDate: Date = Date()
	@State var isShow = false
	@State var showModal = false
	
	private var ploggingDate: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM월 dd일"
		return formatter.string(from: Date())
	}
	
	var movedDistance: String {
		String(format: "%.1f", locationManager.movedDistance / 1000)
	}


	let meeeelong = ["1"]
	
	var body: some View {
		ScrollView {
			Spacer()
			myCalView()
				.padding(.horizontal)
				.padding(.horizontal)
			CalenderView(month: selectedDate)
				.padding(.horizontal)
			
			myhistoryView(meeeelong)
		}
		.sheet(isPresented: $isShow) {
			Spacer()
			SelectFoodView()
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				dismissButton(sfName: "chevron.backward") {
					dismiss()
				}
			}
			ToolbarItem(placement: .principal) {
				Text("이전 기록")
					.font(.Jamsil.bold.font(size: 20))
			}
			
		}
		.navigationBarBackButtonHidden()
		.sheet(isPresented: self.$showModal) {
			EndResultView()
		}
	}
	
	func myCalView() -> some View {
		VStack {
			HStack {
				Text("2023년 7월의 소모 칼로리")
					.font(.Jamsil.regular.font(size: 17))
				Spacer()
				Image(systemName: "pencil")
					.foregroundColor(.defaultColor)
					.font(.system(size: 17))
					.padding(.all, 10)
					.background(
						Circle().fill(Color.init(hexCode: "#F5F5F5"))
					)
					.onTapGesture {
						isShow = true
					}
			}
			HStack {
				Text(ploggingManager.kcal.formatWithDot)
					.foregroundColor(.defaultColor)
					.font(.Jamsil.extraBold.font(size: 24))
				Text("kcal")
					.font(.Jamsil.regular.font(size: 17))
				Spacer()
			}
			HStack {
				Text("라멘 1그릇")
					.font(.Jamsil.extraBold.font(size: 20))
					.foregroundColor(.fontColor)
				Spacer()
			}.padding(.top, 1)
			Text("🍜")
				.frame(maxWidth: .infinity, alignment: .leading)
				.lineLimit(50)
				.padding(.top, 5)
			HStack {
				Text("만큼의 칼로리를 소비했어요.")
					.font(.Jamsil.regular.font(size: 17))
				Spacer()
			}.padding(.vertical, 7)
		}.padding()
			.background(
				RoundedRectangle(cornerRadius: 25).fill(Color.white)
					.shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
			)
	}
	func myhistoryView(_ list: [String]) -> some View {
		
		VStack {
			HStack {
				Text("2023년 7월의 플로깅")
					.font(.Jamsil.regular.font(size: 17))
					.padding(.leading)
					.padding(.leading)
					.padding(.leading)
				Spacer()
			}.padding(.vertical)
			ForEach(list, id: \.self) { _ in
				HStack(spacing: 24) {
					VStack {
						Text("08")
							.font(.Jamsil.light.font(size: 14))
						Text("03")
							.font(.Jamsil.regular.font(size: 17))
					}.foregroundColor(.fontColor)
					Divider()
						.background(Color.fontColor)
						.padding(.vertical, 2)
					VStack(alignment: .listRowSeparatorLeading) {
						Text("\(ploggingDate) 같이줍깅")
							.font(.Jamsil.regular.font(size: 17))
						Text("\(ploggingManager.pickedCount)개 \(movedDistance)km \(ploggingManager.totalStep)걸음 \(ploggingManager.kcal)kcal")
							.font(.Jamsil.light.font(size: 12))
					}
					Image(systemName: "chevron.right")
						.foregroundColor(.fontColor)
				}
				.padding().padding(.vertical, 5)
					.background(
						RoundedRectangle(cornerRadius: 26)
							.fill(Color.background2Color)
							.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
					)
					.padding(.bottom)
					.onTapGesture {
						showModal = true
					}
			}
			 
		}
	}
}

struct MyHistoryView_Previews: PreviewProvider {
	static var previews: some View {
		MyHistoryView()
	}
}
