import Foundation

struct Journal: Codable {
    let group: Group
}

struct Group: Codable {
    let groupName: String
    let students: [Student]?
}

struct Student: Codable {
    let firstName: String
    let secondName: String
    let subjects: [Subject]?
}

struct Subject: Codable {
    let name: String
    let grade: Int
}
