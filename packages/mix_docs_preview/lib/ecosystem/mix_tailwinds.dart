import 'package:flutter/material.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

// #docregion example
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return TwScope(
      child: Div(
        classNames:
            'bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 p-6',
        child: Div(
          classNames:
              'bg-white/10 border border-white/20 rounded-3xl p-6 shadow-2xl',
          child: Div(
            classNames: 'flex items-start gap-4',
            children: [
              Div(
                classNames:
                    'w-14 h-14 rounded-full bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center border-2 border-purple-400',
                child: const Span(
                  text: 'SM',
                  classNames: 'text-white font-semibold text-lg',
                ),
              ),
              Div(
                classNames: 'flex-1 min-w-0',
                children: [
                  Div(
                    classNames: 'flex items-center gap-2 mb-1',
                    children: const [
                      H3(
                        text: 'Sarah Mitchell',
                        classNames: 'text-white font-semibold text-lg truncate',
                      ),
                      Span(
                        text: 'Admin',
                        classNames:
                            'px-2 py-0.5 bg-purple-500/30 text-purple-200 text-xs rounded-full font-medium',
                      ),
                    ],
                  ),
                  const P(
                    text:
                        'Your profile changes are ready to publish. Review and confirm to update your public information.',
                    classNames: 'text-slate-300 text-sm mb-4',
                  ),
                  Div(
                    classNames:
                        'bg-white/5 rounded-xl p-3 mb-4 border border-white/10',
                    child: Div(
                      classNames:
                          'flex items-center gap-2 text-amber-300 text-sm',
                      children: const [
                        Span(text: '\u26A0'),
                        Span(text: 'This action cannot be undone'),
                      ],
                    ),
                  ),
                  Div(
                    classNames: 'flex gap-3',
                    children: [
                      Div(
                        classNames:
                            'flex-1 px-4 py-2.5 bg-white/10 hover:bg-white/20 text-white rounded-xl font-medium border border-white/10 hover:border-white/20 flex items-center justify-center',
                        child: const Span(text: 'Cancel'),
                      ),
                      Div(
                        classNames:
                            'flex-1 px-4 py-2.5 bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-400 hover:to-pink-400 text-white rounded-xl font-medium shadow-lg flex items-center justify-center',
                        child: const Span(text: 'Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// #enddocregion example
