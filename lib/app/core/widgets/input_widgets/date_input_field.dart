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
  static const List<String> _monthNames = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ];

  static int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  final TextEditingController controller = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // The listener is kept for validation display, though direct text input is disabled.
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      setState(() {
        _errorText = _validate(controller.text);
      });
    } else {
      setState(() {});
    }
  }

  String? _validate(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return null;

    final dt = _parseDDMMYYYY(v);
    if (dt == null) return 'Enter a valid date (dd/mm/yyyy)';
    if (dt.isBefore(widget.firstDate) || dt.isAfter(widget.lastDate)) {
      return 'Date out of range';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    /// ============= iOS (Cupertino) UI =============
    if (isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            controller: controller,
            placeholder: widget.hint,
            readOnly: true,
            onTap: _pickDate,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _pickDate,
                child: const Icon(CupertinoIcons.calendar),
              ),
            ),
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 8.0),
              child: Text(
                _errorText!,
                style: const TextStyle(
                  color: CupertinoColors.systemRed,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    }

    /// ============= Android / Material UI =============
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: _pickDate,
      validator: _validate,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: _pickDate,
        ),
      ),
    );
  }

  /// =================== PICKER =====================
  Future<void> _pickDate() async {
    final existingDate = _parseDDMMYYYY(controller.text);
    final initialDate = (existingDate ?? DateTime(2000, 1, 1))
        .clamp(widget.firstDate, widget.lastDate);

    int selectedDay = initialDate.day;
    int selectedMonth = initialDate.month;
    int selectedYear = initialDate.year;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return StatefulBuilder(
          builder: (context, setStatePicker) {
            final daysInMonth = _getDaysInMonth(selectedYear, selectedMonth);

            Widget item(String text) =>
                Center(child: Text(text, style: theme.textTheme.titleMedium));

            return SizedBox(
              height: 320,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Date",
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            final finalDate =
                            DateTime(selectedYear, selectedMonth, selectedDay);

                            if (!finalDate.isBefore(widget.firstDate) &&
                                !finalDate.isAfter(widget.lastDate)) {
                              Navigator.pop(context, finalDate);
                            }
                          },
                          child: const Text("Done"),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        /// Day
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedDay - 1),
                            onSelectedItemChanged: (i) {
                              selectedDay = i + 1;
                            },
                            children: List.generate(
                                daysInMonth, (i) => item("${i + 1}")),
                          ),
                        ),

                        /// Month
                        Expanded(
                          flex: 2,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedMonth - 1),
                            onSelectedItemChanged: (i) {
                              setStatePicker(() {
                                selectedMonth = i + 1;
                                final newDays =
                                _getDaysInMonth(selectedYear, selectedMonth);
                                if (selectedDay > newDays) {
                                  selectedDay = newDays;
                                }
                              });
                            },
                            children: List.generate(
                                12, (i) => item(_monthNames[i])),
                          ),
                        ),

                        /// Year
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 40,
                            scrollController:
                            FixedExtentScrollController(
                                initialItem: selectedYear - widget.firstDate.year),
                            onSelectedItemChanged: (i) {
                              setStatePicker(() {
                                selectedYear = widget.firstDate.year + i;
                                final newDays =
                                _getDaysInMonth(selectedYear, selectedMonth);
                                if (selectedDay > newDays) {
                                  selectedDay = newDays;
                                }
                              });
                            },
                            children: List.generate(
                              widget.lastDate.year - widget.firstDate.year + 1,
                                  (i) => item("${widget.firstDate.year + i}"),
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
      widget.onSelectDate(controller.text);
    }
  }

  /// ================== HELPERS ==================
  static DateTime? _parseDDMMYYYY(String s) {
    final parts = s.split('/');
    if (parts.length != 3) return null;
    final dd = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final yyyy = int.tryParse(parts[2]);
    if (dd == null || mm == null || yyyy == null) return null;

    // This check handles invalid dates like 31/02/2023
    final dt = DateTime(yyyy, mm, dd);
    if (dt.year != yyyy || dt.month != mm || dt.day != dd) return null;
    return dt;
  }

  static String _formatDDMMYYYY(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';
}

// This formatter is no longer strictly necessary if the field is read-only,
// but it doesn't hurt to keep it for robustness.
class _DateSlashFormatter extends TextInputFormatter {
  const _DateSlashFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old,
      TextEditingValue now,
      ) {
    final digits = now.text.replaceAll(RegExp(r'[^0-9]'), '');
    final b = StringBuffer();

    for (int i = 0; i < digits.length && i < 8; i++) {
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
