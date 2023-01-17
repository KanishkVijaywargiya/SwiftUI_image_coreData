//
//  HomeView.swift
//  CoreDataBootcamp
//
//  Created by Kanishk Vijaywargiya on 17/01/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var manager: ApiManager
    
    var body: some View {
        List (manager.imageData) { item in
            HStack (alignment: .center) {
                
                VStack (alignment: .leading, spacing: 2) {
                    Text(item.first_name ?? "")
                        .font(.title2.bold())
                    Text(item.last_name ?? "")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                AsyncImage(
                    url: URL(string: item.avatar ?? "")) { image in
                        image
                            .resizable()
                            .frame(width: 56, height: 56)
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32, weight: .bold))
                            .padding(.all, 6)
                    }
            }
        }
//        .onAppear {
//            if networkMonitor.connected {
//                manager.fetchData()
//            } else {
//                manager.fetchDataFromCD()
//            }
//        }
        .refreshable {
            manager.fetchData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared.container.viewContext
        
        HomeView()
            .environmentObject(ApiManager(context: persistenceController))
    }
}
