//
//  ViewController.swift
//  RxSwiftIOSAcademy
//
//  Created by Avanade on 12/05/22.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {

    private var tableview: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableview)
        tableview.frame = view.bounds
        bindTableData()
    }

    func bindTableData() {
        // Bind items to the table
        viewModel.items.bind(to: tableview.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
            
        }.disposed(by: bag)
        
        // Bind a model selected handler
        tableview.rx.modelSelected(Product.self).bind { product in
            print(product.title)
            
        }.disposed(by: bag)
        
        // fetch items
        viewModel.fetchItems()
    }

}

