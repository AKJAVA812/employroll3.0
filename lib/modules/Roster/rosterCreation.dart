/*
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_app/themes/empThemes.dart';

class RosterCreation extends StatefulWidget {
  const RosterCreation({Key? key}) : super(key: key);

  @override
  State<RosterCreation> createState() => _RosterCreationState();
}

class _RosterCreationState extends State<RosterCreation> {
  var titleName = "Roster Creation";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleName.text.make(),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: SfCalendar(
            view: CalendarView.month,
            blackoutDates: <DateTime>[
              DateTime(2020, 08, 10),
              DateTime(2020, 08, 15),
              DateTime(2020, 08, 20),
              DateTime(2020, 08, 22),
              DateTime(2020, 08, 24)
            ],
            blackoutDatesTextStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.red,
                decoration: TextDecoration.lineThrough),
            monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              appointmentDisplayCount: 2,
              navigationDirection: MonthNavigationDirection.horizontal,
              showAgenda: true,
              agendaViewHeight: 70,
                showTrailingAndLeadingDates: false,
                agendaStyle: AgendaStyle(
                  backgroundColor: Color(0xFF066cccc),
                  appointmentTextStyle: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF0ffcc00)),
                  dateTextStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  dayTextStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
