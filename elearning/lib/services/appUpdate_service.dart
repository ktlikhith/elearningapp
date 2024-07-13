import 'dart:ffi';

class AppupdateService {

 updatechek() async {
  String version="0.1.1";
  String update_link="http://www.google.com";
  String updatestatus = Array(2) as String;
  updatestatus=["0.1.1","http://www.google.com"] as String;

  return (updatestatus);

}

}