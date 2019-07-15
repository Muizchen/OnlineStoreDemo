//
//  OrderDetailViewController.swift
//  Tuhu
//
//  Created by Muiz on 04/07/2019.
//  Copyright © 2019 Tuhu. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    // Delivery Module
    @IBOutlet weak var deliveryStackView: UIStackView!
    @IBOutlet weak var topCornerView: UIView!
    @IBOutlet weak var noticeView: UIView!
    // Beautify
    @IBOutlet weak var beautifyView: UIView!
    @IBOutlet weak var beautifyCodeLabel: UILabel!
    @IBOutlet weak var beautifyDurationLabel: UILabel!
    // Tracking
    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingLabel: UILabel!
    @IBOutlet weak var trackingTimeLabel: UILabel!
    // Shop
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopReceiverLabel: UILabel!
    @IBOutlet weak var shopPhoneLabel: UILabel!
    // Address
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var estimateTimeLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    // Vehicle
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var vehicleDetailLabel: UILabel!
    @IBOutlet weak var bottomCornerView: UIView!
    
    // Payment Module
    @IBOutlet weak var paymentStackView: UIStackView!
    // Goods
    @IBOutlet weak var installImageView: UIImageView!
    @IBOutlet weak var goodsStackView: UIStackView!
    // Gift
    @IBOutlet weak var giftStackView: UIStackView!
    // Service
    @IBOutlet weak var serviceStackView: UIStackView!
    // Paymen
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderCreateTimeLabel: UILabel!
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    // Price
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var settlePriceLabel: UILabel!
    
    // QRCode Module
    @IBOutlet weak var orderQRCodeView: UIView!
    @IBOutlet weak var orderQRCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.title = "订单详情"
//        let image = UIImage(named: "order_detail_background_rectangle")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
//        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        
        self.navigationController?.isNavigationBarHidden = true
        
        loadComponents()
    }
    
    @IBAction func getOnlineService(_ sender: Any) {
        
    }
    
    @IBAction func getCallService(_ sender: Any) {
        
    }
    
    @IBAction func copyOrderId(_ sender: Any) {
//        UIPasteboard.general.string = model?.deliveryCode ??? ""
//        THToast.showText("复制成功")
    }
    
    private func loadComponents() {
        //        orderDetailStackView.removeArrangedSubview(vehicleView)
        //        vehicleView.removeFromSuperview()
        
        // Goods
        let goodsStackView = UIStackView()
        goodsStackView.alignment = .fill
        goodsStackView.axis = .vertical
        goodsStackView.spacing = 0.5
        for _ in 0...1 {
            let goodsView = OrderDetailGoodsView()
            // Todo
            goodsView.goods = GoodsModel()
            goodsStackView.insertArrangedSubview(goodsView, at: goodsStackView.arrangedSubviews.count)
        }
        self.goodsStackView.insertArrangedSubview(goodsStackView, at: self.goodsStackView.arrangedSubviews.count)
        
        // Gifts
        for _ in 0...1 {
            let goodsView = OrderDetailGoodsView()
            // Todo
            goodsView.goods = GoodsModel()
            giftStackView.insertArrangedSubview(goodsView, at: giftStackView.arrangedSubviews.count)
        }
        
        // Service
        for _ in 0...1 {
            let goodsView = OrderDetailGoodsView()
            // Todo
            goodsView.goods = GoodsModel()
            serviceStackView.insertArrangedSubview(goodsView, at: serviceStackView.arrangedSubviews.count)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
