import { createMDX } from 'fumadocs-mdx/next';

const withMDX = createMDX();

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,

  // Preserve existing redirects from Mix website
  async redirects() {
    return [
      {
        source: "/docs/changelog",
        destination: "https://github.com/btwld/mix/releases",
        permanent: true,
      },
    ];
  },
};

export default withMDX(config);
