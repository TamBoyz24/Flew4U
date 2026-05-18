class UserStore {
  static List<Map<String, String>> users = [];

  static void addUser(String email, String password) {
    users.add({'email': email, 'password': password});
  }

  static bool checkUser(String email, String password) {
    return users.any((u) => u['email'] == email && u['password'] == password);
  }

  static bool emailExists(String email) {
    return users.any((u) => u['email'] == email);
  }
}
