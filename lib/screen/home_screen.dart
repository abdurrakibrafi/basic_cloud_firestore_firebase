import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.docID});

  final String docID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot<Map<String, dynamic>>>? collectionSnapshot = FirebaseFirestore.instance
        .collection('Football')
        .doc(widget.docID)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Score'),
      ),
      body: StreamBuilder(
          stream: collectionSnapshot,
          builder:
              (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final score = snapshot.data!;
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(score.get('match_name') ?? '',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 6.0,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(score.get('score_team_a').toString(),
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text('  :  ',
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text(score.get('score_team_b').toString(),
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0,),
                          Text('Time: ${score.get('time')}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text('Total Time: ${score.get('total_time')}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
