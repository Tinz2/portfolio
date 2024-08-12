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
  int totalcal = 0;  // แก้ไขตรงนี้
  String showtotalcal = '';
  int remainingCalories = 0;
  String remainingCaloriesText = '';

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
      calculateRemainingCalories();
    });
  }

  void updateSelectedText(String name, int cal) {
    List<String> selectedItems = [];    
    totalcal += cal; // เพิ่มค่าของแคลอรีแทนการรีเซ็ตเป็น 0

    // ตรวจสอบว่าค่าของ name ใน values2 ไม่เป็น null
    if (values2[name] != null) {
        values2[name]!['selected'] = true; // แก้สถานะให้ถูกเลือก
    }

    extractedValues = extractValues(values2); // อัพเดทค่าจาก Map

    selectedItems.add(name); // เพิ่มชื่ออาหารที่ถูกเลือกในลิสต์

    String selectedItemsText = selectedItems.join(", ");
    showtotalcal = totalcal.toString(); // แสดงค่าของแคลอรีที่รวมทั้งหมด

    setState(() {
        selectedText = "อาหารที่เลือก: $selectedItemsText";
        calculateRemainingCalories(); // คำนวณแคลอรีที่เหลือ
    });
}


  Map<String, bool> values = {
    'ดูหนัง': false,
    'ฟังเพลง': false,
    'เล่นเกม': false,
  };

  String _getSelectedOptions() {
    List<String> selectedOptions = [];
    values.forEach((key, value) {
      if (value) {
        selectedOptions.add(key);
      }
    });
    if (selectedOptions.isEmpty) {
      return 'No options selected';
    } else {
      return 'Selected: ${selectedOptions.join(', ')}';
    }
  }

  void calculateRemainingCalories() {
    int selectedCalories = 0;
    if (selectedValueRadio.isNotEmpty) {
      selectedCalories = radioValues[selectedValueRadio]?['allcal'] ?? 0;
    }
    remainingCalories = selectedCalories - totalcal;
    setState(() {
      remainingCaloriesText =
          'วันนี้ท่านยังสามารถบริโภคได้อีก $remainingCalories แคลอรี';
    });
  }

  void clearAllSelections() {
    setState(() {
      selectedValueRadio = '';
      selectedTextRadio = '';
      extractedValues.forEach((item) {
        item['selected'] = false;
      });
      totalcal = 0; // Reset totalcal to 0
      selectedText = '';
      showtotalcal = '';
      remainingCalories = 0;
      remainingCaloriesText = '';
      // Clear Checkbox values for "ดูหนัง", "ฟังเพลง", "เล่นเกม"
      values.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromARGB(255, 238, 183, 1),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Widgets เก่าที่ทำไว้แล้ว
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
              Text(_getSelectedOptions()),
              SizedBox(
                height: 20,
              ),
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
              Column(
                children: extractedValues.map((item) {
                  return CheckboxListTile(
                    title: Text(item['name']),
                    subtitle: Text('cal: ${item['cal']}'),
                    value: item['selected'],
                    onChanged: (bool? value) {
                      setState(() {
                        item['selected'] = value!;
                        updateSelectedText(item['name'], item['cal']);
                      });
                    },
                  );
                }).toList(),
              ),
              Text(selectedText),
              Text(showtotalcal),
              Text(selectedTextRadio),
              ElevatedButton(
                onPressed: calculateRemainingCalories,
                child: Text('คำนวณแคลอรี'),
              ),
              ElevatedButton(
                onPressed: clearAllSelections,
                child: Text('เคลียร์'),
              ),
              Text(remainingCaloriesText),
            ],
          ),
        ));
  }
}
