//
//  ResultLogView2.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct ResultWithPolylineView: View {
	
	let kcal: String
	let movedDistance: String
	let steps: String
	let ploogingCount: String
	let date: String
	let polylineMapImage: UIImage
	let profileImage: UIImage
	
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .shadow(radius: 10, y: 4)
                .overlay(
                  Image(uiImage: polylineMapImage)
                  .resizable()
                  .scaledToFit()
                )

            // 데이터 부분
            VStack {
                HStack {
                    Text(date)
                        .font(.Jamsil.medium.font(size: 16))
                        .shadow(radius: 2, y: 1)
                    
                    Spacer()
                    
					VStack {
						Image(uiImage: profileImage)
							.resizable()
							.frame(width: 36, height: 36)
							.background(Circle().foregroundColor(.backgroundColor))
						Text("같이줍깅")
							.foregroundColor(.black)
							.font(.Jamsil.light.font(size: 12))

					}
                }
                .padding()
                .foregroundColor(.black)
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Text(movedDistance)
                            .font(.Jamsil.medium.font(size: 20))
                        
                        Text("km")
                            .font(.Jamsil.light.font(size: 12))
                    }
                    Spacer()
                    
                    VStack {
						Text(steps)
                            .font(.Jamsil.medium.font(size: 20))
                        
                        Text("steps")
                            .font(.Jamsil.light.font(size: 12))
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(ploogingCount)
                            .font(.Jamsil.medium.font(size: 20))
                        
                        Text("줍깅")
                            .font(.Jamsil.light.font(size: 12))
                    }
                    
                    Spacer()
                    
                    VStack {
						Text(kcal)
                            .font(.Jamsil.medium.font(size: 20))
                        
                        Text("kcal")
                            .font(.Jamsil.light.font(size: 12))
                    }
                    
                    Spacer()
            
                }
                .shadow(radius: 2, y: 1)
                .foregroundColor(.black)
                .padding(.bottom)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ResultWithPolylineView_Previews: PreviewProvider {
    static var previews: some View {
        EndResultView()
            .environmentObject(MatchManager())
            .environmentObject(UserInfo())
            .environmentObject(PloggingManager())
            .environmentObject(LocationManager())
    }
}
