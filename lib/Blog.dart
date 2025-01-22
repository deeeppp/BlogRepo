class Blog {
  final int id;
  final String title;
  final String content;
  final String author;

  Blog({required this.id, required this.title, required this.content, required this.author});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'author': author,
  };
}
