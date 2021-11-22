import Foundation

final class JournalModel {
    private let defaults = UserDefaults.standard
    private(set) var journals: [Journal]

    init() {
        guard let data = defaults.object(forKey: "Journal") as? Data else {
            self.journals = []
            return
        }

        let decoder = JSONDecoder()
        // Вопрос: в каком случае decode может упасть с ошибкой?
        if let loadedJournals = try? decoder.decode([Journal].self, from: data) {
            self.journals = loadedJournals
        }  else {
            self.journals = []
        }
    }

    private func saveJournals() {
        let encoder = JSONEncoder()

        do {
            let encoded = try encoder.encode(journals)
            defaults.set(encoded, forKey: "Journal")
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    // MARK: Journal

    func add(journal: Journal) {
        journals.append(journal)
        saveJournals()
    }

    func removeJournal(index: Int) {
        if journals.count < index {
            assertionFailure("Index greater than journals count")
        }

        journals.remove(at: index)
        saveJournals()
    }

    func getGroupName(by journalId: String) -> String {
        let filteredJournals = journals.filter { $0.id == journalId }

        if let groupName = filteredJournals.first?.groupName {
           return "\(NSLocalizedString("Group", comment: "")) \(groupName)"
        } else {
            return "\(NSLocalizedString("Group", comment: ""))"
        }
    }

    func editGroupName(journal: Journal, newValue: String) {
        let id = journal.id

        if let index = journals.firstIndex(where: { $0.id == id }) {
            journals[index].groupName = newValue
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournals()
    }

    func getGroupIndex(by journalId: String) -> Int? {
        journals.firstIndex(where: { $0.id == journalId })
    }

    // MARK: Student

    func add(student: Student, for journalId: String) {
        if let groupIndex = getGroupIndex(by: journalId) {
            journals[groupIndex].students.append(student)
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournals()
    }

    func getStudents(journalId: String) -> [Student] {
        if let groupIndex = getGroupIndex(by: journalId) {
            return journals[groupIndex].students
        } else {
            return []
        }
    }

    func removeStudent(index: Int, journalId: String) {
        if let groupIndex = getGroupIndex(by: journalId) {
            journals[groupIndex].students.remove(at: index)
        } else {
            assertionFailure("Didn't get journal by id")
        }

        saveJournals()
    }

    func editStudent(student: Student, journalId: String, newFirstName: String, newSecondName: String) {
        guard let groupIndex = getGroupIndex(by: journalId),
              let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == student.id }) else {
            return assertionFailure("Didn't get student by id")
        }

        journals[groupIndex].students[studentIndex].secondName = newSecondName
        journals[groupIndex].students[studentIndex].firstName = newFirstName

        saveJournals()
    }

    func getStudentName(journalId: String, studentId: String) -> String {
        guard let groupIndex = getGroupIndex(by: journalId),
              let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId }) else {
            return NSLocalizedString("Unknown student", comment: "")
        }

        return "\(journals[groupIndex].students[studentIndex].firstName) \(journals[groupIndex].students[studentIndex].secondName)"
    }

    // MARK: Subject

    func add(subject: Subject, for studentId: String, in journalId: String) {
        guard let groupIndex = getGroupIndex(by: journalId),
              let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) else {
                  return assertionFailure("Didn't get student by id")
              }

        journals[groupIndex].students[studentIndex].subjects.append(subject)
        saveJournals()
    }

    func getSubjects(studentId: String, journalId: String) -> [Subject] {
        guard let groupIndex = getGroupIndex(by: journalId),
              let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) else {
                  return []
              }

        return journals[groupIndex].students[studentIndex].subjects
    }

    func removeSubject(index: Int, studentId: String, journalId: String) {
        guard let groupIndex = getGroupIndex(by: journalId),
              let studentIndex = journals[groupIndex].students.firstIndex(where: { $0.id == studentId } ) else {
                  return assertionFailure("Didn't get student by id")
              }

        journals[groupIndex].students[studentIndex].subjects.remove(at: index)
        saveJournals()
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
