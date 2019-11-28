//
//  BatteryAddressSearchViewController.swift
//  TuhuSample
//
//  Created by Muiz on 24/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation

class BatteryAddressSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNibOf(BatteryAddressInputCell.self)
        tableView.registerNibOf(BatteryAddressSearchCell.self)
        
        let searchField = searchBar.value(forKey: "_searchField") as? UITextField
        searchField?.font = UIFont.systemFont(ofSize: 14)
        searchField?.textColor = UIColor.tuhu.textBlack
        searchField?.attributedPlaceholder = NSAttributedString.init(string: "请输入详细地址", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.tuhu.textLightGray])
        searchField?.borderStyle = .none
        searchField?.leftView = nil
        searchBar.searchTextPositionAdjustment = UIOffset.init(horizontal: 2, vertical: 0)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .clear)
        searchBar.layer.cornerRadius = 15
        searchBar.layer.masksToBounds = true
    }
    
}

extension BatteryAddressSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
    }
    
}

extension BatteryAddressSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(of: BatteryAddressSearchCell.self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(of: BatteryAddressInputCell.self)
            cell.configure(input: searchBar.text ?? "")
            return cell
        }
    }
    
}
