import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SvCard extends StatefulWidget {
  const SvCard({
    Key? key,
    required this.nameSV,
    required this.MSSV,
    required this.onPressed,
    required this.onDelete,
    this.colorl = const Color(0xFF5DC4EA),
  }) : super(key: key);

  final String nameSV,MSSV;
  final Color colorl;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  State<SvCard> createState() => _SvCardState();
}

class _SvCardState extends State<SvCard> {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nameSV,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.MSSV,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: widget.onDelete,
                icon: Icon(Icons.delete, color: Colors.white)
            )
          ],
        ),
      ),
    );
  }
}
