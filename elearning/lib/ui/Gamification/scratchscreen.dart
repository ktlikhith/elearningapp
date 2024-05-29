import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:elearning/services/scratchcard_service.dart';
import 'package:elearning/services/gamepoints_service.dart';

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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Available scratch cards:',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
          ),
          Text(
            '${scratchCards.length}/${scratchCards.length}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.02),
          isLoading ? _buildShimmerSkeleton(screenWidth) : _buildScratchCards(screenWidth),
        ],
      ),
    );
  }

  Widget _buildShimmerSkeleton(double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3, // Number of shimmer items
          (index) => Container(
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildScratchCards(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: scratchCards.map((card) => _buildScratchCard(screenWidth, card)).toList(),
    );
  }

  Widget _buildScratchCard(double screenWidth, ScratchCard card) {
    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
      child: Stack(
        children: [
          // Scratch Card
          Scratcher(
            brushSize: screenWidth * 0.06,
            threshold: 100,
            image: Image.network(card.scratchImage), // Set the scratch image directly
            onChange: (value) {
              // Handle scratch progress change
            },
            onThreshold: () async {
              try {
                // Call RewardPointService to add reward points
                await RewardPointService().addReward(
                  token: widget.token,
                  type: 'scratchcard', // Set the type to 'scratch'
                  points: card.point, // Pass the points from the scratch card
                );
                // Display the point and point image
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Container(
                      // You can set width and height if you want to control the size of the dialog
                      child: Image.network(
                        card.pointImage,
                        fit: BoxFit.cover, // This will ensure the image fits well in the dialog
                      ),
                    ),
                  ),
                );
              } catch (e) {
                // Handle error if needed
                print('Error adding reward points: $e');
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to add reward points. Please try again later.'),
                  ),
                );
              }
            },
            child: Image.network(
              card.pointImage,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
