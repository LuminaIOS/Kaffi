//
//
//

import FoundationModels
import Foundation

@available(iOS 18.1, *)
class CosechaSpeechParser {

    private let session: LanguageModelSession

    init() {
        let instructions = """
        You extract structured data for a coffee harvest registration form.

        ALWAYS respond ONLY in valid JSON with these keys:
        {
          "volumen": "",
          "inicioCosecha": "",
          "finCosecha": "",
          "procesamiento": "",
          "fermentacion": "",
          "secado": "",
          "subproductos": "",
          "tratamientoAgua": "",
          "emisiones": "",
          "capturaArboles": "",
          "emisionesNetas": "",
          "aguaBeneficio": "",
          "aguaRiego": "",
          "huellaTotal": "",
          "catacion": "",
          "sensorial": "",
          "empaque": "",
          "nutricional": ""
        }

        Field explanations:
        - volumen: Volume produced. ALWAYS capitalize (e.g., "27 Quintales Pergamino", "1500 Kg Café Verde")
        - inicioCosecha: Harvest start date. ALWAYS capitalize month (e.g., "Noviembre 2024", "Octubre 2024")
        - finCosecha: Harvest end date. ALWAYS capitalize month (e.g., "Febrero 2025", "Enero 2025")
        - procesamiento: Processing method. ALWAYS capitalize first letter (e.g., "Lavado Ecológico", "Natural", "Honey")
        - fermentacion: Fermentation time in hours (number only, e.g., "18", "24")
        - secado: Drying method description. ALWAYS capitalize first letter (e.g., "Camas Africanas Al Sol Durante 12 Días")
        - subproductos: Byproducts usage. ALWAYS capitalize first letter (e.g., "Pulpa Compostada Y Usada Como Fertilizante")
        - tratamientoAgua: Water treatment method. ALWAYS capitalize first letter (e.g., "Filtro Anaeróbico Con Lombricomposta")
        - emisiones: Carbon emissions in kg CO₂e/kg (number only, e.g., "0.94")
        - capturaArboles: Carbon capture by shade trees in kg CO₂e/kg (number only, usually negative, e.g., "-1.08")
        - emisionesNetas: Net carbon emissions in kg CO₂e/kg (number only, can be negative, e.g., "-0.14")
        - aguaBeneficio: Water used in processing in L/kg (number only, e.g., "1.2")
        - aguaRiego: Irrigation water in L/kg (number only, e.g., "0")
        - huellaTotal: Total water footprint. ALWAYS capitalize (e.g., "1.2 L/kg Café Verde")
        - catacion: Cupping score from Q Grader (number only, e.g., "82.25", "85.5")
        - sensorial: Sensory profile description. ALWAYS capitalize first letter of sentence (e.g., "Aromas A Panela Y Jazmín...")
        - empaque: Packaging description. ALWAYS capitalize first letter (e.g., "Bolsa Compostable 250g...")
        - nutricional: Nutritional content per 250g. ALWAYS capitalize first letter (e.g., "Calorías: 2, Azúcares: 0g...")

        CRITICAL ANTI-HALLUCINATION RULES:
        ONLY extract information EXPLICITLY stated by the user
        If a field is NOT mentioned, it MUST be empty ""
        Do NOT infer, assume, guess, or make up ANY data
        Do NOT use example values from these instructions

        Example:
        User: "el volumen es 27 quintales"
        CORRECT: {"volumen": "27 Quintales", "inicioCosecha": "", "finCosecha": "", ...all others empty...}
        WRONG: Filling any field not mentioned by the user

        Formatting rules:
        - ALWAYS capitalize the first letter of descriptive text, methods, and proper nouns
        - Return only numbers for numeric fields (fermentacion, emisiones, capturaArboles, emisionesNetas, aguaBeneficio, aguaRiego, catacion)
        - For descriptive fields, write complete sentences or phrases with proper capitalization
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
        User said: "\(text)"

        Extract ONLY what the user explicitly said. Leave ALL unmentioned fields as empty strings "".
        DO NOT fill in any field that was not directly mentioned.
        """

        let response = try await session.respond(
            to: prompt,
            options: GenerationOptions(temperature: 0.0)
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
