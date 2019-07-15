//
//  TableView.swift
//  TuhuSample
//
//  Created by Muiz on 2019/6/12.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import UIKit

// MARK: - Reusable

protocol Reusable: class {
    static var th_reuseIdentifier: String { get }
}

extension UITableViewCell: Reusable {
    static var th_reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {
    static var th_reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable {
    static var th_reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - NibLoadable

protocol NibLoadable: class {
    static var th_nibName: String { get }
    static var nib: UINib { get }
}

extension NibLoadable {
    static var th_nibName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: th_nibName, bundle: Bundle(for: self))
    }
}

extension NibLoadable where Self: UIView {
    static func loadFromNib(frame: CGRect = .zero) -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        view.frame = frame
        return view
    }
}

extension UIView: NibLoadable {}

// MARK: - Register & Dequeue

extension UITableView {
    func registerNibOf<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.th_nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.th_reuseIdentifier)
    }
    
    func registerClassOf<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.th_reuseIdentifier)
    }
    
    func registerHeaderFooterNibOf<T: UITableViewHeaderFooterView>(_: T.Type) {
        let nib = UINib(nibName: T.th_nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: T.th_reuseIdentifier)
    }
    
    func registerHeaderFooterClassOf<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.th_reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        return dequeueReusableCell(of: T.self)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(of cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.th_reuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.th_reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.th_reuseIdentifier) as? T else {
            fatalError("Could not dequeue HeaderFooter with identifier: \(T.th_reuseIdentifier)")
        }
        return view
    }
}

extension UICollectionView {
    func registerNibOf<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: T.th_nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.th_reuseIdentifier)
    }
    
    func registerClassOf<T: UICollectionReusableView>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.th_reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.th_reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.th_reuseIdentifier)")
        }
        return cell
    }
}
