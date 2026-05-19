import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatefulWidget {
  final String room_id;
  final String password;
  final VoidCallback scrollBottomCall;

  const ChatInput({
    super.key,
    required this.room_id,
    required this.password,
    required this.scrollBottomCall,
  });

  @override
  State<ChatInput> createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmoji = false;
  bool _isRecording = false;
  String? _recordingPath;
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _recordTimer;
  int _recordSeconds = 0;
  String? _replyToId;
  String? _replyText;
  final FocusNode _focusNode = FocusNode();

  // Public method to set reply state
  void setReply(String id, String text) {
    setState(() {
      _replyToId = id;
      _replyText = text;
    });
    // Auto-focus the input field when replying
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _recorder.dispose();
    _recordTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _send(BuildContext context) async {
    final chat = context.read<ChatService>();
    if (_controller.text.trim().isEmpty) return;
    
    await chat.sendMessage(
      widget.room_id, 
      widget.password, 
      _controller.text.trim(), 
      "text",
      replyTo: _replyToId,
      replyText: _replyText,
    );

    setState(() {
      _replyToId = null;
      _replyText = null;
    });
    _controller.clear();
    widget.scrollBottomCall();
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    _recordingPath = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _recordingPath!,
    );

    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordSeconds++);
    });
  }

  Future<void> _stopAndSendRecording() async {
    _recordTimer?.cancel();
    await _recorder.stop();

    if (!mounted) return;

    setState(() => _isRecording = false);

    if (_recordingPath != null && File(_recordingPath!).existsSync()) {
      final chat = context.read<ChatService>();
      await chat.uploadAudio(widget.room_id, widget.password, _recordingPath!);
      widget.scrollBottomCall();
    }
  }

  Future<void> _cancelRecording() async {
    _recordTimer?.cancel();
    await _recorder.stop();
    if (_recordingPath != null) {
      final f = File(_recordingPath!);
      if (f.existsSync()) f.deleteSync();
    }
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  String _formatDuration(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8);
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08);
    final inputFill = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);
    final hintColor = isDark ? Colors.white54 : Colors.black38;
    final iconColor = isDark ? Colors.white70 : Colors.black54;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: borderColor, width: 1.0)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    if (_replyToId != null) _buildReplyPreview(isDark, textColor),
                    _isRecording ? _buildRecordingBar(iconColor) : _buildInputBar(inputFill, hintColor, iconColor, textColor, context),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Emoji Picker
        if (_showEmoji)
          SizedBox(
            height: 280,
            child: EmojiPicker(
              textEditingController: _controller,
              onEmojiSelected: (category, emoji) {
                _controller.text += emoji.emoji;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              },
              config: Config(
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  columns: 8,
                  emojiSizeMax: 28,
                ),
                categoryViewConfig: CategoryViewConfig(
                  backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                  iconColor: Colors.grey,
                  iconColorSelected: const Color(0xFF38BDF8),
                  indicatorColor: const Color(0xFF38BDF8),
                ),
                bottomActionBarConfig: BottomActionBarConfig(
                  backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                  buttonColor: const Color(0xFF38BDF8),
                  buttonIconColor: Colors.white,
                ),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  buttonIconColor: const Color(0xFF38BDF8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInputBar(Color inputFill, Color hintColor, Color iconColor, Color textColor, BuildContext context) {
    return Row(
      children: [
        // Emoji toggle
        IconButton(
          onPressed: () => setState(() => _showEmoji = !_showEmoji),
          icon: Icon(_showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined),
          color: _showEmoji ? const Color(0xFF38BDF8) : iconColor,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 6),
        // Image attachment
        IconButton(
          onPressed: () async {
            setState(() => _showEmoji = false);
            final chat = context.read<ChatService>();
            await chat.getImage(widget.room_id, widget.password);
            widget.scrollBottomCall();
          },
          icon: const Icon(CupertinoIcons.paperclip),
          color: iconColor,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        // Text field
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: hintColor.withOpacity(0.2)),
            ),
            child: TextField(
              onTap: () {
                setState(() => _showEmoji = false);
                widget.scrollBottomCall();
              },
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
                hintStyle: TextStyle(color: hintColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Mic button (hold to record)
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _stopAndSendRecording(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.1),
            ),
            child: Icon(Icons.mic_none, color: iconColor, size: 22),
          ),
        ),
        const SizedBox(width: 8),
        // Send button
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
            ),
          ),
          child: IconButton(
            onPressed: () => _send(context),
            icon: const Icon(Icons.send_rounded, size: 20),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildReplyPreview(bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: const Color(0xFF38BDF8), width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Replying to",
                  style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  _replyText ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _replyToId = null;
              _replyText = null;
            }),
            icon: const Icon(Icons.close, size: 18),
            color: textColor.withOpacity(0.5),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingBar(Color iconColor) {
    return Row(
      children: [
        // Cancel
        IconButton(
          onPressed: _cancelRecording,
          icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
        ),
        const SizedBox(width: 8),
        // Animated mic + timer
        const Icon(Icons.mic, color: Color(0xFFEF4444), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Recording  ${_formatDuration(_recordSeconds)}',
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        // Send recording
        GestureDetector(
          onTap: _stopAndSendRecording,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
              ),
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
