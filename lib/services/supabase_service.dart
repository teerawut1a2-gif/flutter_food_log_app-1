//class นี้เป็นการจัดการข้อมูลต่างๆ ที่เกี่ยวข้องกับ Supabase
import 'package:flutter_food_log_app/models/food.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //สร้าง object/instance ของ SupabaseClient เพื่อใช้กับ Supabase
  final supabase = Supabase.instance.client;

//ส่วนของ Methods เพื่อใช้กับ Supabase
//เช่นการเพิ่ม...,การลบ...,การแก้ไข...ข้อมูลต่างๆ ที่เกี่ยวข้องกับ Supabase

// สร้างเมธอดสำหรับการดึงข้อมูลทั้งหมดจาก food_tb ใน Supabase
  Future<List<Food>> getAllFoods() async {
//ดึงข้อมูลทั้งหมดจากตาราง food_tb ใน Supabase
    final data = await supabase
        .from('food_tb')
        .select('*')
        .order('foodDate', ascending: false);
//แปลงข้อมูลที่ได้จาก Supabase ซึ่งเป็น JSON มาใช้ในแอปฯ แล้วส่งผลลัพธ์ไปยังหน้าที่เรียกใช้เมธอด
    return data.map<Food>((e) => Food.fromJson(e)).toList();
  }

// สร้างเมธอดสำหรับการเพิ่มข้อมูลใหม่ลงใน food_tb ใน Supabase
  Future insertFood(Food food) async {
    await supabase.from('food_tb').insert(food.toJson());
  }
  
// สร้างเมธอดสำหรับการแก้ไขข้อมูลใน food_tb ใน Supabase
  Future updateFood(String id, Food food) async {
    await supabase.from('food_tb').update(food.toJson()).eq('id', id);
  }

// สร้างเมธอดสำหรับการลบข้อมูลใน food_tb ใน Supabase
  Future deleteFood(String id) async {
    await supabase.from('food_tb').delete().eq('id', id);
  }
}
