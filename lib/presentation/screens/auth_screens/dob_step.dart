import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/step_dots.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({super.key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    /// Open DOB picker immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openDobPicker();
    });
  }

  void _openDobPicker() {
    DateTime tempDate = _selectedDate ?? DateTime(2000, 1, 1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempDate,
                    maximumDate: DateTime.now(),
                    minimumDate: DateTime(1900),
                    onDateTimeChanged: (date) {
                      tempDate = date;
                    },
                  ),
                ),

                const Divider(height: 1),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = tempDate;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String get formattedDate {
    if (_selectedDate == null) return '';
    return DateFormat('MMM d, yyyy').format(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _selectedDate != null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// 🔝 Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const StepDots(currentStep: 3), // 👈 4th dot active
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 24),

              /// Title
              const Text(
                "Hi Rahul! Enter your birthdate",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "To help keep Pinterest safe, we now require your birthdate. "
                  "Your birthdate also helps us provide more personalized recommendations "
                  "and relevant ads. We won't share this information without your permission "
                  "and it won't be visible on your profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),

              const SizedBox(height: 40),

              /// Selected Date (Tap to reopen picker)
              GestureDetector(
                onTap: _openDobPicker,
                child: Text(
                  isValid ? formattedDate : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Use your own age, even if this is a business account",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),

              const Spacer(),

              /// 🔴 Next Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isValid
                      ? () {
                          /// 👉 Navigate to gender screen next
                          context.go('/step-gender');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid ? Colors.red : Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
