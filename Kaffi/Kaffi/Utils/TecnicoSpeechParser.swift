//
//
//

import FoundationModels
import Foundation

@available(iOS 18.1, *)
class TecnicoSpeechParser {

    private let session: LanguageModelSession

    init() {
        let instructions = """
        You extract structured data for a technician visit registration form.

        ALWAYS respond ONLY in valid JSON with these keys:
        {
          "tecnico": "",
          "cargo": "",
          "visita": "",
          "fechaLevantamiento": "",
          "resultado": ""
        }

        Field explanations:
        - tecnico: Name of the technician responsible for the visit. ALWAYS capitalize first letter of each name (e.g., "Eduardo Gómez Morín")
        - cargo: Job title/position. ALWAYS capitalize first letter (e.g., "Técnico De Campo", "Inspector Orgánico")
        - visita: Type of visit. ALWAYS capitalize first letter (e.g., "Inspección Interna Orgánica", "Visita De Seguimiento")
        - fechaLevantamiento: Date of data collection in format "dd/MM/yyyy" (e.g., "15/11/2024"). Convert natural language dates to this format ("hoy" → today's date, "ayer" → yesterday)
        - resultado: Internal control results. ALWAYS capitalize first letter. Write full sentences with proper punctuation (descriptive paragraph, e.g., "Cumple requisitos orgánicos. Se observó...")

        IMPORTANT RULES:
        - ALWAYS capitalize the first letter of names, job titles, and proper nouns
        - For fechaLevantamiento, use format dd/MM/yyyy
        - For resultado, write complete sentences with proper capitalization and punctuation
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
