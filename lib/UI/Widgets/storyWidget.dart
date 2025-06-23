import 'package:flutter/material.dart';
import 'package:instagram/UI/Widgets/storyView.dart';

Widget storyWidget() {
  List<Map<String, String>> stories = [
    {"username": "mahmoud", "image": "https://i.pravatar.cc/150?img=1"},
    {"username": "amira", "image": "https://i.pravatar.cc/150?img=2"},
    {"username": "samy", "image": "https://i.pravatar.cc/150?img=3"},
    {"username": "ahmed", "image": "https://i.pravatar.cc/150?img=4"},
    {"username": "malak", "image": "https://i.pravatar.cc/150?img=5"},
    {"username": "Ali", "image": "https://i.pravatar.cc/150?img=6"},

  ];

  return SizedBox(
    height: 110,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryView(
                        storyUrls: [
                          'https://img.freepik.com/free-photo/closeup-scarlet-macaw-from-side-view-scarlet-macaw-closeup-head_488145-3540.jpg?semt=ais_hybrid&w=740',
                          'https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp',
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.orange,
                        Colors.red,
                        Colors.yellow,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(story['image']!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                story['username']!,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    ),
  );
}
