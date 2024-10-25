import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/widgets/category_selector_widget.dart';
import 'package:expense_app/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  final Rect buttonRect;

  const AddPage({super.key, required this.buttonRect});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _buttonAnimation;
  late Animation _pageAnimation;

  late String category;
  int value = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _pageAnimation = Tween<double>(begin: -1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        Navigator.of(context).pop();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0, height * (1 - _pageAnimation.value)),
          child: Scaffold(
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
                    _controller.reverse();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            body: _body(),
          ),
        ),
        _submit(),
      ],
    );
  }

  Widget _body() {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        _categorySelector(),
        _currentValue(),
        _numPad(),
        SizedBox(
          height: height - widget.buttonRect.top,
        )
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
    if (_controller.value < 1) {
      var buttonWidth = widget.buttonRect.right - widget.buttonRect.left;
      var width = MediaQuery.of(context).size.width;
      return Positioned(
        top: widget.buttonRect.top,
        left: widget.buttonRect.left * (1 - _buttonAnimation.value),
        right: (width - widget.buttonRect.right) * (1 - _buttonAnimation.value),
        bottom: (MediaQuery.of(context).size.height -  widget.buttonRect.bottom) * (1 - _buttonAnimation.value),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              buttonWidth * (1 - _buttonAnimation.value),
            ),
            color: Colors.blueAccent,
          ),
        ),
      );
    } else {
      return Positioned(
        top: widget.buttonRect.top,
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: MaterialButton(
                onPressed: () {
                  var user = Provider.of<LoginState>(context, listen: false)
                      .currentUser();
                  if (value > 0 && category != '') {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('expenses')
                        .doc()
                        .set({
                      'category': category,
                      'value': value / 100,
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
          },
        ),
      );
    }
  }
}
