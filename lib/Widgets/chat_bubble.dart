import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/Imagedisplay.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final Alignment alignment;
  final String type;
  final String messageId;
  final String? replyText;
  final String senderUsername;
  final DateTime timestamp;
  final VoidCallback onDelete;
  final VoidCallback onReply;

  const ChatBubble({
    super.key,
    required this.alignment,
    required this.message,
    required this.type,
    required this.messageId,
    required this.senderUsername,
    required this.timestamp,
    required this.onDelete,
    required this.onReply,
    this.replyText,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final AudioPlayer _player = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.type == "audio") {
      _player.onPlayerStateChanged.listen((s) {
        if (mounted) setState(() => _playerState = s);
      });
      _player.onDurationChanged.listen((d) {
        if (mounted) setState(() => _duration = d);
      });
      _player.onPositionChanged.listen((p) {
        if (mounted) setState(() => _position = p);
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    bool isSentByMe = widget.alignment == Alignment.centerRight;

    BorderRadius bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isSentByMe ? const Radius.circular(20) : const Radius.circular(4),
      bottomRight: isSentByMe ? const Radius.circular(4) : const Radius.circular(20),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onLongPress: () => _showMenu(context, isSentByMe),
      child: Align(
        alignment: widget.alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: isSentByMe
                      ? const LinearGradient(
                          colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSentByMe
                      ? null
                      : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06)),
                  borderRadius: bubbleRadius,
                  border: isSentByMe
                      ? null
                      : Border.all(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                          width: 1,
                        ),
                  boxShadow: isSentByMe
                      ? [
                          BoxShadow(
                            color: const Color(0xFF38BDF8).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: bubbleRadius,
                  child: isSentByMe
                      ? _buildContent(context, isSentByMe)
                      : BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: _buildContent(context, isSentByMe),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context, bool isSentByMe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Message Info"),
                onTap: () {
                  Navigator.pop(context);
                  _showInfoDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text("Reply"),
                onTap: () {
                  Navigator.pop(context);
                  widget.onReply();
                },
              ),
              if (isSentByMe)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text("Delete Message", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onDelete();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Message Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sender: ${widget.senderUsername}"),
            const SizedBox(height: 8),
            Text("Time: ${widget.timestamp.toLocal().toString().split('.')[0]}"),
            const SizedBox(height: 8),
            Text("Type: ${widget.type}"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isSentByMe) {
    final textColor = isSentByMe
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyText != null) _buildReplyHeader(isSentByMe, textColor),
        _buildMainContent(context, isSentByMe, textColor),
      ],
    );
  }

  Widget _buildReplyHeader(bool isSentByMe, Color textColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSentByMe ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: isSentByMe ? Colors.white70 : const Color(0xFF38BDF8), width: 3)),
      ),
      child: Text(
        widget.replyText!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isSentByMe, Color textColor) {

    if (widget.type == "text") {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          widget.message,
          style: TextStyle(color: textColor, fontSize: 16, height: 1.3),
        ),
      );
    } else if (widget.type == "image") {
      final bool isUrl = widget.message.startsWith('http');
      final bool isBase64 = !isUrl && widget.message.length > 50; // Simple heuristic for Base64

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!isUrl && !isBase64)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      const SizedBox(height: 12),
                      Text(widget.message, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              if (isUrl)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Imagedisplay(src: widget.message),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.message,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                      },
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 40),
                      ),
                    ),
                  ),
                ),
              if (isBase64)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Imagedisplay(src: widget.message),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      base64Decode(widget.message),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 40),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else if (widget.type == "audio") {
      final bool isUrl = widget.message.startsWith('http');
      final bool isBase64 = !isUrl && widget.message.length > 50;

      if (!isUrl && !isBase64) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              const SizedBox(width: 10),
              Text(widget.message, style: TextStyle(color: textColor, fontSize: 13)),
            ],
          ),
        );
      }
      return _buildAudioBubble(isSentByMe, textColor, isBase64);
    }

    return const SizedBox.shrink();
  }

  Widget _buildAudioBubble(bool isSentByMe, Color textColor, bool isBase64) {
    final isPlaying = _playerState == PlayerState.playing;
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: SizedBox(
        width: 220,
        child: Row(
          children: [
            // Play/Pause button
            GestureDetector(
              onTap: () async {
                if (isPlaying) {
                  await _player.pause();
                } else {
                  if (isBase64) {
                    final bytes = base64Decode(widget.message);
                    await _player.play(BytesSource(bytes));
                  } else {
                    await _player.play(UrlSource(widget.message));
                  }
                }
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSentByMe
                      ? Colors.white.withOpacity(0.25)
                      : const Color(0xFF38BDF8).withOpacity(0.15),
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isSentByMe ? Colors.white : const Color(0xFF38BDF8),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Progress + duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.toDouble(),
                      minHeight: 4,
                      backgroundColor: isSentByMe
                          ? Colors.white.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSentByMe ? Colors.white : const Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_fmt(_position)} / ${_fmt(_duration)}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
