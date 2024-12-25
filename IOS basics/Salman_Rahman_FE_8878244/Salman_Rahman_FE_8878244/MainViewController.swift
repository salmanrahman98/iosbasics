//
//  ViewController.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/1/23.
//

import UIKit

class MainViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //opens popup which allows to move to another screen by entering city name
    @IBAction func discover(_ sender: Any) {
        let alertDialog = UIAlertController(title: "Add New Item",
                                            message: "Enter new item",
                                            preferredStyle: UIAlertController.Style.alert)
        
        
        alertDialog.addTextField(configurationHandler: nil)
        alertDialog.addAction(UIAlertAction(title: "News", style: .default, handler: { [weak self] _ in
            guard let field = alertDialog.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            
            if let newsVC = self?.storyboard?.instantiateViewController(withIdentifier: "News") as? News {
                newsVC.dataPopup = text
                self?.navigationController?.pushViewController(newsVC, animated: true)
            }
            
        }))
        
        alertDialog.addAction(UIAlertAction(title: "Directions", style: .default, handler: { [weak self] _ in
            guard let field = alertDialog.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            
            if let mapsVC = self?.storyboard?.instantiateViewController(withIdentifier: "Maps") as? Map {
                mapsVC.textFromPopup = text
                self?.navigationController?.pushViewController(mapsVC, animated: true)
            }
            
        }))
        
        alertDialog.addAction(UIAlertAction(title: "Weather", style: .default, handler: { [weak self] _ in
            guard let field = alertDialog.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            
            if let weatherVC = self?.storyboard?.instantiateViewController(withIdentifier: "Weather") as? Weather {
                weatherVC.textFromPopup = text
                self?.navigationController?.pushViewController(weatherVC, animated: true)
            }
            
        }))
        alertDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { (action: UIAlertAction!) in
            
        }))
    
        present(alertDialog,animated: true)
    }
    
    
    @IBAction func news(_ sender: Any) {
        
    }
    
}

