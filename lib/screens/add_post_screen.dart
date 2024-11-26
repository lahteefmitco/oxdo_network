import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/models/post.dart';
import 'package:oxdo_network/providers/add_post_notifiers.dart';
import 'package:oxdo_network/screens/home_screen.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  final Post? post;
  const AddPostScreen({super.key, this.post});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    myCallBack(() {
    context.read<AddPostNotifiers>().reset();
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    if (post != null) {
      _titleController.text = post.title;
      _bodyController.text = post.body;
      _userIdController.text = post.userId.toString();
      
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(post == null ? "Add Post" : "Edit Post"),
      ),
      body: Consumer<AddPostNotifiers>(
        builder: (context, value, child) {
          final showProgressBar = value.showProgressBar;
          final errorMessage = value.error;
          final isCompleted = value.addedCompleted;

          if (isCompleted) {
            myCallBack(() {
              Navigator.pop(context);
            });
          }

          if (errorMessage != null) {
            myCallBack(() {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(errorMessage)));
            });
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("User Id"),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter user id";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                            label: Text("Title"), border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          label: Text("Body"),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Save data
                            final title = _titleController.text.trim();
                            final body = _bodyController.text.trim();
                            final String userIdString =
                                _userIdController.text.trim();

                            final p = Post(
                              id: 0,
                              title: title,
                              body: body,
                              userId: int.tryParse(userIdString) ?? 0,
                            );

                            if (post == null) {
                              await context
                                  .read<AddPostNotifiers>()
                                  .addAPost(p);
                            } else {
                              final p = Post(
                              id: post.id,
                              title: title,
                              body: body,
                              userId: int.tryParse(userIdString) ?? 0,
                            );
                              context.read<AddPostNotifiers>().editAPost(p);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              post == null ? Colors.amber : Colors.blue,
                          foregroundColor:
                              post == null ? Colors.black : Colors.white,
                        ),
                        child:  Text(post==null ? "Save":"Edit"),
                      )
                    ],
                  ),
                ),
              ),
              if (showProgressBar) const CircularProgressIndicator()
            ],
          );
        },
      ),
    );
  }
}
