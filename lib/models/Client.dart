class Client {
  final String name;
  final String id;
  final String company;
  final String orderId;
  final String invoicepaid;
  final String invoicePending;

  Client({
    required this.name,
    required this.id,
    required this.company,
    required this.orderId,
    required this.invoicepaid,
    required this.invoicePending,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        name: json['name'],
        id: json['id'],
        company: json['company'],
        orderId: json['orderId'],
        invoicepaid: json['invoicepaid'],
        invoicePending: json['invoicePending']);
  }

  static List<Client> fromJsonArray(Map<String, dynamic> json) {
    List<Client> clients = [];
    List jsonArray = json['clients'];
    jsonArray.forEach((element) {
      clients.add(Client.fromJson(element));
    });
    return clients;
  }
}
