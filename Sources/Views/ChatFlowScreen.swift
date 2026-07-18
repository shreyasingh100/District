import SwiftUI

// MARK: - Adaptive Question Data
struct VibeConfig {
    let label: String
    let subtitle: String
    
    // Step 2: Contextual activities
    let step2Title: String
    let step2Subtitle: String
    let activities: [String]
    
    // Step 3: Contextual company (nil = skip, auto-set)
    let autoCompany: String?           // If set, skip company question
    let step3CompanyTitle: String?
    let companyOptions: [String]?
}

struct ChatFlowScreen: View {
    // Theme
    let lavender = Color(red: 184/255, green: 164/255, blue: 248/255)
    let deepLavender = Color(red: 147/255, green: 120/255, blue: 240/255)
    let cardBg = Color(UIColor.secondarySystemBackground)
    
    @State private var currentStep = 0
    @State private var isNavigating = false
    @State private var selectedVibe: String? = nil
    @State private var selectedActivities: Set<String> = []
    @State private var selectedCompany: String? = nil
    @State private var budgetValue: Double = 1500
    
    // Fully customized flows per vibe (No emojis, just text)
    let vibeConfigs: [VibeConfig] = [
        VibeConfig(
            label: "Party", subtitle: "Night out with the crew",
            step2Title: "What kind of party?",
            step2Subtitle: "Pick everything that sounds lit",
            activities: [
                "Bar Hopping", "Karaoke", "Live Music",
                "Rooftop Party", "Club Night", "Bowling Night"
            ],
            autoCompany: nil,
            step3CompanyTitle: "How big is the crew?",
            companyOptions: [
                "Just 2-3", "Small Group", "Big Squad"
            ]
        ),
        VibeConfig(
            label: "Romantic", subtitle: "Quality time together",
            step2Title: "Plan your perfect date",
            step2Subtitle: "What does your ideal date look like?",
            activities: [
                "Dinner Date", "Movie Night", "Sunset Walk",
                "Cafe Hopping", "Art Gallery", "Stargazing"
            ],
            autoCompany: "Partner",
            step3CompanyTitle: nil,
            companyOptions: nil
        ),
        VibeConfig(
            label: "Chill", subtitle: "Take it easy today",
            step2Title: "How do you want to unwind?",
            step2Subtitle: "Low effort, maximum vibes",
            activities: [
                "Cafe & Read", "Dessert Run", "Park Walk",
                "Spa Day", "Bookstore Crawl", "Music & Drive"
            ],
            autoCompany: nil,
            step3CompanyTitle: "Who's with you?",
            companyOptions: [
                "Just Me", "Best Friend", "Partner", "Small Group"
            ]
        ),
        VibeConfig(
            label: "Adventure", subtitle: "Get the adrenaline pumping",
            step2Title: "Pick your thrill",
            step2Subtitle: "Let's get that heart racing",
            activities: [
                "Trekking", "Go Karting", "Paintball",
                "Water Sports", "Rock Climbing", "Skydiving"
            ],
            autoCompany: nil,
            step3CompanyTitle: "Squad size?",
            companyOptions: [
                "Solo", "Duo", "Group 3-5", "Big Group"
            ]
        ),
        VibeConfig(
            label: "Explore", subtitle: "Discover hidden gems",
            step2Title: "What do you want to discover?",
            step2Subtitle: "Be a tourist in your own city",
            activities: [
                "Heritage Walk", "Street Food Trail", "Art District",
                "Local Markets", "Rooftop Views", "Photo Walk"
            ],
            autoCompany: nil,
            step3CompanyTitle: "Who's exploring with you?",
            companyOptions: [
                "Solo", "A Friend", "Partner", "Family"
            ]
        )
    ]
    
    var activeConfig: VibeConfig? {
        vibeConfigs.first(where: { $0.label == selectedVibe })
    }
    
    // How many steps for this vibe?
    var totalSteps: Int {
        guard let config = activeConfig else { return 3 }
        return config.autoCompany != nil ? 2 : 3
    }
    
    // Check if step segment should be colored purple
    func isStepValid(_ step: Int) -> Bool {
        if step < currentStep { return true }
        if step > currentStep { return false }
        
        // For the active step:
        switch step {
        case 0: return selectedVibe != nil
        case 1: return !selectedActivities.isEmpty
        case 2: return selectedCompany != nil
        default: return false
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress
            HStack(spacing: 6) {
                let steps = currentStep == 0 ? 3 : totalSteps
                ForEach(0..<steps, id: \.self) { i in
                    Capsule()
                        .fill(isStepValid(i) ? lavender : Color(UIColor.systemGray5))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: isStepValid(i))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 12)
            
            // Content
            Group {
                switch currentStep {
                case 0: vibeStep
                case 1: activityStep
                case 2: preferencesStep
                default: EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .id(currentStep)
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationTitle("Plan Your Day")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isNavigating) {
            ItineraryResultScreen()
        }
    }
    
    // MARK: - Step 1: Vibe
    var vibeStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's the vibe?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.horizontal, 24)
            
            Text("This shapes your entire day")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(vibeConfigs, id: \.label) { vibe in
                        let isSelected = selectedVibe == vibe.label
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedVibe = vibe.label
                                // Auto-set company for Romantic
                                if let auto = activeConfig?.autoCompany {
                                    selectedCompany = auto
                                } else {
                                    selectedCompany = nil
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                goNext()
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(vibe.label)
                                        .font(.system(size: 18, weight: .bold))
                                    Text(vibe.subtitle)
                                        .font(.system(size: 14))
                                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(isSelected ? lavender : cardBg)
                            .foregroundColor(isSelected ? .white : .primary)
                            .cornerRadius(18)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Step 2: Contextual Activities
    var activityStep: some View {
        let config = activeConfig ?? vibeConfigs[0]
        
        return VStack(alignment: .leading, spacing: 16) {
            Text(config.step2Title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.horizontal, 24)
            
            Text(config.step2Subtitle)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
            
            let columns = [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(config.activities, id: \.self) { activity in
                        let isSelected = selectedActivities.contains(activity)
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if isSelected {
                                    selectedActivities.remove(activity)
                                } else {
                                    selectedActivities.insert(activity)
                                }
                            }
                        }) {
                            Text(activity)
                                .font(.system(size: 15, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(isSelected ? lavender : cardBg)
                                .foregroundColor(isSelected ? .white : .primary)
                                .cornerRadius(16)
                                .scaleEffect(isSelected ? 1.03 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            Button(action: {
                if config.autoCompany != nil {
                    // Skip step 3, go straight to generate
                    isNavigating = true
                } else {
                    goNext()
                }
            }) {
                Text(config.autoCompany != nil ? "Generate Itinerary" : "Continue")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(selectedActivities.isEmpty ? Color(UIColor.systemGray5) : lavender)
                    .foregroundColor(selectedActivities.isEmpty ? .gray : .white)
                    .cornerRadius(22)
            }
            .disabled(selectedActivities.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Step 3: Company + Budget (skipped for Romantic)
    var preferencesStep: some View {
        let config = activeConfig ?? vibeConfigs[0]
        let companyOpts = config.companyOptions ?? []
        
        return VStack(alignment: .leading, spacing: 20) {
            Text("Almost done!")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.horizontal, 24)
            
            Text("Last step, promise")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
            
            // Company
            if let title = config.step3CompanyTitle {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    let columns = [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(companyOpts, id: \.self) { company in
                            let isSelected = selectedCompany == company
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCompany = company
                                }
                            }) {
                                Text(company)
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(isSelected ? lavender : cardBg)
                                    .foregroundColor(isSelected ? .white : .primary)
                                    .cornerRadius(14)
                                    .scaleEffect(isSelected ? 1.03 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(20)
                .background(cardBg.opacity(0.6))
                .cornerRadius(20)
                .padding(.horizontal, 24)
            }
            
            // Budget
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Budget per person")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("₹\(Int(budgetValue))")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(deepLavender)
                }
                
                Slider(value: $budgetValue, in: 500...5000, step: 500)
                    .tint(lavender)
                
                HStack {
                    Text("₹500").font(.system(size: 12)).foregroundColor(.secondary)
                    Spacer()
                    Text("₹5000+").font(.system(size: 12)).foregroundColor(.secondary)
                }
            }
            .padding(20)
            .background(cardBg.opacity(0.6))
            .cornerRadius(20)
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Generate
            Button(action: { isNavigating = true }) {
                Text("Generate Itinerary")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(selectedCompany == nil ? Color(UIColor.systemGray5) : lavender)
                    .foregroundColor(selectedCompany == nil ? .gray : .white)
                    .cornerRadius(22)
            }
            .disabled(selectedCompany == nil)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
    }
    
    func goNext() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            currentStep += 1
        }
    }
}
