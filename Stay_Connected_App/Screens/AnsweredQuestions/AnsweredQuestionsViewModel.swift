
import Foundation
import NetworkPackage

final class AnsweredQuestionsViewModel {
    
    var technologies: [Technology] = []
    var questions: [Question] = []
    
    private let networkService: NetworkService = NetworkPackage()
    
    var onTechnologiesUpdated: (() -> Void)?
    var onQuestionsUpdated: (() -> Void)?
    var onErrorOccurred: ((Error) -> Void)?
    
    func fetchTags() {
        networkService.fetchData(from: "http://127.0.0.1:8000/tags/", modelType: [Technology].self) { [weak self] result in
            switch result {
            case .success(let technologies):
                DispatchQueue.main.async {
                    self?.technologies = technologies
                    self?.onTechnologiesUpdated?()
                }
            case .failure(let error):
                self?.onErrorOccurred?(error)
            }
        }
    }
    
    func fetchAnsweredQuestions() {
        networkService.fetchDataWithToken(urlString: "http://127.0.0.1:8000/user/profile/", modelType: UserResponseModel.self) { [weak self] result in
            switch result {
            case .success(let answeredQuestions):
                DispatchQueue.main.async {
                    self?.questions = answeredQuestions.questions_written_in_answers
                    self?.onQuestionsUpdated?()
                }
            case .failure(let error):
                self?.onErrorOccurred?(error)
            }
        }
    }
}
