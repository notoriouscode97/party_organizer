//
//  CRUDPartyViewController.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CRUDMode {
    case ReadOrUpdate
    case Create
}

class CRUDPartyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var partyNameLabel: UILabel!
    @IBOutlet weak var partyNameTextField: UITextField!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var membersView: UIView!
    
    private let bag = DisposeBag()
    fileprivate let membersDatasource = DataSource()
    let tapGesture = UITapGestureRecognizer()
    let tapGestureForDismiss = UITapGestureRecognizer()
    
    var party: Party?
    var selectedMembers: BehaviorSubject<[Profile]> = BehaviorSubject(value: [])
    var currentMode: CRUDMode = .Create
    
    lazy var dateFormater : DateFormatter  = {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy HH:MM"
        return formater
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateAndTimeTextField.inputView = datePicker
        return datePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bind()
    }
    
    func setupUI() {
        navigationItem.title = "Party"
        partyNameLabel.text = "Type party name!"
        dateAndTimeLabel.text = "Select a date!"
        tableView.delegate = self
        membersButton.isUserInteractionEnabled = false
        membersView.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(tapGestureForDismiss)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: nil, action: nil)
        
        guard let `party` = party else { return }
        party.members.count != 0 ? (membersLabel.text = "Members(\(party.members.count))") : (membersLabel.text = "Members")
        descriptionTextView.text = party.description
        partyNameLabel.text = party.name
        partyNameTextField.text = party.name
        dateAndTimeLabel.text = "\(party.date)"
        dateAndTimeTextField.text = "\(party.date)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
    }
    
    func setupActions() {
        //Create new party
        if currentMode == .Create {
            navigationItem.rightBarButtonItem!.rx.tap
                .asDriver()
                .throttle(RxTimeInterval.milliseconds(500))
                .drive(onNext: { [weak self] _ in
                    let partiesOpt = try? Parties.allParties.value()
                    guard var `parties` = partiesOpt, let members = try? self?.selectedMembers.value() else { return }
                    
                    if let partyWithHighestID = parties.sorted(by: { $0.id > $1.id }).first {
                        parties.append(Party(id: partyWithHighestID.id + 1, name: self?.partyNameLabel.text ?? "", date: self?.datePicker.date ?? Date(), description: self?.descriptionTextView.text ?? "", members: members))
                        Parties.allParties.onNext(parties)
                        Parties.membersToAddForCreate.onNext([])
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        parties.append(Party(id: 0, name: self?.partyNameLabel.text ?? "", date: self?.datePicker.date ?? Date(), description: self?.descriptionTextView.text ?? "", members: members))
                        Parties.allParties.onNext(parties)
                        Parties.membersToAddForCreate.onNext([])
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
                .disposed(by: bag)
        } else if currentMode == .ReadOrUpdate {
            //Update
            navigationItem.rightBarButtonItem!.rx.tap
                .asDriver()
                .throttle(RxTimeInterval.milliseconds(500))
                .drive(onNext: { [weak self] _ in
                    let partiesOpt = try? Parties.allParties.value()
                    guard let this = self, var `parties` = partiesOpt, let members = try? self?.selectedMembers.value() else { return }
                    this.party?.name = this.partyNameLabel.text ?? ""
                    this.party?.date = this.datePicker.date
                    this.party?.description = this.descriptionTextView.text ?? ""
                    this.party?.members = members
                    parties.removeAll { $0.id == this.party?.id }
                    if let currentParty = this.party {
                        parties.append(currentParty)
                        Parties.allParties.onNext(parties)
                        this.navigationController?.popViewController(animated: true)
                    }
                })
                .disposed(by: bag)
        
            //Mode is Read only forbit any editing
            partyNameTextField.isEnabled = false
            dateAndTimeTextField.isEnabled = false
            descriptionTextView.isEditable = false
            membersView.isUserInteractionEnabled = false
        }
        
        tableView.rx.itemDeleted
            .asDriver()
            .drive(onNext: { [weak self] in
                print($0)
                guard let this = self else { return }
                let row = $0.row
                
                if let membersWithDeletedMember = this.party?.members.filter({ $0.id != row }) {
                    this.party?.members = membersWithDeletedMember
                    
                    let partiesOpt = try? Parties.allParties.value()
                    guard var `parties` = partiesOpt else { return }
                    parties.removeAll { $0.id == this.party?.id }
                    if let currentParty = this.party {
                        parties.append(currentParty)
                        Parties.allParties.onNext(parties)
                    }
                }
            })
            .disposed(by: bag)
        
        tapGesture.rx.event
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let this = self else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: PartyMemberPreviewViewController.ID) as! PartyMemberPreviewViewController
                if this.currentMode != .Create {
                    vc.party = this.party
                }
                this.navigationController?.show(vc, sender: self)
            })
            .disposed(by: bag)
        
        tapGestureForDismiss.rx.event
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: bag)
        
        partyNameTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(partyNameTextField.rx.text.orEmpty)
            .bind(onNext: { [weak self] text in
                text != "" ? (self?.partyNameLabel.text = text) : (self?.partyNameLabel.text = "Type party name!")
            })
            .disposed(by: bag)
        
        datePicker.rx.date
            .map{ [weak self] in
                self?.dateFormater.string(from: $0)
        }
        .bind(to: dateAndTimeLabel.rx.text)
        .disposed(by: bag)
        
        datePicker.rx.date
            .map{ [weak self] in
                self?.dateFormater.string(from: $0)
        }
        .bind(to: dateAndTimeTextField.rx.text)
        .disposed(by: bag)
    }
    
    func bind() {
        Parties.allParties.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map{
                $0.filter{ $0.id == self.party?.id }.first
            }
            .compactMap{ $0?.members.map{ CRUDPartyCellBlueprint(member: $0) } }
            .filter{!$0.isEmpty}
            .debug("bind elementi", trimOutput: true)
            .bind(to: tableView.rx.items(dataSource: membersDatasource))
            .disposed(by: bag)
        
        Parties.membersToAddForCreate.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .bind(to: selectedMembers)
            .disposed(by: bag)
    }
    
}

extension CRUDPartyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 43.5
    }
}

