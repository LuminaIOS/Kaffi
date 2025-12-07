//
//  FincaSpeechParser.swift
//  Kaffi
//
//  Created by osc on 20/11/25.
//

import FoundationModels
import Foundation

@available(iOS 18.1, *)
class FincaSpeechParser {
    
    private let session: LanguageModelSession
    
    init() {
        let instructions = """
        You extract structured data for a coffee farm registration form.

        ALWAYS respond ONLY in valid JSON with these keys and use uppercase when needed.:
        {
          "finca": "",
          "productor": "",
          "estado": "",
          "ciudad": "",
          "latitud": "",
          "longitud": "",
          "hectareas": "",
          "altitud": "",
          "suelo": "",
          "descripcion": ""
        }

        If a field is missing, leave it empty.
        Add any extra information mentioned into "descripcion", use proper grammar and convert it into a more descriptive description.
        Do NOT include any markdown formatting, code blocks, or explanatory text.
        Return ONLY the raw JSON object.
        """
        
        self.session = LanguageModelSession(instructions: instructions)
    }
    
    func parseSpeech(_ text: String) async throws -> [String: String] {
        // Handle empty transcript
        guard !text.isEmpty else {
            print("Empty transcript provided")
            return [:]
        }
        
        let prompt = """
        User said:

        "\(text)"

        Extract all possible values into the JSON format.
        """
        
        let response = try await session.respond(
            to: prompt,
            options: GenerationOptions(temperature: 0.2)
        )
        
        // Extract JSON from response (handles markdown code blocks and extra text)
        let cleanedJSON = extractJSON(from: response.content)
        
        guard let data = cleanedJSON.data(using: .utf8) else {
            throw ParsingError.invalidResponse("Could not convert to data")
        }
        
        do {
            return try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            print("Failed to decode JSON: \(cleanedJSON)")
            throw ParsingError.jsonDecodingFailed(error)
        }
    }
    
    /// Extracts JSON from a string that may contain markdown code blocks or extra text
    private func extractJSON(from text: String) -> String {
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove markdown code blocks (```json ... ```)
        if cleaned.hasPrefix("```") {
            cleaned = cleaned.replacingOccurrences(of: "```json", with: "")
                             .replacingOccurrences(of: "```", with: "")
                             .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Find the first { and last } to extract just the JSON object
        if let firstBrace = cleaned.firstIndex(of: "{"),
           let lastBrace = cleaned.lastIndex(of: "}") {
            cleaned = String(cleaned[firstBrace...lastBrace])
        }
        
        return cleaned
    }
    
    enum ParsingError: LocalizedError {
        case invalidResponse(String)
        case jsonDecodingFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse(let message):
                return "Invalid AI response: \(message)"
            case .jsonDecodingFailed(let error):
                return "JSON decoding failed: \(error.localizedDescription)"
            }
        }
    }
}
