//
//  HomeViewController.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/22/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var viewModel: HomeViewModel = HomeViewModel()
    fileprivate let partyDatasource = DataSource()

    private lazy var noPartiesView: NoPartiesView = {
        let noPartiesView: NoPartiesView = NoPartiesView.fromNib()
        noPartiesView.frame = UIScreen.main.bounds
        noPartiesView.createPartyButton.layer.cornerRadius = 10
        return noPartiesView
    }()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bind()
    }
    
    func setupUI() {
        navigationItem.title = "Parties"
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton
        tableView.delegate = self
        noPartiesView.isHidden = false
        tableView.isHidden = true
        view.addSubview(noPartiesView)
    }
    
    func setupActions() {
        navigationItem.rightBarButtonItem!.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: CRUDPartyViewController.ID) as! CRUDPartyViewController
                vc.currentMode = .Create
                this.navigationController?.show(vc, sender: self)
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected
        .asDriver()
        .throttle(RxTimeInterval.milliseconds(500))
        .drive(onNext: { [weak self] indexPath in
            guard let this = self, let parties = try? Parties.allParties.value() else { return }
            let party = parties.filter{ $0.id == indexPath.row }.first
            if let `party` = party {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: CRUDPartyViewController.ID) as! CRUDPartyViewController
                vc.currentMode = .ReadOrUpdate
                vc.party = party
                this.navigationController?.show(vc, sender: self)
            }
        })
        .disposed(by: bag)
        
        tableView.rx.itemDeleted
            .asDriver()
            .drive(onNext: {
                print($0)
                let members = try? Members.allMembers.value()
                let row = $0.row
                
                if let membersWithDeletedMember = members?.filter({ $0.id != row }) {
                    Members.allMembers.onNext(membersWithDeletedMember)
                }
            })
            .disposed(by: bag)
        
        noPartiesView.createPartyButton.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.milliseconds(500))
            .drive(onNext: { [weak self] in
                guard let this = self else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: CRUDPartyViewController.ID) as! CRUDPartyViewController
                vc.currentMode = .Create
                this.navigationController?.show(vc, sender: self)
            })
            .disposed(by: bag)
    }
    
    func bind() {
        Parties.allParties.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map{ $0.map{ HomeCellRowBlueprint(party: $0) } }
            .filter{!$0.isEmpty}
            .debug("bind elementi", trimOutput: true)
            .do(onNext: { [weak self] _ in
                guard let this = self else { return }
                this.noPartiesView.isHidden = true
                this.noPartiesView.removeFromSuperview()
                this.tableView.isHidden = false
            })
            .bind(to: tableView.rx.items(dataSource: partyDatasource))
            .disposed(by: bag)
    }


}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 154.0
    }
}
