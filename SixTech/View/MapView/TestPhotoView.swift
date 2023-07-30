//
//  TestPhotoView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/26.
//

import SwiftUI

struct TestPhotoView: View {
	@Binding var snapshot: UIImage

	var body: some View {
		VStack {
			Image(uiImage: snapshot)
		}
	}
}
