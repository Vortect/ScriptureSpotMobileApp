import SwiftUI

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
        do {
            return try AttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
}
