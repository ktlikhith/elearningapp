import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void Showerrordialog(BuildContext context,String ErrorTitle,String errortext,[String? callbackfunction,String? buttontitle]){
  showDialog(context: context, 
  builder:(context) {
    return AlertDialog(
      title: Center(child: Text(ErrorTitle,style: TextStyle(fontWeight: FontWeight.bold))),
      content:  Text(errortext,style: TextStyle(fontWeight: FontWeight.bold),),
      actions: [
        if(callbackfunction!=null)
             TextButton(
          onPressed:()=> callbackfunction,
           child: Text(buttontitle!),),
        
        
          TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Close'),),
      ],
    );
    
  },);
}