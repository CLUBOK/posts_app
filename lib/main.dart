import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postsapp/protocol/protocol.dart';

import 'api/placeholder_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PostsPage(),
    );
  }
}

















class PostsPage extends StatefulWidget {
  PostsPage({Key key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POSTS"),
      ),
      body: FutureBuilder(
          future: PlaceholderService.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<PostObj> list = snapshot.data;
              return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (BuildContext context, int index) => Divider( height: 3, color: Colors.black),
                  itemBuilder: (BuildContext context, int index) {
                    PostObj postObj = list[index];
                    return InkWell(
                      child: PostItem(postObj),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentPage(postId: postObj.id)),
                        );
                      },
                    );
                  }
              );
            }
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}


class PostItem extends StatelessWidget {

  final PostObj postObj;
  PostItem(this.postObj);

  @override
  Widget build(BuildContext context) {

    return Hero(
      tag: postObj.id,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(postObj.title, style: Theme.of(context).textTheme.bodyText1,),
          ),
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(postObj.body, style: Theme.of(context).textTheme.bodyText2,)),
        ],
      ),
    );
  }
}









class CommentPage extends StatefulWidget {
  CommentPage({Key key, this.postId}) : super(key: key);
  final int postId;

  @override
  _CommentPage createState() => _CommentPage(postId);
}

class _CommentPage extends State<CommentPage> {

  final int postId;
  _CommentPage(this.postId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COMMENTS"),
      ),
      body: Hero(
        tag: postId,
        child: FutureBuilder(
            future: PlaceholderService.getComments(postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<CommentObj> list = snapshot.data;
                return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (BuildContext context, int index) => Divider( height: 3, color: Colors.black),
                    itemBuilder: (BuildContext context, int index) {
                      return CommentItem(list[index]);
                    }
                );
              }
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}


class CommentItem extends StatelessWidget {

  final CommentObj comment;
  CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(comment.email, style: Theme.of(context).textTheme.bodyText1,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(comment.body, style: Theme.of(context).textTheme.bodyText2,),
        ),
      ],
    );
  }

}