import 'dart:async';
import 'dart:io';

import 'package:geolocation/geolocation.dart';

class TransVar{
  static bool sendqor = false;
  static StreamSubscription<LocationResult> streamSubscription;

  static File pickimg;
  static File picksign;

  static File delimg;
  static String delsign;
  static String qr;
  static String otp;

  static File retimg;
  static String retsign;

  static String fname;
  static String mname;
  static String contactno;
  static String lname;
  static String driveli;
  static String drivexp;
  static String pass;
  static String cpass;
  static String email;

  static String reloadme;

  static bool snacknot = true;

  static String driverid;

  static Timer timer;

  static String token = "";
  static String username = "";
  static String usermail = "";
  static String userli = "";
  static String plrid = "";
  static String expli = "";
  static String ones = "";
  static String myplate;

  static String accreload = "";

  static String delotp;

  //settings
  static String duty;
  static String autosave = "on";

  //today
  static bool floatvisi = false;

  static String mylatidute;
  static String mylongitude;
}
