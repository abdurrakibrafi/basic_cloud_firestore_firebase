import 'package:cloud_firestore_flutter/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final CollectionReference _documentsCollection = FirebaseFirestore.instance.collection('Football');

  Future<List<DocumentSnapshot>> fetchDocuments() async {
    final QuerySnapshot querySnapshot = await _documentsCollection.get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match List'),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: fetchDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final documents = snapshot.data;

              return ListView.separated(
                itemCount: documents!.length,
                separatorBuilder: (BuildContext context, int index) =>
                  const Divider(thickness: 1,),
                itemBuilder: (context, index) =>
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                              HomeScreen(docID: documents[index].id)));
                    },
                    title: Text(documents[index].id),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
              );
            }
          },
        ),
      )
    );
  }
}
