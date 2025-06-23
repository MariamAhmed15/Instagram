
import 'package:flutter/material.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/UI/Screens/ProfileScreen.dart';

Widget SearchResults(List<UserData> users) {
  if (users.isEmpty) {
    return const Center(child: Text('No users found', style: TextStyle(color: Colors.white)));
  }

  return ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, index) {
      final user = users[index];
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: user.profile_photo != null
              ? NetworkImage(user.profile_photo!)
              : const AssetImage('assets/default pic.jpg') as ImageProvider,
          child: user.profile_photo == null
              ? Text(user.username[0].toUpperCase(), style: const TextStyle(color: Colors.white))
              : null,
        ),
        title: Text(
          " ${user.username}",
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(user.name ?? '', style: TextStyle(color: Colors.grey[400])),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(userData: user),
          ));
        },
      );
    },
  );
}