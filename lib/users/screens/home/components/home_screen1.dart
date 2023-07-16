import 'package:flutter/material.dart';

import '../../../model/course.dart';
import 'course_card.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFF5DC4EA),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Text(
                            "123",
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){},
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF14AEE7),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Text(
                            "345",
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white,fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){},
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF69ADC9),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Text(
                            "456",
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white,fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){},
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF0891C4),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Text(
                            "678",
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white,fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
