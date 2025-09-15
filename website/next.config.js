import nextra from "nextra";

const withNextra = nextra({
  theme: "nextra-theme-docs",
  themeConfig: "./theme.config.tsx",
  mdxOptions: { remarkPlugins: [] },
});

export default withNextra({
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
