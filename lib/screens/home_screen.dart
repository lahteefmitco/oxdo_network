import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/models/post.dart';
import 'package:oxdo_network/providers/post_notifires.dart';
import 'package:oxdo_network/screens/add_post_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<PostNotifiers>().getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Post> posts = [];
    bool showProgressBar = false;
    String? errorMessage;

    return Consumer<PostNotifiers>(
      builder: (BuildContext context, PostNotifiers value, Widget? child) {
        posts = value.posts;
        for (var element in posts) {
          log(element.userId.toString());
        }
        showProgressBar = value.showProgressBar;
        errorMessage = value.error;

        if (errorMessage != null) {
          myCallBack(() {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(errorMessage!)));
          });
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPostScreen()));
                  myCallBack(() {
                    context.read<PostNotifiers>().getPosts();
                  });
                },
                child: const Icon(Icons.add),
              ),
              appBar: AppBar(
                title: const Text("Posts"),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (posts.isEmpty && !showProgressBar)
                    ? const Center(
                        child: Text(
                          "Empty Data",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          log(post.toString());
                          return ListTile(
                            tileColor: Colors.amber[100],
                            title: Text(post.title),
                            subtitle: Text(post.body),
                            leading: Text(
                              post.userId.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPostScreen(
                                          post: post,
                                        ),
                                      ),
                                    );
                                    myCallBack(() {
                                      context.read<PostNotifiers>().getPosts();
                                    });
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<PostNotifiers>()
                                        .deleteAPost(post.id);
                                  },
                                  style: IconButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: posts.length,
                      ),
              ),
            ),
            showProgressBar
                ? const CircularProgressIndicator()
                : const SizedBox()
          ],
        );
      },
    );
  }
}

void myCallBack(void Function() callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
