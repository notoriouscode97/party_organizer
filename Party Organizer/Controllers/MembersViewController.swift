//
//  MembersViewController.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MembersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let membersDatasource = DataSource()

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bind()
    }
    
    func setupUI() {
        navigationItem.title = "Members"
        tableView.delegate = self
    }
    
    func setupActions() {
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let this = self, let members = try? Members.allMembers.value() else { return }
                let member = members.filter{ $0.id == indexPath.row }.first
                if let `member` = member {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: ProfileViewController.ID) as! ProfileViewController
                    
                    vc.member = member
                    this.navigationController?.show(vc, sender: self)
                }
            })
            .disposed(by: bag)
    }
    
    func bind() {
        Members.allMembers.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map{ $0.map{ MembersCellRowBlueprint(member: $0) } }
            .filter{!$0.isEmpty}
            .debug("bind elementi", trimOutput: true)
            .bind(to: tableView.rx.items(dataSource: membersDatasource))
            .disposed(by: bag)
    }
}

extension MembersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108.0
    }
}
