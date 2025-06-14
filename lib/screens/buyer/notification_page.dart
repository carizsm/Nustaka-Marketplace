import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../models/order.dart';
import 'cart_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Map<String, dynamic>>> _notifFuture;
  late Future<Map<String, int>> _orderStatusCountsFuture;
  late Future<int> _cartItemCountFuture;

  @override
  void initState() {
    super.initState();
    _notifFuture = _fetchNotifications();
    _orderStatusCountsFuture = _fetchOrderStatusCounts();
    _cartItemCountFuture = _fetchCartCount();
  }

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifString = prefs.getString('notifications') ?? '[]';
      final List<dynamic> notifJson = jsonDecode(notifString);
      return notifJson
          .where((e) => e is Map)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, int>> _fetchOrderStatusCounts() async {
    try {
      final api = ApiService();
      final List<BuyerOrder> orders = await api.getMyOrders() as List<BuyerOrder>;
      int ongoing = 0;
      int pending = 0;
      for (final order in orders) {
        if (order.orderStatus == "pending") {
          pending++;
        } else if (order.orderStatus == "processed" ||
            order.orderStatus == "shipped" ||
            order.orderStatus == "ongoing" ||
            order.orderStatus == "accepted" ||
            order.orderStatus == "delivering") {
          ongoing++;
        }
      }
      return {
        'ongoing': ongoing,
        'pending': pending,
      };
    } catch (e) {
      return {
        'ongoing': 0,
        'pending': 0,
      };
    }
  }

  Future<int> _fetchCartCount() async {
    try {
      final api = ApiService();
      final cartItems = await api.getCart();
      return cartItems.length;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _notifFuture = _fetchNotifications();
      _orderStatusCountsFuture = _fetchOrderStatusCounts();
      _cartItemCountFuture = _fetchCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A340),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notifFuture,
        builder: (context, snapshot) {
          final notifList = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _buildTopTabs(),
                const SizedBox(height: 20),
                FutureBuilder<Map<String, int>>(
                  future: _orderStatusCountsFuture,
                  builder: (context, snap) {
                    final ongoing = snap.data?['ongoing'] ?? 0;
                    final pending = snap.data?['pending'] ?? 0;
                    return FutureBuilder<int>(
                      future: _cartItemCountFuture,
                      builder: (context, cartSnap) {
                        final cartCount = cartSnap.data ?? 0;
                        return _buildStatusSummary(
                          ongoing: ongoing,
                          pending: pending,
                          cartCount: cartCount,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text("Terbaru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                notifList.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "Belum ada notifikasi.",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
                    : Column(
                  children: [
                    _buildNotifCard(notifList.first),
                  ],
                ),
                if (notifList.length > 1) ...[
                  const SizedBox(height: 28),
                  const Text("Sebelumnya", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildNotifCard(notifList[1]),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTab("Transaksi", true),
        _buildTab("Promo", false),
        _buildTab("Info", false),
        _buildTab("Feed", false),
      ],
    );
  }

  Widget _buildTab(String text, bool active) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEAEAEA) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSummary({required int ongoing, required int pending, required int cartCount}) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            icon: Icons.shopping_cart_outlined,
            label: 'Item di Keranjang',
            count: cartCount.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            icon: Icons.shopping_cart_checkout,
            label: 'Transaksi Berlangsung',
            count: ongoing.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            icon: Icons.schedule,
            label: 'Menunggu Pembayaran',
            count: pending.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({required IconData icon, required String label, required String count}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Color(0xFF86A340),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 26, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF0C7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notif['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      notif['time'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notif['body'] ?? '',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}