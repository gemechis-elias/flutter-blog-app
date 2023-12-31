import 'dart:developer';
import 'dart:io';

import 'package:blog_app/features/blog/domain/entities/article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../blocs/add_bookmark/bloc/add_bookmark_event.dart';
import '../blocs/bloc.dart';
import '../blocs/delete_blog/delete_blog_event.dart';
import '../blocs/get_bookmarks/bloc/get_bookmark_event.dart';
import '../blocs/get_bookmarks/bloc/get_bookmark_state.dart';
import '../widgets/MiniBlogInfo.dart';
import '../widgets/inputForm.dart';

class ViewBlog extends StatefulWidget {
  final Article article;
  final String fullName;

  const ViewBlog({super.key, required this.article, required this.fullName});

  @override
  State<ViewBlog> createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  List<Article> articles = [];
  bool _isDisposed = false; // Flag to track widget disposal
  bool is_bookmarked = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(GetBookmarksEvent());
    context.read<BlogBloc>().stream.listen((state) {
      if (!_isDisposed) {
        if (state is BookmarkLoading) {
          log("Loading Bookmark..");
        }
        if (state is LoadedBookmarksState) {
          log("Bookmark Blogs are fetched ${state.article}");
          setState(() {
            articles = state.article;
            // iterate through articles and find widget.article.id make is_bookmarked true if exist
            for (Article article in articles) {
              bool check = articles.any(
                  (bookmarkArticle) => bookmarkArticle.id == widget.article.id);

              is_bookmarked = check;
            }
          });
        }
        if (state is BookmarkError) {
          log("Error ${state.errorMessage}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFF8FAFF),
        foregroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              size: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0XFFF8FAFF),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Column(
                        children: [
                          Text(
                            widget.article.title!,
                            maxLines: 3,
                            style: const TextStyle(
                                color: Color(0xFF0D253C),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: "poppins"),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 15, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    MiniBlogInfo(object: widget.article),
                                  ],
                                ),
                                //bookmark icon here
                                widget.article.user?.fullName! !=
                                        widget.fullName
                                    ? is_bookmarked
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                is_bookmarked = false;
                                              });
                                              context.read<BlogBloc>().add(
                                                    AddBookmarkEvent(
                                                      title: widget.article
                                                          .user!.fullName!,
                                                      content: widget
                                                          .article.content!,
                                                      image: File(widget
                                                          .article.content!),
                                                      subTitle: widget
                                                          .article.subTitle!,
                                                      tags: widget
                                                          .article.tags![0],
                                                    ),
                                                  );
                                            },
                                            icon: const Icon(
                                              Icons.bookmark_rounded,
                                              color: Color(0xff376AED),
                                              size: 24,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                is_bookmarked = true;
                                              });
                                              context.read<BlogBloc>().add(
                                                    AddBookmarkEvent(
                                                      title: widget.article
                                                          .user!.fullName!,
                                                      content: widget
                                                          .article.content!,
                                                      image: File(widget
                                                          .article.content!),
                                                      subTitle: widget
                                                          .article.subTitle!,
                                                      tags: widget
                                                          .article.tags![0],
                                                    ),
                                                  );
                                            },
                                            icon: const Icon(
                                              Icons.bookmark_outline,
                                              color: Color(0xff376AED),
                                              size: 24,
                                            ))
                                    : GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Are you sure you want to delete this article?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel")),
                                                    TextButton(
                                                        onPressed: () {
                                                          //delete article DeleteBlogEvent
                                                          context
                                                              .read<BlogBloc>()
                                                              .add(DeleteBlogEvent(
                                                                  id: widget
                                                                      .article
                                                                      .id!));
                                                          // if state is deleted then show deleted red bg snackbar and pop
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                "Article Deleted",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          );

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Delete")),
                                                  ],
                                                );
                                              });
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color(0xff376AED),
                                          size: 24,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          const Text("")
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 219,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: widget.article.image != null
                          ? CachedNetworkImage(
                              key: Key(widget.article.image!),
                              imageUrl: widget.article.image!,
                              height: 140,
                              width: 130,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => SkeletonItem(
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF222222),
                                        Color(0xFF242424),
                                        Color(0xFF2B2B2B),
                                        Color(0xFF242424),
                                        Color(0xFF222222),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Image.asset(
                              "assets/images/no_image.jpg",
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                      child: Column(
                        children: [
                          Text(
                              style: const TextStyle(
                                color: Color(0xff2D4379),
                                fontFamily: "Poppins",
                                fontSize: 16,
                              ),
                              widget.article.content!)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 111,
        height: 48,
        decoration: BoxDecoration(
            color: const Color(0xff376AED),
            border: Border.all(
              // width: 2,
              color: const Color(0xff376AED),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        //like button icon
        padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up_off_alt,
              color: Colors.white,
            ),
            Text(
              "2.1k",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
