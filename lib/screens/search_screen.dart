import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tif/api/mapi.dart';
import 'package:tif/model/event_model.dart';
import 'package:tif/screens/event_details_screen.dart';
import 'package:tif/utils/responsive_size.dart';

import '../utils/date_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => Search_ScreenState();
}

class Search_ScreenState extends State<SearchScreen> {
  List<MData> mlist = [];
  List<MData> SearchingList = [];
  bool isSearching = false;
  EventModel myEvents = EventModel();
  @override
  void initState() {
    DataApi.getInitialData().then((value) {
      setState(() {
        myEvents = value;
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
    return SafeArea(
        child: Scaffold(
      body: GestureDetector(
        onTap: () {
          isSearching = !isSearching;
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            if (isSearching) {
              setState(() {
                isSearching = !isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 21, left: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        isSearching ? "Searching.." : "Search",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 18, 13, 38),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ResponsiveSize.height(31, context),
                    left: 27,
                    right: 27),
                child: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSearching = !isSearching;
                            });
                          },
                          child: Container(
                              height: 24,
                              width: 24,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child:
                                      Image.asset("images/search_purple.png"))),
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Container(
                        height: 26,
                        width: 1.5,
                        color: const Color.fromARGB(255, 121, 116, 231),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            if (!isSearching) isSearching = !isSearching;
                            SearchingList.clear();
                            mlist = myEvents.content?.data ?? [];
                            for (var i in mlist) {
                              if (i.title
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  i.venueName
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase())) {
                                SearchingList.add(i);
                                setState(() {
                                  SearchingList;
                                });
                              }
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: 'Type Event Name',
                              border: InputBorder.none,
                              focusColor: Color.fromARGB(255, 0, 0, 0),
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(70, 0, 0, 0),
                                  letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
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
                            itemCount: isSearching
                                ? SearchingList.length
                                : myEvents.content?.data?.length,
                            itemBuilder: (context, index) {
                              return cutelistItemWidget(isSearching
                                  ? SearchingList[index]
                                  : myEvents.content!.data![index]);
                            }),
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
      ),
    ));
  }

  Widget cutelistItemWidget(MData e) {
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      fontSize: 12,
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
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
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
