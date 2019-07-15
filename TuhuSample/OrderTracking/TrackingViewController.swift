//
//  TrackingViewController.swift
//  Tuhu
//
//  Created by Muiz on 2019/5/31.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation
import UIKit

class TrackingViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mapView: BMKMapView!
    @IBOutlet weak var trayView: UIView!
    
    private var trayOriginalCenter: CGPoint!
    private var trayHeight: CGFloat!
    private var trayUp: CGPoint!
    private var trayDown: CGPoint!
    
    private var packageTrackingViewController: PackageTrackingTableViewController?
    
    let startCoordinate = CLLocationCoordinate2D(latitude: 39.91, longitude: 116.414)
    let midCoordinate = CLLocationCoordinate2D(latitude: 39.925, longitude: 116.434)
    let endCoordinate = CLLocationCoordinate2D(latitude: 39.935, longitude: 116.490)
    private var arcline: BMKArcline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initData()
    }
    
    private func initUI() {
        title = "订单跟踪"
    }
    
    private func initData() {
        mapView.delegate = self
        
        placeAnnotation(title: "华南保税1号仓", subTitle: "发", coordinate: startCoordinate)
        placeAnnotation(title: "hangzhou", subTitle: "", coordinate: midCoordinate)
        placeAnnotation(title: "上海闵行区", subTitle: "收", coordinate: endCoordinate)
        
        let routeSearch = BMKRouteSearch()
        routeSearch.delegate = self
        let start = BMKPlanNode()
        start.pt = startCoordinate
        let end = BMKPlanNode()
        end.pt = midCoordinate

        let drivingRoutePlan = BMKDrivingRoutePlanOption()
        drivingRoutePlan.from = start
        drivingRoutePlan.to = end
        if !routeSearch.drivingSearch(drivingRoutePlan) {
            print("当前无法获取路线，请稍后重试！")
        }
        
        var coords = [CLLocationCoordinate2D]()
        coords.append(midCoordinate)
        coords.append(CLLocationCoordinate2D(latitude: 39.930, longitude: 116.470))
        coords.append(endCoordinate)
        
//        let mid = CLLocationCoordinate2D(latitude: CLLocationDegrees((midCoordinate.latitude + endCoordinate.latitude) / 2.0), longitude: CLLocationDegrees((midCoordinate.longitude + endCoordinate.longitude) / 2.0))
//
//        coords.append(midCoordinate)
//        coords.append(mid)
//        coords.append(endCoordinate)
        
        arcline = BMKArcline(coordinates: &coords)
        mapView.add(arcline)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PackageTrackingTableViewController {
            self.packageTrackingViewController = vc
        }
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        trayHeight = trayView.bounds.height
        trayUp = mapView.convert(CGPoint(x: UIScreen.main.bounds.width / 2.0, y: 147 + trayHeight / 2.0), to: self.view)
        trayDown = mapView.convert(CGPoint(x: UIScreen.main.bounds.width / 2.0, y: mapView.bounds.height + trayHeight / 2.0), to: self.view)
        
        let translation = sender.translation(in: trayView)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            let y = min(trayDown.y, max(trayOriginalCenter.y + translation.y, trayUp.y))
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: y)
            topView.center = topViewCenter(from: trayView.center)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            moveTrayView(up: velocity.y < 0)
        }
    }
    
    public func restoreTrayView() {
        let isMoveUp = (trayView.center.y - trayUp.y) < (trayDown.y - trayView.center.y)
        moveTrayView(up: isMoveUp)
    }
    
    private func moveTrayView(up: Bool) {
        if up {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.trayView.center = self.trayUp
                self.topView.center = self.topViewCenter(from: self.trayView.center)
            }, completion: { _ in
                if let vc = self.packageTrackingViewController {
                    vc.tableView.isScrollEnabled = true
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.trayView.center = self.trayDown
                self.topView.center = self.topViewCenter(from: self.trayView.center)
            }, completion: { _ in
                if let vc = self.packageTrackingViewController {
                    vc.tableView.isScrollEnabled = false
                }
            })
        }
    }
    
    private func topViewCenter(from trayCenter: CGPoint) -> CGPoint {
        let centerY = -(trayCenter.y - trayUp.y) + mapView.convert(CGPoint(x: UIScreen.main.bounds.width / 2.0, y: 147 / 2.0), to: self.view).y
        return CGPoint(x: trayCenter.x, y: centerY)
    }
    
}

// MARK: - BaiduMap
extension TrackingViewController: BMKMapViewDelegate, BMKRouteSearchDelegate {
    
    private func placeAnnotation(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        let annotation = BMKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let annotationView: BMKAnnotationView = BMKAnnotationView.init(annotation: annotation, reuseIdentifier: "TrackingAnnotation")
        let annotationType = TrackingAnnotationType(rawValue: annotation.subtitle?() ?? "") ?? .deliver
        annotationView.image = TrackingAnnotationView(address: annotation.title?() ?? "", type: annotationType).image
        annotationView.canShowCallout = false
        return annotationView
    }
    
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        
        //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
        if error == BMK_SEARCH_NO_ERROR {
            //+polylineWithPoints: count:坐标点的个数
            var pointCount = 0
            //获取所有驾车路线中第一条路线
            var routeline: BMKDrivingRouteLine = BMKDrivingRouteLine()
            if result.routes.count > 0 {
                routeline = result.routes[0]
            }
            //遍历驾车路线中的所有路段
            for (_, item) in routeline.steps.enumerated() {
                //获取驾车路线中的每条路段
                let step: BMKDrivingStep = item as! BMKDrivingStep
                //初始化标注类BMKPointAnnotation的实例
                let annotation = BMKPointAnnotation()
                //设置标注的经纬度坐标为子路段的入口经纬度
                annotation.coordinate = step.entrace.location
                //设置标注的标题为子路段的说明
                annotation.title = step.entraceInstruction
                /**
                 
                 当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
                 来生成标注对应的View
                 @param annotation 要添加的标注
                 */
                //统计路段所经过的地理坐标集合内点的个数
                pointCount += Int(step.pointsCount)
            }
            
            //+polylineWithPoints: count:指定的直角坐标点数组
            var points = [BMKMapPoint](repeating: BMKMapPoint(x: 0, y: 0), count: pointCount)
            var count = 0
            //遍历驾车路线中的所有路段
            for (_, item) in routeline.steps.enumerated() {
                //获取驾车路线中的每条路段
                let step: BMKDrivingStep = item as! BMKDrivingStep
                //遍历每条路段所经过的地理坐标集合点
                for index in 0..<Int(step.pointsCount) {
                    //将每条路段所经过的地理坐标点赋值给points
                    points[count].x = step.points[index].x
                    points[count].y = step.points[index].y
                    count += 1
                }
            }
            //根据指定直角坐标点生成一段折线
            let polyline = BMKPolyline(points: &points, count: UInt(pointCount))
            /**
             向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
             来生成标注对应的View
             
             @param overlay 要添加的overlay
             */
            mapView.add(polyline)
            
            // 根据Points设置地图范围
            var mapPoints = [BMKMapPoint]()
            if let line = polyline {
                for i in 0..<line.pointCount {
                    mapPoints.append(line.points[Int(i)])
                }
            }
            if let arcline = self.arcline {
                for i in 0..<arcline.pointCount {
                    mapPoints.append(arcline.points[Int(i)])
                }
            }
            mapViewFitPolyline(mapPoints, mapView)
        }
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay.isKind(of: BMKPolyline.self) {
            let polylineView: BMKPolylineView = BMKPolylineView(overlay: overlay)
            polylineView.strokeColor = UIColor.tuhu.red
            polylineView.lineWidth = 3
            return polylineView
        } else if let arcline = overlay as? BMKArcline { // 画虚线
            let arclineView: BMKArclineView = BMKArclineView(arcline: arcline)
            arclineView.strokeColor = UIColor(hex: 0xFE8594)
            arclineView.lineDash = true
            arclineView.lineWidth = 2
            return arclineView
        }
        return nil
    }
    
    // 根据polyline设置地图范围
    func mapViewFitPolyline(_ points: [BMKMapPoint], _ mapView: BMKMapView) {
        var leftTop_x: Double = 0
        var leftTop_y: Double = 0
        var rightBottom_x: Double = 0
        var rightBottom_y: Double = 0
        if points.count < 1 {
            return
        }
        let pt: BMKMapPoint = points[0]
        leftTop_x = pt.x
        leftTop_y = pt.y
        // 左上方的点lefttop坐标（leftTop_x，leftTop_y）
        rightBottom_x = pt.x
        rightBottom_y = pt.y
        
        for index in 1..<points.count {
            let point: BMKMapPoint = points[Int(index)]
            if (point.x < leftTop_x) {
                leftTop_x = point.x
            }
            if (point.x > rightBottom_x) {
                rightBottom_x = point.x
            }
            if (point.y < leftTop_y) {
                leftTop_y = point.y
            }
            if (point.y > rightBottom_y) {
                rightBottom_y = point.y
            }
        }
        var rect: BMKMapRect = BMKMapRect()
        rect.origin = BMKMapPointMake(leftTop_x, leftTop_y)
        rect.size = BMKMapSizeMake(rightBottom_x - leftTop_x, rightBottom_y - leftTop_y)
        let padding: UIEdgeInsets = UIEdgeInsets.init(top: 30, left: 50, bottom: 20, right: 50)
        mapView.fitVisibleMapRect(rect, edgePadding: padding, withAnimated: true)
    }
    
}

class PackageTrackingTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI() {
        tableView.registerNibOf(TrackingGoodsCell.self)
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false   // 保证最开始的时候可以整体上滑
        tableView.panGestureRecognizer.addTarget(self, action: #selector(didPan(_:)))
    }
    
}

extension PackageTrackingTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(of: TrackingGoodsCell.self)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 49))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 16, y: 9, width: 100, height: 20))
        label.text = "包裹1"
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if translation.y > 0 && tableView.contentOffset.y <= 0,
            let vc = self.parent as? TrackingViewController {
            vc.didPanTray(sender)
        } else if sender.state == .ended, let vc = self.parent as? TrackingViewController {
            vc.restoreTrayView()
        }
    }
    
}



