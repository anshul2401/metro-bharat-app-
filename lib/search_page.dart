import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/Bookmark.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/Model/News.dart';
import 'package:news_app/NewsDetails.dart';
import 'package:news_app/widgets/search_widget.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class FilterNetworkListPage extends StatefulWidget {
  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<FilterNetworkListPage> {
  List<News> news = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final news = await BooksApi.getNews(query);

    setState(() => this.news = news);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Search News'),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final book = news[index];

                  return buildBook(book);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search News',
        onChanged: searchBook,
      );

  Future searchBook(String query) async => debounce(() async {
        final news = await BooksApi.getNews(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.news = news;
        });
      });
  updateHomePage() {
    setState(() {
      bookmarkList.clear();
      bookMarkValue.clear();
      // _getBookmark();
    });
  }

  List<News> newsList = [];
  Widget buildBook(News news) => GestureDetector(
        onTap: () {
          News model = news;
          List<News> recList = [];
          recList.addAll(newsList);
          recList.removeWhere((element) => element.id == news.id);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewsDetails(
                    model: model,
                    index: 1,
                    updateParent: updateHomePage,
                    id: model.id,
                    isFav: false,
                    isDetails: true,
                    news: recList,
                  )));
        },
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                news.image!,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              title: Text(
                news.title!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(book.author),
            ),
            Divider(),
          ],
        ),
      );
}

class BooksApi {
  static Future<List<News>> getNews(String query) async {
    var param = {
      ACCESS_KEY: access_key,
      LIMIT: perPage.toString(),
      OFFSET: '0',
      USER_ID: CUR_USERID != "" ? CUR_USERID : "0"
    };

    http.Response response = await http
        .post(Uri.parse(getNewsApi), body: param, headers: headers)
        .timeout(Duration(seconds: timeOut));

    if (response.statusCode == 200) {
      var news = json.decode(response.body);

      return (news['data'] as List)
          .map((json) => News.fromJson(json))
          .where((news) {
        final titleLower = news.title!.toLowerCase();
        final authorLower = news.desc!.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            authorLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
