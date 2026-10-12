import 'package:flutter/material.dart';
import 'package:mix_winds/mix_winds.dart';

/// Isolated Flutter subjects for the ten complex Tailwind visual comparisons.
class ComplexParityPreview extends StatelessWidget {
  const ComplexParityPreview({
    super.key,
    required this.caseId,
    required this.width,
  });

  final String caseId;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 320,
      child: ColoredBox(
        color: const Color(0xFFF3F4F6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _SelectedComplexCase(caseId: caseId),
        ),
      ),
    );
  }
}

class _SelectedComplexCase extends StatelessWidget {
  const _SelectedComplexCase({required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: switch (caseId) {
        '01' => const _Case01(),
        '02' => const _Case02(),
        '03' => const _Case03(),
        '04' => const _Case04(),
        '05' => const _Case05(),
        '06' => const _Case06(),
        '07' => const _Case07(),
        '08' => const _Case08(),
        '09' => const _Case09(),
        '10' => const _Case10(),
        _ => const _Case01(),
      },
    );
  }
}

class _Case01 extends StatelessWidget {
  const _Case01();

  @override
  Widget build(BuildContext context) {
    return const Div(
      classNames:
          'w-80 h-48 p-6 bg-slate-900 border-2 border-slate-700 '
          'rounded-2xl shadow-lg',
      child: SizedBox(),
    );
  }
}

class _Case02 extends StatelessWidget {
  const _Case02();

  @override
  Widget build(BuildContext context) {
    return div('flex w-full flex-col', [
      Div(
        classNames: 'p-2 px-6 pt-4 m-2 mx-4 mt-8 bg-red-500',
        child: div('w-16 h-12 bg-white'),
      ),
      Div(
        classNames: 'bg-red-500 mt-8 mx-4 m-2 pt-4 px-6 p-2',
        child: div('w-16 h-12 bg-white'),
      ),
    ]);
  }
}

class _Case03 extends StatelessWidget {
  const _Case03();

  @override
  Widget build(BuildContext context) {
    return div(
      'w-[37px] h-[29px] bg-[#123456]/[50%] '
      'translate-x-[11px] -translate-y-[7px]',
    );
  }
}

class _Case04 extends StatelessWidget {
  const _Case04();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      child: p(
        'text-2xl font-bold leading-tight tracking-tight '
            'text-slate-700 uppercase text-center truncate',
        'complex tailwind overflow sample',
      ),
    );
  }
}

class _Case05 extends StatelessWidget {
  const _Case05();

  @override
  Widget build(BuildContext context) {
    return div(
      'w-[300px] h-[120px] bg-linear-to-br '
      'from-blue-500 via-purple-500 to-pink-500',
    );
  }
}

class _Case06 extends StatelessWidget {
  const _Case06();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: div(
        'w-24 h-24 bg-emerald-500 translate-x-4 '
        '-translate-y-2 rotate-45 scale-105',
      ),
    );
  }
}

class _Case07 extends StatelessWidget {
  const _Case07();

  @override
  Widget build(BuildContext context) {
    return div('w-full md:w-1/2 lg:w-1/3 h-12 bg-blue-500');
  }
}

class _Case08 extends StatelessWidget {
  const _Case08();

  @override
  Widget build(BuildContext context) {
    return div(
      'w-full h-40 flex flex-col gap-2 md:flex-row md:gap-6 '
      'items-center justify-between',
      [
        div('w-10 h-10 rounded-lg bg-blue-500'),
        div('w-10 h-10 rounded-lg bg-purple-500'),
        div('w-10 h-10 rounded-lg bg-pink-500'),
      ],
    );
  }
}

class _Case09 extends StatelessWidget {
  const _Case09();

  @override
  Widget build(BuildContext context) {
    return div(
      'w-24 h-24 bg-white dark:bg-slate-900 '
      'dark:hover:bg-blue-900',
    );
  }
}

class _Case10 extends StatelessWidget {
  const _Case10();

  @override
  Widget build(BuildContext context) {
    return div(
      'w-24 h-24 bg-red-500 hover:bg-blue-500 transition-colors '
      'duration-300 ease-in-out delay-100',
    );
  }
}
