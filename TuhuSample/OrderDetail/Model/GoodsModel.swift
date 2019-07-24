//
//  GoodsModel.swift
//  TuhuSample
//
//  Created by Muiz on 15/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation

class GoodsModel: NSObject {
    
    public var name: String = "镭射眼智能后视镜行车记录仪1080P超清夜视 智能防堵语音导航"
    public var price: Double = 0.00
    public var count: UInt = 1
    
}

enum OrderDetailFooterButton {
    case payNow
    case confirmReceipt
    case commentNow
    case cancle
    case shopReservation
    case commentAgain
    case remindShipments
    case remindDelivery
    case salesReturn
    case invoicing
    case afterSaleService
    case applyForInvoice(String)
    case invoiceProgress
    
    var displayingText: String {
        switch self {
        case .payNow:
            return "立即支付"
        case .confirmReceipt:
            return "确认收货"
        case .commentNow:
            return "立即评价"
        case .cancle:
            return "取消订单"
        case .shopReservation:  // 这个按钮没有显示过欸
            return "门店预约"
        case .commentAgain:
            return "追加评价"
        case .remindShipments:
            return "提醒发货"
        case .remindDelivery:
            return "催物流"
        case .salesReturn:
            return "退货"
        case .invoicing:
            return "开发票"
        case .afterSaleService:
            return "售后"
        case .applyForInvoice(let state):
            return state == "1" ? "申请开票" : "查看发票"
        case .invoiceProgress:
            return "查看发票"
        }
    }
    
}
