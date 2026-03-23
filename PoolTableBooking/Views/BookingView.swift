import SwiftUI

struct BookingView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.dismiss) var dismiss
    
    let tableNumber: Int
    let date: Date
    
    @State private var selectedSlot: String = ""
    @State private var studentName: String = ""
    @State private var showConfirmation = false
    
    var availableSlots: [String] {
        bookingManager.timeSlots().filter {
            !bookingManager.isSlotBooked(tableNumber: tableNumber, date: date, timeSlot: $0)
        }
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "00853E").opacity(0.12))
                                .frame(width: 56, height: 56)
                            Image(systemName: "tablecells.fill")
                                .font(.system(size: 26))
                                .foregroundColor(Color(hex: "00853E"))
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Table \(tableNumber)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(dateString)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Name")
                            .font(.headline)
                            .padding(.horizontal)
                        TextField("Enter your name", text: $studentName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Time Slots")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if availableSlots.isEmpty {
                            Text("No slots available for this date")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(availableSlots, id: \.self) { slot in
                                    Button(action: { selectedSlot = slot }) {
                                        Text(slot)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .padding(.vertical, 10)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                selectedSlot == slot ?
                                                Color(hex: "00853E") : Color.white
                                            )
                                            .foregroundColor(
                                                selectedSlot == slot ? .white : .primary
                                            )
                                            .cornerRadius(10)
                                            .shadow(color: .black.opacity(0.05), radius: 4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Button(action: confirmBooking) {
                        Text("Confirm Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                studentName.isEmpty || selectedSlot.isEmpty ?
                                Color.gray : Color(hex: "00853E")
                            )
                            .cornerRadius(14)
                            .padding(.horizontal)
                    }
                    .disabled(studentName.isEmpty || selectedSlot.isEmpty)
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Book a Slot")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showConfirmation) {
                ConfirmationView(
                    tableNumber: tableNumber,
                    date: dateString,
                    timeSlot: selectedSlot,
                    studentName: studentName
                )
            }
        }
    }
    
    func confirmBooking() {
        bookingManager.addBooking(
            tableNumber: tableNumber,
            date: date,
            timeSlot: selectedSlot,
            studentName: studentName
        )
        showConfirmation = true
    }
}

#Preview {
    BookingView(tableNumber: 1, date: Date())
        .environmentObject(BookingManager())
}
