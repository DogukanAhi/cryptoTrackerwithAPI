//
//  ViewController.swift
//  cyrptoTracker
//
//  Created by Doğukan Ahi on 26.07.2023.
//

import UIKit




class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CrpytoTableViewCell.self, forCellReuseIdentifier: CrpytoTableViewCell.identifier)
    
        return tableView
    }()
    
    private var viewModels = [CryptoTableViewCellViewModel]()
    
    static let numberFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dodo's Crypto Tracker"
    
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        APICALLER.shared.getAllCyrptoData { [weak self] result in
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap({ model in
                    let price = model.price_usd ?? 0
                    let formatter = ViewController.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    let iconUrl = URL(string: APICALLER.shared.icons.filter({ icon in icon.asset_id == model.asset_id }).first?.url ?? "")
                    
                    
                    
                    return CryptoTableViewCellViewModel(name: model.name ?? "N/A", symbol:  model.asset_id, price: priceString ?? "N/A", iconUrl : iconUrl)
                    
                })
                
                DispatchQueue.main.async {
                    
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
            
            
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CrpytoTableViewCell.identifier, for : indexPath) as? CrpytoTableViewCell
        else {
            fatalError()
            
        }
        
        cell.Configure(with: viewModels[indexPath.row])
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

