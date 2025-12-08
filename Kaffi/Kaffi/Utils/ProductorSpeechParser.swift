//
//
//

import FoundationModels
import Foundation

@available(iOS 18.1, *)
class ProductorSpeechParser {

    private let session: LanguageModelSession

    init() {
        let instructions = """
        You extract structured data for a coffee producer registration form.

        ALWAYS respond ONLY in valid JSON with these keys:
        {
          "nombre": "",
          "edad": "",
          "genero": "",
          "generacion": "",
          "ubicacion": "",
          "comunidad": "",
          "latitud": "",
          "longitud": "",
          "testimonio": ""
        }

        Field explanations:
        - nombre: Full name of the producer. ALWAYS capitalize first letter of each name (e.g., "Doña María De Los Ángeles Gómez")
        - edad: Age in years (number only, e.g., "56")
        - genero: Gender. ALWAYS capitalize (e.g., "Femenino", "Masculino", "Otro")
        - generacion: Coffee farming generation. ALWAYS start with capital letter (e.g., "3ra Generación De Caficultores")
        - ubicacion: Full location/address. ALWAYS capitalize place names (e.g., "Ejido El Zapotal, Motozintla, Chiapas, México")
        - comunidad: Community description. ALWAYS capitalize first letter (e.g., "Plan De La Libertad (Baja), Productora Indígena")
        - latitud: Latitude coordinate (number only, e.g., "15.3631")
        - longitud: Longitude coordinate (number only, negative for west e.g., "-92.2515")
        - testimonio: Producer's testimony/story. ALWAYS capitalize first letter of the sentence (descriptive paragraph)

        IMPORTANT RULES:
        - ALWAYS capitalize the first letter of names, places, and proper nouns
        - Return only numbers for numeric fields (edad, latitud, longitud)
        - For testimonio, write full sentences with proper capitalization and punctuation
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
