import SwiftUI
import Foundation

struct HTMLText: View {
    let htmlString: String

    var body: some View {
        if let attributed = attributedString(from: htmlString) {
            Text(attributed)
        } else {
            Text(htmlString)
        }
    }

    private func attributedString(from html: String) -> AttributedString? {
        guard let data = html.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let nsAttributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        return try? AttributedString(nsAttributed)
    }
}
