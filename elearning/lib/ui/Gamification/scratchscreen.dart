import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scratcher/widgets.dart';
import 'package:elearning/services/scratchcard_service.dart';
import 'package:shimmer/shimmer.dart';

class ScratchCardScreen extends StatefulWidget {
  final String token;

  ScratchCardScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ScratchCardScreenState createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  late List<ScratchCard> scratchCards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScratchCards();
  }

  Future<void> fetchScratchCards() async {
    try {
      final scratchCardsData = await ScratchCardService.fetchScratchCards(widget.token);
      setState(() {
        scratchCards = scratchCardsData; // Assign the fetched data to scratchCards
        isLoading = false; // Set isLoading to false when data is loaded
      });
    } catch (e) {
      print('Error fetching scratch cards: $e');
      // Handle error
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Available scratch cards:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '${scratchCards.length}/3',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          isLoading ? _buildShimmerSkeleton() : _buildScratchCards(),
        ],
      ),
    );
  }

  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3, // Number of shimmer items
          (index) => Container(
            width: 100,
            height: 100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildScratchCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: scratchCards.map((card) => _buildScratchCard(card)).toList(),
    );
  }

  Widget _buildScratchCard(ScratchCard card) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // Scratch Card
          Scratcher(
            brushSize: 30,
            threshold: 50,
            color: Colors.blue,
            onChange: (value) {
              // Handle scratch progress change
            },
            onThreshold: () {
              if (card.point > 0) {
                // Display the point and point image
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Congratulations!'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('You won ${card.point} points!'),
                        Image.network(card.pointImage),
                      ],
                    ),
                  ),
                );
              } else {
                // Display better luck next time and point image
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Better Luck Next Time!'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Try again next time.'),
                        Image.network(card.pointImage),
                      ],
                    ),
                  ),
                );
              }
            },
            child: Container(
              color: Colors.white,
            ),
          ),
          // Scratch Image
          Positioned.fill(
            child: Image.network(
              card.scratchImage,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
