//
//  AddressViewController.swift
//  TuhuSample
//
//  Created by Muiz on 2019/5/8.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation
import UIKit

class AddressViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 371, height: 380)
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        self.tableView.beginUpdates()
        self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: container.preferredContentSize.width, height: container.preferredContentSize.height)
        self.tableView.endUpdates()
    }
    
}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoredAddressCell", for: indexPath)
        cell.textLabel?.text = "Num \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 20))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}

class EmbededBatteryAddressPickerViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var locateAddressLabel: UILabel!
    
    @IBOutlet weak var addressTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationViewHeightConstraint: NSLayoutConstraint!
    
    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressTextView.textContainerInset = .zero
        self.addressTextView.textContainer.lineFragmentPadding = 0
        // 设置默认值，更新自身VC的contentSize
        self.addressTextView.text = ""
        self.confirmButton.addTarget(self, action: #selector(confirmSelection(btn:)), for: .touchUpInside)
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        UIView.animate(withDuration: 0.1) {
            sender.invalidateIntrinsicContentSize()
        }
    }
    
    @objc private func confirmSelection(btn: UIButton) {
        let texts = ["",
                     "短地址",
                     "沪闵路7866号城开中心1号楼途虎养车楼途虎养车楼途",
                     "沪闵路7866号城开中心1号楼途虎养车楼途虎养车楼途,沪闵路7866号城开中心1号楼途虎养车楼途虎养车楼途"]
        let text = texts[index % texts.count]
        index += 1
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        
        locateAddressLabel.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14), .paragraphStyle: style])
        let sizeToFitIn = CGSize(width: locateAddressLabel.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newHeight = text.isEmpty ? 0 : ceil(locateAddressLabel.sizeThatFits(sizeToFitIn).height) + 31
        
        locationViewHeightConstraint.constant = newHeight
        relayoutTableView(withDuration: 0.3)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: textView.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newHeight = ceil(textView.sizeThatFits(sizeToFitIn).height)
        
        self.addressTextViewHeightConstraint.constant = newHeight
        self.relayoutTableView()
    }
    
    // Dispatch: While a user is typing a letter, the focusing of the cursor and the layout of the tableView are conflicting. The only thing we need to do is to defer the layout for the next run loop by dispatching it to the main queue
    private func relayoutTableView(withDuration: TimeInterval = 0.1) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                // 告诉table只re-layout。否则Input会失焦
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                self.preferredContentSize = self.tableView.contentSize
            }
        }
    }
    
}

class EmbededAddressViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var locateAddressLabel: UILabel!
    @IBOutlet weak var locataAddressView: UIView!
    
    @IBOutlet weak var addressTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationViewHeightConstraint: NSLayoutConstraint!
    
    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressTextView.textContainerInset = .zero
        self.addressTextView.textContainer.lineFragmentPadding = 0
        // 设置默认值，更新自身VC的contentSize
        self.addressTextView.text = ""
        self.confirmButton.addTarget(self, action: #selector(confirmSelection(btn:)), for: .touchUpInside)
    }
    
    @objc private func confirmSelection(btn: UIButton) {
        let texts = ["",
                     "短地址",
                     "沪闵路7866号城开中心1号楼途虎养车楼途虎养车楼途",
                     "沪闵路7866号城开中心1号楼途虎养车楼途虎养车楼途,沪闵路7866号城开中心1号楼途虎养车楼途虎养车楼途"]
        let text = texts[index % texts.count]
        index += 1
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        
        locateAddressLabel.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14), .paragraphStyle: style])
        let sizeToFitIn = CGSize(width: locateAddressLabel.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newHeight = text.isEmpty ? 0 : ceil(locateAddressLabel.sizeThatFits(sizeToFitIn).height) + 31
        
        self.locataAddressView.isHidden = text.isEmpty
        locationViewHeightConstraint.constant = newHeight
        relayoutTableView(withDuration: 0.3)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: textView.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newHeight = ceil(textView.sizeThatFits(sizeToFitIn).height)
        
        self.addressTextViewHeightConstraint.constant = newHeight
        self.relayoutTableView()
    }
    
    // Dispatch: While a user is typing a letter, the focusing of the cursor and the layout of the tableView are conflicting. The only thing we need to do is to defer the layout for the next run loop by dispatching it to the main queue
    private func relayoutTableView(withDuration: TimeInterval = 0.1) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                // 告诉table只re-layout。否则Input会失焦
                self.preferredContentSize = self.view.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.width, height: CGFloat(MAXFLOAT)))
            }
        }
    }
    
}
