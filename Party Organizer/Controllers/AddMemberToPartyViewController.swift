//
//  AddMemberToPartyViewController.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddMemberToPartyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let partiesDatasource = DataSource()

    private let bag = DisposeBag()
    
    var member: Profile!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bind()
    }
    
    func setupUI() {
        navigationItem.title = member.username
        tableView.delegate = self
    }
    
    func setupActions() {
        tableView.rx.itemSelected
            .asDriver()
            .throttle(RxTimeInterval.milliseconds(500))
            .drive(onNext: { [weak self] indexPath in
                let cellOpt = self?.tableView.cellForRow(at: indexPath) as? AddMemberTableViewCell
                guard let cell = cellOpt else { return }
                UIView.animate(withDuration: 0.5) {
                    cell.checkMarkImageView.isHidden = !cell.checkMarkImageView.isHidden
                }
                //Nakon ovoga proveriti ako se vidi checkMark dodaj tog membera u odredjeni party
            }).disposed(by: bag)
    }
    
    func bind() {
//        Parties.allParties.asObservable()

//        Observable.just([Party(id: 0, name: "Test Party", date: Date(), description: "Test", members: nil), Party(id: 0, name: "Test Party", date: Date(), description: "Test", members: [])])
//        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//        .observeOn(MainScheduler.instance)
//        .map{ $0.map{ AddMemberToPartyRowBlueprint(party: $0) } }
//        .filter{!$0.isEmpty}
//        .debug("bind elementi", trimOutput: true)
//        .bind(to: tableView.rx.items(dataSource: partiesDatasource))
//        .disposed(by: bag)
    }
    
}

extension AddMemberToPartyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 43.5
    }
}
