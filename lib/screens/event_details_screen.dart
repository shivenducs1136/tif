import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tif/api/mapi.dart';
import 'package:tif/model/event_detail_model.dart';
import 'package:tif/utils/date_helper.dart';
import 'package:tif/utils/responsive_size.dart';
import 'package:readmore/readmore.dart';

import '../model/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.mdata});
  final MData mdata;
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventDetailsModel mEventDetail =
      EventDetailsModel(content: null, status: null);
  @override
  void initState() {
    DataApi.getEventDetails(widget.mdata.id.toString()).then((value) {
      setState(() {
        mEventDetail = value;
      });
    });
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: mEventDetail.content != null
            ? Column(children: [
                Stack(children: [
                  Container(
                    height: ResponsiveSize.height(244, context),
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                          "${mEventDetail.content?.data.bannerImage}"),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: ResponsiveSize.height(94, context),
                      width: MediaQuery.of(context).size.width,
                      // Below is the code for Linear Gradient.
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: ResponsiveSize.height(52, context),
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 22,
                                  width: 22,
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                "Event Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(50, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child:
                              Center(child: Image.asset("images/bookmark.png")),
                        )
                      ],
                    ),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.only(
                      top: ResponsiveSize.height(21, context),
                      left: ResponsiveSize.height(24, context),
                      right: ResponsiveSize.height(24, context)),
                  child: Container(
                    height: ResponsiveSize.height(84, context),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${mEventDetail.content?.data.title}",
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 18, 13, 38)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 22, right: 24, top: 16),
                      child: ListTile(
                        title: Text(
                          "${mEventDetail.content?.data.organiserName}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 13, 12, 38),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        subtitle: const Text(
                          "Organizer",
                          style: TextStyle(
                              color: Color.fromARGB(255, 112, 110, 143),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        leading: Container(
                          height: 48,
                          width: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                                "${mEventDetail.content?.data.title == 'DevOpsDays Berlin' ? 'https://ms-azuretools.gallerycdn.vsassets.io/extensions/ms-azuretools/vscode-docker/1.24.0/1677187109445/Microsoft.VisualStudio.Services.Icons.Default' : widget.mdata.organiserIcon}"),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22, right: 24, top: 16),
                      child: ListTile(
                        title: Text(
                          DateHelper.getEventDetailDate(
                              mEventDetail.content!.data.dateTime.toString()),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 13, 12, 38),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          DateHelper.getEventDetailTime(
                              mEventDetail.content!.data.dateTime.toString()),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 112, 110, 143),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            width: 48,
                            color: const Color.fromARGB(10, 86, 105, 255),
                            child: Image.asset(
                              "images/calender.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 22, right: 24, top: 16),
                      child: ListTile(
                        title: Text(
                          mEventDetail.content!.data.venueName.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 13, 12, 38),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          "${mEventDetail.content!.data.venueCity}, ${mEventDetail.content!.data.venueCountry} ",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 112, 110, 143),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            width: 48,
                            color: const Color.fromARGB(10, 86, 105, 255),
                            child: Image.asset(
                              "images/Location.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: ResponsiveSize.height(214, context),
                      child: Stack(
                        children: [
                          Positioned(
                            top: ResponsiveSize.height(33, context),
                            left: 20,
                            child: const Text(
                              "About Event",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 18, 13, 38),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ),
                          Positioned(
                            top: ResponsiveSize.height(59, context),
                            left: 20,
                            right: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 20, right: 20),
                              child: ReadMoreText(
                                mEventDetail.content!.data.description
                                    .toString(),
                                trimLines: 4,
                                colorClickableText:
                                    const Color.fromARGB(255, 86, 105, 255),
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read More',
                                trimExpandedText: 'Show Less',
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.fade,
                                  height: 1.5,
                                ),
                                moreStyle: const TextStyle(
                                    decorationColor:
                                        Color.fromARGB(255, 86, 105, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.fade,
                                    height: 1.5),
                              ),
                            ),
                          ),
                          Positioned(
                            top: ResponsiveSize.height(92, context),
                            child: Container(
                              height: ResponsiveSize.height(181, context),
                              width: MediaQuery.of(context).size.width,
                              // Below is the code for Linear Gradient.
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(20, 255, 255, 255),
                                    Color.fromARGB(255, 255, 255, 255)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 52,
                            right: 52,
                            bottom: 23,
                            child: Container(
                                height: 58,
                                width: ResponsiveSize.width(271, context),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 86, 105, 255),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Stack(children: [
                                  const Center(
                                    child: Text(
                                      "BOOK NOW",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Positioned(
                                      top: 14,
                                      bottom: 14,
                                      right: 14,
                                      left: ResponsiveSize.width(227, context),
                                      child:
                                          Image.asset("images/circularbtn.png"))
                                ])),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ])
            : Container(
                height: MediaQuery.of(context).size.height * .85,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )),
      ),
    );
  }
}
