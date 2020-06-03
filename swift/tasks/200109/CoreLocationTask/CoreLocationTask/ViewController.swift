
//  ViewController.swift
//  CoreLocationTask
//
//  Created by 양중창 on 2020/01/09.
//  Copyright © 2020 didwndckd. All rights reserved.
//

//[ 실습 ]
//자신의 집 주소에 Annotation 추가해보기
//자신의 집 주소 주변에 삼각형으로 표시하기
//[ 과제 ]
//1. 입력한 주소들을 차례대로 잇는 선 만들기   (샘플 영상 참고)
//> 텍스트필드에 주소를 입력하면 해당 위치로 애니메이션과 함께 맵 이동 (CoordinateSpan 값 - 0.02)
//> 입력한 주소값으로 이동한 뒤 그 위치를 표시하기 위한 사각형 그리기 + Annotation 추가하기
//> Annotation 의 제목은 1번째 행선지, 2번째 행선지 처럼 순서를 표시하고, 부제목은 그 곳의 주소 나타내기
//> 마지막으로 입력한 주소값과 그 직전의 주소값 사이에 선 그리기
//  (가장 처음 입력한 주소는 그것과 연결할 직전의 주소값이 없으므로 제외)
//참고: delegate 메서드 중 regionDidChangeAnimated 메서드 참고

import UIKit
import MapKit

class ViewController: UIViewController {

    
    private let mapView = MKMapView()
    private var lastCoordinate: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    private var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        setupNavigation()
        setupUI()
    }
    
    private func setupNavigation() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        // 서치뷰컨트롤러의 서치바에 델리게이트에 self를 넣어준다 (검색버튼을 누른 시점을 잡기위함)
        
        navigationItem.searchController = searchController
        // 네비게이션 아이템에 서치컨트롤러를 넣어줌
    }
    
    private func setupUI() {
        let guide = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
    }
    
    func geocodeAddressString(_ addressString: String) {
        
        let geocode = CLGeocoder()
        // CLGeocoder -> 좌표와 사용자 친화적인 표현의 상호 변환을 위한 클래스임
        
        // 받은 스트링을 위도, 경도로 바꿔줌
        geocode.geocodeAddressString(addressString, completionHandler: { (placeMark, error)
            //문자열 주소를 첫번째 매개변수로 받고
            // completionHandler 는 CLGeocodeCompletionHandler 타입이 들어오는데
            // 이는 ([CLPlacemark]?, Error?) -> Void 타입의 클로져 이다
            // 함수 내부적으로 받은 스트링을 처리한 후 [CPlacemark] 타입 또는 error타입을 매개인자로 넣어 호출한다
            
            in
            if error != nil {
                print(error!.localizedDescription)
                return
                
            }
            guard let place = placeMark?.first else { return }
            print(place)
            
            self.setRegion(place: place)
            // 주소를 CLplacemark타입으로 변경한 것을 setRegion() 함수의 매개인자로 넣어 호출
            
        })
        
        
    }
    
    private func setRegion (place: CLPlacemark) {
        //매개 인자로 받아온 CLPlacemar 타입의 coordinate(좌표값)를 뽑아서
        // 해당 좌표로 맵뷰를 이동시킨다
        guard let coordinate = place.location?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        // 델타값을 사용해서 맵의 확대 정도를 지정한다
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        // 매개인자로 들어간 좌표를 중심값으로 잡고 위에서 지정한 span의 값으로 지도의 확대 정도를 정한다
        
        mapView.setRegion(region, animated: true)
        //위에서 만들어준 MKCoordinateRegion타임의 region을 매개인자로 넣어준다 mapView의 setRegion() 함수를 호출
        
        addAnnotation(place: place)
        // Annotation(핑) 찍는 함수 호출
        
    }
    
    private func addAnnotation (place: CLPlacemark) {
        guard let coordinate = place.location?.coordinate else { return }
        let currentPoint = MKPointAnnotation()
        //Anotation 객체를 만들어준다
        
        currentPoint.title = place.name
        currentPoint.subtitle = "point: \(count)"
        count += 1
        currentPoint.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        // Anotation의 title,subtitle,coordinate등을 세팅 해준다
        
        mapView.addAnnotation(currentPoint)
        //mapView의 addAnnotation을 호출 (매개인자는 위에 만들어 놓은 MKPointAnnotation 객체)
        
        drawQuadrangle(currentCoordinate: coordinate)
        //draw
        drawLine(currentCoordinate: coordinate)
        
    }
    
    private func drawQuadrangle (currentCoordinate: CLLocationCoordinate2D) {
        let center = currentCoordinate
        
        var point1 = center; point1.latitude += 0.02; point1.longitude -= 0.02
        var point2 = center; point2.latitude += 0.02; point2.longitude += 0.02
        var point3 = center; point3.latitude -= 0.02; point3.longitude -= 0.02
        var point4 = center; point4.latitude -= 0.02; point4.longitude += 0.02
        
        let points: [CLLocationCoordinate2D] = [point1, point2, point4, point3, point1]
        let polyLine = MKPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(polyLine)
        
    }
    
    private func drawLine (currentCoordinate: CLLocationCoordinate2D) {
        guard let lastPoint = lastCoordinate else {
            lastCoordinate = currentCoordinate
            return
        }
        print("drawLine()")
        let points = [lastPoint, currentCoordinate]
        let polyLine = MKPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(polyLine)
        lastCoordinate = currentCoordinate
        
    }
    
    


}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        print(searchText)
        geocodeAddressString(searchText)
        // 검색버튼을 누르면 검색버튼의 텍스트를 geocodeAddressString 함수의 매개변수로 넣어준다
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // 지도에 선 긋는 메서드
        print("addOverlay")
        if let polyLine = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .red
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
        
    }
    
    
}
