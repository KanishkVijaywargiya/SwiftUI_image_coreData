//
//  ApiClient.swift
//  CoreDataBootcamp
//
//  Created by Kanishk Vijaywargiya on 17/01/23.
//

import SwiftUI
import CoreData
import AwesomeNetwork

class ApiManager: ObservableObject {
    @StateObject private var connect = NetworkConnection()
    @Published var imageData: [ImageEntity] = []
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        if connect.connected {
            fetchData()
        } else {
            fetchDataFromCD()
        }
    }
    
    func fetchData() {
        let urlString = "https://random-data-api.com/api/users/random_user?size=3"
        performRequest(urlString: urlString) { data in
            self.parseJSON(data)
            self.fetchDataFromCD()
        }
    }
}

// MARK: for performing api calls
extension ApiManager {
    private func performRequest(urlString: String, completionHandler: @escaping(_ data: Data?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else {
                print("Error downloading data")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }.resume()
    }
    
    private func parseJSON(_ returnedData: Data?) {
        if let data = returnedData {
            guard let decodeData = try? JSONDecoder().decode([ImageData].self, from: data) else { return }
            
            //To replace old data with new data in Core Data, you can first fetch the existing data and then delete it before saving the new data.
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try viewContext.execute(batchDeleteRequest)
            } catch let error {
                print("Error deleting existing data, \(error.localizedDescription) 🔴")
            }
            
            decodeData.forEach { decodedData in
                let imageModel = ImageEntity(context: viewContext)
                
                imageModel.id = Int16(decodedData.id)
                imageModel.first_name = decodedData.first_name
                imageModel.last_name = decodedData.last_name
                imageModel.avatar = decodedData.avatar
                
                DispatchQueue.main.async {
                    do {
                        self.imageData.append(imageModel)
                        try self.viewContext.save()
                    } catch let error {
                        print("Error in storing it to CoreData, \(error.localizedDescription) 🔴")
                    }
                }
            }
        }
    }
}


// MARK: for fetching data from coreData
extension ApiManager {
    func fetchDataFromCD() {
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        DispatchQueue.main.async {
            do {
                self.imageData = try self.viewContext.fetch(request)
            } catch let error {
                print("Error fetching categories. \(error.localizedDescription)🔴")
            }
        }
    }
}
