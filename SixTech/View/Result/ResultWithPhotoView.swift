//
//  ResultLogStyle.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct ResultWithPhotoView: View {
    
	let kcal: String
	let movedDistance: String
	let steps: String
	let ploogingCount: String
	let date: String
	let userTakeImage: UIImage
	let profileImage: UIImage
    
    var body: some View {
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(.white)
                    .shadow(radius: 10, y: 1)
                
				Image(uiImage: userTakeImage)
                    .resizable()
                    .frame(width: 294, height: 294)
                    .padding(.top)
                
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(.white)
                    .frame(height: 90)
                }
                
                // 데이터 부분
                VStack {
                    HStack {
                        Text(date)
                            .font(.Jamsil.medium.font(size: 16))
                            .foregroundColor(.white)
                            .shadow(radius: 2, y: 1)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
							.frame(width: 70, height: 70)
							.foregroundColor(.white)
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.backgroundColor)
                            .overlay(
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFit()
                            )
                    }
                    
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
                    .padding(.bottom)
                }
            }
            .frame(width: 320, height: 337)
        }
}
