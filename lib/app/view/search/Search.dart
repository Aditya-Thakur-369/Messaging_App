// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/app/controller/search/bloc/search_bloc.dart';
import 'package:chat_app/app/model/user_model.dart';

class Search extends StatefulWidget {
  UserModel? userModel;
  Search({
    Key? key,
    this.userModel,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();
  List<Map> searchResult = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchUserNotFound) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is SearchError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is SearchLoaded) {
              searchResult = state.searchResult;
            }
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: "type username",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<SearchBloc>(context).add(
                              PerformSearchEvent(textEditingController.text));
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
                if (searchResult.isNotEmpty)
                  Expanded(
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: CircleAvatar(
                              // child: Image.network(searchResult[index]['image']),
                              ),
                          title: Text(searchResult[index]['name']),
                          subtitle: Text(searchResult[index]['email']),
                          trailing: const Icon(Icons.message),
                        ),
                      );
                    },
                    itemCount: searchResult.length,
                  ))
                else if (state is SearchLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          },
        ));
  }
}
