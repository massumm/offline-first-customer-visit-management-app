import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatePickerInputField extends StatefulWidget {
  final String hint;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(String value) onSelectDate;

  const DatePickerInputField({
    super.key,
    this.hint = 'dd/mm/yyyy',
    required this.firstDate,
    required this.lastDate,
    required this.onSelectDate,
  });

  @override
  State<DatePickerInputField> createState() => _DatePickerInputFieldState();
}

class _DatePickerInputFieldState extends State<DatePickerInputField> {
  // Use short month names for a cleaner UI in the picker.
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // Helper to calculate the number of days in a given month and year.
  static int _getDaysInMonth(int year, int month) {
    // The 0th day of the next month is the last day of the current month.
    return DateTime(year, month + 1, 0).day;
  }

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add a listener to rebuild the widget when the text changes.
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Clean up the listener to prevent memory leaks.
    controller.removeListener(_onTextChanged);

    controller.clear();
    super.dispose();
  }

  void _onTextChanged() {
    // Calling setState triggers a rebuild, which re-evaluates the suffix icon.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the controller has text to decide which icon to show.
    final bool hasValue = controller.text.isNotEmpty;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8), // we insert slashes -> 10 chars
        _DateSlashFormatter(), // 01011990 -> 01/01/1990
      ],
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: hasValue
            ? IconButton(
                tooltip: 'Send',
                icon: const Icon(Icons.send),
                onPressed: () => widget.onSelectDate(controller.text),
              )
            : IconButton(
                tooltip: 'Pick date',
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: _pickDate,
              ),
      ),
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return null; // optional field
        final dt = _parseDDMMYYYY(v);
        if (dt == null) return 'Enter a valid date (dd/mm/yyyy)';
        if (dt.isBefore(widget.firstDate) || dt.isAfter(widget.lastDate)) {
          return 'Date out of range';
        }
        return null;
      },
    );
  }

  /// Shows a modal bottom sheet with segmented pickers for day, month, and year.
  Future<void> _pickDate() async {
    final existingDate = _parseDDMMYYYY(controller.text);
    final initialDate = (existingDate ?? DateTime(2000, 1, 1)).clamp(
      widget.firstDate,
      widget.lastDate,
    );

    int selectedDay = initialDate.day;
    int selectedMonth = initialDate.month;
    int selectedYear = initialDate.year;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,

      builder: (context) {
        final theme = Theme.of(context);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final daysInMonth = _getDaysInMonth(selectedYear, selectedMonth);

            Widget buildPickerItem(String text) =>
                Center(child: Text(text, style: theme.textTheme.titleMedium));

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Date',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                          child: const Text('Done'),
                          onPressed: () {
                            final finalDate = DateTime(
                              selectedYear,
                              selectedMonth,
                              selectedDay,
                            );
                            if (!finalDate.isBefore(widget.firstDate) &&
                                !finalDate.isAfter(widget.lastDate)) {
                              Navigator.pop(context, finalDate);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Day Picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedDay - 1,
                            ),
                            itemExtent: 40.0,
                            onSelectedItemChanged: (index) {
                              selectedDay = index + 1;
                            },
                            children: List<Widget>.generate(daysInMonth, (
                              index,
                            ) {
                              return buildPickerItem('${index + 1}');
                            }),
                          ),
                        ),
                        // Month Picker
                        Expanded(
                          flex: 2,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMonth - 1,
                            ),
                            itemExtent: 40.0,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedMonth = index + 1;
                                // If the new month has fewer days, clamp the selected day.
                                final newDaysInMonth = _getDaysInMonth(
                                  selectedYear,
                                  selectedMonth,
                                );
                                if (selectedDay > newDaysInMonth) {
                                  selectedDay = newDaysInMonth;
                                }
                              });
                            },
                            children: List<Widget>.generate(12, (index) {
                              return buildPickerItem(_monthNames[index]);
                            }),
                          ),
                        ),
                        // Year Picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedYear - widget.firstDate.year,
                            ),
                            itemExtent: 40.0,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedYear = widget.firstDate.year + index;
                                // Re-validate day in case of leap year changes.
                                final newDaysInMonth = _getDaysInMonth(
                                  selectedYear,
                                  selectedMonth,
                                );
                                if (selectedDay > newDaysInMonth) {
                                  selectedDay = newDaysInMonth;
                                }
                              });
                            },
                            children: List<Widget>.generate(
                              widget.lastDate.year - widget.firstDate.year + 1,
                              (index) {
                                return buildPickerItem(
                                  '${widget.firstDate.year + index}',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      controller.text = _formatDDMMYYYY(picked);
    }
  }

  static DateTime? _parseDDMMYYYY(String s) {
    final parts = s.split('/');
    if (parts.length != 3) return null;
    final dd = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final yyyy = int.tryParse(parts[2]);
    if (dd == null || mm == null || yyyy == null) return null;
    if (yyyy < 1000 || mm < 1 || mm > 12 || dd < 1) return null;

    // This check handles invalid dates like 31/02/2023
    final dt = DateTime(yyyy, mm, dd);
    if (dt.year != yyyy || dt.month != mm || dt.day != dd) return null;
    return dt;
  }

  static String _formatDDMMYYYY(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year.toString()}';
}

class _DateSlashFormatter extends TextInputFormatter {
  const _DateSlashFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final b = StringBuffer();

    for (var i = 0; i < digits.length && i < 8; i++) {
      b.write(digits[i]);
      if (i == 1 || i == 3) b.write('/');
    }

    final out = b.toString();
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: out.length),
    );
  }
}

extension on DateTime {
  DateTime clamp(DateTime min, DateTime max) {
    if (isBefore(min)) return min;
    if (isAfter(max)) return max;
    return this;
  }
}
