import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatefulWidget {
  const ClassCard({
    Key? key,
    required this.nameClass,
    required this.giangvien,
    required this.semester,
    required this.onPressed,
    required this.onDelete,
    this.colorl = const Color(0xFF5DC4EA),
  }) : super(key: key);
  final String nameClass,giangvien,semester;
  final Color colorl;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
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
                    widget.nameClass ,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.giangvien,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.semester,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
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
