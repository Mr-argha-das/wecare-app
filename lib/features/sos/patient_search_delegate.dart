import 'package:flutter/material.dart';

class PatientSearchDelegate
    extends SearchDelegate<Map<String, dynamic>> {
  final List<Map<String, dynamic>> patients;

  PatientSearchDelegate(this.patients);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, {}),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _list(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _list(context);
  }

  Widget _list(context) {
    final filtered = patients.where((p) {
      final name = p["name"]?.toLowerCase() ?? "";
      return name.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final p = filtered[i];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(p["name"] ?? "Unknown"),
          subtitle: Text(
              "Room ${p["room_no"] ?? "-"} • ${p["gender"] ?? ""}"),
          onTap: () => close(context, p),
        );
      },
    );
  }
}
