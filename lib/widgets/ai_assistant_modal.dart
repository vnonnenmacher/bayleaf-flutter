import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

void showAiModal({
  required BuildContext context,
  required void Function(String action) onAction,
  VoidCallback? onVoiceTap,
  void Function(String text)? onTextSend,
  List<Map<String, dynamic>>? suggestionsOverride,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return _AiModalContent(
        onAction: onAction,
        onVoiceTap: onVoiceTap,
        onTextSend: onTextSend,
        suggestionsOverride: suggestionsOverride,
      );
    },
  );
}

class _AiModalContent extends StatefulWidget {
  final void Function(String action) onAction;
  final VoidCallback? onVoiceTap;
  final void Function(String text)? onTextSend;
  final List<Map<String, dynamic>>? suggestionsOverride;

  const _AiModalContent({
    required this.onAction,
    this.onVoiceTap,
    this.onTextSend,
    this.suggestionsOverride,
  });

  @override
  State<_AiModalContent> createState() => _AiModalContentState();
}

class _AiModalContentState extends State<_AiModalContent> {
  bool typingMode = false;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Map<String, dynamic>> get suggestions =>
      widget.suggestionsOverride ??
      [
        {
          "label": "Add Medication",
          "icon": Icons.medication_outlined,
          "action": "add_medication",
        },
        {
          "label": "Schedule",
          "icon": Icons.calendar_today_outlined,
          "action": "schedule_appointment",
        },
        {
          "label": "Log Symptom",
          "icon": Icons.edit_note_outlined,
          "action": "log_symptom",
        },
      ];

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _enterTypingMode() {
    setState(() => typingMode = true);
    Future.delayed(Duration(milliseconds: 150), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _exitTypingMode() {
    setState(() => typingMode = false);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final instructionStyle = TextStyle(
      fontSize: 14,
      color: AppColors.textSecondary.withOpacity(0.8),
    );
    final tapToSpeakStyle = TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    );
    final typeInsteadStyle = TextStyle(
      fontSize: 13,
      color: AppColors.textSecondary.withOpacity(0.7),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline,
    );
    final chipLabelStyle = TextStyle(
      fontSize: 13,
      color: AppColors.textSecondary.withOpacity(0.85),
      fontWeight: FontWeight.w500,
    );
    final chipLabelMuted = TextStyle(
      fontSize: 12,
      color: AppColors.textSecondary.withOpacity(0.7),
      fontWeight: FontWeight.w400,
    );

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
        child: typingMode
            ? _buildTypeView(context, instructionStyle)
            : _buildMicView(
                context,
                instructionStyle,
                tapToSpeakStyle,
                typeInsteadStyle,
                chipLabelStyle,
                chipLabelMuted,
              ),
      ),
    );
  }

  Widget _buildMicView(
    BuildContext context,
    TextStyle instructionStyle,
    TextStyle tapToSpeakStyle,
    TextStyle typeInsteadStyle,
    TextStyle chipLabelStyle,
    TextStyle chipLabelMuted,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Mic icon - centered, large
        Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(64),
            onTap: () {
              Navigator.of(context).pop();
              if (widget.onVoiceTap != null) widget.onVoiceTap!();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.22),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              width: 72,
              height: 72,
              child: Icon(Icons.mic, color: Colors.white, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Prompt
        Center(
          child: Text(
            "How can I help you today?",
            style: TextStyle(
              fontSize: 17,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        // Tap to speak (bold, green, CTA)
        Center(
          child: Text(
            "Tap to speak",
            style: tapToSpeakStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // Type instead (muted, secondary link)
        Center(
          child: TextButton(
            onPressed: _enterTypingMode,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary.withOpacity(0.7),
              minimumSize: Size(20, 20),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("Type instead", style: typeInsteadStyle),
          ),
        ),
        // --------- Suggestions Section -------------
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 24),
          Divider(
            color: AppColors.grey.withOpacity(0.14),
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 10),
          Text(
            "Or try one of these:",
            style: chipLabelMuted,
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 6,
            children: suggestions.map((suggestion) {
              return ActionChip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: AppColors.greyLight,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                elevation: 0,
                pressElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: BorderSide(
                    color: AppColors.grey.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                avatar: Icon(
                  suggestion["icon"] as IconData,
                  size: 17,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                label: Text(
                  suggestion["label"] as String,
                  style: chipLabelStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onAction(suggestion["action"] as String);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeView(BuildContext context, TextStyle instructionStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // AI Icon
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.psychology_alt_rounded, color: AppColors.primary, size: 32),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            "What can I help you with?",
            style: instructionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 18),
        // Text Input
        TextField(
          controller: _textController,
          focusNode: _focusNode,
          autofocus: true,
          minLines: 1,
          maxLines: 3,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Type your request...",
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.grey.withOpacity(0.17), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.7), width: 1.4),
            ),
            fillColor: AppColors.greyLight,
            filled: true,
          ),
          onSubmitted: (value) => _handleSend(context),
        ),
        // 🎤 Use voice instead
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _exitTypingMode,
              icon: Icon(Icons.mic, size: 18, color: AppColors.textSecondary.withOpacity(0.65)),
              label: Text(
                "Use voice instead",
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.65),
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size(20, 32),
                foregroundColor: AppColors.textSecondary.withOpacity(0.65),
              ),
            ),
          ),
        ),
        // Buttons
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Cancel
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Cancel"),
              ),
              const SizedBox(width: 12),
              // Send
              ElevatedButton(
                onPressed: () => _handleSend(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text("Send"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSend(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isNotEmpty && widget.onTextSend != null) {
      Navigator.of(context).pop();
      widget.onTextSend!(text);
    }
  }
}
