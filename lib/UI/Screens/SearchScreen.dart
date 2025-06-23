import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Logic/Cubit/searchCubit.dart';
import 'package:instagram/Logic/State/searchState.dart';
import 'package:instagram/UI/Widgets/searchResultsWidget.dart';
import 'dart:async';


class SearchScreen extends StatefulWidget {
  final SearchCubit searchCubit;
  const SearchScreen({Key? key, required this.searchCubit}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.searchCubit.searchUsers(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.searchCubit,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: TextField(
                onChanged: (value){
                  BlocProvider.of<SearchCubit>(context).searchUsers(value);
                },
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search users',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: IconButton(
                      icon:const Icon(Icons.search),
                    onPressed: (){},
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear,),
                    onPressed: () {
                      searchController.clear();
                      widget.searchCubit.searchUsers('');
                    },
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchSuccessState) {
                    return SearchResults(state.users);
                  } else if (state is SearchErrorState) {
                    return Center(child: Text('Error: ${state.errorMessage}',));
                  } else {
                    return const Center(child: Text('Start searching for users',));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
