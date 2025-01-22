import 'package:flutter/material.dart';
import './Blog.dart';
import './ApiService.dart';
import 'AddEditScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Blog>> _blogList;

  @override
  void initState() {
    super.initState();
    _blogList = _apiService.fetchBlogs();
  }

  void _refreshBlogs() {
    setState(() {
      _blogList = _apiService.fetchBlogs();
    });
  }

  void _showDeleteDialog(BuildContext context, Blog blog) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Blog'),
          content: Text('Are you sure you want to delete this blog?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _apiService.deleteBlog(blog.id);
                _refreshBlogs();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PostBlogs"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshBlogs),
        ],
        backgroundColor: Colors.blueGrey,

      ),
      body: FutureBuilder<List<Blog>>(
        future: _blogList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No blogs available"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final blog = snapshot.data![index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(blog.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          blog.content, style: TextStyle(fontSize: 14, color: Colors.black87),
                          maxLines: 3, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text("-- By  ${blog.author}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () async {
                                  final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AddEditScreen(blog: blog),),
                                  );
                                  if (result == true) _refreshBlogs();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {_showDeleteDialog(context, blog);},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditScreen()),
          );
          if (result == true) _refreshBlogs();
        },
      ),
    );
  }
}
