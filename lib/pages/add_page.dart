import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/category_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late String category;
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Category',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _categorySelector(),
        _currentValue(),
        _numPad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return SizedBox(
      height: 80.0,
      child: CategorySelectorWidget(
        categories: const {
          'Shopping': Icons.shopping_cart,
          'Alcohol': FontAwesomeIcons.beerMugEmpty,
          'Fast Food': FontAwesomeIcons.burger,
          'Bills': FontAwesomeIcons.wallet,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 100.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        "\$${realValue.toStringAsFixed(2)}",
        style: const TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _num(text, height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(
          () {
            if (text == '.') {
              value *= 100;
            } else {
              value = value * 10 + int.parse(text);
            }
          },
        );
      },
      child: SizedBox(
        height: height,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 40.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numPad() {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var height = constraints.biggest.height / 4;

          return Table(
            border: TableBorder.all(
              color: Colors.grey,
              width: 1.0,
            ),
            children: [
              TableRow(children: [
                _num('1', height),
                _num('2', height),
                _num('3', height),
              ]),
              TableRow(children: [
                _num('4', height),
                _num('5', height),
                _num('6', height),
              ]),
              TableRow(children: [
                _num('7', height),
                _num('8', height),
                _num('9', height),
              ]),
              TableRow(
                children: [
                  _num('.', height),
                  _num('0', height),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        value = value ~/ 10;
                      });
                    },
                    child: SizedBox(
                      height: height,
                      child: const Center(
                        child: Icon(
                          Icons.backspace,
                          color: Colors.grey,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _submit() {
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: MaterialButton(
        onPressed: () {
          if (value > 0 && category != '') {
            FirebaseFirestore.instance.collection('expenses').doc().set({
              'category': category,
              'value': value,
              'month': DateTime.now().month,
              'day': DateTime.now().day,
            });
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Select value and category"),
              ),
            );
          }
        },
        child: const Text(
          'Add expense',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
