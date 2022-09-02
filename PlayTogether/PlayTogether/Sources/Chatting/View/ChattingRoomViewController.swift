//
//  ChattingRoomViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

import UIKit
import RxSwift

final class ChattingRoomViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ChattingRoomViewModel
    
    private let leftBarItem = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let tapGesture = UITapGestureRecognizer(
        target: ChattingRoomViewController.self,
        action: nil
    ).then {
        $0.cancelsTouchesInView = false
    }
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.register(
            ChattingRoomTableViewCell.self,
            forCellReuseIdentifier: "ChattingRoomTableViewCell"
        )
        $0.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 32)
    }
    
    private let inputTextView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.applyShadow(
            color: .black,
            alpha: 0.05,
            xValue: 0,
            yValue: -2,
            blur: 10,
            spread: 0
        )
    }
    
    private let textField = UITextField()
    
    private let sendButton = UIButton().then {
        $0.setImage(.ptImage(.sendInActiveIcon), for: .disabled)
        $0.setImage(.ptImage(.sendActiveIcon), for: .normal)
        $0.isEnabled = false
    }
    
    init(userName: String, roomID: Int) {
        self.viewModel = ChattingRoomViewModel(roomID: roomID)
        super.init()
        
        setupNavigationBarTitle(userName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
        
        view.addSubview(tableView)
        view.addSubview(inputTextView)
        inputTextView.addSubview(textField)
        inputTextView.addSubview(sendButton)
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func setupLayouts() {
        inputTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.0554)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        sendButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 0.106)
        }
        
        textField.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(sendButton.snp.leading)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputTextView.snp.top)
        }
    }
    
    override func setupBinding() {
        leftBarItem.rx.tap
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.existingMessageSubject
            .bind(to: tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "ChattingRoomTableViewCell",
                    for: IndexPath(row: 0, section: 0)
                ) as? ChattingRoomTableViewCell,
                      let item = item
                else { return UITableViewCell() }
                
                cell.setupCell(
                    profileImage: nil, // 추후 변경 예정
                    send: item.send,
                    content: item.content,
                    createdAt: item.createdAt
                )
                return cell
            }
            .disposed(by: disposeBag)
    }
}

private extension ChattingRoomViewController {
    func setupNavigationBarTitle(_ userName: String) {
        title = userName
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        inputTextView.transform = CGAffineTransform(
            translationX: 0,
            y: -keyboardFrame.cgRectValue.height + getSafeAreaBottomHeight()
        )
        tableView.transform = CGAffineTransform(
            translationX: 0,
            y: -keyboardFrame.cgRectValue.height + getSafeAreaBottomHeight()
        )
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        inputTextView.transform = .identity
        tableView.transform = .identity
    }
    
    func getSafeAreaBottomHeight() -> CGFloat {
        let window = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive}
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
        
        guard let height = window?.safeAreaInsets.bottom else { return CGFloat.init() }
        return height
    }
}
