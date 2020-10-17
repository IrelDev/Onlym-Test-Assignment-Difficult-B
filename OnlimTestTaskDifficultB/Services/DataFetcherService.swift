//
//  DataFetcherService.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 16.10.2020.
//

import Foundation

struct DataFetcherService {
    func fetchDataFromURl<Type: Codable>(url: URL, completion: @escaping (Type?, Data?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard error == nil else { print(debugPrint(error!)); completion(nil, nil); return; }
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            
            let wrappedResponse = try? jsonDecoder.decode(Type.self, from: data)
            
            completion(wrappedResponse, data)
        }
        dataTask.resume()
    }
}
