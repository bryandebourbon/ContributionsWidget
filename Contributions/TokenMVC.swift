import Combine
import SwiftUI

// View
struct TokenForm: View {
  @State private var userToken: String = ""
  private var tokenController: TokenController

  init(tokenController: TokenController) {
    self.tokenController = tokenController
  }

  var body: some View {
    VStack {
      TextField("Enter GitHub Token", text: $userToken)
        .multilineTextAlignment(.center)
        .padding()

      Button("Submit") {
        tokenController.saveToken(userToken)
      }.padding()
    }
  }
}

// Controller
struct TokenController {
  let tokenModel: TokenModel
  let dataFetcher: GitHubDataFetcher
  let contributionsModel: ContributionsModel

  func saveToken(_ token: String) {
    tokenModel.saveToken(token)
    fetchData(with: token)
  }

  private func fetchData(with token: String) {
    let calendar = Calendar.current
    let toDate = Date()
    guard let fromDate = calendar.date(byAdding: .month, value: -1, to: toDate) else {
      print("Error calculating date")
      return
    }
    dataFetcher.fetchGitHubData(from: fromDate, to: toDate, accessToken: token) { result in
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self.contributionsModel.contributions = response.data.viewer.contributionsCollection
            .contributionCalendar.weeks.flatMap { $0.contributionDays }
        }
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
}

// Model
class TokenModel: ObservableObject {
  @Published var token: String?

  func saveToken(_ token: String) {
    UserDefaults.standard.set(token, forKey: "GitHubToken")
    self.token = token  // notifies any observers
  }

  func loadToken() -> String {
    UserDefaults.standard.string(forKey: "GitHubToken") ?? ""
  }
}

// Preview
#if DEBUG
  struct TokenForm_Previews: PreviewProvider {
    static var previews: some View {
      // Create the required instances
      let tokenModel = TokenModel()
      let dataFetcher = GitHubDataFetcher()
      let contributionsModel = ContributionsModel()

      // Initialize TokenController with these instances
      let tokenController = TokenController(
        tokenModel: tokenModel, dataFetcher: dataFetcher, contributionsModel: contributionsModel)

      // Use this tokenController for the TokenForm
      TokenForm(tokenController: tokenController)
        .frame(width: 200)
    }
  }
#endif
