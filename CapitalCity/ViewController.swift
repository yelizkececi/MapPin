//
//  ViewController.swift
//  CapitalCity
//
//  Created by Yeliz Keçeci on 21.01.2021.
//
import MapKit
import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let localData = self.readLocalFile(forName: "cities") {
            self.getCountries(jsonData: localData)
            let annotations = cities.map { city -> MKAnnotation in
                let annotation = MKPointAnnotation()
                annotation.title = city.title
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(city.latitude) ?? 0.0, longitude: Double(city.longitude) ?? 0.0)
                annotation.subtitle = city.info
                return annotation
            }
            mapView.addAnnotations(annotations)
        }
    }
    
    private func getCountries(jsonData: Data){
        do {
            cities = try JSONDecoder().decode([City].self, from: jsonData)
        } catch (let error) {
            print("decode error \(error)")
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: "cities", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch (let error) {
            print(error)
        }
        
        return nil
    }
}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Province"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let viewAnno = view.annotation
        let placeName = viewAnno?.title
        let placeInfo = viewAnno?.subtitle

        alert(title: placeName! ?? "", info: placeInfo! ?? "")
    }
    
    func alert(title: String, info: String){
        let ac = UIAlertController(title: title, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
   
}
