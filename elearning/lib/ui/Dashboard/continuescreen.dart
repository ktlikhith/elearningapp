import 'package:flutter/material.dart';

class ContinueWatchingItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String lastWatched;
  final Function onTap;

  const ContinueWatchingItem({
    Key? key, // Added the Key parameter
    required this.title,
    required this.imageUrl,
    required this.lastWatched,
    required this.onTap,
  }) : super(key: key); // Initialize the key parameter in the constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color for each list item
          borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Optional: Add box shadow
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0), // Padding on all sides
        margin: const EdgeInsets.all(8.0),
        child: Container(
          //margin: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Adjust top and bottom margins
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  width: 120.0,
                  height: 180.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Last watched: $lastWatched',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContinueWatchingScreen extends StatefulWidget {
  final List<ContinueWatchingItem> items;

  const ContinueWatchingScreen({Key? key, required this.items}) : super(key: key);

  @override
  _ContinueWatchingScreenState createState() => _ContinueWatchingScreenState();
}

class _ContinueWatchingScreenState extends State<ContinueWatchingScreen> {
  final ScrollController _scrollController = ScrollController();
  

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continue Watching'),
         backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
       body: Container(
        
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return widget.items[index];
          },
        ),
      ),
    
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: ContinueWatchingScreen(
//       items: List.generate(
//         5,
//         (index) => ContinueWatchingItem(
//           key: Key('item_$index'), // Provide a unique key for each item
//           title: 'Title $index',
//           imageUrl: 'https://via.placeholder.com/150',
//           lastWatched: '2 hours ago',
//           onTap: () {
//             print('Item $index tapped');
//           },
//         ),
//       ),
//     ),
//   ));
// }
