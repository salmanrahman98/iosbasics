//
//  History.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/1/23.
//

import UIKit
import CoreData

class History: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    var historyItemList = [HistoryEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var historyTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        historyTable.delegate = self
        historyTable.dataSource = self
        fetchAllHistoryItems()
    }
    
    //gives and displays all history items in core data
    func fetchAllHistoryItems(){
        do {
            historyItemList = try context.fetch(HistoryEntity.fetchRequest())
            
            print(historyItemList[0].id ?? "")
            print(historyItemList[0].type ?? "")
            print(historyItemList[0].description ?? "")
            print(historyItemList.count)
            
            let newsEntity = getNewsItem(with: historyItemList[0].id)
            print(newsEntity?.title)
            
            historyItemList = historyItemList.reversed()

            if(historyItemList.count > 0){
                DispatchQueue.main.async {
                    self.historyTable.reloadData()
                }
            }
        } catch{
            //Error
        }
    }
    
    //returns number of items to show in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItemList.count ?? 0
    }
    
    //filling each cell in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(historyItemList[indexPath.row].type == "news"){
            //News cell
            let cell =  tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
            
            let newsEntityModel = getNewsItem(with: historyItemList[indexPath.row].id)
            
            cell.title.text = "\(newsEntityModel?.title ?? "")"
            print("Desc -------\(newsEntityModel?.description ?? "")")
            cell.newsDescription.text = "Description - \(newsEntityModel?.description ?? "")"
            cell.source.text = "Source - \(newsEntityModel!.source ?? "")"
            cell.author.text = "Author - \(newsEntityModel?.author ?? "")"
            cell.city.text = "City - \(newsEntityModel?.searchedCity ?? "")"
            cell.from.text = "From - \(newsEntityModel?.originatedFrom ?? "")"
            
            return cell
        }else if (historyItemList[indexPath.row].type == "weather"){
            //Weather
            let cell =  tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
            
            let weatherEntityModel = getWeatherItem(with: historyItemList[indexPath.row].id)
            
            cell.wind.text = "Wind - \(weatherEntityModel?.wind ?? "")"
            cell.temperature.text = "Temperature - \(weatherEntityModel?.temperature ?? "")"
            cell.city.text = "City - \(weatherEntityModel?.cityName ?? "")"
            cell.humidity.text = "Temperature - \(weatherEntityModel?.humidity ?? "")"
            cell.date.text = "Date - \(weatherEntityModel?.date), Time - \(weatherEntityModel?.time)"
            cell.from.text = "From - \(weatherEntityModel?.originatedFrom ?? "")"
            
            return cell
        } else {
            //Maps
            let cell =  tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell
            
            let mapEntityModel = getMapItem(with: historyItemList[indexPath.row].id)
            
            cell.startPoint.text = "Start Point - \(mapEntityModel?.startPoint ?? "")"
            cell.endPoint.text = "End Point - \(mapEntityModel?.endPoint ?? "")"
            cell.modeOfTravel.text = "Mode of Travel - \(mapEntityModel!.modeOfTravel ?? "")"
            cell.distance.text = "Distance - \(mapEntityModel?.distanceTravelled ?? "")"
            cell.from.text = "From - \(mapEntityModel?.originatedFrom ?? "")"
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //https://stackoverflow.com/a/69082977
    func getNewsItem(with historyId: UUID?) -> NewsEntity? {
        guard let historyId = historyId else { return nil }
        let request = NewsEntity.fetchRequest() as NSFetchRequest<NewsEntity>
        request.predicate = NSPredicate(format: "%K == %@", "historyId", historyId as CVarArg)
        guard let items = try? context.fetch(request) else { return nil }
        return items.first
    }
    
    //https://stackoverflow.com/a/69082977
    func getWeatherItem(with historyId: UUID?) -> WeatherEntity? {
        guard let historyId = historyId else { return nil }
        let request = WeatherEntity.fetchRequest() as NSFetchRequest<WeatherEntity>
        request.predicate = NSPredicate(format: "%K == %@", "historyId", historyId as CVarArg)
        guard let items = try? context.fetch(request) else { return nil }
        return items.first
    }
    
    //https://stackoverflow.com/a/69082977
    func getMapItem(with historyId: UUID?) -> MapsEntity? {
        guard let historyId = historyId else { return nil }
        let request = MapsEntity.fetchRequest() as NSFetchRequest<MapsEntity>
        request.predicate = NSPredicate(format: "%K == %@", "historyId", historyId as CVarArg)
        guard let items = try? context.fetch(request) else { return nil }
        return items.first
    }
    
    
    //allows to swipe item
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.deleteItem(itemToDelete: historyItemList[indexPath.row])
            historyTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //deleting item
    func deleteItem(itemToDelete : HistoryEntity){
        context.delete(itemToDelete)
        
        do {
            try context.save()
            fetchAllHistoryItems()
        } catch{
            //Error
        }
    }

}
