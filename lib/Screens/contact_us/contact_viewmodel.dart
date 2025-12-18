import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/contact_us_model/contact_us_response.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class ContactViewModel extends ChangeNotifier {
  List<ContactData> contacts = [];
  bool isLoading = false;
  bool isLoadingMore = false;

  int currentPage = 1;
  bool hasMore = true;

  final UserService userService = UserService();

  ContactViewModel() {
    fetchContacts();
  }

  // --- INITIAL FETCH ---
  Future<void> fetchContacts() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await userService.fetchContactUsList(1);

      contacts = response.data;
      currentPage = response.page;

      // If totalCount > fetched items → more pages exist
      hasMore = (response.totalCount > contacts.length);
    } catch (e) {
      // You may add error states here
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- PAGINATION FETCH ---
  Future<void> fetchMore() async {
    if (isLoadingMore || !hasMore) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      final nextPage = currentPage + 1;

      final response = await userService.fetchContactUsList(nextPage);

      if (response.data.isNotEmpty) {
        contacts.addAll(response.data);
        currentPage = response.page;
      }

      // Check if more pages exist
      final totalFetched = contacts.length;
      hasMore = totalFetched < response.totalCount;

    } catch (e) {
      rethrow;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }


Future<void> markMessageAsRead(String contactId) async {
  try {
    final response = await userService.markAsRead(contactId);

    // Update your contacts list if you have one
    int index = contacts.indexWhere((c) => c.id == contactId);
    if (index != -1 && response.data.isNotEmpty) {
      final updated = response.data.firstWhere((c) => c.id == contactId, orElse: () => response.data.first);
      contacts[index] = updated;
      notifyListeners();
    }
  } catch (e) {
    print("Failed to mark read: $e");
  }
}
void updateContact(ContactData updatedData) {
  // Find the index of the contact with the same ID
  int index = contacts.indexWhere((c) => c.id == updatedData.id);

  if (index != -1) {
    // Replace the old contact with the updated one
    contacts[index] = updatedData;

    // Notify listeners so the UI rebuilds
    notifyListeners();
  }
}

}
