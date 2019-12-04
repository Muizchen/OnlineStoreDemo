//
//  BatteryAddressSearchViewController.swift
//  TuhuSample
//
//  Created by Muiz on 24/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation
import MapKit

class BatteryAddressSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNibOf(BatteryAddressInputCell.self)
        tableView.registerNibOf(BatteryAddressSearchCell.self)
        
        var searchField: UITextField?
        if #available(iOS 13, *) {
            searchField = searchBar.searchTextField
        } else {
            searchField = searchBar.value(forKey: "searchField") as? UITextField
        }
        searchField?.font = UIFont.systemFont(ofSize: 14)
        searchField?.textColor = UIColor.tuhu.textBlack
        searchField?.attributedPlaceholder = NSAttributedString.init(string: "请输入详细地址", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.tuhu.textLightGray])
        searchField?.borderStyle = .none
        /// 左侧搜索图标
        searchField?.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: 14, height: 14))
        searchBar.setPositionAdjustment(UIOffset(horizontal: -6, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .clear)
        /// 文字
        searchBar.searchTextPositionAdjustment = UIOffset.init(horizontal: 3, vertical: 0)
        searchBar.layer.cornerRadius = 15
    }
    
}

extension BatteryAddressSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        /// 更改地址搜索页面状态
        self.tableViewLeadingConstraint.constant = 8
        self.tableViewHeightConstraint.constant = self.mapView.bounds.height - 8 - (self.view.bounds.height * self.tableViewHeightConstraint.multiplier)
        tableView.layer.cornerRadius = 4
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        self.tableViewLeadingConstraint.constant = 0
        self.tableViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
            return 15
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
    }
    
}
