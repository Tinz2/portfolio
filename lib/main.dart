import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI APPLICATION',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'BMI APPLICATION'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const TextStyle mainTextStyle = TextStyle(
    color: Color.fromARGB(255, 12, 12, 12),
    fontSize: 18,
  );
  static const TextStyle titleTextStyle = TextStyle(
    color: Color.fromARGB(255, 14, 14, 14),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  final TextEditingController weightText = TextEditingController();
  final TextEditingController heightText = TextEditingController();
  String bmiResult = '';
  String bmiStatus = '';
  String imagePath = '';

  void calculateBMI() {
    String weight = weightText.text;
    String height = heightText.text;

    double bmi = double.parse(weight) /
        ((double.parse(height) / 100) * (double.parse(height) / 100));

    String status;
    if (bmi < 18.5) {
      status = 'ผอมเกินไป';
      imagePath = 'assets/thin.jpg';
    } else if (bmi >= 18.5 && bmi < 25) {
      status = 'น้ำหนักปกติ';
      imagePath = 'assets/normal.png';
    } else if (bmi >= 25 && bmi < 30) {
      status = 'เริ่มละ';
      imagePath = 'assets/chubby.jpg';
    } else if (bmi >= 30 && bmi < 35) {
      status = 'อ้วน';
      imagePath = 'assets/fat.png';
    } else {
      status = 'อ้วนเกิน';
      imagePath = 'assets/oversize.jpg';
    }

    setState(() {
      bmiResult = 'ค่าดัชนีมวลกาย (BMI) ของคุณ คือ ${bmi.toStringAsFixed(2)}';
      bmiStatus = 'สถานะ: $status';
    });
  }

  void clearFields() {
    setState(() {
      weightText.clear();
      heightText.clear();
      bmiResult = '';
      bmiStatus = '';
      imagePath = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Image.asset('assets/logobmi.png'),
                ),
                Text(
                  'โปรแกรมคำนวณ BMI',
                  style: titleTextStyle,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        'กรุณากรอกน้ำหนัก:',
                        style: mainTextStyle,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: weightText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'น้ำหนัก (กรอกเป็นกิโลกรัม)',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.line_weight),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        'กรุณากรอกส่วนสูง:',
                        style: mainTextStyle,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: heightText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'ส่วนสูง (กรอกเป็นเซนติเมตร)',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.height),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        child: Text('คำนวณ BMI'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: clearFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        child: Text('ยกเลิก'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (imagePath.isNotEmpty)
                  Image.asset(
                    imagePath,
                    height: 200,
                  ),
                Text(
                  bmiResult,
                  style: mainTextStyle,
                ),
                Text(
                  bmiStatus,
                  style: mainTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
