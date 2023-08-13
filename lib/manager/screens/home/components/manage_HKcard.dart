import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HkCard extends StatefulWidget {
  const HkCard({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.onDelete,
    this.color = const Color(0xFF5DC4EA),
  }) : super(key: key);

  final String title;
  final Color color;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  _HkCardState createState() => _HkCardState();
}

class _HkCardState extends State<HkCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: widget.color,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  widget.onDelete();
                },
              ),
          ],
        ),
      ),
    );
  }
}
