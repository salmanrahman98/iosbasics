//
//  News.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/1/23.
//


import UIKit

class News: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var newsTable: UITableView!
    var news : NewsModel?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataPopup = ""
    var originated_from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.delegate = self
        newsTable.dataSource = self
        if(dataPopup.isEmpty){
            originated_from = "News"
            callNewsAPI(city:"Washington");
        } else {
            originated_from = "Home"
            callNewsAPI(city:dataPopup);
        }
    }
    
    //opens popup to enter data
    @IBAction func newsSearchAlert(_ sender: Any) {
        let alertDialog = UIAlertController(title: "Enter new city",
                                            message: "Enter city name",
                                            preferredStyle: UIAlertController.Style.alert)
        
        
        alertDialog.addTextField(configurationHandler: nil)
        alertDialog.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak self] _ in
            guard let field = alertDialog.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            self!.callNewsAPI(city: text)
        }))
        alertDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { (action: UIAlertAction!) in
            
        }))
    
        present(alertDialog,animated: true)
    }
    
    //calling news api by passing city
    func callNewsAPI(city: String){
        print(city)
        let apiKey = "5b1d467811034f7fb5950777a96bae7e"
        let apiUrlString : String = "https://newsapi.org/v2/top-headlines?q=\(city)&pageSize=10&apiKey=\(apiKey)"
        print(apiUrlString)
        
        let urlSession = URLSession(configuration: .default)
        
        let url = URL(string: apiUrlString)
        
        if let url = url {
            let urlSession = URLSession(configuration: .default)
            
            let url = URL(string: apiUrlString)
            
            if let url = url {
                let dataTask = urlSession.dataTask(with: url) {(data, response, error) in
                    
                    if let data = data {
                        print(data)
                        let jsonDecoder = JSONDecoder()
                        
                        do {
                            let newsData = try JSONDecoder().decode(NewsModel.self, from: data)

                            if(newsData.totalResults > 0){
                                DispatchQueue.main.async {
                                    self.news = newsData
                                    //                                self.articles = articles.articles
                                    //                                 print(self.articles)
                                    print(newsData.totalResults)
//                                    print(newsData.articles[0].author)
                                    print(newsData.articles[0].title)
//                                    print(newsData.articles[0].description)
//                                    print(newsData.articles[0].source)
                                    self.createNewsItem(newsModel: newsData, city: city)
                                    self.newsTable.reloadData()
                                }
                            }else{
                                print("Sorry! No data found")
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                dataTask.resume()
                dataTask.response
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(news == nil){
            return 0
        }else {
            return (news?.articles.count ?? 0)
        }
        
    }
    //showing data in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        cell.title.text = self.news?.articles[indexPath.row].title
        cell.newsDescription.text = "Description - \(self.news?.articles[indexPath.row].description ?? "")"
        cell.source.text = "\(self.news!.articles[indexPath.row].source)"
        cell.author.text = "Author - \(self.news?.articles[indexPath.row].author ?? "")"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //adds item to core data
    func createNewsItem(newsModel : NewsModel, city : String){
        let newsItem = NewsEntity(context: context)
//        newItem.item  = itemText
        let newsDesc = "\(newsModel.articles[0].description ?? "")"
        print("newssssasldkfajs \(newsModel.articles[0].description ?? "")")
        newsItem.newsDescription = newsDesc
        print("news Create item - \(newsItem.newsDescription)")
        newsItem.title = newsModel.articles[0].title
        newsItem.author = newsModel.articles[0].author
        newsItem.source = newsModel.articles[0].source.name
        newsItem.originatedFrom = originated_from
        let historyUUId = UUID()
        newsItem.historyId = historyUUId
        newsItem.searchedCity = city
        newsItem.id = UUID()
        
        
        let historyItem = HistoryEntity(context: context)
        historyItem.id = historyUUId
        historyItem.type = "news"
        do {
            try context.save()
        } catch{
            //Error
        }
    }
    
}
