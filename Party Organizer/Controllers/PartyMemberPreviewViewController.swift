//
//  PartyMemberPreviewViewController.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PartyMemberPreviewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()
    fileprivate let membersDatasource = DataSource()
    var party: Party!
    var rowsToSave: [Int] = []
    var currentMode: CRUDMode = .Create

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bind()
    }
    
    func setupUI() {
           navigationItem.title = "Members"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
           tableView.delegate = self
    }
    
    func setupActions() {
        tableView.rx.itemSelected
            .asDriver()
            .throttle(RxTimeInterval.milliseconds(500))
            .drive(onNext: { [weak self] indexPath in
                let cellOpt = self?.tableView.cellForRow(at: indexPath) as? MembersTableViewCell
                guard let cell = cellOpt else { return }
                UIView.animate(withDuration: 0.5) {
                    cell.checkMarkImageView.isHidden = !cell.checkMarkImageView.isHidden
                    if cell.containedInParty {
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                        self?.rowsToSave.append(indexPath.row)
                    } else {
                        if cell.checkMarkImageView.isHidden == false {
                            self?.navigationItem.rightBarButtonItem?.isEnabled = true
                            self?.rowsToSave.append(indexPath.row)
                        } else {
                            self?.navigationItem.rightBarButtonItem?.isEnabled = false
                            self?.rowsToSave.removeAll(where: { number in
                                number == indexPath.row
                            })
                            self?.rowsToSave.remove(at: indexPath.row)
                        }
                    }
                }
            }).disposed(by: bag)
        
        navigationItem.rightBarButtonItem!.rx.tap
            .asDriver()
            .throttle(RxTimeInterval.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }
                
                if let allMembers = try? Members.allMembers.value() {
                    var membersToAdd: [Profile] = []
                    this.rowsToSave.forEach{ number in
                        membersToAdd.append(allMembers[number])
                    }
                    if this.currentMode == .Create {
                        Parties.membersToAddForCreate.onNext(membersToAdd)
                    } else {
                        this.party.members.append(contentsOf: membersToAdd)
                        
                        if var allParties = try? Parties.allParties.value() {
                            
                            allParties.removeAll { $0.id == this.party?.id }
                            allParties.append(this.party)
                            Parties.allParties.onNext(allParties)
                        }
                    }
                    
                }
                this.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    func bind() {
        Members.allMembers.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map{ $0.map{ MembersCellRowBlueprint(member: $0, isPartyMemberScreen: true, party: self.party) } }
            .filter{!$0.isEmpty}
            .debug("bind elementi", trimOutput: true)
            .bind(to: tableView.rx.items(dataSource: membersDatasource))
            .disposed(by: bag)
    }
}

extension PartyMemberPreviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108.0
    }
}
