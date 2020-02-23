//
//  ProfileViewController.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addToPartyButton: UIButton!
    
    var member: Profile!
    private let dataSourceKeys = ["Full name:", "Gender:", "email:"]
    private var dataSourceValues: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: nil, action: nil)
        addToPartyButton.layer.cornerRadius = 10
        dataSourceValues = [member.username ?? "N/A", member.gender ?? "N/A", member.email ?? "N/A"]
    }
    
    func setupActions() {
        
    }
    
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 4 }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellTop = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.ID, for: indexPath) as!
            ProfileImageTableViewCell
            guard let photo = member.photo, let url = URL(string: photo) else { return UITableViewCell() }
            cellTop.profileImageView.setImage(with: url, urlString: photo, placeholder: UIImage(named: "placeholder"), isAnimated: true)
            cellTop.selectionStyle = .none
            
            return cellTop
        }
        switch indexPath.row {
        case 0,1,2:
            print("")
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileLabelsTableViewCell.ID, for: indexPath) as!
            ProfileLabelsTableViewCell
            cell.labelKey.text = dataSourceKeys[indexPath.row]
            cell.labelValue.text = dataSourceValues[indexPath.row]
            cell.selectionStyle = .none
            return cell
        case 3:
            print("")
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMultipleTableViewCell.ID, for: indexPath) as!
            ProfileMultipleTableViewCell
            cell.descriptionLabel.text = member.aboutMe ?? ""
            cell.selectionStyle = .none

            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           if indexPath.section == 0 {
            return 233.0
           } else if indexPath.row >= 3 {
            return 120.0
           } else {
            return 37.5
           }
       }
}
