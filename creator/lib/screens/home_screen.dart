import 'package:creator/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//参考サイト:https://zuma-lab.com/posts/flutter-nested-list

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("ホーム"),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: _buildDrawer(context),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          itemBuilder: _buildVerticalItem),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("ログアウト"),
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

  Widget _buildVerticalItem(BuildContext context, int verticalIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: SizedBox(
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "なんっでやねん",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "あかんやろ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildHorizontalItem(context, verticalIndex)
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalItem(BuildContext context, int verticalIndex) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, horiontalIndex) =>
            _buildHorizontalView(context, verticalIndex, horiontalIndex),
      ),
    );
  }

  Widget _buildHorizontalView(
      BuildContext context, int verticalIndex, int horiontalIndex) {
    final imageUrl =
        'https://source.unsplash.com/random/275x240?sig=$verticalIndex$horiontalIndex';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Image.network(imageUrl),
      ),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override

//   //TODO(PR_#9):サロン一覧の画面(概要)を作成する。
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text('ホーム'),
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       drawer: _buildDrawer(context),
//       body: Center(
//         child: ElevatedButton(
//           style: Theme.of(context).elevatedButtonTheme.style.copyWith(
//                 backgroundColor: MaterialStateProperty.all(Colors.white),
//                 foregroundColor: MaterialStateProperty.all(Colors.black),
//               ),
//           onPressed: () => {
//             print("ボタンが押された"),
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           ListTile(
//             title: Text("ログアウト"),
//             onTap: () async {
//               await FirebaseAuth.instance.signOut();
//               await Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return LoginScreen();
//                   },
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

