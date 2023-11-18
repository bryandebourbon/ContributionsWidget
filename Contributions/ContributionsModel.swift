import Foundation

class ContributionsModel: ObservableObject {
  @Published var contributions: [ContributionDay] = []

  init() {
//    #if DEBUG
//      generateMockData()
//    #else
      loadContributions()
//    #endif
  }

  private func loadContributions() {
    guard let sharedDefaults = UserDefaults(suiteName: "group.com.bryandebourbon.contributions"),
      let encodedData = sharedDefaults.data(forKey: "githubContributions"),
      let contributionDays = try? JSONDecoder().decode([ContributionDay].self, from: encodedData)
    else {
      return
    }
    self.contributions = contributionDays
  }

  // Function to generate mock data
  private func generateMockData() {
    let calendar = Calendar.current
    let today = Date()
    var mockContributions = [ContributionDay]()

    // Generate mock data for the past 365 days
    for dayOffset in 0..<365 {
      guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      let dateString = formatter.string(from: date)
      let contributionCount = Int.random(in: 0...10)  // Random contribution count
      mockContributions.append(
        ContributionDay(date: dateString, contributionCount: contributionCount))
    }

    self.contributions = mockContributions
  }
}
