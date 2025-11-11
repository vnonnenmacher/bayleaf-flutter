import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bayleaf_flutter/theme/app_colors.dart';
import 'package:bayleaf_flutter/l10n/app_localizations.dart';
import 'package:bayleaf_flutter/models/user_type.dart';

class DoraScreen extends StatefulWidget {
  const DoraScreen({super.key});

  @override
  State<DoraScreen> createState() => _DoraScreenState();
}

class _DoraScreenState extends State<DoraScreen>
    with SingleTickerProviderStateMixin {
  List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = false;

  final List<_TreatmentEvent> _events = [
    _TreatmentEvent(
      icon: Icons.medication_liquid_outlined,
      title: "Tomar medicação",
      subtitle: "Daqui 30 minutos",
      color: AppColors.primary,
    ),
    _TreatmentEvent(
      icon: Icons.calendar_today_rounded,
      title: "Consulta médica",
      subtitle: "Amanhã às 09:00",
      color: AppColors.secondary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final typeString = prefs.getString('user_type');
    final userType =
        typeString != null ? userTypeFromString(typeString) : UserType.patient;

    List<_ChatMessage> msgs = [
      _ChatMessage(
        sender: _Sender.dora,
        text: "Olá! 👋 Eu sou a Dora, sua assistente de cuidados.",
      ),
      _ChatMessage(
        sender: _Sender.dora,
        text: "Você já tomou o seu medicamento de hoje?",
        hasQuickReplies: true,
        quickReplies: ["Sim", "Não"],
      ),
      _ChatMessage(
        sender: _Sender.dora,
        text: "Como você está se sentindo agora?",
      ),
    ];

    if (userType == UserType.relative || userType == UserType.professional) {
      msgs = [
        _ChatMessage(
          sender: _Sender.dora,
          text: "Olá! 👋 Eu sou a Dora, sua assistente de cuidados.",
        ),
        _ChatMessage(
          sender: _Sender.dora,
          text:
              "Aqui você pode acompanhar o progresso e as tarefas do seu familiar.",
        ),
        _ChatMessage(
          sender: _Sender.dora,
          text:
              "Maria completou todas as tarefas de hoje ✅ e possui uma consulta agendada amanhã às 09:00.",
        ),
        _ChatMessage(
          sender: _Sender.dora,
          text:
              "O estoque de medicamentos está ficando baixo. Deseja receber um lembrete para repor?",
          hasQuickReplies: true,
          quickReplies: ["Sim", "Não"],
        ),
      ];
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _messages = msgs);
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _showSuggestions = !_showSuggestions);
      return;
    }
    setState(() {
      _messages.add(_ChatMessage(sender: _Sender.user, text: text));
      _showSuggestions = false;
    });
    _controller.clear();
  }

  void _handleQuickReply(int index, String reply) {
    setState(() {
      _messages[index] = _messages[index].copyWith(hasQuickReplies: false);
      _messages.add(_ChatMessage(sender: _Sender.user, text: reply));
    });
  }

  void _openAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined,
                  color: AppColors.primary),
              title: const Text("Documento"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selecionar documento...")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primary),
              title: const Text("Mídia (foto ou vídeo)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selecionar da galeria...")));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openCamera() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Abrir câmera...")));
  }

  void _onSuggestionSelected(String title) {
    setState(() {
      _showSuggestions = false;
      _messages.add(_ChatMessage(sender: _Sender.user, text: title));
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildNextEvents(),
                  const Divider(height: 1, color: AppColors.greyLight),
                  Expanded(child: _buildChatList()),
                  _buildInputBar(loc),
                ],
              ),
              if (_showSuggestions) _buildFloatingSuggestions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextEvents() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  color: AppColors.primary.withOpacity(0.8), size: 22),
              const SizedBox(width: 8),
              const Text(
                "Próximas etapas no tratamento",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 115,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: _events.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final e = _events[index];
                return Container(
                  width: 210,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: e.color.withOpacity(0.25), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: e.color.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: e.color.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(e.icon, color: e.color, size: 22),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isDora = msg.sender == _Sender.dora;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: 1,
          child: Align(
            alignment: isDora ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: isDora
                    ? AppColors.primaryLight.withOpacity(0.8)
                    : AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isDora ? 4 : 18),
                  bottomRight: Radius.circular(isDora ? 18 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDora)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              AppColors.primary.withOpacity(0.25),
                          child: const Icon(Icons.local_florist_rounded,
                              color: AppColors.primary, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            msg.text,
                            style: const TextStyle(
                              fontSize: 15.5,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      msg.text,
                      style: const TextStyle(
                        fontSize: 15.5,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  if (msg.hasQuickReplies && msg.quickReplies != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 28),
                      child: Row(
                        children: [
                          _buildInlineReplyButton(
                            msg.quickReplies![0],
                            index,
                            Colors.green.shade50,
                            Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          _buildInlineReplyButton(
                            msg.quickReplies![1],
                            index,
                            Colors.red.shade50,
                            Colors.red.shade700,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputBar(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file_rounded,
                color: AppColors.textSecondary),
            onPressed: _openAttachmentOptions,
          ),
          IconButton(
            icon: const Icon(Icons.photo_camera_outlined,
                color: AppColors.textSecondary),
            onPressed: _openCamera,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.greyLight.withOpacity(0.6)),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: loc.typeYourMessage,
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _handleSend,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineReplyButton(
      String text, int msgIndex, Color bgColor, Color borderColor) {
    return GestureDetector(
      onTap: () => _handleQuickReply(msgIndex, text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: borderColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingSuggestions() {
    return Positioned(
      bottom: 100, // sits right above the input bar
      right: 20,
      child: AnimatedOpacity(
        opacity: _showSuggestions ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSuggestionButton("Adicionar medicação",
                Icons.medication_outlined, Colors.green.shade500),
            const SizedBox(height: 10),
            _buildSuggestionButton("Adicionar consulta",
                Icons.calendar_today_outlined, Colors.teal.shade600),
            const SizedBox(height: 10),
            _buildSuggestionButton("Adicionar exame",
                Icons.biotech_outlined, Colors.orange.shade400),
            const SizedBox(height: 10),
            _buildSuggestionButton("Orientação médica",
                Icons.shield_outlined, Colors.lightBlue.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionButton(String text, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _onSuggestionSelected(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Sender { dora, user }

class _ChatMessage {
  final _Sender sender;
  final String text;
  final bool hasQuickReplies;
  final List<String>? quickReplies;

  _ChatMessage({
    required this.sender,
    required this.text,
    this.hasQuickReplies = false,
    this.quickReplies,
  });

  _ChatMessage copyWith({bool? hasQuickReplies}) {
    return _ChatMessage(
      sender: sender,
      text: text,
      hasQuickReplies: hasQuickReplies ?? this.hasQuickReplies,
      quickReplies: quickReplies,
    );
  }
}

class _TreatmentEvent {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  _TreatmentEvent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
