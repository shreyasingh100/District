import SwiftUI
import MapKit

struct PlannerTabScreen: View {
    @EnvironmentObject var itineraryStore: ItineraryStore
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                if itineraryStore.hasActiveItinerary {
                    activeItineraryView
                } else {
                    plannerHomeView
                }
            }
            .navigationTitle(itineraryStore.hasActiveItinerary ? "Live Itinerary" : "Plan Your Day")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        if itineraryStore.hasActiveItinerary {
                            Button(action: {
                                withAnimation { itineraryStore.clearActive() }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        
                        Button(action: { showHistory = true }) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 18))
                                .foregroundColor(Theme.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                ItineraryHistoryScreen()
                    .environmentObject(itineraryStore)
            }
        }
    }
    
    // MARK: - Planner Home (No Active Itinerary)
    
    private var plannerHomeView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.paddingL) {
                
                // Option 1: I Have an Idea
                NavigationLink(destination: UploadFlowScreen()) {
                    optionCard(
                        icon: "lightbulb.fill",
                        iconColor: Color.orange,
                        title: "I Have an Idea",
                        description: "Already have a plan? Upload an image, PDF, or paste text and let AI organize it into a perfect itinerary.",
                        actionText: "Upload or Paste",
                        actionIcon: "arrow.up.doc.fill",
                        gradient: [
                            Color(red: 60/255, green: 40/255, blue: 20/255),
                            Theme.cardBackground
                        ],
                        borderColor: Color.orange.opacity(0.3)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Divider with "or"
                HStack {
                    Rectangle()
                        .fill(Theme.elevatedSurface)
                        .frame(height: 1)
                    
                    Text("or")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textMuted)
                        .padding(.horizontal, 12)
                    
                    Rectangle()
                        .fill(Theme.elevatedSurface)
                        .frame(height: 1)
                }
                .padding(.horizontal, Theme.paddingL)
                
                // Option 2: Surprise Me
                NavigationLink(destination: ChatFlowScreen()) {
                    optionCard(
                        icon: "wand.and.stars",
                        iconColor: Theme.primary,
                        title: "Surprise Me",
                        description: "Answer a few quick questions and AI will build your perfect day from scratch. No planning needed!",
                        actionText: "Let's Go",
                        actionIcon: "sparkles",
                        gradient: [
                            Color(red: 30/255, green: 20/255, blue: 60/255),
                            Theme.cardBackground
                        ],
                        borderColor: Theme.primary.opacity(0.3)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Recent / quick stats
                if !itineraryStore.history.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Plans")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                            Button(action: { showHistory = true }) {
                                Text("See All")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.primary)
                            }
                        }
                        
                        ForEach(Array(itineraryStore.history.prefix(2))) { itinerary in
                            recentPlanRow(itinerary)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, Theme.paddingM)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: - Option Card
    
    private func optionCard(
        icon: String,
        iconColor: Color,
        title: String,
        description: String,
        actionText: String,
        actionIcon: String,
        gradient: [Color],
        borderColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.textMuted)
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(4)
            
            HStack(spacing: 8) {
                Image(systemName: actionIcon)
                    .font(.system(size: 14))
                Text(actionText)
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(iconColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(iconColor.opacity(0.12))
            .cornerRadius(Theme.cornerS)
        }
        .padding(20)
        .background(
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(Theme.cornerL)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerL)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Recent Plan Row
    
    private func recentPlanRow(_ itinerary: Itinerary) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "map.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Theme.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(itinerary.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text("\(itinerary.stopCount) stops • \(itinerary.date.formatted(.dateTime.month().day()))")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerS)
    }
    
    // MARK: - Active Itinerary View (Map + Live Timeline)
    
    private var activeItineraryView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if let itinerary = itineraryStore.activeItinerary {
                    // MapKit Preview
                    ItineraryMapView(timeline: itinerary.timeline)
                        .frame(height: 260)
                        .cornerRadius(Theme.cornerL)
                        .padding(.horizontal, Theme.paddingM)
                        .padding(.top, 8)
                        .shadow(color: Color.black.opacity(0.3), radius: 15, y: 5)
                    
                    // Quick stats bar
                    HStack {
                        statPill(icon: "clock.fill", text: "\(itinerary.stopCount * 2)h plan")
                        Spacer()
                        statPill(icon: "mappin.circle.fill", text: "\(itinerary.stopCount) stops")
                        Spacer()
                        statPill(icon: "location.fill", text: "~14 km")
                    }
                    .padding(.horizontal, Theme.paddingL)
                    .padding(.top, 16)
                    
                    // Section title
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Live Itinerary")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                            Text("Your day, step by step")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, Theme.paddingM)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                    
                    // Live Timeline
                    liveTimeline(itinerary.timeline)
                        .padding(.horizontal, Theme.paddingM)
                        .padding(.bottom, 120)
                }
            }
        }
        .background(Theme.background)
    }
    
    private func statPill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Theme.primary)
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Theme.cardBackground)
        .cornerRadius(20)
    }
    
    // MARK: - Live Timeline
    
    private func liveTimeline(_ timeline: [TimelineBlock]) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(timeline.enumerated()), id: \.offset) { index, block in
                HStack(alignment: .top, spacing: 16) {
                    // Timeline indicator
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(index == itineraryStore.currentStopIndex ? Theme.primary : Theme.elevatedSurface)
                                .frame(width: 36, height: 36)
                            
                            if index == itineraryStore.currentStopIndex {
                                // Pulsing ring for current stop
                                Circle()
                                    .stroke(Theme.primary.opacity(0.4), lineWidth: 2)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "location.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            } else if index < itineraryStore.currentStopIndex {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.green)
                            } else {
                                Text(block.icon)
                                    .font(.system(size: 16))
                            }
                        }
                        
                        if index != timeline.count - 1 {
                            Rectangle()
                                .fill(index < itineraryStore.currentStopIndex ? Color.green.opacity(0.5) : Theme.elevatedSurface)
                                .frame(width: 2, height: 80)
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text(block.time)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(index == itineraryStore.currentStopIndex ? Theme.primary : Theme.textMuted)
                        
                        Text(block.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        if let firstItem = block.items.first {
                            HStack(spacing: 8) {
                                Text(firstItem.name)
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.textSecondary)
                                
                                Text("•")
                                    .foregroundColor(Theme.textMuted)
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(.yellow)
                                    Text(firstItem.rating)
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                        
                        if index == itineraryStore.currentStopIndex {
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    itineraryStore.advanceStop()
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 14))
                                    Text("Mark Complete")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Theme.primary)
                                .cornerRadius(10)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                }
            }
        }
    }
}
