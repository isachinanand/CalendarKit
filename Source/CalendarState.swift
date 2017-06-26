import Foundation

protocol DayViewStateUpdating: class {
  func move(from oldDate: Date, to newDate: Date)
}

class DayViewState {

  private(set) var selectedDate: Date
  private var clients = [DayViewStateUpdating]()

  init(date: Date = Date()) {
    let date = date.dateOnly()
    self.selectedDate = date
  }

  func move(to date: Date) {
    let date = date.dateOnly()
    notify(clients: clients, moveTo: date)
    selectedDate = date
  }

  func client(client: DayViewStateUpdating, didMoveTo date: Date) {
    let date = date.dateOnly()
    notify(clients: allClientsWithout(client: client),
           moveTo: date)
    selectedDate = date
  }

  func subscribe(client: DayViewStateUpdating) {
    clients.append(client)
  }

  func unsubscribe(client: DayViewStateUpdating) {
    clients = allClientsWithout(client: client)
  }

  private func allClientsWithout(client: DayViewStateUpdating) -> [DayViewStateUpdating] {
    return clients.filter{$0 !== client}
  }

  private func notify(clients: [DayViewStateUpdating], moveTo date: Date) {
    for client in clients {
      client.move(from: selectedDate, to: date)
    }
  }
}
