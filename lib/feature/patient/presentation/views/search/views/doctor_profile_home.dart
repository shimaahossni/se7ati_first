// feature/patient/presentation/views/search/views/doctor_profile_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_model.dart';
import 'package:flutter_application/feature/patient/presentation/views/appointment/views/booking_screen.dart';
import 'package:flutter_application/feature/patient/presentation/views/appointment/views/patient_appointment.dart';
import 'package:flutter_application/feature/patient/presentation/views/search/widget/icon_tile_widget.dart';
import 'package:flutter_application/feature/patient/presentation/views/search/widget/tile_widget.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorHome extends StatefulWidget {
  DoctorModel? doctor;
  DoctorHome({super.key, required this.doctor});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  //late doctor doctor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'بيانات الدكتور',
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.blueColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            // ------------ body ---------------
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    //image
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.whiteColor,
                      child: CircleAvatar(
                        backgroundColor: AppColors.whiteColor,
                        radius: 60,
                        backgroundImage: (widget.doctor?.image != null)
                            ? NetworkImage(widget.doctor!.image!)
                            : const AssetImage('assets/doc.png'),
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //name
                      Text(
                        "د. ${widget.doctor?.name ?? ''}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getTitleStyle(),
                      ),
                      //specialization
                      Text(
                        widget.doctor?.specialization ?? '',
                        style: getBodyStyle(),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          //rating
                          Text(
                            widget.doctor?.rating.toString() ?? '0.0',
                            style: getBodyStyle(),
                          ),
                          const Gap(5),
                          const Icon(
                            Icons.star_rounded,
                            size: 20,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          //phone
                          IconTile(
                            onTap: () async {
                              await launchUrl(
                                  Uri.parse('tel:${widget.doctor?.phone1}'));
                            },
                            backColor: AppColors.accentColor,
                            imgAssetPath: Icons.phone,
                            text: '1',
                          ),
                          if (widget.doctor?.phone2 != '') ...[
                            const SizedBox(
                              width: 15,
                            ),
                            IconTile(
                              onTap: () async {
                                await launchUrl(
                                    Uri.parse('tel:${widget.doctor?.phone2}'));
                              },
                              backColor: AppColors.accentColor,
                              imgAssetPath: Icons.phone,
                              text: '2',
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Gap(25),
            Text(
              "نبذه تعريفية",
              style: getBodyStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(10),
            Text(
              widget.doctor?.bio ?? '',
              style: getSmallStyle(),
            ),
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.accentColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TileWidget(
                      text:
                          '${widget.doctor?.openHour} - ${widget.doctor?.closeHour}',
                      icon: Icons.watch_later_outlined),
                  const Gap(15),

                  //address
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${widget.doctor?.address}'));
                    },
                    child: TileWidget(
                        text: widget.doctor?.address ?? '',
                        icon: Icons.location_on_rounded),
                  ),
                ],
              ),
            ),
            const Gap(20),
            // --------------- contact --------------
            Text(
              "معلومات الاتصال",
              style: getBodyStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.accentColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //email
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(
                          Uri.parse('mailto:${widget.doctor?.email}'));
                    },
                    child: TileWidget(
                        text: widget.doctor?.email ?? '', icon: Icons.email),
                  ),
                  const Gap(15),

                  //phone1
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(
                          Uri.parse('tel:${widget.doctor?.phone1}'));
                    },
                    child: TileWidget(
                        text: widget.doctor?.phone1 ?? '', icon: Icons.call),
                  ),
                  if (widget.doctor?.phone2 != '') ...{
                    const SizedBox(
                      height: 15,
                    ),
                    //phone2
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(
                            Uri.parse('tel:${widget.doctor?.phone2}'));
                      },
                      child: TileWidget(
                          text: widget.doctor?.phone2 ?? '', icon: Icons.call),
                    ),
                  }
                ],
              ),
            ),
            //map
            const Gap(20),
            Text(
              "الموقع",
              style: getBodyStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              width: double.infinity,
              height: 300,
              child: OSMViewer(
                controller: SimpleMapController(
                  initPosition: GeoPoint(
                    latitude: 47.4358055,
                    longitude: 8.4737324,
                  ),
                  markerHome: const MarkerIcon(
                    icon: Icon(Icons.home),
                  ),
                ),
                zoomOption: const ZoomOption(
                  initZoom: 16,
                  minZoomLevel: 11,
                ),
              ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: 'احجز موعد الان',
          onPressed: () {
            push(
                context,
                BookingScreen(
                  doctor: widget.doctor!,
                ));
          },
        ),
      ),
    );
  }
}
