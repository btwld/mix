import 'package:flutter/material.dart';
import 'package:mix_winds/mix_winds.dart';

/// Five product-scale specimens used by the advanced visual parity suite.
///
/// The matching Tailwind markup lives in
/// `real_tailwind/advanced-examples.html`. Keep utility strings identical
/// between both implementations so a diff measures renderer behavior rather
/// than fixture drift.
class AdvancedParityPreview extends StatelessWidget {
  const AdvancedParityPreview({super.key, required this.exampleId});

  final String exampleId;

  @override
  Widget build(BuildContext context) {
    final (selectedExampleId, selectedExample) = switch (exampleId) {
      '02' => ('02', _signalAnalytics),
      '03' => ('03', _incidentRoom),
      '04' => ('04', _releaseTimeline),
      '05' => ('05', _capacityMap),
      _ => ('01', _launchCommand),
    };

    return Div(
      key: const ValueKey('advanced-parity-frame'),
      classNames: 'flex w-full flex-col items-center gap-8 p-6',
      child: KeyedSubtree(
        key: ValueKey('advanced-example-$selectedExampleId'),
        child: selectedExample,
      ),
    );
  }
}

// showcase:start launch-command
final _launchCommand = div(
  'flex w-full max-w-5xl flex-col overflow-hidden rounded-3xl bg-slate-950 shadow-2xl',
  [
    div('flex h-2 w-full', [
      div('h-2 flex-1 bg-cyan-400'),
      div('h-2 flex-1 bg-blue-500'),
      div('h-2 flex-1 bg-violet-500'),
    ]),
    div('flex flex-col p-6 md:p-8', [
      div('flex flex-col gap-4 md:flex-row md:items-center md:justify-between', [
        div('flex flex-col gap-2', [
          p(
            'text-xs font-bold tracking-widest text-cyan-300',
            'NORTHSTAR / LAUNCH CONTROL',
          ),
          h1(
            'text-4xl font-bold tracking-tight text-white md:text-5xl',
            'Atlas release',
          ),
          p(
            'text-base text-slate-400',
            'Production window opens today at 18:40 UTC.',
          ),
        ]),
        div(
          'flex self-start items-center gap-2 rounded-full border border-emerald-400/40 bg-emerald-400/10 px-3 py-2',
          [
            div('h-2 w-2 rounded-full bg-emerald-400'),
            span('text-sm font-semibold text-emerald-300', 'Systems nominal'),
          ],
        ),
      ]),
      div('mt-8 flex flex-col gap-4 md:flex-row', [
        div(
          'flex flex-1 flex-col justify-between gap-6 rounded-2xl border border-white/10 bg-white/5 p-5',
          [
            div('flex items-start justify-between gap-4', [
              div('flex flex-col gap-1', [
                p('text-sm font-semibold text-slate-300', 'Launch readiness'),
                p('text-xs text-slate-500', 'All critical paths'),
              ]),
              p('text-4xl font-bold tracking-tight text-white', '86%'),
            ]),
            div('h-3 w-full overflow-hidden rounded-full bg-white/10', [
              div(
                'h-3 w-5/6 rounded-full bg-linear-to-r from-cyan-400 to-blue-500',
              ),
            ]),
            div(
              'flex flex-col gap-3 border-t border-white/10 pt-4 lg:flex-row',
              [
                div('flex flex-1 items-center gap-2', [
                  div('h-3 w-3 rounded-full bg-emerald-400'),
                  span('text-xs font-medium text-slate-300', 'Build signed'),
                ]),
                div('flex flex-1 items-center gap-2', [
                  div('h-3 w-3 rounded-full bg-cyan-400'),
                  span('text-xs font-medium text-slate-300', 'QA cleared'),
                ]),
                div('flex flex-1 items-center gap-2', [
                  div('h-3 w-3 rounded-full bg-amber-300'),
                  span('text-xs font-medium text-slate-300', 'Comms ready'),
                ]),
              ],
            ),
          ],
        ),
        div('flex flex-col gap-4 md:flex-1', [
          div(
            'flex flex-1 items-end justify-between gap-4 rounded-2xl border border-white/10 bg-white/5 p-5',
            [
              div('flex flex-col gap-1', [
                p(
                  'text-xs font-semibold uppercase text-slate-400',
                  'Open incidents',
                ),
                p('text-xs text-slate-500', 'Both non-blocking'),
              ]),
              p('text-3xl font-bold tracking-tight text-white', '02'),
            ],
          ),
          div(
            'flex flex-1 items-end justify-between gap-4 rounded-2xl border border-white/10 bg-white/5 p-5',
            [
              div('flex flex-col gap-1', [
                p(
                  'text-xs font-semibold uppercase text-slate-400',
                  'Deploy window',
                ),
                p('text-xs text-slate-500', 'Ahead by 11 min'),
              ]),
              p('text-3xl font-bold tracking-tight text-white', '42m'),
            ],
          ),
        ]),
      ]),
      div(
        'mt-6 flex flex-col gap-4 border-t border-white/10 pt-6 md:flex-row md:items-center md:justify-between',
        [
          p(
            'text-sm text-slate-400',
            'Last integrity check completed 4 minutes ago.',
          ),
          button(
            'flex items-center justify-center rounded-full bg-cyan-300 px-5 py-3 text-sm font-bold text-slate-950 hover:bg-cyan-200 focus-visible:bg-cyan-200',
            [span('', 'Open command center')],
            onPressed: _noop,
          ),
        ],
      ),
    ]),
  ],
);

// showcase:end launch-command

// showcase:start signal-analytics
final _signalAnalytics = div(
  'flex w-full max-w-5xl flex-col overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-xl',
  [
    div('flex h-2 w-full', [
      div('h-2 flex-1 bg-blue-600'),
      div('h-2 flex-1 bg-cyan-400'),
      div('h-2 flex-1 bg-teal-300'),
    ]),
    div('flex flex-col p-6 md:p-8', [
      div('flex flex-col gap-3 md:flex-row md:items-end md:justify-between', [
        div('flex flex-col items-start gap-2', [
          p(
            'text-xs font-bold tracking-widest text-blue-700',
            'WEEKLY SIGNAL / ACQUISITION',
          ),
          h2(
            'text-3xl font-bold tracking-tight text-slate-900 md:text-4xl',
            'Momentum is compounding',
          ),
        ]),
        p('text-sm font-medium text-slate-500', 'Oct 14 – Oct 20'),
      ]),
      div('mt-8 flex flex-col gap-6 md:flex-row md:items-start', [
        div(
          'flex flex-col justify-between gap-6 rounded-2xl bg-blue-600 p-6 md:flex-1',
          [
            div('flex flex-col gap-2', [
              p('text-sm font-medium text-blue-100', 'Qualified sessions'),
              p('text-4xl font-bold tracking-tight text-white', '48,219'),
              p(
                'text-sm font-semibold text-cyan-200',
                '+18.4% from prior week',
              ),
            ]),
            div(
              'flex items-center justify-between border-t border-blue-400 pt-4',
              [
                span('text-xs text-blue-100', 'Target attainment'),
                span('text-sm font-bold text-white', '112%'),
              ],
            ),
          ],
        ),
        div(
          'flex flex-1 flex-col gap-4 rounded-2xl border border-slate-200 bg-slate-50 p-5',
          [
            div('flex items-center justify-between gap-4', [
              p(
                'text-sm font-semibold text-slate-700',
                'Intent-weighted traffic',
              ),
              span(
                'rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-500 shadow-sm',
                '7 days',
              ),
            ]),
            div('flex h-52 items-end gap-3', [
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-16 w-full rounded-t-lg bg-blue-200'),
                span('text-xs font-semibold text-slate-400', 'M'),
              ]),
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-24 w-full rounded-t-lg bg-blue-300'),
                span('text-xs font-semibold text-slate-400', 'T'),
              ]),
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-20 w-full rounded-t-lg bg-blue-300'),
                span('text-xs font-semibold text-slate-400', 'W'),
              ]),
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-32 w-full rounded-t-lg bg-blue-400'),
                span('text-xs font-semibold text-slate-400', 'T'),
              ]),
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-28 w-full rounded-t-lg bg-blue-400'),
                span('text-xs font-semibold text-slate-400', 'F'),
              ]),
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-40 w-full rounded-t-lg bg-blue-500'),
                span('text-xs font-semibold text-slate-400', 'S'),
              ]),
              div('flex flex-1 flex-col items-center justify-end gap-2', [
                div('h-44 w-full rounded-t-lg bg-cyan-400'),
                span('text-xs font-semibold text-slate-400', 'S'),
              ]),
            ]),
          ],
        ),
      ]),
      div('mt-6 flex flex-col gap-3 md:flex-row', [
        div(
          'flex flex-1 items-end justify-between gap-3 rounded-2xl border border-slate-200 bg-white p-4',
          [
            div('flex flex-col gap-1', [
              p('text-xs font-semibold uppercase text-slate-500', 'Activation'),
              p('text-2xl font-bold tracking-tight text-slate-900', '34.8%'),
            ]),
            span('text-xs font-semibold text-emerald-600', '+4.1 pts'),
          ],
        ),
        div(
          'flex flex-1 items-end justify-between gap-3 rounded-2xl border border-slate-200 bg-white p-4',
          [
            div('flex flex-col gap-1', [
              p(
                'text-xs font-semibold uppercase text-slate-500',
                'Median depth',
              ),
              p('text-2xl font-bold tracking-tight text-slate-900', '6.2'),
            ]),
            span('text-xs font-semibold text-emerald-600', '+0.8 pages'),
          ],
        ),
        div(
          'flex flex-1 items-end justify-between gap-3 rounded-2xl border border-slate-200 bg-white p-4',
          [
            div('flex flex-col gap-1', [
              p(
                'text-xs font-semibold uppercase text-slate-500',
                'Return rate',
              ),
              p('text-2xl font-bold tracking-tight text-slate-900', '41%'),
            ]),
            span('text-xs font-semibold text-emerald-600', '+7.3 pts'),
          ],
        ),
      ]),
    ]),
  ],
);

// showcase:end signal-analytics

// showcase:start incident-room
final _incidentRoom = div(
  'flex w-full max-w-5xl flex-col overflow-hidden rounded-3xl border border-amber-200 bg-amber-50 shadow-xl',
  [
    div('flex h-2 w-full', [
      div('h-2 flex-1 bg-amber-300'),
      div('h-2 flex-1 bg-orange-500'),
      div('h-2 flex-1 bg-red-500'),
    ]),
    div('flex flex-col p-6 md:p-8', [
      div('flex flex-col gap-3 md:flex-row md:items-center md:justify-between', [
        div('flex flex-col gap-2', [
          p(
            'text-xs font-bold tracking-widest text-orange-700',
            'INCIDENT ROOM / ACTIVE',
          ),
          h2(
            'text-3xl font-bold tracking-tight text-slate-950 md:text-4xl',
            'Checkout latency elevated',
          ),
        ]),
        span(
          'self-start rounded-full bg-red-100 px-3 py-2 text-sm font-bold text-red-700',
          'SEV-2 · 18 min',
        ),
      ]),
      div(
        'mt-6 flex flex-col gap-5 rounded-2xl bg-slate-950 p-5 md:flex-row md:items-center md:justify-between',
        [
          div('flex flex-1 items-start gap-4', [
            div(
              'flex h-12 w-12 items-center justify-center rounded-2xl bg-orange-400',
              [span('text-lg font-bold text-slate-950', '02')],
            ),
            div('flex flex-1 flex-col gap-1', [
              p(
                'text-base font-semibold text-white',
                'North America edge cluster',
              ),
              p(
                'text-sm text-slate-400',
                'P95 response time crossed 1.8s after the latest routing change.',
              ),
            ]),
          ]),
          div('flex gap-3', [
            div(
              'flex h-10 w-10 items-center justify-center rounded-full border-2 border-slate-700 bg-blue-500',
              [span('text-xs font-bold text-white', 'LM')],
            ),
            div(
              'flex h-10 w-10 items-center justify-center rounded-full border-2 border-slate-700 bg-violet-500',
              [span('text-xs font-bold text-white', 'AK')],
            ),
            div(
              'flex h-10 w-10 items-center justify-center rounded-full border-2 border-slate-700 bg-emerald-500',
              [span('text-xs font-bold text-white', 'RS')],
            ),
          ]),
        ],
      ),
      div('mt-6 flex flex-col gap-3', [
        div(
          'flex flex-col gap-3 rounded-2xl border border-amber-200 bg-white p-4 md:flex-row md:items-center',
          [
            p('text-sm font-bold text-orange-700 md:w-16', '14:32'),
            div('flex flex-1 flex-col gap-1', [
              p(
                'text-sm font-semibold text-slate-900',
                'Traffic shifted to healthy pool',
              ),
              p('text-sm text-slate-500', 'Error rate fell from 3.8% to 0.7%.'),
            ]),
            span(
              'rounded-full bg-emerald-100 px-3 py-1 text-xs font-bold text-emerald-700',
              'Mitigating',
            ),
          ],
        ),
        div(
          'flex flex-col gap-3 rounded-2xl border border-amber-200 bg-white p-4 md:flex-row md:items-center',
          [
            p('text-sm font-bold text-orange-700 md:w-16', '14:27'),
            div('flex flex-1 flex-col gap-1', [
              p(
                'text-sm font-semibold text-slate-900',
                'Regression isolated to route cache',
              ),
              p(
                'text-sm text-slate-500',
                'Rollback candidate verified in staging.',
              ),
            ]),
            span(
              'rounded-full bg-blue-100 px-3 py-1 text-xs font-bold text-blue-700',
              'Verified',
            ),
          ],
        ),
        div(
          'flex flex-col gap-3 rounded-2xl border border-amber-200 bg-white p-4 md:flex-row md:items-center',
          [
            p('text-sm font-bold text-orange-700 md:w-16', '14:18'),
            div('flex flex-1 flex-col gap-1', [
              p(
                'text-sm font-semibold text-slate-900',
                'Automated alert opened incident',
              ),
              p(
                'text-sm text-slate-500',
                'On-call and payments leads acknowledged.',
              ),
            ]),
            span(
              'rounded-full bg-slate-200 px-3 py-1 text-xs font-bold text-slate-600',
              'Observed',
            ),
          ],
        ),
      ]),
      div(
        'mt-6 flex flex-col gap-3 border-t border-amber-200 pt-6 md:flex-row md:justify-end',
        [
          button(
            'flex items-center justify-center rounded-full border border-slate-300 bg-white px-5 py-3 text-sm font-bold text-slate-700 hover:bg-slate-50 focus-visible:bg-slate-50',
            [span('', 'View runbook')],
            onPressed: _noop,
          ),
          button(
            'flex items-center justify-center rounded-full bg-slate-950 px-5 py-3 text-sm font-bold text-white hover:bg-slate-800 focus-visible:bg-slate-800',
            [span('', 'Join incident room')],
            onPressed: _noop,
          ),
        ],
      ),
    ]),
  ],
);

// showcase:end incident-room

// showcase:start release-timeline
final _releaseTimeline = div(
  'flex w-full max-w-5xl flex-col overflow-hidden rounded-3xl bg-linear-to-br from-indigo-950 via-blue-950 to-slate-950 shadow-2xl',
  [
    div('flex h-2 w-full', [
      div('h-2 flex-1 bg-fuchsia-400'),
      div('h-2 flex-1 bg-violet-400'),
      div('h-2 flex-1 bg-blue-400'),
    ]),
    div('flex flex-col p-6 md:p-8', [
      div('flex flex-col gap-4 md:flex-row md:items-end md:justify-between', [
        div('flex flex-col gap-2', [
          p(
            'text-xs font-bold tracking-widest text-violet-300',
            'RELEASE ORBIT / THURSDAY',
          ),
          h2(
            'text-3xl font-bold tracking-tight text-white md:text-4xl',
            'A calm path to production',
          ),
          p(
            'text-base text-blue-200',
            'Four deliberate handoffs. One shared launch clock.',
          ),
        ]),
        div(
          'flex self-start flex-col rounded-2xl border border-white/10 bg-white/10 px-4 py-3',
          [
            span('text-xs font-bold tracking-widest text-violet-200', '18 OCT'),
            span('text-lg font-bold text-white', '18:40 UTC'),
          ],
        ),
      ]),
      div('mt-8 flex flex-col gap-4 md:flex-row', [
        div(
          'flex flex-1 flex-col gap-5 rounded-2xl border border-white/10 bg-white/10 p-5',
          [
            div('flex items-center justify-between gap-3', [
              div(
                'flex h-10 w-10 items-center justify-center rounded-xl bg-fuchsia-400 text-sm font-bold text-slate-950',
                [span('', '01')],
              ),
              span('text-sm font-bold text-blue-200', '16:00'),
            ]),
            div('flex flex-col gap-2', [
              h3('text-lg font-bold text-white', 'Change freeze'),
              p(
                'text-sm text-blue-200',
                'Release branch locks and final checks begin.',
              ),
            ]),
          ],
        ),
        div(
          'flex flex-1 flex-col gap-5 rounded-2xl border border-white/10 bg-white/10 p-5',
          [
            div('flex items-center justify-between gap-3', [
              div(
                'flex h-10 w-10 items-center justify-center rounded-xl bg-violet-400 text-sm font-bold text-slate-950',
                [span('', '02')],
              ),
              span('text-sm font-bold text-blue-200', '17:15'),
            ]),
            div('flex flex-col gap-2', [
              h3('text-lg font-bold text-white', 'Readiness review'),
              p(
                'text-sm text-blue-200',
                'Owners confirm metrics and rollback paths.',
              ),
            ]),
          ],
        ),
        div(
          'flex flex-1 flex-col gap-5 rounded-2xl border border-white/10 bg-white/10 p-5',
          [
            div('flex items-center justify-between gap-3', [
              div(
                'flex h-10 w-10 items-center justify-center rounded-xl bg-blue-400 text-sm font-bold text-slate-950',
                [span('', '03')],
              ),
              span('text-sm font-bold text-blue-200', '18:40'),
            ]),
            div('flex flex-col gap-2', [
              h3('text-lg font-bold text-white', 'Progressive deploy'),
              p(
                'text-sm text-blue-200',
                'Traffic opens at 5%, then expands by region.',
              ),
            ]),
          ],
        ),
        div(
          'flex flex-1 flex-col gap-5 rounded-2xl border border-white/10 bg-white/10 p-5',
          [
            div('flex items-center justify-between gap-3', [
              div(
                'flex h-10 w-10 items-center justify-center rounded-xl bg-cyan-300 text-sm font-bold text-slate-950',
                [span('', '04')],
              ),
              span('text-sm font-bold text-blue-200', '20:10'),
            ]),
            div('flex flex-col gap-2', [
              h3('text-lg font-bold text-white', 'Orbit confirmed'),
              p(
                'text-sm text-blue-200',
                'Post-launch health window completes.',
              ),
            ]),
          ],
        ),
      ]),
      div(
        'mt-6 flex flex-col gap-4 rounded-2xl border border-white/10 bg-white/5 p-5 md:flex-row md:items-center md:justify-between',
        [
          div('flex flex-col gap-1', [
            p('text-xs font-semibold uppercase text-blue-300', 'Next handoff'),
            p(
              'text-base font-semibold text-white',
              'Readiness review begins in 1h 24m',
            ),
          ]),
          button(
            'flex items-center justify-center rounded-full bg-white px-5 py-3 text-sm font-bold text-indigo-950 hover:bg-blue-50 focus-visible:bg-blue-50',
            [span('', 'Review launch brief')],
            onPressed: _noop,
          ),
        ],
      ),
    ]),
  ],
);

// showcase:end release-timeline

// showcase:start capacity-map
final _capacityMap = div(
  'flex w-full max-w-5xl flex-col overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-xl',
  [
    div('flex h-2 w-full', [
      div('h-2 flex-1 bg-emerald-400'),
      div('h-2 flex-1 bg-teal-500'),
      div('h-2 flex-1 bg-sky-500'),
    ]),
    div('flex flex-col p-6 md:p-8', [
      div('flex flex-col gap-3 lg:flex-row lg:items-end lg:justify-between', [
        div('flex flex-col items-start gap-2', [
          p(
            'text-xs font-bold tracking-widest text-emerald-700',
            'CAPACITY MAP / SPRINT 42',
          ),
          h2(
            'text-3xl font-bold tracking-tight text-slate-950 md:text-4xl',
            'Protect the teams doing the work',
          ),
        ]),
        div('flex', [
          span(
            'self-start rounded-full bg-slate-100 px-3 py-2 text-sm font-semibold text-slate-600',
            '6 days remaining',
          ),
        ]),
      ]),
      div('mt-8 flex flex-col gap-6 md:flex-row md:items-start', [
        div(
          'flex flex-col justify-between gap-8 rounded-2xl bg-linear-to-br from-emerald-500 to-teal-700 p-6 md:flex-1',
          [
            div('flex flex-col gap-2', [
              p('text-sm font-semibold text-emerald-50', 'Portfolio load'),
              p('text-5xl font-bold tracking-tight text-white', '74%'),
              p(
                'text-sm text-emerald-100',
                'Healthy, with room for one priority shift.',
              ),
            ]),
            div('flex flex-col gap-2 border-t border-emerald-300 pt-4', [
              div('flex items-center justify-between', [
                span('text-xs text-emerald-100', 'Planned'),
                span('text-sm font-bold text-white', '286h'),
              ]),
              div('flex items-center justify-between', [
                span('text-xs text-emerald-100', 'Protected'),
                span('text-sm font-bold text-white', '74h'),
              ]),
            ]),
          ],
        ),
        div('flex flex-1 flex-col gap-4', [
          div('flex flex-col gap-4 rounded-2xl bg-slate-50 p-4', [
            div('flex items-center gap-3', [
              div(
                'flex h-11 w-11 items-center justify-center rounded-xl bg-blue-100',
                [span('text-sm font-bold text-blue-700', 'PL')],
              ),
              div('flex flex-1 flex-col gap-1', [
                p('text-sm font-bold text-slate-900', 'Platform'),
                p('text-xs text-slate-500', '12 people · 3 initiatives'),
              ]),
              span('text-sm font-bold text-slate-700', '82%'),
            ]),
            div('h-2 w-full overflow-hidden rounded-full bg-slate-200', [
              div('h-2 w-4/5 rounded-full bg-blue-500'),
            ]),
          ]),
          div('flex flex-col gap-4 rounded-2xl bg-slate-50 p-4', [
            div('flex items-center gap-3', [
              div(
                'flex h-11 w-11 items-center justify-center rounded-xl bg-violet-100',
                [span('text-sm font-bold text-violet-700', 'PX')],
              ),
              div('flex flex-1 flex-col gap-1', [
                p('text-sm font-bold text-slate-900', 'Product experience'),
                p('text-xs text-slate-500', '9 people · 2 initiatives'),
              ]),
              span('text-sm font-bold text-slate-700', '67%'),
            ]),
            div('h-2 w-full overflow-hidden rounded-full bg-slate-200', [
              div('h-2 w-2/3 rounded-full bg-violet-500'),
            ]),
          ]),
          div('flex flex-col gap-4 rounded-2xl bg-slate-50 p-4', [
            div('flex items-center gap-3', [
              div(
                'flex h-11 w-11 items-center justify-center rounded-xl bg-amber-100',
                [span('text-sm font-bold text-amber-700', 'GO')],
              ),
              div('flex flex-1 flex-col gap-1', [
                p('text-sm font-bold text-slate-900', 'Growth operations'),
                p('text-xs text-slate-500', '7 people · 4 initiatives'),
              ]),
              span('text-sm font-bold text-slate-700', '75%'),
            ]),
            div('h-2 w-full overflow-hidden rounded-full bg-slate-200', [
              div('h-2 w-3/4 rounded-full bg-amber-400'),
            ]),
          ]),
        ]),
      ]),
      div(
        'mt-6 flex flex-col gap-4 border-t border-slate-200 pt-6 md:flex-row md:items-center md:justify-between',
        [
          div('flex items-center gap-3', [
            div(
              'flex h-10 w-10 items-center justify-center rounded-full bg-emerald-100',
              [span('text-lg font-bold text-emerald-700', '+')],
            ),
            div('flex flex-col gap-1', [
              p(
                'text-sm font-semibold text-slate-900',
                '18 hours can be reallocated safely',
              ),
              p(
                'text-xs text-slate-500',
                'Based on current protected-work policies.',
              ),
            ]),
          ]),
          button(
            'flex items-center justify-center rounded-full bg-emerald-600 px-5 py-3 text-sm font-bold text-white hover:bg-emerald-500 focus-visible:bg-emerald-500',
            [span('', 'Review allocation')],
            onPressed: _noop,
          ),
        ],
      ),
    ]),
  ],
);

// showcase:end capacity-map

void _noop() {}
