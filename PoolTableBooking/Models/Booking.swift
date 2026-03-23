import Foundation
import Combine

struct Booking: Identifiable, Codable {
    var id = UUID()
    var tableNumber: Int
    var date: Date
    var timeSlot: String
    var studentName: String
}

class BookingManager: ObservableObject {
    @Published var bookings: [Booking] = []
    private let saveKey = "SavedBookings"
    
    init() { loadBookings() }
    
    func addBooking(tableNumber: Int, date: Date, timeSlot: String, studentName: String) {
        let booking = Booking(tableNumber: tableNumber, date: date, timeSlot: timeSlot, studentName: studentName)
        bookings.append(booking)
        saveBookings()
    }
    
    func deleteBooking(id: UUID) {
        bookings.removeAll { $0.id == id }
        saveBookings()
    }
    
    func isSlotBooked(tableNumber: Int, date: Date, timeSlot: String) -> Bool {
        let calendar = Calendar.current
        return bookings.contains {
            $0.tableNumber == tableNumber &&
            $0.timeSlot == timeSlot &&
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
    func timeSlots() -> [String] {
        var slots: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        var components = DateComponents()
        for i in 0..<28 {
            let minutes = i * 30
            components.hour = 8 + minutes / 60
            components.minute = minutes % 60
            if let date = Calendar.current.date(from: components) {
                slots.append(formatter.string(from: date))
            }
        }
        return slots
    }
    
    private func saveBookings() {
        if let encoded = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadBookings() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Booking].self, from: data) {
            bookings = decoded
        }
    }
}
