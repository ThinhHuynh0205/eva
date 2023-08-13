import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GvCard extends StatefulWidget {
  const GvCard({
    Key? key,
    required this.nameGV,
    required this.description,
    required this.onPressed,
    required this.onDelete,
    this.colorl = const Color(0xFF5DC4EA),
  }) : super(key: key);

  final String nameGV,description;
  final Color colorl;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  State<GvCard> createState() => _GvCardState();
}

class _GvCardState extends State<GvCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
            backgroundColor: widget.colorl,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nameGV,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 20),
                      IconButton(
                          onPressed: widget.onDelete,
                          icon: Icon(Icons.delete, color: Colors.white)
                      ),

                    ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
