
import UIKit
import NetworkPackage

class AddQuestionViewModel {
    private let networkService = NetworkPackage()

    var tagList: [Technology] = [] {
        didSet {
            onTagsUpdated?()
        }
    }
    
    var onTagsUpdated: (() -> Void)?

    func addTag(_ technology: Technology) {
        if !tagList.contains(where: { $0.id == technology.id }) {
            tagList.append(technology)
        }
    }

    func removeTag(at index: Int) {
        guard index < tagList.count else { return }
        tagList.remove(at: index)
    }

    func postQuestion(subject: String, description: String, completion: @escaping (Bool) -> Void) {
        let tags = tagList.map { $0.name }
        let questionRequest = QuestionRequest(title: subject, description: description, tags: tags)
        
        networkService.postDataWithToken(urlString: "http://127.0.0.1:8000/questions", modelType: QuestionRequest.self, body: questionRequest) { (result: Result<QuestionResponse, Error>) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}

