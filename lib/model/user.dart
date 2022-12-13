import 'package:flutter/material.dart';

class User {
  //att

  
   final String username;
   final String adress;
   final String wallet;
   final String _id;
 

  //constuctor
  User(this._id, this.username, this.adress, this.wallet);

   getid() { 
    return _id;
   }

 
}
