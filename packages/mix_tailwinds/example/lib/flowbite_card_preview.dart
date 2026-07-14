import 'package:flutter/material.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

const _flowbiteCardHeroAsset = 'assets/images/flowbite-card-hero.png';

TwConfig flowbiteCardTwConfig(TwConfig base) {
  return base.copyWith(
    radii: {...base.radii, 'base': 8},
    colors: {
      ...base.colors,
      'gray-50': const Color(0xFFF9FAFB),
      'neutral-primary-soft': Colors.white,
      'default': const Color(0xFFE5E7EB),
      'brand': const Color(0xFF1C64F2),
      'brand-strong': const Color(0xFF1A56DB),
      'brand-medium': const Color(0x553B82F6),
      'brand-softer': const Color(0xFFEFF6FF),
      'brand-subtle': const Color(0xFFBFDBFE),
      'fg-brand-strong': const Color(0xFF1D4ED8),
      'heading': const Color(0xFF111827),
    },
  );
}

/// Flowbite card sample matching `real_tailwind/flowbite-card.html`.
class FlowbiteCardPreview extends StatelessWidget {
  const FlowbiteCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Div(
      key: const ValueKey('flowbite-card-root'),
      classNames:
          'bg-neutral-primary-soft block max-w-sm border border-default rounded-base shadow-xs',
      children: const [
        _FlowbiteCardHero(),
        Div(
          key: ValueKey('flowbite-card-content'),
          classNames: 'p-6 text-center',
          children: [
            Div(classNames: 'flex justify-center', child: _FlowbiteBadge()),
            H5(
              key: ValueKey('flowbite-card-heading'),
              text: 'Streamlining your design process today.',
              classNames:
                  'mt-3 mb-6 text-2xl font-semibold tracking-tight text-heading text-center',
            ),
            Div(
              classNames: 'flex justify-center',
              child: _FlowbiteReadMoreButton(),
            ),
          ],
        ),
      ],
    );
  }
}

class _FlowbiteCardHero extends StatelessWidget {
  const _FlowbiteCardHero();

  @override
  Widget build(BuildContext context) {
    return Div(
      key: const ValueKey('flowbite-card-hero'),
      classNames: 'rounded-t-base overflow-hidden',
      child: Image.asset(
        _flowbiteCardHeroAsset,
        width: double.infinity,
        height: 256,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _FlowbiteBadge extends StatelessWidget {
  const _FlowbiteBadge();

  @override
  Widget build(BuildContext context) {
    return const Div(
      key: ValueKey('flowbite-card-badge'),
      classNames:
          'inline-flex items-center bg-brand-softer border border-brand-subtle text-fg-brand-strong text-xs font-medium px-1.5 py-0.5 rounded-sm',
      children: [
        TwIcon(
          Icons.local_fire_department_outlined,
          classNames: 'w-3 h-3 me-1',
        ),
        Span(text: 'Trending'),
      ],
    );
  }
}

class _FlowbiteReadMoreButton extends StatelessWidget {
  const _FlowbiteReadMoreButton();

  @override
  Widget build(BuildContext context) {
    return const Div(
      key: ValueKey('flowbite-card-read-more'),
      classNames:
          'inline-flex items-center text-white bg-brand box-border border border-transparent hover:bg-brand-strong focus:ring-4 focus:ring-brand-medium shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none',
      children: [
        Span(text: 'Read more'),
        TwIcon(Icons.arrow_forward, classNames: 'w-4 h-4 ms-1.5'),
      ],
    );
  }
}
