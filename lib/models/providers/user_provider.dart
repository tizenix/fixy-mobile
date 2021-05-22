import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  dynamic user;
  dynamic serviceProvider;
  dynamic company;

  setUser(dynamic user) {
    this.user = user;
    notifyListeners();
  }

  setServiceProvider(dynamic serviceProvide) {
    this.serviceProvider = serviceProvide;
    notifyListeners();
  }

  setCompany(dynamic company) {
    this.company = company;
  }

  getUser() => user;
  getServiceProvider() => serviceProvider;
  getCompany() => company;
}
