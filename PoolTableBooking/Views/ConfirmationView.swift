import SwiftUI

struct ConfirmationView: View {
    @Environment(\.dismiss) var dismiss
    
    let tableNumber: Int
    let date: String
    let timeSlot: String
    let studentName: String
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "00853E").opacity(0.12))
                        .frame(width: 120, height: 120)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Color(hex: "00853E"))
                }
                
                VStack(spacing: 8) {
                    Text("Booking Confirmed!")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Your table has been reserved.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 0) {
                    DetailRow(icon: "person.fill", label: "Name", value: studentName)
                    Divider().padding(.leading, 52)
                    DetailRow(icon: "tablecells.fill", label: "Table", value: "Table \(tableNumber)")
                    Divider().padding(.leading, 52)
                    DetailRow(icon: "calendar", label: "Date", value: date)
                    Divider().padding(.leading, 52)
                    DetailRow(icon: "clock.fill", label: "Time", value: timeSlot)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "00853E"))
                        .cornerRadius(14)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "00853E"))
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ConfirmationView(
        tableNumber: 1,
        date: "Mar 22, 2026",
        timeSlot: "10:00 AM",
        studentName: "Shilp"
    )
}
