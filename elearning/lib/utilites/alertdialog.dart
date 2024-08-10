import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void Showerrordialog(BuildContext context,String ErrorTitle,String errortext,[String? callbackfunction,String? buttontitle]){
  showDialog(context: context, 
  builder:(context) {
    return AlertDialog(
      title: Text(ErrorTitle),
      content:  Text(errortext),
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