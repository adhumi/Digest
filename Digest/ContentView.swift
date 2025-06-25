//
//  ContentView.swift
//  Digest
//
//  Created by Adrien Humilière on 25/06/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    private var model = SystemLanguageModel.default
    private let digestService = DigestService()
    
    @State private var articles: [Article] = []
    
    var body: some View {
        switch model.availability {
            case .available:
                articlesListView()
                    .task {
                        self.articles = try! await digestService.generateDigest(topics: ["trail running", "société", "politique internationale"], count: 5, startDate: Date(timeIntervalSinceNow: -60*60*24*15))
                    }
            case .unavailable(.deviceNotEligible):
                Text("Device not eligible for Apple Intelligence.")
            case .unavailable(.appleIntelligenceNotEnabled):
                Text("Please activate Apple Intelligence in your device settings.")
            case .unavailable(.modelNotReady):
                Text("Model not ready yet. Please try again later.")
            case .unavailable(_):
                Text("An unknown error occured.")
        }
    }
    
    func articlesListView() -> some View {
        List(articles, id: \.url) { article in
            Link(destination: URL(string: article.url)!) {
                VStack(alignment: .leading) {
                    Text(article.topic.uppercased())
                        .font(.footnote)
                        .foregroundStyle(.blue)
                    
                    Text(article.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(article.date.description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    if let domain = article.domain {
                        Text(domain)
                            .font(.footnote)
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer(minLength: 8)
                    
                    Text(article.abstract)
                        .foregroundStyle(.secondary)
                }
            }
            .accentColor(Color(.label))
        }
    }
}

#Preview {
    ContentView()
}
