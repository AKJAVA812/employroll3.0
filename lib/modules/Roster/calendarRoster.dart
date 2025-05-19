/*
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_app/themes/empThemes.dart';

class RosterCalendar extends StatefulWidget {
  const RosterCalendar({Key? key}) : super(key: key);

  @override
  State<RosterCalendar> createState() => _RosterCalendarState();
}

class _RosterCalendarState extends State<RosterCalendar> {
  var titleName = "Roster Creation";
  final List<Appointment> _appointmentDetails = <Appointment>[];

  late _DataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = getCalendarDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Mythemes.whitish,
      appBar: AppBar(
        title: titleName.text.make(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: dataSource,
                initialSelectedDate: DateTime.now(),
                onSelectionChanged: selectionChanged,
              ),
            ),
            Expanded(
                child: Container(
                    color: Colors.black12,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(2),
                      itemCount: _appointmentDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.all(2),
                            height: 60,
                            color: _appointmentDetails[index].color,
                            child: ListTile(
                              leading: Column(
                                children: <Widget>[
                                  Text(
                                    _appointmentDetails[index].isAllDay
                                        ? ''
                                        : DateFormat('hh:mm a').format(
                                        _appointmentDetails[index].startTime),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.5),
                                  ),
                                  Text(
                                    _appointmentDetails[index].isAllDay
                                        ? 'All day'
                                        : '',
                                    style: const TextStyle(
                                        height: 0.5, color: Colors.white),
                                  ),
                                  Text(
                                    _appointmentDetails[index].isAllDay
                                        ? ''
                                        : DateFormat('hh:mm a').format(
                                        _appointmentDetails[index].endTime),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                  child: Icon(
                                    Icons.subject,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                              title: Container(
                                  child: Text(
                                      '${_appointmentDetails[index].subject}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        height: 5,
                      ),
                    )))
          ],
        ),
      ),
    ));
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _appointmentDetails.clear();
      });

      if (dataSource.appointments!.isEmpty) {
        return;
      }

      for (int i = 0; i < dataSource.appointments!.length; i++) {
        Appointment appointment = dataSource.appointments![i] as Appointment;

        /// It return the occurrence appointment for the given pattern appointment at the selected date.
        final Appointment? occurrenceAppointment = dataSource
            .getOccurrenceAppointment(appointment, selectedDate!, '');
        if ((DateTime(appointment.startTime.year, appointment.startTime.month,
            appointment.startTime.day) ==
            DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day)) || occurrenceAppointment != null) {
          setState(() {
            _appointmentDetails.add(appointment);
          });
        }
      }
    });
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];

    appointments.add(Appointment(
        startTime: DateTime.now().add(const Duration(days: 0)),
        endTime: DateTime.now().add(const Duration(hours: 0)),
        subject: 'Recurrence',
        color: Colors.red,
        //recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=1'
    ));

    appointments.add(Appointment(
        startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
        endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
        subject: 'Release Meeting',
        color: Colors.lightBlueAccent,
        isAllDay: true));

    appointments.add(Appointment(
            startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
            endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
            subject: 'Release Meeting 1',
            color: Colors.black12,
            isAllDay: false));

    appointments.add(Appointment(
            startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
            endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
            subject: 'Release Meeting 2',
            color: Colors.grey,
            isAllDay: true));

    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      subject: 'Meeting',
      color: const Color(0xFFfb21f66),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 5)),
      subject: 'Development Meeting   New York, U.S.A',
      color: const Color(0xFFf527318),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
      subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
      color: const Color(0xFFfb21f66),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 2)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
      subject: 'Support - Web Meeting   Dubai, UAE',
      color: const Color(0xFFf3282b8),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 1)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 2)),
      subject: 'Project Release Meeting   Istanbul, Turkey',
      color: const Color(0xFFf2a7886),
    ));

    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 2, days: -4)),
      endTime: DateTime.now().add(const Duration(hours: 4, days: -4)),
      subject: 'Performance check',
      color: Colors.amber,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 11, days: -2)),
      endTime: DateTime.now().add(const Duration(hours: 12, days: -2)),
      subject: 'Customer Meeting   Tokyo, Japan',
      color: const Color(0xFFffb8d62),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 6, days: 2)),
      endTime: DateTime.now().add(const Duration(hours: 7, days: 2)),
      subject: 'Retrospective',
      color: Colors.purple,
    ));

    return _DataSource(appointments);
  }


}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
*/
