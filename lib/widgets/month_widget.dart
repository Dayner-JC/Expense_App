import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/pages/datails_page.dart';
import 'package:expense_app/widgets/graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GraphType {
  LINES,
  PIE,
}

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final GraphType graphType;
  final int month;

  MonthWidget({
    super.key,
    required this.documents,
    days,
    required this.graphType, 
    required this.month,
  })  : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List.generate(
          days,
          (int index) {
            return documents
                .where((doc) => doc['day'] == (index + 1))
                .map((doc) => doc['value'])
                .fold(0.0, (a, b) => a + b);
          },
        ),
        categories = documents.fold<Map<String, double>>({},
            (Map<String, double> map, document) {
          final category = document['category'];
          map[category] = (map[category] ?? 0.0) + (document['value']);
          return map;
        });

  @override
  State<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(.15),
            height: 24.0,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _expenses() {
    return Column(
      children: [
        Text(
          "\$${widget.total.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        const Text(
          "Total expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return SizedBox(
        height: 220,
        child: LinesGraphWidget(
          data: widget.perDay,
        ),
      );
    } else {
      var perCategories = widget.categories.keys
          .map((name) => widget.categories[name]! / widget.total)
          .toList();
      return SizedBox(
        height: 220,
        child: PieGraphWidget(
          data: perCategories,
        ),
      );
    }
  }

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _item(FontAwesomeIcons.cartShopping, key,
              100 * data! ~/ widget.total, data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(.15),
            height: 8.0,
          );
        },
      ),
    );
  }

  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/details', arguments: DetailsParams( categoryName: name, month: widget.month,));
      },
      leading: Icon(icon),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(
        "$percent% of expenses",
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\$$value",
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
