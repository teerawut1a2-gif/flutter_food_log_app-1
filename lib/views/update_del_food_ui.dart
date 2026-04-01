import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:intl/intl.dart';
 
class UpdateDelFoodUi extends StatefulWidget {
  //สร้างตัวแปรเพื่อรับข้อมูลของรายการอาหารที่ต้องการแก้ไข/ลบจากหน้าจอ ShowAllFoodUi
  Food? food;
 
  //เอาตัวแปรที่สร้างมารับค่า
  UpdateDelFoodUi({super.key, this.food});
  @override
  State<UpdateDelFoodUi> createState() => _UpdateDelFoodUiState();
}
 
class _UpdateDelFoodUiState extends State<UpdateDelFoodUi> {
  //ตัวควบคุม TextField
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();
 
  //เก็บข้อมูลมื้ออาหารที่เลือก
  String foodMeal = 'เช้า';
 
  //เก็บข้อมูลวันที่ที่กิน
  DateTime? foodDate;
 
  //เปิดปฏิทินให้ผู้ใช้เลือกวันที่ ใน foodDate ที่ Create กับ result บน TextField
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
 
    if (picked != null) {
      setState(() {
        foodDate = picked;
 
        foodDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
 
 @override
  void initState() {

    super.initState();
   foodNameCtrl.text = widget.food!.foodName ;
   foodPriceCtrl.text = widget.food!.foodPrice.toString();
   foodPersonCtrl.text = widget.food!.foodPerson.toString() ;
   foodDateCtrl.text = widget.food!.foodDate ;
   foodMeal = widget.food!.foodMeal ;
   foodDate = DateTime.parse(widget.food!.foodDate) ;
  }
 //เมธอดบันทึกข้อมูลแก้ไข
 void editFood() async {
  //Validation
  if (foodNameCtrl.text.isEmpty ||
        foodPriceCtrl.text.isEmpty ||
        foodPersonCtrl.text.isEmpty ||
        foodDateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
          'กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }


  //แพ็คข้อมูลที่จะส่งไปแก้ไขใน Supabase
  Food food = Food(
      foodName: foodNameCtrl.text,
      foodMeal: foodMeal,
      foodPrice: double.parse(foodPriceCtrl.text),
      foodPerson: int.parse(foodPersonCtrl.text),
      foodDate: foodDate!.toIso8601String(),
    );

  //เรรียกใช้เมธอดแก้ไขข้อมูลใน Supabase ผ่านทาง SupabaseService
    final service = SupabaseService();
    await service.updateFood(widget.food!.id!, food);


  //แจ้งผลทำงาน 
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

  //ย้อนกลับไปหน้าที่เปิดมา
   Navigator.pop(context);


 }

  //เมธอดลบข้อมูล
  Future<void> delFood() async {
    //แสดง Dialog เพื่อยืนยันการลบข้อมูลผู้ใช้ก่อนลบจริง
    await showDialog(
      context: context,
      //หน้าต่าง Dialog
      builder: (context) => AlertDialog(
      //หัวข้อของ Dialog
        title: Text('ยืนยันการลบข้อมูล'),
        //ข้อความเนื้อหาใน Dialog
        content: Text('คุณต้องการลบข้อมูลนี้จริงหรือไม่?'),
        //ปุ่มคำสั่งต่างๆ ใน Dialog
       actions: [
            //ปุ่มยกเลิกเพื่อปิด Dialog โดยไม่ทำอะไร
            ElevatedButton(
              onPressed: () {
                //ปิด Dialog
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('ยกเลิก',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
//ปุ่มยืนยันการลบข้อมูลออกจาก Supabase ผ่านทางSupabaseService
            ElevatedButton(
              onPressed: () async {
                //เรียกใช้ฟังก์ชัน deleteFood จาก SupabaseService
                final service = SupabaseService();
                await service.deleteFood(widget.food!.id!);

                //แสดงผลการทำงาน
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                //ปิด Dialog
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'ยืนยันลบข้อมูล',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
      ),
    );

          
         

            
                   

  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 88, 232),
        title: Text(
          'กินแซ๊บบบบบแซ่บ LOG (แก้ไข/ลบรายการ)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
      ),
         body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Center(
            child: Column(
              children: [
                // ส่วนแสดง Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                // ป้อนกินอะไร
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น KFC, Pizza',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกกินมื้อไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เช้า';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'เช้า' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(
                        'เช้า',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'กลางวัน';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'กลางวัน' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(
                        'กลางวัน',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เย็น';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'เย็น' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(
                        'เย็น',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'ว่าง';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'ว่าง' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(
                        'ว่าง',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // ป้อนกินไปเท่าไหร่
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ทั้งหมดกี่บาท',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 299.50',
                  ),
                ),
                SizedBox(height: 20),
                // ป้อนกินกันกี่คน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกันกี่คน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 3',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกกินไปวันไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปวันไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodDateCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 2020-01-31',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    //เปิดปฏิทินให้ผู้ใช้เลือกวันที่
                    pickDate();
                    //แสดงที่ TextField
                    foodDateCtrl.text = DateFormat('yyyy-MM-dd')
                        .format(foodDate ?? DateTime.now());
                  },
                ),
                SizedBox(height: 20),
                // ปุ่มบันทึก
                ElevatedButton(
                  onPressed: () {
                    editFood()  ;
 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text("บันทึกแก้ไข",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: 10),
                // ปุ่มลบ
                ElevatedButton(
                  onPressed: () {
                    delFood().then((value){
                      //เมื่อลบข้อมูลเสร็จแล้วให้ย้อนกลับไปหน้าที่ showAllFoodUi
                      Navigator.pop(context);

                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text("ลบข้อมูล",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}