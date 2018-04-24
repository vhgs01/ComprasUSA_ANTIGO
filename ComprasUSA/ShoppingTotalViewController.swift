//
//  ShoppingTotalViewController.swift
//  ComprasUSA
//
//  Created by Fellipe Soares Oliveira on 22/04/2018.
//  Copyright © 2018 Fellipe Soares Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTotalViewController: UIViewController {

    var dataSource: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        //Fazer cálculo com a soma dos produtos de cada estado
        
    }
    
    // MARK: - Methods
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

}
