/* eslint-disable @typescript-eslint/no-var-requires */

const withNextra = require("nextra")({
  theme: "nextra-theme-docs",
  themeConfig: "./theme.config.tsx",
  mdxOptions: { remarkPlugins: [] },
});

// eslint-disable-next-line no-undef
module.exports = withNextra({
  reactStrictMode: true,

  async redirects() {
    return [
      {
        source: "/docs/changelog",
        destination: "https://github.com/btwld/mix/releases",
        permanent: true,
      },
    ];
  },
});
