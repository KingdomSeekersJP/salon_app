import 'package:creator/common/color_filters.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:creator/widgets/carousel_with_dot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final List<String> imgCarouselList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1506355683710-bd071c0a5828?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'
];

final List<String> titleList = [
  'マタイ6・33',
  '箴言6・9-11',
  'イザヤ53・4',
  '伝道10・17',
  '箴言1・7'
];

final List<String> subList = [
  '空白',
  '怠け者よ、いつまで寝ているのか。いつ目を覚まして起き上がるのか。少し眠り、少しまどろみ、少し腕を組んで、横になる。すると、付きまとう者のように貧しさが、武装した者のように乏しさがやって来る。',
  '空白',
  '幸いなことよ、あなたのような国は。王が貴族の出であり、高官たちが、酔うためではなく力をつけるために、定まった時に食事をする国は。',
  '空白'
];

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int carouselCellCount = 1;
  int listCellCount = titleList.length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('ホーム'),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: _buildDrawer(
        context,
      ),
      body: ListView.builder(
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return CarouselWithDotsPage(
              imgList: imgCarouselList,
            );
          } else if (index % 2 == 0) {
            return buildImageCardOne(
              index - 1,
            );
          } else if (index % 2 == 1) {
            return buildImageCardTwo(
              index - 1,
            );
          }
        },
        itemCount: listCellCount + carouselCellCount,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('ログアウト'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildImageCardOne(int index) => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            24,
          ),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Ink.image(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1327&q=80',
              ),
              colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {},
              ),
              height: 240,
              fit: BoxFit.cover,
            ),
            _decolorationOfCardTextMessage(
              index,
            ),
          ],
        ),
      );

  Widget _decolorationOfCardTextMessage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 24,
        ),
        Center(
          child: _mainMessageOfSalonTopic(index),
        ),
        SizedBox(
          height: 50,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(
              12.0,
            ),
            child: _subMessageOfSalonTopic(index),
          ),
        ),
      ],
    );
  }

  Widget _mainMessageOfSalonTopic(int index) {
    return Text(
      titleList[index],
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _subMessageOfSalonTopic(int index) {
    return Text(
      subList[index],
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 8,
      ),
    );
  }

  Widget buildImageCardTwo(int index) => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            24,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1327&q=80',
              ),
              child: InkWell(
                onTap: () {},
              ),
              height: 240,
              fit: BoxFit.cover,
            ),
            Text(
              titleList[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      );
}
