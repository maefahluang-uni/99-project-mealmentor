import 'package:flutter/material.dart';
import 'package:mealmentor/models/connect_model.dart';
import 'package:flutter_svg/svg.dart';

class ConnectionPage extends StatefulWidget {
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  List<ConnectionModel> connection = [];

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  void _getInitialInfo() {
    setState(() {
      connection = ConnectionModel.getConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Automatic Tracking Connection',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/Arrow - Left 2.svg',
                height: 20,
                width: 20,
              ),
              decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            itemCount: connection.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: 25,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 40),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      connection[index].iconPath,
                      width: 50,
                      height: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          connection[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          connection[index].description,
                          style: TextStyle(
                            color: Color(0xff7B6F72),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 100,
                          child: Center(
                            child: Text(
                              'Connect',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xff9DCEFF),
                                Color(0xff92A3FD),
                              ]),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff1D1617).withOpacity(0.07),
                      offset: Offset(0, 10),
                      blurRadius: 40,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
