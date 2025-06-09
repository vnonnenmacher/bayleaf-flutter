import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// Next Events data with actions as icon/tooltips and type for border
final List<Map<String, dynamic>> nextEvents = [
  {
    "icon": Icons.calendar_today_outlined,
    "title": "Next Appointment",
    "summary": "With Dr. Silva\nToday at 16:00",
    "actions": [
      {"icon": Icons.calendar_today, "tooltip": "View Details"},
      {"icon": Icons.edit_calendar, "tooltip": "Reschedule"},
    ],
    "type": "appointment",
  },
  {
    "icon": Icons.medication_outlined,
    "title": "Time for Medication",
    "summary": "Aspirin 100mg\nTake at 18:00",
    "actions": [
      {"icon": Icons.check_circle_outline, "tooltip": "Mark as Taken"},
      {"icon": Icons.notifications_active_outlined, "tooltip": "Remind me later"},
    ],
    "type": "medication",
  },
  {
    "icon": Icons.biotech_outlined,
    "title": "Upcoming Exam",
    "summary": "Blood Test\nJune 10, 08:30",
    "actions": [
      {"icon": Icons.remove_red_eye_outlined, "tooltip": "View Prep"},
      {"icon": Icons.edit, "tooltip": "Reschedule"},
    ],
    "type": "exam",
  },
];

// Accent color helper for both event and response types
Color _typeBorderColor(String typeOrContext) {
  switch (typeOrContext.toLowerCase()) {
    case "appointment":
    case "sleep":
      return AppColors.primary;
    case "medication":
    case "activity":
      return AppColors.accent;
    case "exam":
    case "checklist":
      return AppColors.warning;
    default:
      return AppColors.primaryLight;
  }
}

// Dummy AI response feed with improved actions as icons & tooltips
final List<Map<String, dynamic>> aiResponses = [
  {
    "icon": Icons.nightlight_round,
    "context": "Sleep",
    "message": "You averaged 6h 40m of sleep last week. Would you like to set a reminder to wind down at 10pm?",
    "chart": null,
    "actions": [
      {"icon": Icons.bookmark_border, "tooltip": "Bookmark"},
      {"icon": Icons.share_outlined, "tooltip": "Share"},
      {"icon": Icons.notifications_none_outlined, "tooltip": "Set Reminder"},
    ],
  },
  {
    "icon": Icons.directions_walk,
    "context": "Activity",
    "message": "Great job hitting 8,000 steps yesterday! Consistency matters most.",
    "chart": null,
    "actions": [
      {"icon": Icons.bookmark_border, "tooltip": "Bookmark"},
      {"icon": Icons.share_outlined, "tooltip": "Share"},
    ],
  },
  {
    "icon": Icons.check_circle_outline,
    "context": "Checklist",
    "message": "Medication taken at 8:00 AM. Remember to log your evening dose.",
    "chart": null,
    "actions": [
      {"icon": Icons.bookmark_border, "tooltip": "Bookmark"},
      {"icon": Icons.notifications_none_outlined, "tooltip": "Set Reminder"},
    ],
  },
];

class AiAgentScreen extends StatefulWidget {
  const AiAgentScreen({super.key});

  @override
  State<AiAgentScreen> createState() => _AiAgentScreenState();
}

class _AiAgentScreenState extends State<AiAgentScreen> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  bool _showTextInput = false;
  String _transcription = "";
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.9,
      upperBound: 1.08,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onVoiceTap() {
    setState(() {
      _isListening = !_isListening;
      _transcription = _isListening ? "Listening... Try saying: \"Remind me to walk at 5pm.\"" : "";
    });
    // TODO: Hook up real voice input logic here
  }

  void _onTextTap() {
    setState(() {
      _showTextInput = true;
    });
  }

  void _onTextSend(String text) {
    setState(() {
      _showTextInput = false;
      _transcription = "";
      // TODO: Add text to AI feed
    });
  }

  @override
  Widget build(BuildContext context) {
    final ambientColor = AppColors.background;
    return Scaffold(
      backgroundColor: ambientColor,
      body: Stack(
        children: [
          _AnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                _NextEventsCarousel(),
                const SizedBox(height: 18),
                _AiAvatarWithInput(
                  isListening: _isListening,
                  pulseController: _pulseController,
                  transcription: _transcription,
                  onVoiceTap: _onVoiceTap,
                  onTextTap: _onTextTap,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _AiResponsesFeed(),
                ),
              ],
            ),
          ),
          // Bottom Sheet for text input
          if (_showTextInput)
            _TextInputBottomSheet(
              onSend: _onTextSend,
              onCancel: () => setState(() => _showTextInput = false),
            ),
        ],
      ),
    );
  }
}

// Top Carousel with heading
class _NextEventsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8, top: 2),
          child: Text(
            "Upcoming Events",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary.withOpacity(0.85),
              letterSpacing: 0.1,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: nextEvents
                .map((event) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _NextEventCard(
                        icon: event["icon"],
                        title: event["title"],
                        summary: event["summary"],
                        actions: event["actions"],
                        borderColor: _typeBorderColor(event["type"] ?? ""),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _NextEventCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String summary;
  final List<Map<String, dynamic>> actions;
  final Color borderColor;

  const _NextEventCard({
    required this.icon,
    required this.title,
    required this.summary,
    required this.actions,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: borderColor.withOpacity(0.22),
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor.withOpacity(0.5), width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 210, minWidth: 170),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 34, color: borderColor),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                summary,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                children: actions.map((action) {
                  return Tooltip(
                    message: action['tooltip'],
                    child: IconButton(
                      icon: Icon(action['icon'], color: borderColor, size: 22),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom: AI Responses Feed - improved version!
class _AiResponsesFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (var resp in aiResponses) {
      groups.putIfAbsent(resp['context'], () => []).add(resp);
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        for (final context in groups.keys)
          ...[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 4, bottom: 4),
              child: Text(
                context,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _typeBorderColor(context),
                ),
              ),
            ),
            ...groups[context]!.map((resp) => _AiResponseCard(response: resp)),
          ],
      ],
    );
  }
}

class _AiResponseCard extends StatelessWidget {
  final Map<String, dynamic> response;

  const _AiResponseCard({required this.response});

  @override
  Widget build(BuildContext context) {
    final contextType = response['context']?.toString() ?? '';
    final borderColor = _typeBorderColor(contextType);

    return Card(
      color: AppColors.card,
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 14),
      shadowColor: borderColor.withOpacity(0.22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor.withOpacity(0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: borderColor.withOpacity(0.12),
              radius: 22,
              child: Icon(response['icon'], size: 26, color: borderColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response['message'],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  if (response['chart'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: SizedBox(
                        height: 48,
                        child: Placeholder(), // Replace with real chart
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: (response['actions'] as List<Map<String, dynamic>>).map((action) {
                      return Tooltip(
                        message: action['tooltip'],
                        child: IconButton(
                          icon: Icon(action['icon'], color: borderColor, size: 22),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Voice/Text Avatar section
class _AiAvatarWithInput extends StatelessWidget {
  final bool isListening;
  final AnimationController pulseController;
  final String transcription;
  final VoidCallback onVoiceTap;
  final VoidCallback onTextTap;

  const _AiAvatarWithInput({
    required this.isListening,
    required this.pulseController,
    required this.transcription,
    required this.onVoiceTap,
    required this.onTextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Voice Button (left)
          GestureDetector(
            onTap: onVoiceTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isListening ? AppColors.accent : AppColors.primaryLight,
                  width: isListening ? 3 : 2,
                ),
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          // Centered Avatar
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: isListening ? pulseController : AlwaysStoppedAnimation(1.0),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.eco, size: 44, color: AppColors.primary),
                  ),
                ),
                if (isListening && transcription.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(18),
                      color: AppColors.card,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          transcription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Text Button (right)
          GestureDetector(
            onTap: onTextTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: AppColors.primaryLight,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.keyboard_alt_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Text Input Bottom Sheet (unchanged)
class _TextInputBottomSheet extends StatefulWidget {
  final void Function(String text) onSend;
  final VoidCallback onCancel;

  const _TextInputBottomSheet({
    required this.onSend,
    required this.onCancel,
  });

  @override
  State<_TextInputBottomSheet> createState() => _TextInputBottomSheetState();
}

class _TextInputBottomSheetState extends State<_TextInputBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: widget.onCancel,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevents tap from closing when interacting with sheet
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16 + 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Type your request...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.primaryLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) {
                              widget.onSend(text);
                            }
                          },
                          child: const Text("Send"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: widget.onCancel,
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// (Optional) Subtle animated background (unchanged)
class _AnimatedBackground extends StatefulWidget {
  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat(reverse: true);
    _gradientAnim = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientAnim,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                Color.lerp(AppColors.background, AppColors.primaryLight, 0.18 + 0.12 * _gradientAnim.value)!,
              ],
            ),
          ),
        );
      },
    );
  }
}
