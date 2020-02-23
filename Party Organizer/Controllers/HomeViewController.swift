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
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
//                guard let self = self else { return }
                //posalji ga na drugi ekran
            })
            .disposed(by: bag)
    }
    
    func bind() {
        Members.allMembers.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map{ $0.map{ HomeCellRowBlueprint(party: Party(name: $0.username ?? "Test", date: Date(), description: $0.aboutMe ?? "Test", members: nil)) } }
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
