import Foundation

final class JournalModel {
    private let defaults = UserDefaults.standard
    private(set) var journals: [Journal]

    init() {
        if let data = defaults.object(forKey: "Journal") as? Data {
            let decoder = JSONDecoder()
            // Вопрос: в каком случае decode может упасть с ошибкой?
            if let loadedJournals = try? decoder.decode([Journal].self, from: data) {
                self.journals = loadedJournals
            }  else {
                self.journals = []
            }
        } else {
            self.journals = []
        }
    }

    private func saveJournal() {
        let encoder = JSONEncoder()

        do {
            let encoded = try encoder.encode(journals)
            defaults.set(encoded, forKey: "Journal")
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func add(journal: Journal) {
        journals.append(journal)
        saveJournal()
    }

    func removeJournal(index: Int) {
        if journals.count < index {
            // ошибку бы сюда
        }

        journals.remove(at: index)
        saveJournal()
    }

    func getGroupName(by journalId: String) -> String {
        let groups = journals.filter { $0.id == journalId }
        if let groupName = groups.first?.groupName {
           return "\(NSLocalizedString("Group", comment: "")) \(groupName)"
        } else {
            return "\(NSLocalizedString("Group", comment: ""))"
        }
    }

    func add(student: Student, for journalId: String) {
        if let index = journals.firstIndex(where: { $0.id == journalId }) {
            journals[index].students.append(student)
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournal()
    }

    func getStudents(journalId: String) -> [Student] {
        if let index = journals.firstIndex(where: { $0.id == journalId }) {
            return journals[index].students
        } else {
            return []
        }
    }

    func removeStudent(index: Int, journalId: String) {
        if let journalIndex = journals.firstIndex(where: { $0.id == journalId }) {
            journals[journalIndex].students.remove(at: index)
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournal()
    }

    func getStudentName(journalId: String, studentId: String) -> String {
        if let groupIndex = journals.firstIndex(where: { $0.id == journalId }) {
            if let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) {
                return "\(journals[groupIndex].students[studentIndex].firstName) \(journals[groupIndex].students[studentIndex].secondName)"
            } else {
                return "Unknown student"
            }
        } else {
            return "Unknown student"
        }
    }

    func add(subject: Subject, for studentId: String, in journalId: String) {
        if let groupIndex = journals.firstIndex(where: { $0.id == journalId }) {
            if let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) {
                journals[groupIndex].students[studentIndex].subjects.append(subject)
            } else {
                assertionFailure("Didn't get student by id")
            }
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournal()
    }

    func getSubjects(studentId: String, journalId: String) -> [Subject] {
        if let groupIndex = journals.firstIndex(where: { $0.id == journalId }) {
            if let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) {
                return journals[groupIndex].students[studentIndex].subjects
            } else {
                return []
            }
        } else {
            return []
        }
    }

    func removeSubject(index: Int, studentId: String, journalId: String) {
        if let groupIndex = journals.firstIndex(where: { $0.id == journalId }) {
            if let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) {
                journals[groupIndex].students[studentIndex].subjects.remove(at: index)
            } else {
                assertionFailure("Didn't get student by id")
            }
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournal()
    }

    func getAverageRate(studentId: String, journalId: String) -> Float {
        let subjects = getSubjects(studentId: studentId, journalId: journalId)
        var averageGrade: Float = 0.0

        if subjects.isEmpty {
            return averageGrade
        }

        _ = subjects.map {
            averageGrade = Float($0.grade) + averageGrade
        }

        averageGrade = averageGrade / Float(subjects.count)

        return averageGrade
    }
}
