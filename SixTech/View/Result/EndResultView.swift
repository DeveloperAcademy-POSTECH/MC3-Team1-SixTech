//
//  EndResultView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct EndResultView: View {
    @Environment(\.presentationMode) var prsent
    @EnvironmentObject var matchManager: MatchManager
	@EnvironmentObject var ploggingManager: PloggingManager
	@EnvironmentObject var locationManager: LocationManager
	@EnvironmentObject var userInfo: UserInfo
	
	private var kcal: String {
		(Double(ploggingManager.totalStep) * 0.04).formatWithDot
	}
	
	private var movedDistance: String {
		Int((locationManager.movedDistance / 1000)).formatWithDot
	}
	
	private var steps: String {
		ploggingManager.totalStep.formatWithDot
	}

	private var ploggingCount: String {
		ploggingManager.pickedCount.formatWithDot
	}

	private var ploggingDate: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd"
		return formatter.string(from: Date())
	}
	
	private var userTakeImage: UIImage? {
		userInfo.myMissionPhoto
	}
	
	private var polylineMapImage: UIImage {
		ploggingManager.snapshottedMap
	}
	
	private var profileImage: UIImage {
		loadImageFromURL(imageURL: userInfo.profileImageURL)
	}

    @State var isRightTapped: Bool = false
    @State var isLeftTapped: Bool = true
    @State var isAlert = false
    
    var body: some View {
        
        HStack {
            VStack {
				
				Spacer()

                Text("플로깅 완료를 축하합니다!\n 마음에 드는 기록을 공유/저장해요")
                    .font(.Jamsil.light.font(size: 20))
                    .multilineTextAlignment(.center)
					.padding(.top)
                
                Spacer()
                
                if isLeftTapped {
                    ResultWithPhotoView(kcal: kcal,
										movedDistance: movedDistance,
										steps: steps,
										ploogingCount: ploggingCount,
										date: ploggingDate,
										userTakeImage: userTakeImage!,
										profileImage: profileImage)
                        .padding(.vertical)
                } else {
                    ResultWithPolylineView(kcal: kcal,
										   movedDistance: movedDistance,
										   steps: steps,
										   ploogingCount: ploggingCount,
										   date: ploggingCount,
										   polylineMapImage: polylineMapImage,
										   profileImage: profileImage)
                        .padding(.vertical)
                }
                
                Spacer()
                
                HStack {
                    Button {
                        isLeftTapped = true
                        isRightTapped = false
                    } label: {
						Image(uiImage: userTakeImage!)
                            .resizable()
                            .scaledToFill()
                    }
                    .buttonStyle(CircleButton(isTapped: $isLeftTapped))
                    
                    Spacer()
                    
                    Button {
                        isRightTapped = true
                        isLeftTapped = false
                    } label: {
                        
						Image(uiImage: ploggingManager.snapshottedMap)
                            .resizable()
                            .scaledToFill()
                    }
                    .buttonStyle(CircleButton(isTapped: $isRightTapped))
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                HStack {
                    Button {
                        // 저장하는 기능
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                                .padding(.trailing)
                            
                            Text("저장하기")
                                .padding(.trailing)
                        }
                    }
                    .buttonStyle(SmallButton())
                    
                    Spacer()
                    
                    Button {
                        // 공유하는 기능
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                                .padding(.trailing)
                            
                            Text("공유하기")
								.font(.Jamsil.regular.font(size: 17))
                                .padding(.trailing)
                        }
                    }
                    .buttonStyle(SmallButton())
                }
                Spacer()
            }
            .padding(.top, 47)
        }
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				dismissButton(sfName: "xmark") {
					isAlert = true
				}
			}
			ToolbarItem(placement: .principal) {
				Text("오늘의 플로깅 기록")
					.font(.Jamsil.bold.font(size: 24))
			}
		}
        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal, 24)
        .alert(title: "플로깅 완료",
               message:
                            """
                            메인화면으로 돌아갑니다.
                            내 프로필에서 기륵을
                            확인할 수 있어요
                            """,
               primaryButton: CustomAlertButton(title: "확인", action: {
            matchManager.cancelMatchmaking()
            NavigationUtil.popToRootView() }),
               secondaryButton: CustomAlertButton(title: "취소", action: { isAlert = false }),
               isPresented: $isAlert)
        .navigationBarBackButtonHidden()
    }
    
}

struct EndResultView_Previews: PreviewProvider {
    static var previews: some View {
        EndResultView()
    }
}
