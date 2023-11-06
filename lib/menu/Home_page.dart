import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'account_page.dart';
import 'menu_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> fetchData() async {
    var url = Uri.parse('http://192.168.193.38:8080/api/timetable/get/all');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางเวลา'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                            'รหัสวิชา: ${snapshot.data![index]["subject"]["subjectId"]}'),
                        Text(
                            'ชื่อวิชา: ${snapshot.data![index]["subject"]["name"]}'),
                        Text(
                            'อาจารย์ผู้สอน: ${snapshot.data![index]["subject"]["lecturer"]["name"]}'),
                        Text(
                            'เวลาเริ่มต้น: ${snapshot.data![index]["subject"]["startTime"]}'),
                        Text(
                            'เวลาสิ้นสุด: ${snapshot.data![index]["subject"]["endTime"]}'),
                        Text('วัน: ${snapshot.data![index]["subject"]["day"]}'),
                        SizedBox(height: 10),
                        Text(
                            'ชื่อผู้ใช้: ${snapshot.data![index]["user"]["name"]}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'เมนู',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'บัญชี',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
