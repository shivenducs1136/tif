import 'dart:convert';
import 'dart:developer';

import 'package:tif/model/event_detail_model.dart';
import 'package:tif/model/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:tif/screens/event_details_screen.dart';

class DataApi {
  static List<EventModel> mydata = [];
  static String BASE_URL =
      'https://sde-007.api.assignment.theinternetfolks.works/v1/event/';
  static Future<EventModel> getInitialData() async {
    final response = await http.get(Uri.parse(BASE_URL));

    if (response.statusCode == 200) {
      return EventModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  EventModel getData(int index) {
    return mydata[index];
  }

  static Future<EventDetailsModel> getEventDetails(String id) async {
    final response = await http.get(Uri.parse(BASE_URL + id));
    if (response.statusCode == 200) {
      return EventDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
