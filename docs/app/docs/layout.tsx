import { DocsLayout } from 'fumadocs-ui/layout';
import type { ReactNode } from 'react';
import { source } from '@/lib/source';

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <DocsLayout
      tree={source.pageTree}
      nav={{
        title: 'Mix Documentation',
      }}
      links={[
        {
          text: 'GitHub',
          url: 'https://github.com/btwld/mix',
          external: true,
        },
        {
          text: 'Discord',
          url: 'https://discord.gg/Ycn6GV3m2k',
          external: true,
        },
      ]}
    >
      {children}
    </DocsLayout>
  );
}
