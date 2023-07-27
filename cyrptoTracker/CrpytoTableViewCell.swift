//
//  CrpytoTableViewCell.swift
//  cyrptoTracker
//
//  Created by Doğukan Ahi on 26.07.2023.
//

import UIKit

class CryptoTableViewCellViewModel {
    let name : String
    let symbol : String
    let price : String
    let iconUrl : URL?
    var iconData: Data?
    
    init(name : String,symbol : String, price : String,iconUrl : URL?){
        
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}

class CrpytoTableViewCell: UITableViewCell {

    static let identifier = "CrytoTableViewCell"
    
    private let nameLabel : UILabel = {
        
       let label = UILabel()
        
        label.font = .systemFont(ofSize: 20,weight: .medium)
        label.textAlignment = .left
        return label
        
    }()
    private let symbolLabel : UILabel = {
        
       let label = UILabel()
        
        label.font = .systemFont(ofSize: 15,weight: .light)
        
        return label
        
    }()
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        
        
        imageView.contentMode = .scaleAspectFit
        return imageView
        
        
        
    }()
    
    private let priceLabel : UILabel = {
        
       let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 17,weight: .semibold)
        
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height/1.1
        
        iconImageView.frame = CGRect(x: 20, y: (contentView.frame.size.height-size)/2, width: size, height: size)
        
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: 35 + size, y: 0, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        
        symbolLabel.frame = CGRect(x: 30 + size, y: contentView.frame.size.height/2, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        
        priceLabel.frame = CGRect(x: contentView.frame.size.height/2, y: 0, width: (contentView.frame.size.width/2)+147, height: contentView.frame.size.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        
        nameLabel.text = nil
        priceLabel.text = nil
        symbolLabel.text = nil
        
        
    }
    
    func Configure(with  viewModel:CryptoTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        symbolLabel.text = viewModel.symbol
        
        if let data = viewModel.iconData {
            iconImageView.image = UIImage(data: data)
            
        }else {
            if let url = viewModel.iconUrl {
                let task = URLSession.shared.dataTask(with: url) { data, urlresponse, error in
                
                    if let data = data {
                        viewModel.iconData = data
                        DispatchQueue.main.async {
                            
                            self.iconImageView.image = UIImage(data: data)
                            
                        }
                    }
                    
                    
                }
                task.resume()
            }
            
        }
    }
    
    
    
    

}
