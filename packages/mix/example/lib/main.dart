// ABOUTME: Demo app for Mix shadow styling.
// ABOUTME: Shows BoxShadowListMix / ShadowListMix via literal lists and via
// design tokens resolved with `token.mix()`.
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(const ShadowExampleApp());

// -----------------------------------------------------------------------------
// Design tokens.
//
// A `BoxShadowToken` / `ShadowToken` is a named handle for a list of shadows.
// `token.mix()` returns a Mix-compatible reference (a `BoxShadowListMix` /
// `ShadowListMix`) that can be passed straight into the styler shadow methods.
// The actual values are supplied once, at the top of the tree, via `MixScope`.
// -----------------------------------------------------------------------------
const cardShadow = BoxShadowToken('shadow.card');
const floatingShadow = BoxShadowToken('shadow.floating');
const headlineGlow = ShadowToken('shadow.headline-glow');

class ShadowExampleApp extends StatelessWidget {
  const ShadowExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mix Shadow Example',
      debugShowCheckedModeBanner: false,
      home: MixScope(
        // Bind each token to its resolved value. Every `token.mix()` used below
        // resolves through this scope.
        boxShadows: {
          cardShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
          floatingShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 12),
              blurRadius: 28,
              spreadRadius: -6,
            ),
          ],
        },
        shadows: {
          headlineGlow: const [
            Shadow(color: Color(0xAA4527A0), offset: Offset(0, 0), blurRadius: 18),
          ],
        },
        child: const ShadowGallery(),
      ),
    );
  }
}

class ShadowGallery extends StatelessWidget {
  const ShadowGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(title: const Text('Mix · Shadow styling')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _SectionLabel('1 · Literal box shadows (List<BoxShadowMix>)'),
          _LiteralBoxShadowCard(),
          SizedBox(height: 32),

          _SectionLabel('2 · Box shadow token via cardShadow.mix()'),
          _TokenBoxShadowCard(),
          SizedBox(height: 32),

          _SectionLabel('3 · Elevated token via floatingShadow.mix()'),
          _FloatingTokenCard(),
          SizedBox(height: 32),

          _SectionLabel('4 · Text shadows (literal + headlineGlow.mix())'),
          _TextShadowSample(),
        ],
      ),
    );
  }
}

/// A box styled with a literal list of [BoxShadowMix] passed to `boxShadows`.
///
/// Internally Mix wraps this list in a [BoxShadowListMix]; you can also pass an
/// explicit one (e.g. from a token) — see [_TokenBoxShadowCard].
class _LiteralBoxShadowCard extends StatelessWidget {
  const _LiteralBoxShadowCard();

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.white)
        .height(96)
        .borderRounded(16)
        .boxShadows([
          BoxShadowMix(
            color: Colors.black.withValues(alpha: 0.18),
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
          BoxShadowMix(
            color: Colors.indigo.withValues(alpha: 0.20),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ]);

    return Box(style: style, child: const _CardLabel('boxShadows([...])'));
  }
}

/// A box whose shadow comes from the [cardShadow] design token.
///
/// `cardShadow.mix()` returns a `BoxShadowListMix` reference; the styler keeps
/// its plain `List<BoxShadowMix>` signature, so the token flows straight in and
/// resolves against the value registered in [MixScope].
class _TokenBoxShadowCard extends StatelessWidget {
  const _TokenBoxShadowCard();

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.white)
        .height(96)
        .borderRounded(16)
        .boxShadows(cardShadow.mix());

    return Box(style: style, child: const _CardLabel('boxShadows(cardShadow.mix())'));
  }
}

/// Same token mechanism, with a more pronounced "floating" elevation token.
class _FloatingTokenCard extends StatelessWidget {
  const _FloatingTokenCard();

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.white)
        .height(96)
        .borderRounded(20)
        // `shadows` is the DecorationStyleMixin alias for `boxShadows`.
        .shadows(floatingShadow.mix());

    return Box(style: style, child: const _CardLabel('shadows(floatingShadow.mix())'));
  }
}

/// Text using a literal [ShadowMix] list and a token-backed glow.
class _TextShadowSample extends StatelessWidget {
  const _TextShadowSample();

  @override
  Widget build(BuildContext context) {
    final literal = TextStyler()
        .fontSize(28)
        .fontWeight(FontWeight.w800)
        .color(Colors.black87)
        .shadows([
          ShadowMix(
            color: Colors.black.withValues(alpha: 0.35),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ]);

    final glow = TextStyler()
        .fontSize(28)
        .fontWeight(FontWeight.w800)
        .color(Colors.deepPurple)
        .shadows(headlineGlow.mix());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText('Literal shadow', style: literal),
        const SizedBox(height: 16),
        StyledText('Token glow', style: glow),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel(this.code);

  final String code;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}
