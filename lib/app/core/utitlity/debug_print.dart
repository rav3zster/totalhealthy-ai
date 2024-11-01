



import 'package:flutter/foundation.dart';


const String black ="\x1B[30m";
const String red ="\x1B[31m";
const String green ="\x1B[32m";
const String yellow ="\x1B[33m";
const String blue ="\x1B[34m";
const String magenta ="\x1B[35m";
const String cyan ="\x1B[35m";
const String white ="\x1B[37m";
const String reset ="\x1B[0m";

void printDebug(String page,String lineNo,message){
  if(kDebugMode) {
    debugPrint("#####################################################");
    debugPrint("PAGE: $page");
    debugPrint("Line No/Type: $lineNo");
    debugPrint("Message :$message", wrapWidth: 1024);
    debugPrint("-----------------------------------------------------");
  }
}

void printSuccess(String page,String lineNo,message){
  if(kDebugMode) {
    debugPrint("$green#####################################################$reset");
    debugPrint("${green}SUCCESS PAGE: $page$reset");
    debugPrint("${blue}Line No/Type: $lineNo$reset");
    debugPrint("Message :$message", wrapWidth: 1024);
    debugPrint("$green-----------------------------------------------------$reset");
  }
}

void printError(String page,String lineNo,message){
  if(kDebugMode) {
    debugPrint("$red#####################################################$reset");
    debugPrint("${red}ERROR PAGE: $page$reset");
    debugPrint("${red}Line No/Type: $lineNo$reset");
    debugPrint("${red}Message :$message$reset", wrapWidth: 1024);
    debugPrint("$red-----------------------------------------------------$reset");
  }
}

void printInfo(String page,String lineNo,message){
  if(kDebugMode) {
    debugPrint("$yellow#####################################################$reset");
    debugPrint("${yellow}PAGE: $page$reset");
    debugPrint("${yellow}Line No/Type: $lineNo$reset");
    debugPrint("${blue}Message :$message$reset", wrapWidth: 1024);
    debugPrint("$yellow-----------------------------------------------------$reset");
  }
}

void printInfoS(message){
  if(kDebugMode) {
    debugPrint("${yellow}Message :$message$reset", wrapWidth: 1024);
  }
}