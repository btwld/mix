/* eslint-disable react-hooks/rules-of-hooks */
import Image from "next/image";
import { useRouter } from "next/router";
import { useConfig } from "nextra-theme-docs";
import CustomSearch from "./components/Search";

const description = "An expressive way to build design systems in Flutter.";

const Logo = (
  <>
    <Image height={32} width={32} alt="Mix Icon" src={"/assets/mix-icon.svg"} />
    <span className="mr-2 font-extrabold mx-2 md:inline">Mix</span>
  </>
);

const themeConfig = {
  useNextSeoProps() {
    const { asPath } = useRouter();
    if (asPath !== "/") {
      return {
        titleTemplate: "%s – Mix",
      };
    }
  },
  logo: Logo,
  project: {
    link: "https://github.com/conceptadev/mix",
  },
  // banner: {
  //   key: "1.0-beta-doc-wip-notice",
  //   dismissible: false,
  //   text: (
  //     <a href={`${siteUrl}`} target="_blank">
  //       Mix 1.0 is in Beta. Documentation is currently a work-in-progress →
  //     </a>
  //   ),
  // },
  docsRepositoryBase: "https://github.com/conceptadev/mix/blob/main/website",
  search: {
    component: <CustomSearch />,
  },
  head: () => {
    const { title, frontMatter } = useConfig();
    const { route } = useRouter();
    const socialCard =
      route === "/" || !title
        ? "https://fluttermix.com/og.jpeg"
        : `https://fluttermix.com/api/og?title=${title}`;

    return (
      <>
        <meta name="msapplication-TileColor" content="#fff" />
        <meta name="theme-color" content="#fff" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta httpEquiv="Content-Language" content="en" />
        <meta
          name="description"
          content={frontMatter.description || description}
        />
        <meta
          name="og:description"
          content={frontMatter.description || description}
        />
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:image" content={socialCard} />
        <meta name="twitter:site:domain" content="fluttermix.com" />
        <meta name="twitter:url" content="https://fluttermix.com" />
        <meta name="og:title" content={title ? title : "Mix"} />
        <meta name="og:image" content={socialCard} />
        <meta name="apple-mobile-web-app-title" content="Mix" />
        <link rel="icon" href="/favicon.ico" type="image/png" />
        <link
          rel="icon"
          href="/favicon.ico"
          type="image/png"
          media="(prefers-color-scheme: dark)"
        />
      </>
    );
  },

  navigation: {
    prev: true,
    next: true,
  },
  toc: {
    float: true,
    backToTop: true,
  },
  darkMode: false,
  nextThemes: {
    defaultTheme: "dark",
    forcedTheme: "dark",
  },
  sidebar: {
    defaultMenuCollapseLevel: 5,
    autoCollapse: false,
    toggleButton: false,
  },
  primaryHue: {
    light: 200,
    dark: 300,
  },
  primarySaturation: {
    light: 50,
    dark: 40,
  },
  editLink: {
    text: "Edit this page on GitHub",
  },
  chat: {
    link: "https://twitter.com/leoafarias",
    icon: (
      <svg width="24" height="24" viewBox="0 0 248 204">
        <path
          fill="currentColor"
          d="M221.95 51.29c.15 2.17.15 4.34.15 6.53 0 66.73-50.8 143.69-143.69 143.69v-.04c-27.44.04-54.31-7.82-77.41-22.64 3.99.48 8 .72 12.02.73 22.74.02 44.83-7.61 62.72-21.66-21.61-.41-40.56-14.5-47.18-35.07a50.338 50.338 0 0 0 22.8-.87C27.8 117.2 10.85 96.5 10.85 72.46v-.64a50.18 50.18 0 0 0 22.92 6.32C11.58 63.31 4.74 33.79 18.14 10.71a143.333 143.333 0 0 0 104.08 52.76 50.532 50.532 0 0 1 14.61-48.25c20.34-19.12 52.33-18.14 71.45 2.19 11.31-2.23 22.15-6.38 32.07-12.26a50.69 50.69 0 0 1-22.2 27.93c10.01-1.18 19.79-3.86 29-7.95a102.594 102.594 0 0 1-25.2 26.16z"
        />
      </svg>
    ),
  },

  footer: {
    text: (
      <div className="flex w-full flex-col items-center sm:items-start">
        <div>
          <a
            href="https://vercel.com/?utm_source=fluttermix&utm_campaign=oss"
            target="_blank"
            rel="noreferrer"
          >
            <Image
              alt="mix logo"
              src="/assets/powered-by-vercel.svg"
              height={43}
              width={211}
            />{" "}
          </a>
        </div>
        <p className="mt-6 text-xs">© {new Date().getFullYear()} Leo Farias</p>
      </div>
    ),
  },
};

export default themeConfig;
