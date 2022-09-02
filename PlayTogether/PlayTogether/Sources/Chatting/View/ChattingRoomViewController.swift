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
    private let socket = SocketIOManager.shared
    
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
    
    init(userName: String, roomID: Int, receiverID: Int) {
        self.viewModel = ChattingRoomViewModel(roomID: roomID, receiverID: receiverID)
        super.init()
        
        setupNavigationBarTitle(userName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
        socket.reqEnterRoom(receiverID: viewModel.receiverID, roomID: viewModel.roomID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
        socket.reqExitRoom()
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
        
        textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                guard let text = self.textField.text else { return }
                self.socket.reqSendMessage(text)
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
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let safeAreaBottomHeight = view.safeAreaInsets.bottom
        let endLine = UIScreen.main.bounds.height - (inputTextView.frame.height + keyboardHeight)
        
        inputTextView.transform = CGAffineTransform(
            translationX: 0,
            y: safeAreaBottomHeight - keyboardHeight
        )
        
        // 추후 수정 예정
        guard endLine < getLastCellPostion() else { return }
        tableView.transform = CGAffineTransform(
            translationX: 0,
            y: getLastCellPostion() - endLine
        )
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        inputTextView.transform = .identity
        tableView.transform = .identity
    }
    
    func getLastCellPostion() -> CGFloat {
        let indexPath = IndexPath(row: viewModel.messageCount - 1, section: 0)
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: view)
        
        return rectOfCellInSuperview.origin.y + rectOfCellInTableView.size.height
    }
}
