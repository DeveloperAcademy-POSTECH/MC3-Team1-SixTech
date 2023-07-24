//
//  CustomMatchingViewController.swift
//  SixTech
//
//  Created by 주환 on 2023/07/19.
//

import UIKit
import GameKit

protocol CustomMatchmakerViewControllerDelegate: AnyObject {
    func customMatchmakerViewController(_ viewController: CustomMatchmakerViewController,
                                        didFind match: GKMatch)
    func customMatchmakerViewController(_ viewController: CustomMatchmakerViewController,
                                        didFailWithError error: Error)
    func customMatchmakerViewControllerWasCancelled(_ viewController: CustomMatchmakerViewController)
}

final class CustomMatchmakerViewController: UIViewController {
    
    weak var delegate: CustomMatchmakerViewControllerDelegate?
    
    private let matchRequest: GKMatchRequest
    private let matchmakingMode: GKMatchmakingMode
    private var matchmaker: GKMatchmaker?
    
    init(matchRequest: GKMatchRequest, matchmakingMode: GKMatchmakingMode) {
        self.matchRequest = matchRequest
        self.matchmakingMode = matchmakingMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // 매칭 버튼 생성
        view.backgroundColor = .white
        let matchButton = UIButton(type: .system)
        matchButton.setTitle("Start Matching", for: .normal)
        matchButton.addTarget(self, action: #selector(startMatchmaking), for: .touchUpInside)
        matchButton.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 100, height: 50)
        view.addSubview(matchButton)
        matchButton.center(inView: view)
    }
    
    @objc private func startMatchmaking() {
        matchmaker = GKMatchmaker.shared()
        matchmaker?.findMatch(for: matchRequest, withCompletionHandler: { [weak self] (match, error) in
            if let error = error {
                self?.delegate?.customMatchmakerViewController(self!, didFailWithError: error)
            } else if let match = match {
                self?.delegate?.customMatchmakerViewController(self!, didFind: match)
            }
        })
    }
    
    func cancelMatchmaking() {
        matchmaker?.cancel()
        delegate?.customMatchmakerViewControllerWasCancelled(self)
    }
    
    // 이후 매칭 관련 로직을 추가해야합니다.
    // 예를 들면 매칭 성공 시 매치 메서드를 구현하고, 플레이어 연결 상태 변경 등의 델리게이트 메서드를 처리해야합니다.
}
