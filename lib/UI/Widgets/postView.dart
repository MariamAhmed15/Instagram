import 'package:flutter/material.dart';
import 'package:instagram/Data/postModel.dart';

class PostViewWidget extends StatefulWidget {
  final Post post;

  const PostViewWidget({super.key, required this.post});

  @override
  State<PostViewWidget> createState() => _PostViewWidgetState();

}

class _PostViewWidgetState extends State<PostViewWidget> {

  bool isLiked = false;
  int likes = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
            backgroundImage: NetworkImage(widget.post.profImage),
    ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.post.username,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(height: 3),
        Container(
          width: 390,
          height: 390,
          decoration: BoxDecoration(shape: BoxShape.rectangle),
          child: InkWell(
            onDoubleTap: () {
              setState(() {
                isLiked = !isLiked;
                if (isLiked == true) {
                 widget.post.likes++;
                } else if (isLiked == false) {
                  widget.post.likes--;
                }
              });
            },
            child: Image.network(
              widget.post.postUrl
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                  if (isLiked == true) {
                    widget.post.likes++;
                  } else if (isLiked == false) {
                    widget.post.likes--;
                  }
                });
              },
              icon: isLiked
                  ? Icon(
                Icons.favorite,
                color: Colors.red,
              )
                  : Icon(Icons.favorite_outline_rounded),
            ),
            Text(
              "${widget.post.likes} Likes",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text(
                "${widget.post.username}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "${widget.post.description} ",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}







