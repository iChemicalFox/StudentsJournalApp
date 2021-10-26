import Foundation

final class JournalModel {
    // можно вынести decoder и encoder в глобальные приватные константы, либо даже сделать протокол чтобы избавиться от повторений в коде
    private let defaults = UserDefaults.standard

    func addJournal(journal: Journal) {  // может переделать в addGroup, а Key "Journals" в "Groups"?
        // encode и decode массивов журнала
        let encoder = JSONEncoder()
        var journals = getJournals()
        
        journals.append(journal)

        if let encoded = try? encoder.encode(journals) {
            defaults.set(encoded, forKey: "Journals")
        }

        // проверка
        if let savedJournal = defaults.object(forKey: "Journals") as? Data {
            let decoder = JSONDecoder()
            if let loadedJournal = try? decoder.decode([Journal].self, from: savedJournal) {
                print(loadedJournal)
            }
        }
    }

    func getJournals() -> [Journal] {
        if let savedJournal = defaults.object(forKey: "Journals") as? Data {
            let decoder = JSONDecoder()

            if let loadedJournal = try? decoder.decode([Journal].self, from: savedJournal) {
                return loadedJournal
            }
        }

        return []
    }

    func removeJournal(index: Int) {
        var journals = getJournals()

        if journals.isEmpty {
            return
        }

        journals.remove(at: index)
        let encoder = JSONEncoder()

        if let encoded = try? encoder.encode(journals) {
            defaults.set(encoded, forKey: "Journals")
        } // слишком много действий: запросить журналы, сохранить в переменную, удалить из переменной значение, перезаписать defaults

        // проверка
        if let savedJournal = defaults.object(forKey: "Journals") as? Data {
            let decoder = JSONDecoder()
            if let loadedJournal = try? decoder.decode([Journal].self, from: savedJournal) {
                print(loadedJournal)
            }
        }
    }

    func addStudent(student: Student, for group: String) {
        // encode и decode массивов журнала
        let encoder = JSONEncoder()
        var students = getStudents(group: group)
        
        students.append(student)

        if let encoded = try? encoder.encode(students) {
            defaults.set(encoded, forKey: group)
        }

        // проверка
        if let savedStudent = defaults.object(forKey: group) as? Data {
            let decoder = JSONDecoder()
            if let loadedStudent = try? decoder.decode([Student].self, from: savedStudent) {
                print(loadedStudent)
            }
        }
    }

    func getStudents(group key: String) -> [Student] {
        if let savedStudents = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()

            if let loadedStudents = try? decoder.decode([Student].self, from: savedStudents) {
                return loadedStudents
            }
        }

        return []
    }

    func removeStudent(index: Int, by key: String) {
        var students = getStudents(group: key)

        if students.isEmpty {
            return
        }

        students.remove(at: index)
        let encoder = JSONEncoder()

        if let encoded = try? encoder.encode(students) {
            defaults.set(encoded, forKey: key)
        } // слишком много действий: запросить студентов, сохранить в переменную, удалить из переменной значение, перезаписать defaults

        // проверка
        if let savedStudent = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedStudent = try? decoder.decode([Student].self, from: savedStudent) {
                print(loadedStudent)
            }
        }
    }
}
