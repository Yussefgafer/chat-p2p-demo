import 'package:flutter/material.dart';

void main() => runApp(LegacyApp());

class LegacyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinix Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LegacyHomePage(),
    );
  }
}

class LegacyHomePage extends StatefulWidget {
  @override
  _LegacyHomePageState createState() => _LegacyHomePageState();
}

class _LegacyHomePageState extends State<LegacyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinix Hot 50I Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'مرحباً بك في تطبيق الاختبار',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'عدد النقرات:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            Text(
              'إذا ظهر هذا النص، فالتطبيق يعمل!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('نجح الاختبار!'),
                    content: Text('التطبيق يعمل بشكل صحيح على Infinix Hot 50I'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('حسناً'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('اختبار الحوار'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'زيادة',
        child: Icon(Icons.add),
      ),
    );
  }
}
