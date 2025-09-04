/* eslint-disable react-hooks/rules-of-hooks */
import Image from "next/image";
import { useRouter } from "next/router";
import { useConfig } from "nextra-theme-docs";
import CustomSearch from "./components/Search";
import VersionSelector from "./components/VersionSelector";

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
    link: "https://github.com/btwld/mix",
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
  docsRepositoryBase: "https://github.com/btwld/mix/blob/main/website",
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
  navbar: {
    extraContent: (
      <div className="nx-flex nx-items-center nx-gap-2">
        <VersionSelector />
      </div>
    )
  },
  // Removed chat (twitter) and discord from navbar as per instructions

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
