import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clon/create_page.dart';
import 'package:flutter_insta_clon/detail_post_page.dart';

class SearchPage extends StatefulWidget {
  final User user;

  const SearchPage(this.user);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        '𝔦𝔫𝔰𝔱𝔞𝔤𝔯𝔞𝔪 𝔠𝔩𝔬𝔫',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBody() {
    print('search_page created');
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .snapshots(),
          builder:
              (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)
          {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var items = snapshot.data!.docs ?? [];

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                ),

                itemCount: items.length,

                itemBuilder: (BuildContext context, int index) {
                  return _buildListItem(context, items[index]);
                });
          }),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.create),
          onPressed: () {
            print('눌림');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CreatePage(widget.user)));
          }),
    );
  }

  Widget _buildListItem(context, document) {
    return Hero(
      tag: document['photoUrl'],
      // 되돌아갈 때 에러 방지
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return DetailPostPage(document: document);
                }));
          },
          child: Image.network(
            document['photoUrl'],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}