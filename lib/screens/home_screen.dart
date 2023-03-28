import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tif/api/mapi.dart';
import 'package:tif/model/event_model.dart';
import 'package:tif/screens/event_details_screen.dart';
import 'package:tif/screens/search_screen.dart';
import 'package:tif/utils/date_helper.dart';
import 'package:tif/utils/responsive_size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EventModel myEvents = EventModel();
  @override
  void initState() {
    DataApi.getInitialData().then((value) {
      setState(() {
        myEvents = value;
        log(myEvents.toString());
      });
    });
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(children: [
            // Header Row
            Padding(
              padding: EdgeInsets.only(
                  top: ResponsiveSize.height(48, context),
                  left: ResponsiveSize.width(31, context),
                  right: ResponsiveSize.width(31, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Event text
                  const Text("Events",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 18, 13, 38),
                          fontSize: 24)),
                  // Search & More Icons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SearchScreen()));
                        },
                        child: const Padding(
                            padding: EdgeInsets.only(right: 35),
                            child:
                                Image(image: AssetImage("images/search.png"))),
                      ),
                      const Image(image: AssetImage("images/More.png")),
                    ],
                  )
                ],
              ),
            ),
            myEvents.content != null
                ? Padding(
                    padding: EdgeInsets.only(
                        top: ResponsiveSize.height(27, context),
                        left: ResponsiveSize.width(24, context),
                        right: ResponsiveSize.width(24, context),
                        bottom: ResponsiveSize.height(7, context)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .85,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: myEvents.content != null
                              ? myEvents.content!.data!.length
                              : 0,
                          itemBuilder: (context, index) =>
                              listItemWidget(myEvents.content!.data![index])),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * .85,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ))
          ]),
        ),
      ),
    );
  }

  Widget listItemWidget(MData e) {
    return e != null
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EventDetailScreen(
                            mdata: e,
                          )));
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Container(
                  height: 106,
                  width: 327,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(15, 87, 92, 138),
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0.2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: ResponsiveSize.width(107, context),
                        child: Center(
                            child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: ResponsiveSize.height(100, context),
                                  width: ResponsiveSize.width(80, context),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image(
                                        image: NetworkImage(
                                            e!.bannerImage.toString())),
                                  ),
                                ))),
                      ),
                      Container(
                        width: ResponsiveSize.width(206, context),
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 9),
                                  child: Text(
                                    DateHelper.getMyFormattedDate(
                                        e.dateTime.toString()),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 86, 105, 255),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 5),
                                  child: Text(
                                    e.title.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 18, 13, 38),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 11),
                                  child: Row(
                                    children: [
                                      const Image(
                                          image:
                                              AssetImage("images/map-pin.png")),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 7.7),
                                        child: Container(
                                          width: ResponsiveSize.width(
                                              180, context),
                                          child: Text(
                                            e.venueName.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 116, 118, 136),
                                                fontSize: 13),
                                            maxLines: 1,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      )
                    ]),
                  )),
            ),
          )
        : Text("Missing data");
  }
}
