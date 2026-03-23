import SwiftUI

struct HomeView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @State private var selectedDate = Date()
    @State private var selectedTable: Int? = nil
    @State private var showingBooking = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .tint(Color(hex: "00853E"))
                            .padding(.horizontal)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pool Tables")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(1...3, id: \.self) { tableNumber in
                            TableCardView(
                                tableNumber: tableNumber,
                                date: selectedDate,
                                onBook: {
                                    selectedTable = tableNumber
                                    showingBooking = true
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("UNT Pool Tables")
            .sheet(isPresented: $showingBooking) {
                if let table = selectedTable {
                    BookingView(tableNumber: table, date: selectedDate)
                }
            }
        }
    }
}

struct TableCardView: View {
    @EnvironmentObject var bookingManager: BookingManager
    let tableNumber: Int
    let date: Date
    let onBook: () -> Void
    
    var bookedSlots: Int {
        bookingManager.timeSlots().filter {
            bookingManager.isSlotBooked(tableNumber: tableNumber, date: date, timeSlot: $0)
        }.count
    }
    
    var totalSlots: Int { bookingManager.timeSlots().count }
    
    var availabilityColor: Color {
        let ratio = Double(bookedSlots) / Double(totalSlots)
        if ratio == 0 { return Color(hex: "00853E") }
        else if ratio < 0.7 { return .orange }
        else { return .red }
    }
    
    var availabilityText: String {
        let available = totalSlots - bookedSlots
        if available == 0 { return "Fully Booked" }
        else { return "\(available) slots available" }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "00853E").opacity(0.12))
                    .frame(width: 60, height: 60)
                Image(systemName: "tablecells.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "00853E"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Table \(tableNumber)")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(availabilityText)
                    .font(.subheadline)
                    .foregroundColor(availabilityColor)
            }
            
            Spacer()
            
            Button(action: onBook) {
                Text("Book")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        totalSlots - bookedSlots == 0 ?
                        Color.gray : Color(hex: "00853E")
                    )
                    .cornerRadius(10)
            }
            .disabled(totalSlots - bookedSlots == 0)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(BookingManager())
}
