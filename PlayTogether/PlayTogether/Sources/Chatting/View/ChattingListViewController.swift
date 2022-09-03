//
//  ChatViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import RxSwift
import UIKit

final class ChattingListViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = ChattingListViewModel()
    private let socketManager = SocketIOManager.shared
    
    private let tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UIScreen.main.bounds.height * 0.093
        $0.register(
            ChattingListTableViewCell.self,
            forCellReuseIdentifier: "ChattingListTableViewCell"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.shared.establishConnection()
        subscribeNewMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchChattingRoomList()
    }
    
    override func setupViews() {
        title = "채팅"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    override func setupLayouts() {
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarHeight)
        }
    }
    
    override func setupBinding() {
        viewModel.chattingRoomListSubject
            .bind(to: tableView.rx.items) { _, row, item -> UITableViewCell in
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: "ChattingListTableViewCell",
                    for: IndexPath(row: 0, section: 0)
                ) as? ChattingListTableViewCell,
                      let item = item
                else { return UITableViewCell() }
                
                //TODO: 추후 변경 예정
                cell.setupCell(
                    profileImage: nil,
                    name: item.audience,
                    lastChat: item.content,
                    date: item.createdAt,
                    send: item.send,
                    read: item.read
                )
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { view, indexPath in
                guard let values = try? view.viewModel.chattingRoomListSubject.value(),
                      let item = values[indexPath.row]
                else { return }
                
                let chattingRoomViewController = ChattingRoomViewController(
                    userName: item.audience,
                    roomID: item.roomID,
                    receiverID: item.audienceID
                )
                chattingRoomViewController.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(
                    chattingRoomViewController,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
    }
}

private extension ChattingListViewController {
    func subscribeNewMessage() {
        socketManager.socket.subscribeOn("newMessageToUser") { response in
            guard let messageString = response["content"] as? String,
                  let audienceID = response["recvId"] as? Int,
                  var rooms = try? self.viewModel.chattingRoomListSubject.value()
            else { return }
            
            for room in rooms {
                guard var room = room,
                      room.audienceID == audienceID
                else { continue }

                self.updateRoom(audienceID, messageString, &rooms, &room)
                return
            }
            self.addNewRoom(audienceID, messageString, &rooms)
        }
    }
    
    func addNewRoom(_ audinceID: Int, _ message: String, _ originRooms: inout [ChattingRoom?]) {
        let firstIndex = IndexPath(row: 0, section: 0)
        
        //TODO: 변경 예정
        let newRoom = ChattingRoom(
            roomID: 57,
            audience: "이승헌",
            audienceID: audinceID,
            send: false,
            read: false,
            createdAt: "2022-09-03T18:44:57.641Z",
            content: message
        )
        
        tableView.beginUpdates()
        
        originRooms.insert(newRoom, at: 0)
        viewModel.chattingRoomListSubject.onNext(originRooms)
        tableView.insertRows(at: [firstIndex], with: .bottom)
        
        tableView.endUpdates()
    }
    
    func updateRoom(
        _ audienceID: Int,
        _ message: String,
        _ originRooms: inout [ChattingRoom?],
        _ originRoom: inout ChattingRoom
    ) {
        //TODO: 변경 예정
        originRoom.content = message
        var row: Int = .init()
        for i in 0..<originRooms.count {
            guard originRooms[i]?.audienceID == originRoom.audienceID else { continue }

            row = i
            break
        }
        
        let firstIndex = IndexPath(row: 0, section: 0)
        let originIndex = IndexPath(row: row, section: 0)
        
        tableView.beginUpdates()
        
        tableView.moveRow(at: originIndex, to: firstIndex)
        originRooms.insert(originRooms.remove(at: row), at: 0)
        viewModel.chattingRoomListSubject.onNext(originRooms)
        
        tableView.endUpdates()
    }
}
