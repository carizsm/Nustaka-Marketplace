import 'package:flutter/material.dart';

class SellerNotificationPage extends StatelessWidget {
  const SellerNotificationPage({Key? key}) : super(key: key);

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Pesanan Baru',
      'message': 'Pesanan dari Eldwin Fikhar Ananda sedang diproses.',
      'date': '13 Sep, 14:55'
    },
    {
      'title': 'Menunggu Pembayaran',
      'message': 'Pesanan dari Azriel belum dibayar.',
      'date': '12 Sep, 12:32'
    },
    {
      'title': 'Pesanan Dikirim',
      'message': 'Pesanan dari Leonardy sedang dalam perjalanan.',
      'date': '10 Sep, 09:00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.green),
              title: Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notif['message']!),
              trailing: Text(
                notif['date']!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
