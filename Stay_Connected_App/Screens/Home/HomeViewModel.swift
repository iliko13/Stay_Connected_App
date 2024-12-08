
import Foundation
import NetworkPackage

class HomeViewModel {

    // MARK: - Properties
    private let networkService: NetworkService
    private(set) var technologies: [Technology] = []
    private(set) var questions: [Question] = []
    var selectedTag: String?
    var searchQuery: String?

    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Methods
    func fetchTechnologies(completion: @escaping (Result<[Technology], Error>) -> Void) {
        networkService.fetchData(from: "http://127.0.0.1:8000/tags/", modelType: [Technology].self) { result in
            switch result {
            case .success(let technologies):
                self.technologies = technologies
                completion(.success(technologies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        var urlString = "http://127.0.0.1:8000/questions"
        
        if let tag = selectedTag {
            urlString += "?tags=\(tag)"
        }
        
        if let query = searchQuery {
            if urlString.contains("?") {
                urlString += "&search=\(query)"
            } else {
                urlString += "?search=\(query)"
            }
        }
        
        networkService.fetchData(from: urlString, modelType: [Question].self) { result in
            switch result {
            case .success(let questions):
                self.questions = questions
                completion(.success(questions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchUserProfileQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        networkService.fetchDataWithToken(urlString: "http://127.0.0.1:8000/user/profile/", modelType: UserResponseModel.self) { (result: Result<UserResponseModel, Error>) in
            switch result {
            case .success(let userResponse):
                self.questions = userResponse.questions
                completion(.success(userResponse.questions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
