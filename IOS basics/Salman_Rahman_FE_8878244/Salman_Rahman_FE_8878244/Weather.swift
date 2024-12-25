//
//  Weather.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/1/23.
//

import UIKit
import CoreLocation

class Weather: UIViewController, CLLocationManagerDelegate {
    
    //Main screen outlets
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var message: UILabel!
    
    //Used variables and constants
    let locationManager = CLLocationManager()
    var city = ""
    var placemark: CLPlacemark?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textFromPopup = ""
    var isFromHome = false
    var from = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(textFromPopup.isEmpty){
            isFromHome = true
            from = "Home"
        }else{
            isFromHome = false
            from = "Weather"
            locationManager.stopUpdatingLocation()
            getWeatherDataFromApi(city: textFromPopup, countryCode: "CA")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   //Takes up accuracy
        locationManager.requestWhenInUseAuthorization()     //permission popup
        if(isFromHome == true){
            locationManager.startUpdatingLocation()     //starts taking up location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        manager.startUpdatingLocation()
        render(location[0])
    }
    
    //to get weather from city Name. NOTE - only Canada cities can be entered
    @IBAction func getWeather(_ sender: Any) {
        getWeatherDataFromApi(city: cityNameField?.text ?? "", countryCode: "CA")
    }
    
    //to get weather data from location, just start updating the location. We will stop updating once city Name and country code is acquired
    @IBAction func fetchLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    func render (_ location: CLLocation) {
        print("Lat - \(location.coordinate.latitude)")
        print("Long - \(location.coordinate.longitude)")
        
        //fetching city name, have referenced from -
        //https://stackoverflow.com/questions/44031257/find-city-name-and-country-from-latitude-and-longitude-in-swift
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            self.parsePlacemarks(location: location)
       })
    }
    
    
    // placemarks for city
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
        
        
        getWeatherDataFromApi(city: myCity,countryCode: myCountryCode)
        if(myCity.isEmpty == false){
            locationManager.stopUpdatingLocation()  //stop updating location once got the name of city
        }
    }
    
    //alert for 
    @IBAction func addBtnCity(_ sender: Any) {
        let alertDialog = UIAlertController(title: "Enter city Name",
                                            message: "Enter city in Canada",
                                            preferredStyle: UIAlertController.Style.alert)
        
        
        alertDialog.addTextField(configurationHandler: nil)
        alertDialog.addAction(UIAlertAction(title: "City", style: .default, handler: { [weak self] _ in
            guard let field = alertDialog.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            
            self?.getWeatherDataFromApi(city: text ?? "", countryCode: "CA")
            
        }))
        
    
        alertDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { (action: UIAlertAction!) in
            
        }))
    
        present(alertDialog,animated: true)
    }
    
    //Fetches Weather data from API by open weather
    //Uses city name and country code to fetch data
    func getWeatherDataFromApi(city: String, countryCode: String){
        print("City name - \(city)")
        print("CCode - \(countryCode)")
        
        let apiKey = "10827f4801f9e3c385e25e39508e4e3a"
        let apiUrlString : String = "https://api.openweathermap.org/data/2.5/weather?q=\(city),\(countryCode)&appid=\(apiKey)"
        print(apiUrlString)
        
        let urlSession = URLSession(configuration: .default)
        
        let url = URL(string: apiUrlString)
        
        if let url = url {
            let dataTask = urlSession.dataTask(with: url) {(data, response, error) in
                
                if let data = data {
                    print(data)
                    let jsonDecoder = JSONDecoder()
                    
                    do {
                        //converting received json into the model, to read the data
                        let weatherData = try jsonDecoder.decode(WeatherModel.self, from: data)
                        
                        //can not update UI here, as API calling is not done in main thread
                        //start main thread and update UI
                        DispatchQueue.main.async {
                            self.displayData(data:weatherData)
                        }
                    }
                    catch {
                        print("Can't Decode")
                        DispatchQueue.main.async {
                            self.message.text = "Error"
                        }
                    }
                }
            }
            dataTask.resume()
            dataTask.response
        }
    }
    
    //displaying data in screen
    func displayData(data : WeatherModel){
        //200 means api was a success and have received data
        if(data.cod == 200) {
            message.text = ""
            cityName.text = data.name
            weatherDescription.text = data.weather[0].description
            humidity.text = "Humidity: \(data.main.humidity)%"
            temperature.text = "\(String(format: "%.2f", data.main.temp - 273.15))°"    //Received temperature is in Kelvin unit, convert to cesius by subtracting -273.15
            wind.text = "Wind: \(data.wind.speed * 3.6) km/h"   //received wind speed is in m/s, to convert to km/h, multiply by 3.6
            
            //fetching image from openweather url link and passing the icon id which was received in api
            if let url = URL(string: "https://openweathermap.org/img/wn/\(data.weather[0].icon)@2x.png"),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                weatherImage.image = image
            }
            createWeatherItem(weatherModel: data, city: "")
        } else {
            //not 200 means something went wrong
            message.text = "Error"
        }
    }
    
    func createWeatherItem(weatherModel : WeatherModel, city : String){
        let weatherItem = WeatherEntity(context: context)
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        let timeString = timeFormatter.string(from: Date())
        
        weatherItem.date = "\(dateString ?? "")"
        weatherItem.time = "\(timeString ?? "")"
        weatherItem.cityName = weatherModel.name
        weatherItem.wind = "\(weatherModel.wind.speed)"
        weatherItem.humidity = "\(weatherModel.main.humidity)"
        weatherItem.temperature = "\(weatherModel.main.temp)"
        weatherItem.originatedFrom = from
        let historyUUId = UUID()
        weatherItem.historyId = historyUUId
//        weatherItem.searchedCity = city
        weatherItem.id = UUID()
        
        
        let historyItem = HistoryEntity(context: context)
        historyItem.id = historyUUId
        historyItem.type = "weather"
        do {
            try context.save()
        } catch{
            //Error
        }
    }
}
