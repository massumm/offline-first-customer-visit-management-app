import 'package:flutter/material.dart';

class LogRecoveryEntryView extends StatelessWidget {
  const LogRecoveryEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Log Recovery',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Activity Name'),
              const SizedBox(height: 8),
              _textField(
                hint: 'Evening Yoga',
                enabled: false,
              ),
              const SizedBox(height: 20),

              _label('Activity Type'),
              const SizedBox(height: 8),
              _dropdownField(),
              const SizedBox(height: 20),

              _label('Duration (minutes)'),
              const SizedBox(height: 8),
              _textField(
                hint: '20',
                keyboardType: TextInputType.number,
              ),

              const Spacer(),

              _primaryButton(
                title: 'Log Repair',
                onTap: () {
                  // TODO: Submit action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== Widgets =====================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _textField({
    required String hint,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: const Color(0xFF1C1C1E),
          hint: Text(
            'Select type',
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          items: const [
            DropdownMenuItem(
              value: 'Yoga',
              child: Text('Yoga'),
            ),
            DropdownMenuItem(
              value: 'Meditation',
              child: Text('Meditation'),
            ),
            DropdownMenuItem(
              value: 'Stretching',
              child: Text('Stretching'),
            ),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F6DB5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
