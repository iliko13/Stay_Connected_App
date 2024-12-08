
struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let access: String
    let refresh: String
}

struct SignupRequest: Codable {
    let email: String
    let fullname: String
    let password: String
}

struct SignupResponse: Codable {
    let message: String
}

struct SignupErrorResponse: Codable {
    let password: [String]?
}

struct AnswerRequest: Codable {
    let text: String
}

struct AnswerCorrectnessRequest: Codable {
    let isCorrect: Bool
}

struct QuestionRequest: Codable {
    let title: String
    let description: String
    let tags: [String]
    
    init(title: String, description: String, tags: [String]) {
        self.title = title
        self.description = description
        self.tags = tags
    }
}

struct QuestionResponse: Codable {
    let id: Int
    let title: String
    let description: String
    let tagNames: [String]
    let author: Author
    let answers: [Answer]
    let answersCount: Int?
    let createdAt: String?
    let hasCorrectAnswer: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case tagNames = "tag_names"
        case author
        case answers
        case answersCount = "answers_count"
        case createdAt = "created_at"
        case hasCorrectAnswer = "has_correct_answer"
    }
}

struct Author: Codable {
    let id: Int
    let fullname: String
    let email: String
    let rating: Int
}

struct Technology: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Answer: Codable {
    let id: Int?
    let text: String?
    let likesCount: Int?
    var isCorrect: Bool?
    let author: Author?
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case likesCount = "likes_count"
        case isCorrect = "is_correct"
        case author
    }
}

struct Question: Codable {
    let id: Int
    let title: String
    let description: String
    let tagNames: [String]
    let author: Author
    let answers: [Answer]
    let answersCount: Int
    let createdAt: String
    let hasCorrectAnswer: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case tagNames = "tag_names"
        case author
        case answers
        case answersCount = "answers_count"
        case createdAt = "created_at"
        case hasCorrectAnswer = "has_correct_answer"
    }
}

struct UserResponseModel: Codable {
    let id: Int
    let fullname: String
    let email: String
    let rating: Int
    let questions: [Question]
    let answers: [Answer]
    let questions_written_in_answers: [Question]
}
