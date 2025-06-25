//
//  DigestService.swift
//  Digest
//
//  Created by Adrien Humilière on 25/06/2025.
//

import Foundation
import FoundationModels

class DigestService {
    func generateDigest(topics: [String], count: Int = 20, startDate: Date, endDate: Date = Date()) async throws -> [Article]{
        let session = LanguageModelSession()
        
        let prompt = """
            Suggest a list of \(count) articles from various sources covering the news for the period between \(startDate.description) and \(endDate.description) on the following topics : \(topics.joined(separator: ", ")).
            
            You have to respect the following rules:
            * Articles must be in \(Locale.current.identifier) locale
            * Articles must be taken from trusted sources and avoid fake news and other kinds of scams
            * Avoid articles from Wikipedia
            * If you can't find the exact date of an Article, do not suggest this article
            * If you can't find the exact URL of an Article, do not suggest this article
            * Only suggest articles important to have a clear overview of the news for the provided time span
            * If there are no important news in this period of a topic, ignore it.
            """
        
        let response = try await session.respond(to: prompt, generating: [Article].self)
        
        print(response.content)
        
        return response.content
    }
}

@Generable(description: "Informations about an article found on the web.")
struct Article {
    @Guide(description: "Title of the article, as found on the webpage")
    let title: String
    
    @Guide(description: "URL of the article, providing a direct link to the content")
    let url: String
    
    @Guide(description: "Date when the article was published, formatted as ISO 8601")
    let date: String
    
    @Guide(description: "An abstract of the content of the article, usually a short summary of 2 to 3 sentences")
    let abstract: String
    
    @Guide(description: "The main topic or subject of the article")
    let topic: String
}

extension Article {
    var domain: String? {
        URL(string: url)?.host
    }
}
