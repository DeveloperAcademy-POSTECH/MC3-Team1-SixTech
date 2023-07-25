//
//  CharacterCreateView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/18.
//

import SwiftUI

struct CharacterCreateView: View {
    private var imageMerger = ImageMerger()
    private let faceArray: [String] = ["face_bag_", "face_can_", "face_dust_", "face_twin_", "face_centerbag_", "face_pet_", "face_jellyfish_", "face_plasticbag_"]
    private let colorArray: [String] = ["gray", "green", "lightpurple", "mystic", "pink", "orange", "yellow"]
    private let emotionArray: [String] = ["emotion_1", "emotion_2", "emotion_3", "emotion_4", "emotion_5", "emotion_6", "emotion_7", "emotion_8"]
    
    @State private var characterColor: Int
    @State private var characterFace: Int
    @State private var characterEmotion: Int
    @State private var userName: String = ""
    
    init() {
        _characterColor = State(initialValue: Int.random(in: 0..<colorArray.count))
        _characterFace = State(initialValue: Int.random(in: 0..<faceArray.count))
        _characterEmotion = State(initialValue: Int.random(in: 0..<emotionArray.count))
    }
    
    enum Characterkind {
        case face
        case color
        case emotion
    }
    
    private func getCharacterArraykind(kind: Characterkind) -> [String] {
        switch kind {
        case .face:
            return faceArray
        case .color:
            return colorArray
        case .emotion:
            return emotionArray
        }
    }
    
    private func getCharacterkind(kind: Characterkind) -> Binding<Int> {
        switch kind {
        case .face:
            return $characterFace
        case .color:
            return $characterColor
        case .emotion:
            return $characterEmotion
        }
    }
    
    private func increaseCount(kind: Characterkind) {
        let binding = getCharacterkind(kind: kind)
        let index = binding.wrappedValue
        let maxSize = getCharacterArraykind(kind: kind).count
        
        if index < maxSize - 1 {
            binding.wrappedValue += 1
        } else {
            binding.wrappedValue = 0
        }
    }
    private func decreaseCount(kind: Characterkind) {
        let binding = getCharacterkind(kind: kind)
        let index = binding.wrappedValue
        let maxSize = getCharacterArraykind(kind: kind).count
        
        if 0 < index {
            binding.wrappedValue -= 1
        } else {
            binding.wrappedValue = maxSize - 1
        }
    }
    
    private func saveImageToPNG(image: UIImage) {
        if let imageData = image.pngData() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let uniqueFileName = "\(UUID().uuidString).png"
            let fileURL = documentsDirectory.appendingPathComponent(uniqueFileName)
            do {
                try imageData.write(to: fileURL)
                print("Image saved to: \(fileURL)")
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("캐릭터를 생성해주세요.")
                .font(.Jamsil.bold.font(size: 20))
            Text("같이줍깅을 하려면 캐릭터가 필요해요")
                .font(.Jamsil.light.font(size: 17))
            HStack {
                VStack {
                    ImageButton(image: .left) { decreaseCount(kind: .face) }
                    ImageButton(image: .left) { decreaseCount(kind: .emotion) }
                    ImageButton(image: .left) { decreaseCount(kind: .color) }
                }
                
                Image(uiImage: imageMerger.merge("\(faceArray[characterFace] + colorArray[characterColor])", with: "\(emotionArray[characterEmotion])"))
                    .resizable()
                    .frame(width: 200, height: 200)
                
                VStack {
                    ImageButton(image: .right) { increaseCount(kind: .face) }
                    ImageButton(image: .right) { increaseCount(kind: .emotion) }
                    ImageButton(image: .right) { increaseCount(kind: .color) }
                }
            }
            
            TextField("닉네임을 입력해주세요", text: $userName)
                .font(.Jamsil.light.font(size: 17))
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 70)
                .overlay {
                    RoundedRectangle(cornerRadius: 23)
                        .stroke(Color.defaultColor, lineWidth: 2)
                }

            Spacer()
            Spacer()
            
            Button("선택하기") {
                saveImageToPNG(image: imageMerger.merge("\(faceArray[characterFace] + colorArray[characterColor])", with: "\(emotionArray[characterEmotion])"))
            }.buttonStyle(DefaultButton(isdisable: false))
        }
        .navigationBarBackButtonHidden()
    }
}

struct CharacterCreateView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCreateView()
    }
}

//                ZStack {
//                    Image(character[characterFace][characterColor])
//                        .resizable()
//                        .frame(width: 200, height: 200)
//                    Image("123")
//                        .resizable()
//                }
//                .frame(width: 200, height: 200)
//                Image(uiImage: imageMerger.merge("\(character[characterFace][characterColor])", with: "\(emotion[characterEmotion])"))
//                    .resizable()
//                    .frame(width: 200, height: 200)

// let emotion: [String] = ["emotion_1", "emotion_2", "emotion_3", "emotion_4", "emotion_5", "emotion_6", "emotion_7", "emotion_8"]
// let character: [[String]] = [
//    ["face_bag_gray", "face_bag_green", "face_bag_lightpurple", "face_bag_mystic", "face_bag_pink", "face_bag_orange", "face_bag_yellow"],
//    ["face_dust_gray", "face_dust_green", "face_dust_lightpurple", "face_dust_mystic", "face_dust_pink", "face_dust_orange", "face_dust_yellow"]]
// }

// Button("Test") {
//    saveImageToPNG(image: imageMerger.merge("\(character[characterFace][characterColor])", with: "\(emotion[characterEmotion])"))
// }

// Image("\(CharacterFace.facebag.rawValue + CharacterColor.gray.rawValue)")

// enum CharacterFaceEnum: String, CaseIterable {
//    case facebag = "face_bag_"
//    case facedust = "face_dust_"
//    case facecan = "face_can_"
//    case facetwin = "face_twin_"
//    case facecneterbag = "face_centerbag_"
//    case facepet = "face_pet_"
//    case facejellyfish = "face_jellyfish_"
//    case faceplasticbag = "face_plastic_bag_"
// }
//
// enum CharacterColorEnum: String, CaseIterable {
//    case gray
//    case green
//    case lightpurple
//    case mystic
//    case pink
//    case orange
//    case yellow
// }

//    func decreaseCountButton() -> any View {
//        return ImageButton(image: .left) {
//            characterFace = decreaseCount(index: characterFace, maxSize: face.count)
//
//        }
//    }

// HStack {
//    VStack {
//        ImageButton(image: .left) { characterFace = decreaseCount(index: characterFace, maxSize: faceArray.count) }
//        ImageButton(image: .left) { characterColor = decreaseCount(index: characterColor, maxSize: colorArray.count) }
//        ImageButton(image: .left) { characterEmotion = decreaseCount(index: characterEmotion, maxSize: emotionArray.count) }
//    }
//
//    Image(uiImage: imageMerger.merge("\(faceArray[characterFace]+colorArray[characterColor])"
//                                     , with: "\(emotionArray[characterEmotion])"))
//        .resizable()
//        .frame(width: 200, height: 200)
//
//    VStack {
//        ImageButton(image: .right) { characterFace = increaseCount(index: characterFace, maxSize: faceArray.count) }
//        ImageButton(image: .right) { characterColor = increaseCount(index: characterColor, maxSize: colorArray.count) }
//        ImageButton(image: .right) { characterEmotion = increaseCount(index: characterEmotion, maxSize: emotionArray.count) }
//    }
// }

// ZStack {
//    Image("\(faceArray[characterFace]+colorArray[characterColor])")
//        .resizable()
//    Image("\(emotionArray[characterEmotion])")
//        .resizable()
//        .transition(.move(edge: .bottom))
//        .transition(AnyTransition.opacity.animation(.easeInOut))
// }
// .frame(width: 200, height: 200)
