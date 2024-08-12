import 'package:flutter/material.dart';

// Method หลักที่ Run
void main() {
  runApp(const MyApp());
}

// Class state less สั่งแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALORIES APPLICATION',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(239, 245, 188, 2)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CALORIES APPLICATION'),
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ (เรียกใช้ State)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Map<String, Map<String, dynamic>> radioValues = {
  'ชาย': {'allcal': 2000, 'selected': false},
  'หญิง': {'allcal': 1600, 'selected': false},
};

// class state เขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมา คำนวณและส่งค่ากลับไปแสดงผล
class _MyHomePageState extends State<MyHomePage> {
  Map<String, Map<String, dynamic>> values2 = {
    'ราดหน้า': {'cal': 500, 'selected': false},
    'ข้าวมันไก่': {'cal': 600, 'selected': false},
    'ข้าวขาหมู': {'cal': 700, 'selected': false},
  };
  List<Map<String, dynamic>> extractedValues = [];
  String selectedText = "";
  List<Map<String, dynamic>> extractedValuesRadio = [];
  String selectedValueRadio = ''; // เพื่อเก็บค่าที่เลือก
  String selectedTextRadio = ''; // เพื่อเก็บข้อความที่เลือก
  int totalcal = 0;
  String showtotalcal = '';
  int remainingCalories = 0;
  String remainingCaloriesText = '';
  List<String> selectedFoods = []; // เพิ่มตัวแปรเพื่อเก็บรายการอาหารที่เลือก

  // เริ่มการจากการฟังก์ชันกำหนดค่าเริ่มต้นเพื่อนำจาก Map ไปแสดงผลที่ Checkbox ในฟังก์ชัน initState
  @override
  void initState() {
    super.initState();
    extractedValues = extractValues(values2);
    extractedValuesRadio = extractRadioValues(radioValues);
  }

  List<Map<String, dynamic>> extractRadioValues(
      Map<String, Map<String, dynamic>> values) {
    List<Map<String, dynamic>> result = [];
    values.forEach((key, value) {
      result.add({
        'name': key,
        'allcal': value['allcal'],
        'selected': value['selected']
      });
    });
    return result;
  }

  List<Map<String, dynamic>> extractValues(
      Map<String, Map<String, dynamic>> values2) {
    List<Map<String, dynamic>> result = [];
    values2.forEach((key, value) {
      result.add({
        'name': key,
        'cal': value['cal'],
        'selected': value['selected'],
      });
    });
    return result;
  }

  void updateSelectedTextRadio(String name, int allcal) {
    setState(() {
      selectedTextRadio = 'Selected: $name, Calories: $allcal';
    });
  }

  void updateSelectedText(String name, int cal, bool selected) {
    setState(() {
      values2[name]!['selected'] = selected;

      if (selected) {
        selectedFoods.add(name); // เพิ่มชื่ออาหารที่ถูกเลือกในลิสต์
        totalcal += cal; // เพิ่มแคลอรีของอาหารที่เลือก
      } else {
        selectedFoods.remove(name); // ลบชื่ออาหารที่ถูกยกเลิกเลือกออกจากลิสต์
        totalcal -= cal; // ลดแคลอรีของอาหารที่ยกเลิกเลือก
      }

      print(totalcal);

      extractedValues = extractValues(values2); // อัพเดทค่าจาก Map
    });
  }

  void calculateRemainingCalories() {
    int selectedCalories = 0;
    if (selectedValueRadio.isNotEmpty) {
      selectedCalories = radioValues[selectedValueRadio]?['allcal'] ?? 0;
    }
    remainingCalories = selectedCalories - totalcal;
    setState(() {
      selectedText = "อาหารที่เลือก: ${selectedFoods.join(', ')}";
      showtotalcal = totalcal.toString(); // แสดงค่าของแคลอรีที่รวมทั้งหมด
      remainingCaloriesText =
          'วันนี้ท่านยังสามารถบริโภคได้อีก $remainingCalories แคลอรี';
    });
  }

  void clearAllSelections() {
    setState(() {
      selectedValueRadio = '';
      selectedTextRadio = '';
      values2.forEach((key, value) {
        value['selected'] = false;
      });
      totalcal = 0; // Reset totalcal to 0
      selectedText = '';
      showtotalcal = '';
      remainingCalories = 0;
      remainingCaloriesText = '';
      selectedFoods.clear(); // ล้างรายการอาหารที่เลือก
      extractedValues = extractValues(values2); // อัพเดทค่าจาก Map
      values.updateAll((key, value) => false);
    });
  }

  Map<String, bool> values = {
    'ดูหนัง': false,
    'ฟังเพลง': false,
    'เล่นเกม': false,
    'เล่นกีฬา': false,
    'เล่นดนตรี': false,
  };

  String _getSelectedOptions() {
    List<String> selectedOptions = [];
    values.forEach((key, value) {
      if (value) {
        selectedOptions.add(key);
      }
    });
    if (selectedOptions.isEmpty) {
      return 'เลือกงานอดิเรกของคุณ';
    } else {
      return 'งานอดิเรกของคุณคือ:\n${selectedOptions.join(', ')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 238, 155, 1),
      ),
      body: Container(
        // เพิ่มพื้นหลัง
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bgkal2.jpg"), // ใส่ภาพพื้นหลัง
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // โลโก้ที่อยู่ด้านบน
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/logokal.png', // ที่อยู่ของโลโก้
                  width: 100,
                  height: 100,
                ),
              ),
              Column(
                // ดึงค่า value จาก Map มาแสดงที่ checkbox
                children: values.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: values[key],
                    onChanged: (bool? value) {
                      setState(() {
                        values[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
             Text(
            _getSelectedOptions(),
            textAlign: TextAlign.center, // จัดตำแหน่งให้อยู่ตรงกลาง
            style: TextStyle(fontSize: 18), // ขนาดตัวอักษร
          ),
              
              SizedBox(height: 20),
              // Radio Button สำหรับเพศ
              Column(
                children: extractedValuesRadio.map((item) {
                  return RadioListTile(
                    
                    title: Text(item['name']),
                    subtitle: Text('Calories: ${item['allcal']}'),
                    value: item['name'],
                    groupValue: selectedValueRadio,
                    onChanged: (value) {
                      setState(() {
                        selectedValueRadio = value;
                        updateSelectedTextRadio(item['name'], item['allcal']);
                      });
                    },
                  );
                }).toList(),
              ),

              // Checkbox สำหรับอาหาร
              Column(
                children: extractedValues.map((item) {
                  return CheckboxListTile(
                    title: Text(item['name']),
                    subtitle: Text('cal: ${item['cal']}'),
                    value: item['selected'],
                    onChanged: (bool? value) {
                      updateSelectedText(item['name'], item['cal'], value!);
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateRemainingCalories,
                child: Text('คำนวณแคลอรี'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: clearAllSelections,
                child: Text('เคลียร์'),
              ),
              SizedBox(height: 20),
              Text(selectedText),
              Text(showtotalcal),
              Text(remainingCaloriesText),
            ],
          ),
        ),
      ),
    );
  }
}
