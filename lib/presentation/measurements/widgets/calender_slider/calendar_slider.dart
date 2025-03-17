import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
export 'package:intl/date_symbol_data_local.dart';
export 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'full_calendar.dart';
import 'types.dart';

class CalendarSliderController {
  CalendarSliderState? state;

  void bindState(CalendarSliderState state) {
    this.state = state;
  }

  void dispose() {
    state = null;
  }
}

class CalendarSlider extends StatefulWidget implements PreferredSizeWidget {
  final CalendarSliderController? controller;

  final DateTime initialDate; // date to be shown initially
  final DateTime firstDate; // the lower limit of the date range
  final DateTime lastDate; // the upper limit of the date range
  final Function
      onDurationSelected; // function to be called when a date is selected

  final Color? monthYearTextColor; // color of the month year text
  final Color? backgroundColor; // background color for the entire widget
  final Color? selectedDateColor; // color of the selected date
  final Color?
      monthYearButtonBackgroundColor; // background color of the month year button on top
  final Color? dateColor; // color of the date on each tile
  final Color?
      calendarEventSelectedColor; // color of the event on the selected date
  final Color? calendarEventColor; // color of the event on the date
  final FullCalendarScroll
      fullCalendarScroll; // scroll direction of the full calendar
  final Widget? fullCalendarBackgroundImage; // logo of the calendar

  final String? locale; // locale of the calendar
  final bool? fullCalendar; // if the full calendar is enabled
  final WeekDay? fullCalendarWeekDay;
  final WeekDay
      weekDay; // format of the week day (long or short)("Monday" or "Mon")
  final List<DateTime>? events; // list of events

  final DateTime? disabledTo;
  final DateTime? disabledFrom;

  CalendarSlider({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDurationSelected,
    this.controller,
    this.backgroundColor = Colors.transparent,
    this.dateColor = Colors.black,
    this.selectedDateColor = Colors.black,
    this.monthYearTextColor = Colors.black,
    this.monthYearButtonBackgroundColor = Colors.grey,
    this.calendarEventSelectedColor = Colors.white,
    this.calendarEventColor = Colors.blue,
    this.fullCalendarBackgroundImage,
    this.locale = 'en',
    this.events,
    this.fullCalendar = true,
    this.fullCalendarScroll = FullCalendarScroll.horizontal,
    this.weekDay = WeekDay.short,
    this.fullCalendarWeekDay = WeekDay.short,
    this.disabledTo,
    this.disabledFrom,
  })  : assert(
          initialDate.difference(firstDate).inDays >= 0,
          'initialDate must be on or after firstDate',
        ),
        assert(
          !initialDate.isAfter(lastDate),
          'initialDate must be on or before lastDate',
        ),
        assert(
          !firstDate.isAfter(lastDate),
          'lastDate must be on or after firstDate',
        );

  @override
  CalendarSliderState createState() => CalendarSliderState();

  @override
  Size get preferredSize => const Size.fromHeight(250.0);
}

class CalendarSliderState extends State<CalendarSlider>
    with TickerProviderStateMixin {
  late double padding;

  final List<String> _eventDates = [];
  DateTime? _selectedDate;
  DateTime? _selectedDateEnd;
  Duration? _duration;

  String get _locale =>
      widget.locale ?? Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    padding = 25.0;
    initializeDateFormatting(_locale);
    _initCalendar();

    if (widget.events != null) {
      for (var element in widget.events!) {
        _eventDates.add(element.toString().split(' ').first);
      }
    }
  }

  void _transferToNextRange() {
    if (_selectedDateEnd!.isBefore(widget.lastDate)) {
      setState(() {
        _selectedDate = _selectedDateEnd!.add(const Duration(days: 1));
        _selectedDateEnd = _selectedDate!.add(_duration!);
      });
    }
    _saveTheDayRange();
  }

  void _transferBackToPreviousRange() {
    if (_selectedDate!.isAfter(widget.firstDate)) {
      setState(() {
        _selectedDateEnd = _selectedDate!.subtract(const Duration(days: 1));
        _selectedDate = _selectedDateEnd!.subtract(_duration!);
      });
    }
    _saveTheDayRange();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - padding,
        child: GestureDetector(
          onTap: () => widget.fullCalendar!
              ? _showFullCalendar(_locale, widget.weekDay)
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: _transferBackToPreviousRange,
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.grey[400])),
              Expanded(
                child: Text(
                  '${DateFormat("dd MMM", Locale(_locale).toString()).format(_selectedDate!)} - ${DateFormat("dd MMM", Locale(_locale).toString()).format(_selectedDateEnd!)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: widget.monthYearTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                  onPressed: _transferToNextRange,
                  icon: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey[400])),
            ],
          ),
        ),
      ),
    );
  }

  _showFullCalendar(String locale, WeekDay weekday) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        double height;
        DateTime? endDate = widget.lastDate;

        if (widget.firstDate.year == endDate.year &&
            widget.firstDate.month == endDate.month) {
          height = ((MediaQuery.of(context).size.width - 2 * padding) / 7) * 5 +
              150.0;
        } else {
          height = (MediaQuery.of(context).size.height - 100.0);
        }
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: widget.fullCalendarScroll == FullCalendarScroll.vertical
                  ? height
                  : (MediaQuery.of(context).size.height / 7) * 4.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: const Color(0xFFE0E0E0)),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: FullCalendar(
                      startDate: widget.firstDate,
                      endDate: endDate,
                      padding: padding,
                      dateColor: const Color(0xFF3F5266),
                      dateSelectedBg: widget.calendarEventColor,
                      dateSelectedColor: widget.calendarEventSelectedColor,
                      events: _eventDates,
                      selectedDate: _selectedDate,
                      selectedDateEnd: _selectedDateEnd,
                      fullCalendarDay: widget.fullCalendarWeekDay,
                      calendarScroll: widget.fullCalendarScroll,
                      calendarBackground: widget.fullCalendarBackgroundImage,
                      locale: locale,
                      onDateChange: (value) {
                        setModalState(() {
                          if (_selectedDate != null &&
                              _selectedDateEnd != null) {
                            _selectedDate = value;
                            _selectedDateEnd = null;
                          } else {
                            _selectedDateEnd = value;
                            if (_selectedDateEnd!.isBefore(_selectedDate!)) {
                              _swapSelectedDate();
                            }
                          }
                        });
                      },
                      hideCalendar: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      _saveTheDayRange();
    });
  }

  void _saveTheDayRange() {
    setState(() {
      _selectedDateEnd =
          _selectedDateEnd ?? _selectedDate!.add(const Duration(days: 7));
      _duration = _selectedDateEnd!.difference(_selectedDate!);
      _formatDate();
      widget.onDurationSelected(_selectedDate, _selectedDateEnd);
    });
  }

  void _swapSelectedDate() {
    DateTime temp = _selectedDate!;
    _selectedDate = _selectedDateEnd;
    _selectedDateEnd = temp;
  }

  void _formatDate() {
    _selectedDate = DateTime.parse(
        "${_selectedDate.toString().split(" ").first} 00:00:00.000");
    _selectedDateEnd = DateTime.parse(
        "${_selectedDateEnd.toString().split(" ").first} 23:59:59.999");
  }

  _initCalendar() {
    if (widget.controller != null &&
        widget.controller is CalendarSliderController) {
      widget.controller!.bindState(this);
    }
    _selectedDateEnd = widget.initialDate;
    _duration = const Duration(days: 7);
    _selectedDate = _selectedDateEnd!.subtract(_duration!);
  }
}
