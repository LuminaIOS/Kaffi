//
//
//

import FoundationModels
import Foundation

@available(iOS 18.1, *)
class ProduccionSpeechParser {

    private let session: LanguageModelSession

    init() {
        let instructions = """
        You extract structured data for a coffee production practices registration form.

        ALWAYS respond ONLY in valid JSON with these keys:
        {
          "manejoSuelo": "",
          "controlPlagas": "",
          "riego": "",
          "certificaciones": ""
        }

        Field explanations:
        - manejoSuelo: Soil management practices. ALWAYS capitalize first letter of each practice. Comma-separated if multiple (e.g., "Compostaje, Cobertura Vegetal, Rotación De Cultivos")
        - controlPlagas: Pest control methods. ALWAYS capitalize first letter of each method. Comma-separated if multiple (e.g., "Control Biológico, Trampas, Manejo Integrado")
        - riego: Irrigation system description. ALWAYS capitalize first letter (e.g., "Por Goteo", "Riego Natural", "No Usa Riego")
        - certificaciones: Certifications. ALWAYS capitalize properly. Comma-separated if multiple (e.g., "USDA Organic, Fairtrade, Rainforest Alliance")

        IMPORTANT RULES:
        - ALWAYS capitalize the first letter of each practice, method, or certification name
        - For fields with multiple items, provide comma-separated values with spaces after commas
        - Maintain proper capitalization for acronyms (USDA, SPR, etc.)
        - If a field is missing, leave it empty ("")
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

        Extract all possible values into the JSON format.
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
