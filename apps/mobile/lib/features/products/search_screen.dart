import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
      ),
      body: Center(
        child: Text('Display search results for "${widget.query}" here.'),
      ),
    );
  }
}