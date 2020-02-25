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
    var rowsToSave: [Int] = []
    
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
                guard let cell = cellOpt, let this = self else { return }
                UIView.animate(withDuration: 0.5) {
                    cell.checkMarkImageView.isHidden = !cell.checkMarkImageView.isHidden
                    
                    if cell.containedInParty {
                        this.navigationItem.rightBarButtonItem?.isEnabled = true
                        this.rowsToSave.append(indexPath.row)
                    } else {
                        if cell.checkMarkImageView.isHidden == false {
                            this.rowsToSave.append(indexPath.row)
                        } else {
                            this.rowsToSave.removeAll(where: { number in
                                number == indexPath.row
                            })
                            self?.rowsToSave.remove(at: indexPath.row)
                        }
                    }
                    
                    if var allParties = try? Parties.allParties.value() {
                        var partiesToAddMember: [Party] = []
                        var finalPartiesMemberAdded: [Party] = []
                        this.rowsToSave.forEach{ number in
                            partiesToAddMember.append(allParties[number])
                        }
                        
                        partiesToAddMember.forEach { party in
                            var newParty = party
                            newParty.members.append(this.member)
                            allParties.removeAll{ $0.id ==  newParty.id }
                            finalPartiesMemberAdded.append(newParty)
                        }
                        
                        allParties.append(contentsOf: finalPartiesMemberAdded)
                        Parties.allParties.onNext(allParties)
                        
                    }
                    
                }
            }).disposed(by: bag)
    }
    
    func bind() {
        Parties.allParties.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map{ $0.map{ AddMemberToPartyRowBlueprint(party: $0, member: self.member) } }
            .filter{!$0.isEmpty}
            .debug("bind elementi", trimOutput: true)
            .bind(to: tableView.rx.items(dataSource: partiesDatasource))
            .disposed(by: bag)
    }
    
}

extension AddMemberToPartyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 43.5
    }
}
