//
//
//

import FoundationModels
import Foundation

@available(iOS 18.1, *)
class FincaSpeechParser {

    private let session: LanguageModelSession

    init() {
        let instructions = """
        You extract structured data for a coffee farm registration form.

        ALWAYS respond ONLY in valid JSON with these keys:
        {
          "finca": "",
          "hectareas": "",
          "altitud": "",
          "variedades": "",
          "especies": "",
          "sombra": "",
          "arboles": ""
        }

        Field explanations:
        - finca: Name of the farm/ranch. ALWAYS capitalize the first letter of each word (e.g., "Amanecer De La Sierra")
        - hectareas: Size of the farm in hectares (number only, e.g., "15.5")
        - altitud: Altitude in meters above sea level (number only, e.g., "1500")
        - variedades: Coffee varieties cultivated. ALWAYS capitalize first letter of each variety. Comma-separated if multiple (e.g., "Typica, Bourbon, Caturra")
        - especies: Tree species for shade. ALWAYS capitalize first letter. Comma-separated if multiple (e.g., "Inga Spp., Cedro Rojo, Plátano")
        - sombra: Natural shade percentage (number only 0-100, e.g., "65")
        - arboles: Number of trees older than 8 years (number only, e.g., "75")

        IMPORTANT RULES:
        - ALWAYS capitalize the first letter of names and proper nouns
        - Return only numbers for numeric fields (no units like "msnm", "%", "hectáreas")
        - ONLY extract information that is explicitly mentioned in the user's input
        - If a field is NOT mentioned by the user, leave it empty ("")
        - Do NOT make up, infer, or hallucinate any data
        - Do NOT include any markdown formatting, code blocks, or explanatory text
        - Return ONLY the raw JSON object
        """

        self.session = LanguageModelSession(instructions: instructions)
    }

    func parseSpeech(_ text: String) async throws -> [String: String] {
        guard !text.isEmpty else {
            print("Empty transcript provided")
            return [:]
        }

        let prompt = """
        User said:

        "\(text)"

        Extract ONLY the information explicitly mentioned above into the JSON format. Leave all other fields empty.
        """

        let response = try await session.respond(
            to: prompt,
            options: GenerationOptions(temperature: 0.2)
        )

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

    private func extractJSON(from text: String) -> String {
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleaned.hasPrefix("```") {
            cleaned = cleaned.replacingOccurrences(of: "```json", with: "")
                             .replacingOccurrences(of: "```", with: "")
                             .trimmingCharacters(in: .whitespacesAndNewlines)
        }

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
