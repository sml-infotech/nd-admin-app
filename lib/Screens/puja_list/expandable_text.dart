
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class ExpandableText extends StatefulWidget {
  final String label;
  final String text;
  final TextStyle style;
  final int maxLines;

  const ExpandableText({
    required this.label,
    required this.text,
    required this.style,
    this.maxLines = 2,
  });

  @override
  State<ExpandableText> createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool showButton = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: "${widget.label}",
      style: widget.style.copyWith(fontWeight: FontWeight.bold),
      children: [TextSpan(text: widget.text, style: widget.style)],
    );

    final tp = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tp.didExceedMaxLines && !showButton) {
        setState(() => showButton = true);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: textSpan,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (showButton)
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                isExpanded ? "Show less" : "Show more",
                style: widget.style.copyWith(
                  color: ColorConstant.buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}