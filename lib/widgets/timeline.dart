import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_reminder_app/utils/Colors.dart';

import '../Controller/ThemeCubit.dart';

class ThemingTimeLineCalender extends StatefulWidget {
  Function onchanged;
  ThemingTimeLineCalender({super.key, required this.onchanged(date)});

  @override
  State<ThemingTimeLineCalender> createState() => _NewWidgetExampleState();
}

class _NewWidgetExampleState extends State<ThemingTimeLineCalender> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: _selectedDate,
      onDateChange: (selectedDate) {
        widget.onchanged(selectedDate);
        //`selectedDate` the new date selected.
        _selectedDate = selectedDate;
      },
      headerProps: EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: const DateFormatter.fullDateDayAsStrMY(),
        selectedDateStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.read<ThemeCubit>().state == ThemeMode.light
                ? Colors.black
                : Colors.teal),
      ),
      dayProps: EasyDayProps(
        activeDayStyle: const DayStyle(
          borderRadius: 15.0,
        ),
        inactiveDayStyle: DayStyle(
            borderRadius: 15.0,
            decoration: BoxDecoration(
                color: context.read<ThemeCubit>().state == ThemeMode.light
                    ? Colors.white
                    : Colors.teal.withOpacity(0.3))),
      ),
      timeLineProps: const EasyTimeLineProps(
        hPadding: 16.0, // padding from left and right
        separatorPadding: 16.0,
        // padding between days
      ),
      activeColor: MyColors().randomcolors[2].bgcolor,
    );
  }
}
