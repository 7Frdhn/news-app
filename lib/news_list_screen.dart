import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'add_edit_news_screen.dart';
import 'news_model.dart';

class NewsListScreen extends StatelessWidget {
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: newsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              News news = News.fromDocument(doc);
              return ListTile(
                title: Text(news.name),
                subtitle: Text('Age: ${news.age}, Address: ${news.address}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditNewsScreen(news: news),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, news.id);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNewsScreen(),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                newsCollection.doc(docId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
