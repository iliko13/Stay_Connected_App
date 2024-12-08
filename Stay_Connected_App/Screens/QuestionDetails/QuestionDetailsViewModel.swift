import UIKit
import NetworkPackage

final class QuestionDetailsViewModel {
    private let networkService = NetworkPackage()
    var question: Question
    var answers: [Answer] = []
    
    var reloadTableView: (() -> Void)?
    var showAlert: ((String) -> Void)?
    
    init(question: Question) {
        self.question = question
    }

    func fetchAnswers() {
        let endpoint = "http://127.0.0.1:8000/questions/\(question.id)/answers"
        
        networkService.fetchDataWithToken(urlString: endpoint, modelType: [Answer].self) { [weak self] result in
            switch result {
            case .success(let answers):
                self?.answers = answers
                self?.reloadTableView?()
            case .failure(let error):
                self?.showAlert?("Error fetching answers: \(error.localizedDescription)")
            }
        }

    }

    func postAnswer(text: String) {
        let answerRequest = AnswerRequest(text: text)
        let endpoint = "http://127.0.0.1:8000/questions/\(question.id)/answers"
        networkService.postDataWithToken(
            urlString: endpoint,
            modelType: AnswerRequest.self,
            body: answerRequest
        ) { [weak self] (result: Result<Answer, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.answers.append(response)
                    self?.reloadTableView?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error posting answer: \(error)")
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to submit your answer.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                }
            }
        }

    }

    func updateAnswerCorrectness(answer: Answer, isCorrect: Bool) {
        guard let answerId = answer.id else { return }
        
        let endpoint = "http://127.0.0.1:8000/answers/\(answerId)/correct"
        let requestBody = AnswerCorrectnessRequest(isCorrect: isCorrect)
        
        networkService.patchDataWithToken(
            urlString: endpoint,
            modelType: AnswerCorrectnessRequest.self,
            body: requestBody
        ) { [weak self] (result: Result<Answer, Error>) in
            switch result {
            case .success(let updatedAnswer):
                DispatchQueue.main.async {
                    if let index = self?.answers.firstIndex(where: { $0.id == updatedAnswer.id }) {
                        self?.answers[index] = updatedAnswer
                        self?.reloadTableView?()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error updating answer correctness: \(error)")
                }
            }
        }
    }
    
    func acceptAnswer(at indexPath: IndexPath) {
          var answer = answers[indexPath.row]
          answer.isCorrect = true
          answers[indexPath.row] = answer
          updateAnswerCorrectness(answer: answer, isCorrect: true)
      }

      func rejectAnswer(at indexPath: IndexPath) {
          var answer = answers[indexPath.row]
          answer.isCorrect = false
          answers[indexPath.row] = answer
          updateAnswerCorrectness(answer: answer, isCorrect: false)
      }
    
}
