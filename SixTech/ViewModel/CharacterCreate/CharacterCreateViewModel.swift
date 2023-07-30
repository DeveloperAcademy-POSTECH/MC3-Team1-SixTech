//
//  CharacterCreateViewModel.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI
import Combine

class CharacterCreateViewModel: ObservableObject {
    var imageMerger = ImageMerger()
    
    let faceArray: [String] = ["face_bag_", "face_can_", "face_dust_", "face_twin_", "face_centerbag_", "face_pet_", "face_jellyfish_", "face_plasticbag_"]
    let colorArray: [String] = ["gray", "green", "lightpurple", "mystic", "pink", "orange", "yellow"]
    let emotionArray: [String] = ["emotion_1", "emotion_2", "emotion_3", "emotion_4", "emotion_5", "emotion_6", "emotion_7", "emotion_8"]
    
    @Published var characterColor: Int = 0
    @Published var characterFace: Int = 0
    @Published var characterEmotion: Int = 0
    @Published var userName: String = (UserDefaults.standard.string(forKey: "username") ?? "")
    
    init() {
        characterColor = Int.random(in: 0..<colorArray.count)
        characterFace = Int.random(in: 0..<faceArray.count)
        characterEmotion = Int.random(in: 0..<emotionArray.count)
    }
    
    enum Characterkind {
        case face
        case color
        case emotion
    }
    
    func getCharacterArraykind(kind: Characterkind) -> [String] {
        switch kind {
        case .face:
            return faceArray
        case .color:
            return colorArray
        case .emotion:
            return emotionArray
        }
    }
    
    func getCharacterkind(kind: Characterkind) -> Binding<Int> {
            switch kind {
            case .face:
                return Binding<Int>(
                    get: { self.characterFace },
                    set: { self.characterFace = $0 }
                )
            case .color:
                return Binding<Int>(
                    get: { self.characterColor },
                    set: { self.characterColor = $0 }
                )
            case .emotion:
                return Binding<Int>(
                    get: { self.characterEmotion },
                    set: { self.characterEmotion = $0 }
                )
            }
        }
    
    func increaseCount(kind: Characterkind) {
        let binding = getCharacterkind(kind: kind)
        let index = binding.wrappedValue
        let maxSize = getCharacterArraykind(kind: kind).count
        
        if index < maxSize - 1 {
            binding.wrappedValue += 1
        } else {
            binding.wrappedValue = 0
        }
    }
    
    func decreaseCount(kind: Characterkind) {
        let binding = getCharacterkind(kind: kind)
        let index = binding.wrappedValue
        let maxSize = getCharacterArraykind(kind: kind).count
        
        if 0 < index {
            binding.wrappedValue -= 1
        } else {
            binding.wrappedValue = maxSize - 1
        }
    }
    
    func saveImageToPNG(image: UIImage) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let uniqueFileName = "\(UUID().uuidString).png"
        let fileURL = documentsDirectory.appendingPathComponent(uniqueFileName)
        
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: fileURL)
                print("Image saved to: \(fileURL)")
            } catch {
                print("Error saving image: \(error)")
            }
        }
        return fileURL
    }
    
    func saveUserDefault() {
        UserDefaults.standard.set(self.userName, forKey: "username")
        UserDefaults.standard.url(forKey: "profileURL")
        let profileURL = saveImageToPNG(image: imageMerger.merge("\(faceArray[characterFace] + colorArray[characterColor])", with: "\(emotionArray[characterEmotion])"))
        UserDefaults.standard.set(profileURL, forKey: "profileURL")
    }
    
    var isdisable: Bool {
          userName == ""
    }
}
