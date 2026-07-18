import SwiftUI

class ItineraryStore: ObservableObject {
    @Published var activeItinerary: Itinerary? = nil
    @Published var history: [Itinerary] = MockData.sampleHistory
    @Published var currentStopIndex: Int = 0
    
    var hasActiveItinerary: Bool {
        activeItinerary != nil
    }
    
    func finalize(timeline: [TimelineBlock], title: String = "My Itinerary") {
        let itinerary = Itinerary(
            title: title,
            date: Date(),
            timeline: timeline,
            isFinalized: true
        )
        activeItinerary = itinerary
        currentStopIndex = 0
    }
    
    func saveToHistory() {
        if let active = activeItinerary {
            history.insert(active, at: 0)
        }
    }
    
    func clearActive() {
        if let active = activeItinerary {
            // Save to history before clearing
            if !history.contains(where: { $0.id == active.id }) {
                history.insert(active, at: 0)
            }
        }
        activeItinerary = nil
        currentStopIndex = 0
    }
    
    func advanceStop() {
        if let active = activeItinerary, currentStopIndex < active.timeline.count - 1 {
            currentStopIndex += 1
        }
    }
}
