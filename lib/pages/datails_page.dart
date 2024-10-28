import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams({required this.categoryName, required this.month});
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;

  const DetailsPage({super.key, required this.params});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, state, child) {
        var user = Provider.of<LoginState>(context).currentUser();

        // ignore: no_leading_underscores_for_local_identifiers
        var _query = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .where('month', isEqualTo: widget.params.month + 1)
            .where('category', isEqualTo: widget.params.categoryName)
            .snapshots();

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.params.categoryName),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _query,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.hasData) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var document = data.data!.docs[index];
                      return Dismissible(
                        key: Key(document.id),
                        onDismissed: (direction) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('expenses')
                              .doc(document.id)
                              .delete();
                        },
                        child: ListTile(
                          leading: Stack(
                            children: [
                              const Icon(Icons.calendar_today, size: 40),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 8,
                                child: Text(
                                  document['day'].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(.2),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$${document['value']}",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.data!.docs.length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        );
      },
    );
  }
}
