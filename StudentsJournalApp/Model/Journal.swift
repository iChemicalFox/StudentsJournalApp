import Foundation

struct Journal {
    let group: Group
}

struct Group {
    let groupName: String
    let students: [Student]?
}

struct Student {
    let firstName: String
    let secondName: String
    let subjects: [Subject]?
}

struct Subject {
    let name: String
    let grade: Double
}
