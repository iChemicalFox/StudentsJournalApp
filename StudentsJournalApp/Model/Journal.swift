import Foundation

struct Journal: Codable {
    let id: String // UUID нулевой почти шанс что повториться
    var groupName: String
    var students: [Student]
}

struct Student: Codable {
    let id: String
    var firstName: String
    var secondName: String
    var subjects: [Subject]
}

struct Subject: Codable {
    let id: String
    var name: String
    var grade: Int
}
