import 'package:flutter/material.dart';

class CategorySelectorWidget extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) onValueChanged;

  const CategorySelectorWidget({
    super.key,
    required this.categories,
    required this.onValueChanged,
  });

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget(
      {super.key,
      required this.name,
      required this.icon,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: selected ? Colors.blueAccent : Colors.grey,
                width: selected ? 3.0 : 1.0,
              ),
            ),
            child: Icon(icon),
          ),
          Text(name),
        ],
      ),
    );
  }
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  String currentItem = '';

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categories.forEach(
      (name, icon) {
        widgets.add(
          GestureDetector(
            onTap: () {
              setState(() {
                currentItem = name;
              });
              widget.onValueChanged(name);
            },
            child: CategoryWidget(
              name: name,
              icon: icon,
              selected: name == currentItem,
            ),
          ),
        );
      },
    );

    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}
