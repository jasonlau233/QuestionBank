import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    @required this.expandText,
    this.collapseText,
    this.expanded = false,
    this.onExpandedChanged,
    @required this.firstText,
    @required this.middleText,
    @required this.firstText2,
    @required this.middleText2,
    @required this.lastText,
    @required this.maxMiddleCount,
    this.needBetweenText = false,
    this.middlefontSize,
    this.linkColor,
    this.linkEllipsis = true,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.strutStyle,
    this.semanticsLabel,
  })  : assert(text != null),
        assert(expandText != null),
        assert(expanded != null),
        assert(linkEllipsis != null),
        super(key: key);

  final String text;
  final String firstText;
  final String middleText;
  final String firstText2;
  final String middleText2;
  final bool needBetweenText;
  final TextSpan lastText;
  final double middlefontSize;
  final String expandText;
  final String collapseText;
  final int maxMiddleCount;
  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;
  final Color linkColor;
  final bool linkEllipsis;
  final TextStyle style;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final double textScaleFactor;
  final StrutStyle strutStyle;
  final String semanticsLabel;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    final toggledExpanded = !_expanded;

    setState(() => _expanded = toggledExpanded);

    widget.onExpandedChanged?.call(toggledExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final collapseText =
        widget.collapseText != null ? ' ${widget.collapseText}' : '';
    final expandText = widget.expandText;

    final linkText = _expanded ? collapseText : expandText;
    final linkColor = widget.linkColor ?? Theme.of(context).accentColor;
    final linkTextStyle = effectiveTextStyle.copyWith(color: linkColor);

    final link = TextSpan(
      children: [
        if (!_expanded)
          TextSpan(
            text: '',
            style: widget.linkEllipsis ? linkTextStyle : effectiveTextStyle,
            recognizer: widget.linkEllipsis ? _tapGestureRecognizer : null,
          ),
        if (linkText.length > 0)
          TextSpan(
            text: linkText,
            style: linkTextStyle,
            recognizer: _tapGestureRecognizer,
          ),
      ],
    );

    final text = TextSpan(text: widget.text);

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        final textAlign =
            widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
        final textDirection =
            widget.textDirection ?? Directionality.of(context);
        final textScaleFactor =
            widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
        final locale = Localizations.localeOf(context);

        final strutStyle = widget.strutStyle ??
            StrutStyle(
              forceStrutHeight: true,
              height: 1,
              leading: 0.5, //行距（0.5即行高的一半）
            );

        TextPainter textPainter = TextPainter(
            text: link,
            textAlign: textAlign,
            textDirection: textDirection,
            textScaleFactor: textScaleFactor,
            locale: locale,
            maxLines: 1);
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: effectiveTextStyle,
            text: widget.firstText,
            children: <TextSpan>[
              betweenFirstText(),
              betweenMiddleText(),
              TextSpan(
                  text: _expanded
                      ? widget.middleText
                      : '${widget.middleText.substring(0, widget.maxMiddleCount)}${widget.maxMiddleCount != 0 ? '···' : ''}',
                  style: TextStyle(
                      color: ColorUtils.color_bg_theme,
                      fontSize: widget.middlefontSize)),
              widget.lastText,
              link,
            ],
          );
        } else {
          textSpan = text;
        }

        return RichText(
          text: textSpan,
          softWrap: true,
          textDirection: textDirection,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          strutStyle: strutStyle,
          overflow: TextOverflow.clip,
        );
      },
    );

    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }

    return result;
  }

  TextSpan betweenFirstText() {
    if (widget.needBetweenText) {
      return TextSpan(
          text: '${widget.firstText2}',
          style: TextStyle(
              color: ColorUtils.color_bg_theme,
              fontSize: widget.middlefontSize));
    } else {
      return TextSpan(text: '');
    }
  }

  TextSpan betweenMiddleText() {
    if (widget.needBetweenText) {
      return TextSpan(text: '${widget.middleText2}', style: widget.style);
    } else {
      return TextSpan(text: '');
    }
  }
}
