import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'contact.dart';

class HttpService {
  static const _serviceUrl = 'http://192.168.0.191/ksa/api.php';
  static final _headers = {'Content-Type': 'application/json'};
  String token = "";
  static final HttpService _singleton = HttpService._internal();
  factory HttpService() => _singleton;

  HttpService._internal();
  getHeaders() {
    return {'Content-Type': 'application/json', 'apitoken': this.token};
  }

  setToken(String token) {
    this.token = token;
  }

  String getToken() {
    return this.token;
  }

  Future<String> post(String table, String body, [String where]) async {
    var requestbody = {
      "method": "post",
      "table": table,
      "body": body,
      // "where": where != null ? where : ""
    };
    log(json.encode(requestbody));
    final response = await http.post(_serviceUrl,
        headers: getHeaders(), body: json.encode(requestbody));
    String c = response.body;
    return c;
  }

  Future<String> put(var body, String table, [String where]) async {
    var requestbody = {
      "method": "put",
      "table": table,
      "where": where != null ? where : ""
    };

    final response =
        await http.put(_serviceUrl, headers: getHeaders(), body: requestbody);
    String c = response.body;
    return c;
  }

  Future<String> delete(var body, String table, [String where]) async {
    var requestbody = {
      "method": "delete",
      "table": table,
      "where": where != null ? where : ""
    };
    final response =
        await http.post(_serviceUrl, headers: getHeaders(), body: requestbody);
    String c = response.body;
    return c;
  }

  Future<String> report(var body, String table,
      [String where, String order]) async {
    var requestbody = {
      "method": table,
      "where": where != null ? where : "",
      "order": order != null ? order : ""
    };

    final response =
        await http.post(_serviceUrl, headers: getHeaders(), body: requestbody);
    String c = response.body;
    return c;
  }

  Future<String> get(var body, String table, [String where]) async {
    var requestbody = {
      "method": "get",
      "table": table,
      "where": where == null ? where : ""
    };

    final response =
        await http.post(_serviceUrl, headers: getHeaders(), body: requestbody);
    String c = response.body;
    return c;
  }

  Future<String> login(var data) async {
    // var body = {
    //   "method": "login",
    //   "table": data.logintype,
    //   "tokenlifetime": data.tokenlifetime,
    //   "where": "phone,eq," +
    //       data.phone +
    //       "^pwd,eq," +
    //       data.password
    // };
    log(json.encode(data));
    final response = await http.post(_serviceUrl,
        headers: getHeaders(), body: json.encode(data));
    String c = response.body;
    return c;
  }

  logout() {
    return http
        .post(_serviceUrl, headers: getHeaders(), body: {"method": "logout"});
  }

  /////////////////////////////////////////////////////////////////
  ///
  ///
  ///

  String jobToJson(Job job) {
    var mapData = new Map();
    mapData["customername"] = job.customername;
    mapData["entrydate"] = new DateFormat("y-M-d").format(job.entrydate);
    mapData["customerphone"] = job.customerphone;
    mapData["cost"] = job.cost;
    mapData["jobdesc"] = job.jobdesc;
    mapData["address"] ="";
    mapData["status_id"] ="1";
    mapData["users_id"] ="1";

    String jsonContact = json.encode(mapData);
    return jsonContact;
  }
}
