
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
class FilterDrawer extends StatelessWidget {

  const FilterDrawer({key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        padding: EdgeInsets.only(top: 16,left: 16,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Filter"),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Masukkan Tanggal',
              ),
              onTap: () async {
                await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(),
                  dialogSize: const Size(325, 400),
                  value: [],
                  borderRadius: BorderRadius.circular(15),
                );
              },
              readOnly: true,
            ),
          ],
        ),
      )
    );
  }
}
