import nextra from "nextra";

const withNextra = nextra({
  // theme and themeConfig are removed in Nextra 4
  // Pass props to Layout/Search/etc via app/layout.tsx
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
