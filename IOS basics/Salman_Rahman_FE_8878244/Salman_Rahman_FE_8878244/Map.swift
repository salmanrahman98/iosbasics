//
//  Map.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/1/23.
//

import UIKit
import MapKit

class Map: UIViewController, CLLocationManagerDelegate,  MKMapViewDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var modeOfTravel: UILabel!
    var transportMode: MKDirectionsTransportType = .automobile
    
    
    //location Manager
    var locationManager = CLLocationManager()
    var startingLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    
    var textFromPopup = ""
    var originated_from = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var startCityName = ""
    var placemark: CLPlacemark?
    var startLocation: CLLocation?
    
    var totalDistanceInMeters: CLLocationDistance = 0.0
    var destCity = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //request location services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Set up map view
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        slider.minimumValue = 0.1
        slider.maximumValue = 2.0
        slider.value = 1.0
        slider.addTarget(self, action: #selector(sliderSwiped(_:)), for: .valueChanged)
        
        //Checking if there is data in textFromPopup. If there is then,  that will be our destination.
        if(textFromPopup.isEmpty){
            originated_from = "From Map"
        }else{
            self.getCoordinateForCity(textFromPopup)
            originated_from = "From Home"
        }
    }
    
    
    @IBAction func changeDestination(_ sender: Any) {
        destinationChangeAlert()
    }
    
    //function called when new locations are available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        getCityNameFromCoordinates(startLoc: locations[0])

        if startingLocation == nil {
            startingLocation = location
            startLocationPin()
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)

        
        // Defining the map region
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: coordinates, span: span)

        // Setting the region on the map
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
    
    

    //pin added for start location on the map
    func startLocationPin(){
        guard let startingLocation = startingLocation else{return}
        let annotation = MKPointAnnotation()
        annotation.coordinate = startingLocation
        annotation.title = "Starting Origin"
        mapView.addAnnotation(annotation)
    }

    
    //pin for destination on the map
    func DestinationPin(){
        guard let destinationLocation = destinationLocation else{return}
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationLocation
        annotation.title = "Final Destination"
        mapView.addAnnotation(annotation)
    }
    
    //rendering overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5.0
            return renderer
        }
    
    
    //function called when slider value changed
    @objc func sliderSwiped(_ sender: UISlider) {
        let value = sender.value

        let currentRegion = mapView.region
        let latitudeChange = currentRegion.span.latitudeDelta / Double(value)
        let longitudeChange = currentRegion.span.longitudeDelta / Double(value)

        let regionChange = MKCoordinateRegion(
            center: currentRegion.center,
            span: MKCoordinateSpan(
                latitudeDelta: latitudeChange,
                longitudeDelta: longitudeChange
            )
        )
        mapView.setRegion(regionChange, animated: true)
    }
    
    @IBAction func carButton(_ sender: Any) {
        modeOfTravel.text = "Car"
        transportMode = .automobile
        displayRoute(destinationCityName: destCity)
    }
    
    @IBAction func cycle(_ sender: Any) {
        modeOfTravel.text = "Cycle"
        transportMode = .walking
        displayRoute(destinationCityName: destCity)
    }
    
    
    @IBAction func walk(_ sender: Any) {
        modeOfTravel.text = "Walk"
        transportMode = .walking
        displayRoute(destinationCityName: destCity)
    }
        
    
      //getting co-ordinate for the input city
    func getCoordinateForCity(_ city: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first, let location = placemark.location?.coordinate {
                self?.destinationLocation = location
                self?.DestinationPin()
                self?.displayRoute(destinationCityName: city)
                self?.destCity = city
            } else {
                self?.showAlert(message: "Could not find the given destination.")
            }
        }
    }

    
     //alert for destination change
    func destinationChangeAlert(){
        let alertController = UIAlertController(title: "Change Destination", message: "Enter the Destination city", preferredStyle: .alert)
        alertController.addTextField{ textField in textField.placeholder = "End Point"}
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

               let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                   if let destinationCity = alertController.textFields?.first?.text {
                       self?.getCoordinateForCity(destinationCity)
                   }
               }
        alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
    }
    
    
    //updating map region
    func updateMapRegion() {
        guard let startingLocation = startingLocation else { return }
        let region = MKCoordinateRegion(center: startingLocation, latitudinalMeters: 600, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    
    //display rpute on the map
    func displayRoute(destinationCityName : String) {
           guard let startingLocation = startingLocation, let destinationLocation = destinationLocation else { return }

            
            print("Starting - \(startCityName)")
            print(destinationCityName)
           // Remove previous destination annotation
           if let previousDestinationAnnotation = mapView.annotations.first(where: { $0.title == "Destination" }) {
               mapView.removeAnnotation(previousDestinationAnnotation)
               
           }

           // Remove previous overlays
           mapView.removeOverlays(mapView.overlays)

           let request = MKDirections.Request()
           request.source = MKMapItem(placemark: MKPlacemark(coordinate: startingLocation))
           request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
           request.transportType = transportMode
           

           let directions = MKDirections(request: request)
           directions.calculate { [weak self] (response, error) in
               guard let route = response?.routes.first else {
                   self?.showAlert(message: "Could not calculate the route. Please try again.")
                   return
               }

               // Add destination annotation
               let destinationAnnotation = MKPointAnnotation()
               destinationAnnotation.coordinate = destinationLocation
               destinationAnnotation.title = "Destination"
               self?.mapView.addAnnotation(destinationAnnotation)

               self?.mapView.addOverlay(route.polyline, level: .aboveRoads)

               // Adjust the map's region to show the complete route
               self?.mapView.showAnnotations(self?.mapView.annotations ?? [], animated: true)
               
               var dist = ""
               if let startLocation = self?.startLocation {
                   let destlocation = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)

                   let distance = startLocation.distance(from: destlocation)
                   self?.totalDistanceInMeters += distance
                   dist = "\((self?.totalDistanceInMeters ?? 0) / 1000) kms"
//                   distanceValue.text = "\(totalDistanceInMeters / 1000) kms"
//                   distanceValue.text = "\(String(format: "%.2f", totalDistanceInMeters / 1000)) Kms"
               }
               
               self?.createMapItem(startCity: self!.startCityName, endCity: destinationCityName, distanceTravelled: dist)
           }
        
       }
    
    func getCityNameFromCoordinates(startLoc : CLLocation){
        //fetching city name, have referenced from -
        //https://stackoverflow.com/questions/44031257/find-city-name-and-country-from-latitude-and-longitude-in-swift
        CLGeocoder().reverseGeocodeLocation(startLoc, completionHandler: { (placemarks, error) in
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            self.parsePlacemarks(location: startLoc)
       })
    }
    
    func parsePlacemarks(location : CLLocation) {
        var myCity = ""
        var myCountryCode = ""
        if let placemark = placemark {
            if let city = placemark.locality, !city.isEmpty {
                print(city)
                myCity = city
            }
            if let countryCode = placemark.isoCountryCode, !countryCode.isEmpty {
                print(countryCode)
                myCountryCode = countryCode
            }
        }
        
        startCityName = myCity
        if(myCity.isEmpty == false){
            locationManager.stopUpdatingLocation()  //stop updating location once got the name of city
        }
    }
    
    func createMapItem(startCity : String, endCity : String, distanceTravelled : String){
        let mapsItem = MapsEntity(context: context)
        mapsItem.startPoint = startCity
        mapsItem.endPoint = endCity
        mapsItem.modeOfTravel = "\(modeOfTravel.text ?? "")"
        mapsItem.distanceTravelled = distanceTravelled
        mapsItem.originatedFrom = originated_from
        let historyUUId = UUID()
        mapsItem.historyId = historyUUId
        mapsItem.id = UUID()
        
        let historyItem = HistoryEntity(context: context)
        historyItem.id = historyUUId
        historyItem.type = "maps"
        do {
            try context.save()
        } catch{
            //Error
            print(error)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
