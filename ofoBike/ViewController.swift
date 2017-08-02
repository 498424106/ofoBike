//
//  ViewController.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/10.
//  Copyright © 2017年 翟帅. All rights reserved.
//

import UIKit
import SWRevealViewController
import FTIndicator


class ViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate {
    var mapView : MAMapView!
    var search : AMapSearchAPI!
    var pin : MyPinAnnotation!
    var pinView :MAAnnotationView!
    var nearBySearch = true
    var start,end : CLLocationCoordinate2D!
    var walkManager : AMapNaviWalkManager!
    
    var faceView : SureMinionsView!

    @IBOutlet weak var inputBtn: UIButton!
    
    @IBOutlet weak var panelView: UIView!
    @IBAction func buttonView(_ sender: Any) {
        nearBySearch = true  //按钮响应事件，回到我的定位附近
        searchBikeNearby()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenh = UIScreen.main.applicationFrame.size.height
        let screenw = UIScreen.main.applicationFrame.size.width
        
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        view.bringSubview(toFront: panelView)
        
        //带重力感应的小黄人的脸
        faceView = SureMinionsView(frame: CGRect(x: 0, y: 0, width: 190, height: 190))
        faceView.center = CGPoint(x: screenw / 2, y: screenh - 55)
        view.addSubview(faceView)
        view.bringSubview(toFront: inputBtn)
        
        
        mapView.delegate = self
        AMapServices.shared().enableHTTPS = true   //允许高德地图 htpps 协议
        mapView.zoomLevel = 17
        //获取定位蓝点 并设置为追踪
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        //搜索附近位置API 兴趣点
        search = AMapSearchAPI()
        search.delegate = self
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "yellowBikeLogo"))
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "user_center_icon").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "gift_icon").withRenderingMode(.alwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
//        SW 视图容器的切换 侧滑栏
        if let revealVC = revealViewController(){
            revealVC.rearViewRevealWidth = 280
            navigationItem.leftBarButtonItem?.target = revealVC
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
            
        }
        
        //  用于加载启动页数据，可放到网络请求的回调中，图片异步缓存
        LaunchADView.setValue(imgURL: "http://img.shenghuozhe.net/shz/2016/05/07/750w_1224h_043751462609867.jpg", webURL: "http://www.ofo.so", showTime: 3)

        
        //  用于显示启动页。若启动数据更新，则将在下次启动后展示新的启动页
        LaunchADView.show { (url) in
            let vc = WebView()
            vc.url = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //小黄人点击事件
    func tapped(){
        print("tapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //地图初始化完成之后
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate //定位屏幕中心
        pin.lockedScreenPoint = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        pin.isLockedToScreen = true //锁定
        
        mapView.addAnnotations([pin])
        mapView.showAnnotations([pin], animated: true)
        
        searchBikeNearby()  //启动就搜索附近
    }
    // MARK: 大头针的动画
    func pinAnimaation() {
        //追落效果。y轴加位移
        let endFrame = pinView.frame
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            self.pinView.frame = endFrame
        }, completion: nil) //添加物理弹性 1秒发生0.2的弹性
        
    }
    
    
    // MARK: MapView Delegate
    //在地图上渲染规划的路线
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            //取消将大头针锁定至屏幕中央的锁定
            pin.isLockedToScreen = false
            //将地图缩放至显示全部的路线
            mapView.visibleMapRect = overlay.boundingMapRect
            //绘制路线时将大头针进行锁定，不在移动位置
            let renderer = MAPolylineRenderer(overlay: overlay)
            renderer?.lineWidth = 3.0
            renderer?.strokeColor = UIColor.green
            return renderer
        }
        return nil
    }
    
    
//    获取点击坐标点的路线规划
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        start = pin.coordinate
        end = view.annotation.coordinate
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(end.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
        
    }
    
//    制作动画，附近地标的显示动画  从小变大持续0.5秒
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        for aViews in aViews {
            guard aViews.annotation is MAPointAnnotation else {
                continue
            }
            aViews.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: { 
                aViews.transform = .identity
            }, completion: nil)
        }
        
    }
    
    /// 用户发生地图移动时的交互
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - wasUserAction: 用户是否移动
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            pin.isLockedToScreen = true  //保持大头针的位置，不会因显示全部地标而移动位置
            pinAnimaation()    //动画
            searchCustomLocation(mapView.centerCoordinate)
        }
    }
    
    /// 自定义大头针视图
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - annotation: 标注
    /// - Returns: 大头针视图
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //将用户自己的地标排除在外
        if annotation is MAUserLocation {
            return nil
        }
//        自定义大头针的图标
        if annotation is MyPinAnnotation {
            let reuseid = "anchor"
            var pinImage = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            if pinImage == nil {
                pinImage = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            pinImage?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            pinImage?.canShowCallout = false
            
            pinView = pinImage
            return pinImage
        }
        
        let reuseid = "myid"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
        if annotationView == nil{
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
        }
        if annotation.title == "正常使用"{
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }
        else{
            annotationView?.image = #imageLiteral(resourceName: "HomePage_ParkRedPack")
        }
        annotationView?.canShowCallout = true
        annotationView?.animatesDrop = true
        return annotationView
    }
    
    // MARK: Map Search Delegate
    //搜索周边的小黄车，用附近的餐厅位置代替
    func searchBikeNearby() {
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    func searchCustomLocation(_ center:CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 1000
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
    }
    //回调 搜索完周边后的处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count > 0 else {
            print("周边没有小黄车")
            return
        }
        //创建一个数组，将附近地标的信息装进数组
        var annotations : [MAPointAnnotation] = []
        annotations = response.pois.map{
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            if $0.distance < 200{
                annotation.title = "红包区域内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得红包奖励"
            }else{
                annotation.title = "正常使用"
            }
            return annotation
        }
        //将地标数组信息添加到地图上
        mapView.addAnnotations(annotations)
        if nearBySearch {  //判断，如果是用户刚进入 APP，要进行缩放，如果是用户自己移动，则不进行缩放
            //自动缩放地图，将全部地标展示在地图上
            mapView.showAnnotations(annotations, animated: true)
            nearBySearch = !nearBySearch
        }
        
        
        for poi in response.pois {
            print(poi.name)//输出附近地标
        }
        
    }
    // MARK: AMapNaviWalkManager Delegate 导航的代理
//    路线的规划
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("步行路线规划成功")
        //路线规划成功之后，对原来的线和多余的线去掉
        mapView.removeOverlays(mapView.overlays)
        
        //配置路线
        var coordinates = walkManager.naviRoute!.routeCoordinates!.map {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        let polyline = MAPolyline(coordinates: &coordinates, count:UInt(coordinates.count))
        mapView.add(polyline)
        
        //显示到目标地点的距离与时间
        let walkMinute = walkManager.naviRoute!.routeTime / 60
        var timeDesc = "一分钟以内"
        if walkMinute > 0 {
            timeDesc = walkMinute.description + "分钟"
        }
        let hintTitle = "步行" + timeDesc
        let hinSubtile = "距离" + walkManager.naviRoute!.routeLength.description + "米"
        
        //系统的弹窗 提示步行的距离和时间
//        let ac = UIAlertController(title: hintTitle, message: hinSubtile, preferredStyle: .alert)
//        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
//        ac.addAction(action)
//        self.present(ac, animated: true, completion: nil)
        
        // FTIndicator弹框的提示
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hinSubtile)
        
    }
    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
        print("路线规划失败：",error)
    }


}

