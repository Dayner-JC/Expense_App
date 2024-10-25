import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/add_page_transition.dart';
import 'package:expense_app/pages/add_page.dart';
import 'package:expense_app/state/login_state.dart';
import 'package:expense_app/widgets/month_widget.dart';
import 'package:expense_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var globalKey = RectGetter.createGlobalKey();
  late Rect buttonRect;

  late PageController _controller;
  int currentPage = DateTime.now().month - 1;
  late Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: .4,
    );
  }

  Widget _bottomAction(icon, callback) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, LoginState state, Widget? child) {
        var user = Provider.of<LoginState>(context).currentUser();
        _query = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .where('month', isEqualTo: currentPage + 1)
            .snapshots();

        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8.0,
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAction(FontAwesomeIcons.chartLine, () {
                  setState(() {
                    currentType = GraphType.LINES;
                  });
                }),
                _bottomAction(FontAwesomeIcons.chartPie, () {
                  setState(() {
                    currentType = GraphType.PIE;
                  });
                }),
                const SizedBox(width: 48.0),
                _bottomAction(FontAwesomeIcons.wallet, () {}),
                _bottomAction(FontAwesomeIcons.rightFromBracket, () {
                  Provider.of<LoginState>(context, listen: false).logout();
                }),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: RectGetter(
            key: globalKey,
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Icon(Icons.add),
              onPressed: () {
                buttonRect = RectGetter.getRectFromKey(globalKey)!;

                var page = AddPageTransition(
                  background: widget,
                  page: AddPage(
                    buttonRect: buttonRect,
                  ),
                );

                Navigator.of(context).push(page);
              },
            ),
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {
                return MonthWidget(
                  days: daysInMonth(currentPage + 1),
                  documents: data.data!.docs, 
                  graphType: currentType,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    // ignore: no_leading_underscores_for_local_identifiers
    Alignment _alignment;

    const selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );

    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: const Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(
            () {
              var user =
                  Provider.of<LoginState>(context, listen: false).currentUser();
              currentPage = newPage;
              _query = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('expenses')
                  .where('month', isEqualTo: currentPage + 1)
                  .snapshots();
            },
          );
        },
        controller: _controller,
        children: [
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }
}
