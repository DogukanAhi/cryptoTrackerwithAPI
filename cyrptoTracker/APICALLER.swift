//
//  APICALLER.swift
//  cyrptoTracker
//
//  Created by Doğukan Ahi on 26.07.2023.
//

import Foundation

final class APICALLER {
    static let shared = APICALLER()
    
    private struct Constants {
        
        static let apiKey = "F5F0F2BF-32DB-4DDA-A876-18E1FAAC6B96"
        static let assetsEndPoint = "https://rest.coinapi.io/v1/assets/"
    }
    
    
    
    private init() {
        
    }
    
    private var whenReadyBlock: ((Result<[Crypto],Error>) -> Void)?
    
    
    public var icons: [Icon] = []
    
    public func getAllCyrptoData(competion : @escaping (Result<[Crypto],Error>) -> Void) {
        
        guard !icons.isEmpty else {
            whenReadyBlock = competion
            
            return
        }
        
        
        guard let url = URL(string: Constants.assetsEndPoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let  data = data, error  == nil else {
                
                return
            }
            do {
                
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
               
                competion(.success( cryptos.sorted { first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                    }))
                
            }catch {
                competion(.failure(error))
            }
            
        }
        task.resume()
    }
    public func getAllIcons(){
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=F5F0F2BF-32DB-4DDA-A876-18E1FAAC6B96")
        else {
            return
            
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let  data = data, error  == nil else {
                
                return
            }
            do {
                
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                
                if let completion = self?.whenReadyBlock {
                    self?.getAllCyrptoData(competion: completion)
                }
               
                
                
            }catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
}
