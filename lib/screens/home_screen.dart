

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
    final postNotifiers = context.read<PostNotifiers>();
    postNotifiers.getPosts();

    // To show snackbar
    postNotifiers.showSnackBar = (value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value)));
    };
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    List<Post> posts = [];
    bool showProgressBar = false;

    return Consumer<PostNotifiers>(
      builder: (BuildContext context, PostNotifiers value, Widget? child) {
        posts = value.posts;

        showProgressBar = value.showProgressBar;

        return Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _navigate(context, null);
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
                // Condition to show Empty data message on screen
                    ? const Center(
                        child: Text(
                          "Empty Data",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      )

                      // Showing listview
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final post = posts[index];
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
                                  onPressed: () {
                                    // To edit
                                    _navigate(context, post);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {

                                    // To delete
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

  void _navigate(BuildContext context, Post? post) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPostScreen(
                  post: post,
                )));

    if (!context.mounted) return;
    context.read<PostNotifiers>().getPosts();
  }
}


