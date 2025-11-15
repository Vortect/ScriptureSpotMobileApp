import SwiftUI

struct VerseActionsBar: View {
    var onBookmark: () -> Void
    var onShare: () -> Void
    var onCopy: () -> Void
    var onFullChapter: () -> Void
    var isBookmarked: Bool

    var body: some View {
        HStack(spacing: 12) {
            IconActionButton(icon: .bookmark, label: "Save", action: onBookmark, isActive: isBookmarked)
            IconActionButton(icon: .share, label: "Share", action: onShare)
            IconActionButton(icon: .copy, label: "Copy", action: onCopy)
            IconActionButton(icon: .book, label: "Chapter", action: onFullChapter)
        }
    }
}
