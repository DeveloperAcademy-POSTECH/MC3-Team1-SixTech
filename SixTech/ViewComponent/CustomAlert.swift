//
//  CustomAlert.swift
//  SixTech
//
//  Created by 주환 on 2023/07/25.
//

// .alert(title: "대기실 나가기", message: "메인 화면으로 돌아갑니다.",
//       primaryButton: CustomAlertButton(title: "나가기", action: {
//    matchManager.cancelMatchmaking()
//    dismiss() }),
//       secondaryButton: CustomAlertButton(title: "취소", action: { isAlert.toggle() }),
//       isPresented: $isAlert) 대충 아시죠 ? 뭔뜻인지 센스껏..쓰십쇼

import SwiftUI

struct CustomAlert: View {

    // MARK: - Value
    // MARK: Public
    let title: String
    let message: String
    let dismissButton: CustomAlertButton?
    let primaryButton: CustomAlertButton?
    let secondaryButton: CustomAlertButton?
    
    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat             = 1.0

    @Environment(\.dismiss) private var dismiss

    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            alertView
        }

    }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 30) {
            titleView
                .padding()
            messageView
                .padding(.bottom, 40)
            buttonsView
        }
        .padding(24)
        .frame(width: 295)
        .background(.white)
        .cornerRadius(22)
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            Text(title)
                .font(.Jamsil.bold.font(size: 24))
                .foregroundColor(.black)
                .lineSpacing(24 - UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private var messageView: some View {
        if !message.isEmpty {
            Text("\(message)")
                .font(.Jamsil.light.font(size: 20))
                .foregroundColor(title.isEmpty ? .black : .gray)
                .lineSpacing(24 - UIFont.systemFont(ofSize: title.isEmpty ? 18 : 16).lineHeight)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var buttonsView: some View {
        HStack(spacing: 12) {
            if dismissButton != nil {
                dismissButtonView
    
            } else if primaryButton != nil, secondaryButton != nil {
                secondaryButtonView
                    .foregroundColor(.defaultColor)
                    .padding(.leading)
                    .padding(.leading)
                Spacer()
                primaryButtonView
                    .padding(.trailing)
                    .padding(.trailing)
                    .foregroundColor(.red)
            }
        }
        .padding(.top, 23)
    }

    @ViewBuilder
    private var primaryButtonView: some View {
        if let button = primaryButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
//                    dismiss()
                }
            
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    button.action?()
                }
            }
        }
    }

    @ViewBuilder
    private var secondaryButtonView: some View {
        if let button = secondaryButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
//                    dismiss()
                }
        
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    button.action?()
                }
            }
        }
    }

    @ViewBuilder
    private var dismissButtonView: some View {
        if let button = dismissButton {
            CustomAlertButton(title: button.title) {
                animate(isShown: false) {
                    dismiss()
                }
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    button.action?()
                }
            }
        }
    }

    // MARK: - Function
    // MARK: Private
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
    
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }
    
        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity           = 0
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}

#if DEBUG
struct CustomAlert_Previews: PreviewProvider {

    static var previews: some View {
        let primaryButton   = CustomAlertButton(title: "나가기")
        let secondaryButton = CustomAlertButton(title: "취소")

        let title = "대기실 나가기"
        let message = "메인 화면으로 돌아갑니다."

        return VStack {
            CustomAlert(title: title, message: message, dismissButton: nil, primaryButton: primaryButton,
                        secondaryButton: secondaryButton)
        }
        .previewDevice("iPhone 13 Pro Max")
//        .preferredColorScheme(.light)
    }
}
#endif

struct CustomAlertButton: View {

    // MARK: - Value
    // MARK: Public
    let title: LocalizedStringKey
    var action: (() -> Void)?
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Button {
          action?()
        
        } label: {
            Text(title)
                .font(.Jamsil.bold.font(size: 24))
                .multilineTextAlignment(.center)
        }
    }
}

struct CustomAlertModifier {

    // MARK: - Value
    // MARK: Private
    @Binding private var isPresented: Bool

    // MARK: Private
    private let title: String
    private let message: String
    private let dismissButton: CustomAlertButton?
    private let primaryButton: CustomAlertButton?
    private let secondaryButton: CustomAlertButton?
}

extension CustomAlertModifier: ViewModifier {

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                // 얼럿이 띄워질 때 반투명한 뒷 배경을 추가
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)

                CustomAlert(title: title, message: message, dismissButton: dismissButton,
                            primaryButton: primaryButton, secondaryButton: secondaryButton)
                    .zIndex(1) // 얼럿 창이 뒷 배경보다 위에 나타나도록 설정
            }
        }
    }
}

extension CustomAlertModifier {

    init(title: String = "", message: String = "",
         dismissButton: CustomAlertButton, isPresented: Binding<Bool>) {
        self.title         = title
        self.message       = message
        self.dismissButton = dismissButton
        self.primaryButton   = nil
        self.secondaryButton = nil
    
        _isPresented = isPresented
    }

    init(title: String = "", message: String = "",
         primaryButton: CustomAlertButton, secondaryButton: CustomAlertButton, isPresented: Binding<Bool>) {
        self.title           = title
        self.message         = message
        self.primaryButton   = primaryButton
        self.secondaryButton = secondaryButton
    
        self.dismissButton = nil
    
        _isPresented = isPresented
    }
}
