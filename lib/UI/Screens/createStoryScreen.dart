import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Logic/Cubit/storyCubit.dart';
import 'package:instagram/Logic/State/storyState.dart';

class createStoryScreen extends StatelessWidget {
  const createStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit()..getStories(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Create Story")),
        body: BlocConsumer<StoryCubit, StoryState>(
          listener: (context, state) {
            if (state is StoryErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
            if (state is StorySuccessState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is StoryLoadingState)
                    const CircularProgressIndicator()
                  else
                    InkWell(
                      onTap: () => context.read<StoryCubit>().uploadStory(),
                      child: const Text("Upload Story"),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
