import SwiftUI

struct ItineraryHistoryScreen: View {
    @EnvironmentObject var itineraryStore: ItineraryStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                if itineraryStore.history.isEmpty {
                    emptyState
                } else {
                    historyList
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primary)
                }
            }
        }
    }
    
    private var historyList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(itineraryStore.history) { itinerary in
                    historyRow(itinerary)
                }
            }
            .padding(Theme.paddingM)
        }
    }
    
    private func historyRow(_ itinerary: Itinerary) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(itinerary.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(itinerary.date.formatted(.dateTime.weekday(.wide).month().day().year()))
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Text("\(itinerary.stopCount)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.primary)
                }
            }
            
            // Summary pills
            Text(itinerary.summary)
                .font(.system(size: 13))
                .foregroundColor(Theme.textMuted)
                .lineLimit(1)
            
            // Timeline preview
            HStack(spacing: 8) {
                ForEach(Array(itinerary.timeline.prefix(4).enumerated()), id: \.offset) { _, block in
                    HStack(spacing: 4) {
                        Text(block.icon)
                            .font(.system(size: 12))
                        Text(block.time)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Theme.elevatedSurface)
                    .cornerRadius(8)
                }
                
                if itinerary.timeline.count > 4 {
                    Text("+\(itinerary.timeline.count - 4)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Theme.elevatedSurface)
                        .cornerRadius(8)
                }
            }
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: {
                    itineraryStore.activeItinerary = itinerary
                    dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 13))
                        Text("Reuse")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(Theme.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Theme.primary.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 13))
                        Text("Share")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Theme.elevatedSurface)
                    .cornerRadius(10)
                }
            }
        }
        .padding(Theme.paddingM)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerL)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerL)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 48))
                .foregroundColor(Theme.textMuted)
            
            Text("No Past Itineraries")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Your planned itineraries will appear here")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
        }
    }
}
