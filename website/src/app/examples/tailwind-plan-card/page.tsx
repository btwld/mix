'use client';

import { useMemo, useState } from 'react';

const MIN_WIDTH = 320;
const MAX_WIDTH = 1280;

const BREAKPOINTS = [
  { label: 'xs (<640px)', min: 0 },
  { label: 'sm (≥640px)', min: 640 },
  { label: 'md (≥768px)', min: 768 },
  { label: 'lg (≥1024px)', min: 1024 },
  { label: 'xl (≥1280px)', min: 1280 },
];

export default function TailwindPlanCardPage() {
  const [width, setWidth] = useState(420);

  const activeBreakpoint = useMemo(() => {
    return BREAKPOINTS
      .filter((bp) => width >= bp.min)
      .map((bp) => bp.label)
      .pop() ?? BREAKPOINTS[0].label;
  }, [width]);

  return (
    <div className="min-h-screen bg-[#f3f4f6] px-6 py-10">
      <div className="mx-auto flex max-w-5xl flex-col gap-6">
        <header className="text-center">
          <p className="text-sm font-semibold uppercase text-blue-600">
            Tailwind reference output
          </p>
          <h1 className="text-3xl font-semibold text-slate-800">
            Compare with the Flutter mix_tailwinds example
          </h1>
        </header>

        <div className="space-y-3">
          <input
            type="range"
            min={MIN_WIDTH}
            max={MAX_WIDTH}
            value={width}
            onChange={(event) => setWidth(Number(event.target.value))}
            className="w-full accent-blue-600"
          />
          <p className="text-center text-sm text-slate-600">
            Viewport width: {Math.round(width)} px · Active breakpoint: {activeBreakpoint}
          </p>
        </div>

        <main className="mx-auto flex w-full flex-col gap-6" style={{ maxWidth: width }}>
          <CampaignOverviewCard />
          <TeamActivityCard />
        </main>
      </div>
    </div>
  );
}

function CampaignOverviewCard() {
  return (
    <section className="flex flex-col gap-5 rounded-2xl border border-gray-200 bg-white p-6 shadow-lg">
      <p className="text-sm font-semibold uppercase text-blue-700">Campaign Health</p>
      <h2 className="text-3xl font-semibold text-gray-700">November brand push</h2>
      <p className="text-base text-gray-500">
        Live performance snapshot for paid, lifecycle, and organic channels.
      </p>
      <div className="flex flex-col gap-4 border-t border-gray-200 pt-4 md:flex-row">
        <MetricTile label="Spend" value="$241.18M" change="+8.6% vs last week" />
        <MetricTile label="Return" value="4.8x" change="+0.4 uplift" />
        <MetricTile label="CPA" value="$248.30" change="-12% efficiency gain" />
      </div>
      <div className="flex flex-col gap-3 md:flex-row">
        <button
          type="button"
          className="flex flex-1 items-center justify-center rounded-full bg-blue-600 px-4 py-3 text-base font-semibold text-white hover:bg-blue-700"
        >
          View live dashboard
        </button>
        <button
          type="button"
          className="flex flex-1 items-center justify-center rounded-full border border-blue-600 px-4 py-3 text-base font-semibold text-blue-600 hover:bg-blue-50"
        >
          Download CSV
        </button>
      </div>
    </section>
  );
}

function MetricTile({ label, value, change }: { label: string; value: string; change: string }) {
  return (
    <article className="flex flex-1 flex-col gap-2 rounded-xl bg-blue-50 p-4">
      <p className="text-sm font-semibold uppercase text-blue-700">{label}</p>
      <p className="text-2xl font-semibold text-gray-700">{value}</p>
      <p className="text-sm text-blue-700">{change}</p>
    </article>
  );
}

function TeamActivityCard() {
  return (
    <section className="flex flex-col gap-5 rounded-2xl border border-gray-200 bg-white p-6 shadow-lg">
      <p className="text-sm font-semibold uppercase text-blue-700">Team activity</p>
      <h2 className="text-2xl font-semibold text-gray-700">Channel owners</h2>
      <p className="text-base text-gray-500">
        Latest updates from lifecycle, paid, and organic squads.
      </p>
      <div className="flex flex-col">
        <ActivityRow
          name="Rita Carr"
          role="Lifecycle · Email"
          update="Shipped reactivation flow revamp"
          timeago="12m ago"
          accentColor="bg-blue-100"
          showBorder={false}
        />
        <ActivityRow
          name="Jalen Ruiz"
          role="Paid · Social"
          update="Cut CPA by 14% on TikTok lookalikes"
          timeago="1h ago"
          accentColor="bg-blue-50"
          showBorder
        />
        <ActivityRow
          name="Mara Singh"
          role="Organic · Web"
          update="Published performance teardown for Q4"
          timeago="3h ago"
          accentColor="bg-gray-200"
          showBorder
        />
      </div>
    </section>
  );
}

function ActivityRow({
  name,
  role,
  update,
  timeago,
  accentColor,
  showBorder,
}: {
  name: string;
  role: string;
  update: string;
  timeago: string;
  accentColor: string;
  showBorder: boolean;
}) {
  const borderClass = showBorder ? 'border-t border-gray-100' : '';
  const avatarLetter = name.charAt(0);

  return (
    <article className={`flex items-center justify-between gap-4 py-4 ${borderClass}`}>
      <div className="flex flex-1 items-center gap-4">
        <div className="flex h-12 w-12 items-center justify-center rounded-full bg-gray-100">
          <span className="text-lg font-semibold text-gray-700">{avatarLetter}</span>
        </div>
        <div className="flex flex-1 flex-col gap-1 min-w-0">
          <p className="text-base font-semibold text-gray-700">{name}</p>
          <p className="text-sm text-gray-500">{role}</p>
          <div className="flex items-center gap-2 min-w-0">
            <div className={`h-1 w-1 rounded-full ${accentColor}`}></div>
            <div className="flex-1 min-w-0">
              <p className="truncate text-sm text-gray-500">{update}</p>
            </div>
          </div>
        </div>
      </div>
      <p className="text-sm text-gray-500">{timeago}</p>
    </article>
  );
}
