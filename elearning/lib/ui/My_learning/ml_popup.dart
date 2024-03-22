
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MLPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Details',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              IconButton(
                icon: Icon(Icons.info,size: 18.0,),
                onPressed: () {
                  // Handle information icon tap
                },
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            'Course Title',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          LinearProgressIndicator(
            value: 0.3, // Change the value based on the progress
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 10.0),
          Text(
            'Course Description',
            style: TextStyle(fontSize: 16.0),
          ),Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',style: TextStyle(
                  fontSize: 13.0,
                ),),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 2.0),
                      Text('Start Date'),
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 5.0),
                      Text('End Date'),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 5.0),
                      Text('Duration: 3 weeks'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
      icon: FaIcon(FontAwesomeIcons.save, color: Colors.black,), 
      onPressed: () { print("Pressed"); }
     ),
              IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
      icon: FaIcon(FontAwesomeIcons.close, color: const Color.fromARGB(255, 249, 2, 2),),
      onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor:Color.fromARGB(255, 180, 152, 152) ),
     
                
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle Video Camera button tap
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 180, 152, 152),
                ),
                child: Icon(Icons.videocam),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

