import 'package:flutter/material.dart';
import 'package:mix_winds/mix_winds.dart';

void _noop() {}

/// Card alert preview widget matching the card-alert.html Tailwind reference.
class CardAlertPreview extends StatelessWidget {
  const CardAlertPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames:
          'min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 flex items-start justify-start p-4',
      child: Div(
        classNames: 'w-full',
        child: Div(
          classNames:
              'bg-white/10 border border-white/20 rounded-3xl p-6 shadow-2xl',
          child: div('flex items-start gap-4', [
            // Avatar with gradient background
            Div(
              classNames:
                  'w-14 h-14 rounded-full bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center border-2 border-purple-400',
              child: span('text-white font-semibold text-lg', 'SM'),
            ),
            // Content
            Div(
              key: const ValueKey('card-alert-content'),
              classNames: 'flex-1 min-w-0',
              children: [
                // Name + badge row
                div('flex items-center gap-2 mb-1', [
                  h3(
                    'text-white font-semibold text-lg truncate',
                    'Sarah Mitchell',
                  ),
                  span(
                    'px-2 py-0.5 bg-purple-500/30 text-purple-200 text-xs rounded-full font-medium',
                    'Admin',
                  ),
                ]),
                // Message
                const P(
                  key: ValueKey('card-alert-message'),
                  text:
                      'Your profile changes are ready to publish. Review and confirm to update your public information.',
                  classNames: 'text-slate-300 text-sm mb-4',
                ),
                // Warning callout
                Div(
                  key: const ValueKey('card-alert-warning'),
                  classNames:
                      'bg-white/5 rounded-xl p-3 mb-4 border border-white/10',
                  child: div('flex items-center gap-2 text-amber-300 text-sm', [
                    span('', '\u26A0'),
                    span('', 'This action cannot be undone'),
                  ]),
                ),
                // Button row
                Div(
                  key: const ValueKey('card-alert-button-row'),
                  classNames: 'flex gap-3',
                  children: [
                    Button(
                      key: const ValueKey('card-alert-cancel-button'),
                      classNames:
                          'flex-1 px-4 py-2.5 bg-white/10 hover:bg-white/20 text-white rounded-xl font-medium border border-white/10 hover:border-white/20 flex items-center justify-center',
                      onPressed: _noop,
                      child: span('', 'Cancel'),
                    ),
                    Button(
                      key: const ValueKey('card-alert-save-button'),
                      classNames:
                          'flex-1 px-4 py-2.5 bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-400 hover:to-pink-400 text-white rounded-xl font-medium shadow-lg flex items-center justify-center',
                      onPressed: _noop,
                      child: span('', 'Save Changes'),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
