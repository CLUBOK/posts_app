import 'package:postsapp/protocol/protocol.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class PlaceholderService {

  static const BASE_URL = "https://jsonplaceholder.typicode.com";


  static Future<List<PostObj>> getPosts() async {

    List<PostObj> listModel = [];
    Response response = await http.get(BASE_URL + "/posts");
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for(var obj in data){
        listModel.add(PostObj.fromJson(obj));
      }
    }
    return listModel;
  }

  static Future<List<CommentObj>> getComments(int postId) async {

    List<CommentObj> listModel = [];
    Response response = await http.get(BASE_URL + "/comments?postId=" + postId.toString());
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for(var obj in data){
        listModel.add(CommentObj.fromJson(obj));
      }
    }
    return listModel;
  }
}