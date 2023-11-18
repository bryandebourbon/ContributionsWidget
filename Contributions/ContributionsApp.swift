import SwiftUI

@main
struct ContributionsApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  @StateObject var contributionsModel = ContributionsModel()
  let tokenModel = TokenModel()
  let dataFetcher = GitHubDataFetcher()

  var body: some View {
    VStack {
      ContributionsView(contributions: contributionsModel.contributions)
        .padding()
      TokenForm(
        tokenController: TokenController(
          tokenModel: tokenModel, dataFetcher: dataFetcher, contributionsModel: contributionsModel))
    }
  }
}

#Preview{
  ContentView()
    .frame(width: 200)
}
