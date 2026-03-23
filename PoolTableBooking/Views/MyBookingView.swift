import SwiftUI

struct MyBookingsView: View {
    @EnvironmentObject var bookingManager: BookingManager
    
    var sortedBookings: [Booking] {
        bookingManager.bookings.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                if bookingManager.bookings.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color(hex: "00853E").opacity(0.10))
                                .frame(width: 110, height: 110)
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 52))
                                .foregroundColor(Color(hex: "00853E"))
                        }
                        Text("No Bookings Yet")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Head to the Tables tab to book\na pool table slot.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(sortedBookings) { booking in
                            BookingRowView(booking: booking)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteBooking)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("My Bookings")
        }
    }
    
    func deleteBooking(at offsets: IndexSet) {
        offsets.forEach { index in
            let booking = sortedBookings[index]
            bookingManager.deleteBooking(id: booking.id)
        }
    }
}

struct BookingRowView: View {
    let booking: Booking
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: booking.date)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "00853E").opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: "tablecells.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "00853E"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Table \(booking.tableNumber)")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(booking.studentName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(Color(hex: "00853E"))
                    Text(dateString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(Color(hex: "00853E"))
                    Text(booking.timeSlot)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    MyBookingsView()
        .environmentObject(BookingManager())
}
