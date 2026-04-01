import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:flutter_food_log_app/views/add_food_ui.dart';
import 'package:flutter_food_log_app/views/update_del_food_ui.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  //สร้างตัวแปรเพื่อเก็บข้อมูลที่จะนำไปแสดงใน ListView ในส่วนของ body
  List<Food> foods = [];
  //สร้าง object/instance ของ SupabaseService
  final service = SupabaseService();
  //สร้างเมธอดสำหรับการดึงข้อมูลทั้งหมดจาก Supabase
  void loadAllFoods() async {
    //เรียกใช้ฟังก์ชัน getAllFoods จาก SupabaseService
    final data = await service.getAllFoods();
    setState(() {
      //เก็บข้อมูลที่ได้จากฟังก์ชัน getAllFoods ไว้ในตัวแปร foods
      foods = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 88, 232),
        title: Text(
          'กินแซ๊บบบ LOG',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            //ส่วนแสดง logo
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            //ส่วนแสดงชื่อรายการกินทั้งหมดที่บันทึกไว้ใน Supabase
            Expanded(
              child: ListView.builder(
                //จำนวนรายการที่จะแสดงใน ListView
                itemCount: foods.length,
                //สร้างแต่ละรายการใน ListView
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 5,
                      bottom: 5,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => UpdateDelFoodUi(
                              food: foods[index],
                            )))
                            .then((value) {loadAllFoods();});
                           
                        
                      },
                      leading: Image.asset(
                        'assets/images/food_img.png'),
                      title: Text(
                        'กิน ${foods[index].foodName}',
                      ),
                      subtitle: Text(
                        'วันที่ ${foods[index].foodDate} มื้อ ${foods[index].foodMeal} ราคา ${foods[index].foodPrice} บาท จำนวน ${foods[index].foodPerson} คน',
                      ),
                      trailing: Icon(
                        Icons.info,
                      color: Colors.red,
                      ),
                      tileColor:index % 2 == 0 ? Colors.blue[50] : Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => AddFoodUi()))
                .then((value) {loadAllFoods();});
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 242, 88, 232),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
