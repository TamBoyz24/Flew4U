import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      "http://127.0.0.1:3000";

  /// =========================
  /// REGISTER
  /// =========================
  static Future register({
    required String name,
    required String email,
    required String password,
  }) async {

    final response = await http.post(

      Uri.parse("$baseUrl/users"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "name": name,
        "email": email,
        "password": password,
      }),
    );

    print(response.body);

    if (response.statusCode != 201) {
      throw Exception("Register Failed");
    }
  }

  /// =========================
  /// LOGIN
  /// =========================
  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {

    final response = await http.get(

      Uri.parse(
        "$baseUrl/users?email=$email&password=$password",
      ),
    );

    List data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      return data[0];
    }

    return null;
  }

  /// =========================
  /// GET TOURS
  /// =========================
  static Future<List> getTours() async {

    final response = await http.get(
      Uri.parse("$baseUrl/tours"),
    );

    return jsonDecode(response.body);
  }

  /// =========================
  /// ADD TOUR
  /// =========================
  static Future addTour({
    required String title,
    required String image,
    required String description,
    required String location,
    required String price,
  }) async {

    final response = await http.post(

      Uri.parse("$baseUrl/tours"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "title": title,
        "image": image,
        "description": description,
        "location": location,
        "price": price,
      }),
    );

    print(response.body);
  }

  /// =========================
  /// DELETE TOUR
  /// =========================
  static Future deleteTour(String id) async {

    await http.delete(
      Uri.parse("$baseUrl/tours/$id"),
    );
  }

  /// =========================
  /// UPDATE TOUR
  /// =========================
  static Future updateTour({
    required String id,
    required String title,
    required String image,
    required String description,
    required String location,
    required String price,
  }) async {

    await http.put(

      Uri.parse("$baseUrl/tours/$id"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "title": title,
        "image": image,
        "description": description,
        "location": location,
        "price": price,
      }),
    );
  }

  /// =========================
  /// GET TRIPS
  /// =========================
  static Future<List> getTrips() async {
    final response = await http.get(
      Uri.parse("$baseUrl/trips"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to load trips: ${response.statusCode}");
      return [];
    }
  }

  /// =========================
  /// ADD TRIP
  /// =========================
  static Future addTrip(Map<String, dynamic> tripData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/trips"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(tripData),
    );
    print(response.body);
  }

  /// =========================
  /// DELETE TRIP
  /// =========================
  static Future deleteTripById(String id) async {
    await http.delete(
      Uri.parse("$baseUrl/trips/$id"),
    );
  }

  /// =========================
  /// ADD BOOKING
  /// =========================
  static Future addBooking(Map<String, dynamic> bookingData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bookings"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(bookingData),
    );
    print(response.body);
  }

  /// =========================
  /// ADD PAYMENT
  /// =========================
  static Future addPayment(Map<String, dynamic> paymentData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/payments"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(paymentData),
    );
    print(response.body);
  }

  /// =========================
  /// GET NOTIFICATIONS
  /// =========================
  static Future<List> getNotifications() async {
    final response = await http.get(Uri.parse("$baseUrl/notifications"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  /// =========================
  /// ADD NOTIFICATION
  /// =========================
  static Future addNotification(Map<String, dynamic> notifData) async {
    await http.post(
      Uri.parse("$baseUrl/notifications"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notifData),
    );
  }

  /// =========================
  /// MARK NOTIFICATION AS READ / UNREAD
  /// =========================
  static Future markNotificationAsRead(String id, Map<String, dynamic> notifData) async {
    await http.put(
      Uri.parse("$baseUrl/notifications/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notifData),
    );
  }

  /// =========================
  /// DELETE NOTIFICATION
  /// =========================
  static Future deleteNotification(String id) async {
    await http.delete(Uri.parse("$baseUrl/notifications/$id"));
  }

  /// =========================
  /// GET CHATS (for a specific user)
  /// =========================
  static Future<List> getChats(String userName) async {
    final response = await http.get(Uri.parse("$baseUrl/chats?chatWith=$userName"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  /// =========================
  /// ADD CHAT
  /// =========================
  static Future addChat(Map<String, dynamic> chatData) async {
    await http.post(
      Uri.parse("$baseUrl/chats"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(chatData),
    );
  }

  /// =========================
  /// GET WISHLISTS
  /// =========================
  static Future<List> getWishlists() async {
    final response = await http.get(Uri.parse("$baseUrl/wishlists"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  /// =========================
  /// ADD WISHLIST
  /// =========================
  static Future<Map<String, dynamic>> addWishlist(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/wishlists"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  /// =========================
  /// REMOVE WISHLIST
  /// =========================
  static Future removeWishlist(String id) async {
    await http.delete(Uri.parse("$baseUrl/wishlists/$id"));
  }
}