import Image from "next/image";
import { Layout, Navbar } from "nextra-theme-docs";
import { getPageMap } from "nextra/page-map";
import { ReactNode } from "react";

const description = "An expressive way to build design systems in Flutter.";

const Logo = (
    <>
        <Image height={32} width={32} alt="Mix Icon" src={"/assets/mix-icon.svg"} />
        <span className="mr-2 font-extrabold mx-2 md:inline">Mix</span>
    </>
);

export default async function RootLayout({ children }: { children: ReactNode }) {
    const pageMap = await getPageMap();
    return (
        <html lang="en">
            <head>
                <meta name="msapplication-TileColor" content="#fff" />
                <meta name="theme-color" content="#fff" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta httpEquiv="Content-Language" content="en" />
                <meta name="description" content={description} />
                <meta name="og:description" content={description} />
                <meta name="twitter:card" content="summary_large_image" />
                <meta name="twitter:image" content="https://fluttermix.com/og.jpeg" />
                <meta name="twitter:site:domain" content="fluttermix.com" />
                <meta name="twitter:url" content="https://fluttermix.com" />
                <meta name="og:title" content="Mix" />
                <meta name="og:image" content="https://fluttermix.com/og.jpeg" />
                <meta name="apple-mobile-web-app-title" content="Mix" />
                <link rel="icon" href="/favicon.ico" type="image/png" />
                <link rel="icon" href="/favicon.ico" type="image/png" media="(prefers-color-scheme: dark)" />
            </head>
            <body>
                <Layout
                    pageMap={pageMap}
                    navbar={
                        <Navbar logo={Logo} projectLink="https://github.com/btwld/mix" chatLink="https://twitter.com/leoafarias">
                            <a
                                href="https://discord.gg/Ycn6GV3m2k"
                                target="_blank"
                                rel="noreferrer"
                                className="nx-p-2 nx-text-current"
                            >
                                <svg width="24" height="24" viewBox="0 5 30.67 23.25">
                                    <path
                                        fill="currentColor"
                                        d="M26.0015 6.9529C24.0021 6.03845 21.8787 5.37198 19.6623 5C19.3833 5.48048 19.0733 6.13144 18.8563 6.64292C16.4989 6.30193 14.1585 6.30193 11.8336 6.64292C11.6166 6.13144 11.2911 5.48048 11.0276 5C8.79575 5.37198 6.67235 6.03845 4.6869 6.9529C0.672601 12.8736 -0.41235 18.6548 0.130124 24.3585C2.79599 26.2959 5.36889 27.4739 7.89682 28.2489C8.51679 27.4119 9.07477 26.5129 9.55525 25.5675C8.64079 25.2265 7.77283 24.808 6.93587 24.312C7.15286 24.1571 7.36986 23.9866 7.57135 23.8161C12.6241 26.1255 18.0969 26.1255 23.0876 23.8161C23.3046 23.9866 23.5061 24.1571 23.7231 24.312C22.8861 24.808 22.0182 25.2265 21.1037 25.5675C21.5842 26.5129 22.1422 27.4119 22.7621 28.2489C25.2885 27.4739 27.8769 26.2959 30.5288 24.3585C31.1952 17.7559 29.4733 12.0212 26.0015 6.9529ZM10.2527 20.8402C8.73376 20.8402 7.49382 19.4608 7.49382 17.7714C7.49382 16.082 8.70276 14.7025 10.2527 14.7025C11.7871 14.7025 13.0425 16.082 13.0115 17.7714C13.0115 19.4608 11.7871 20.8402 10.2527 20.8402ZM20.4373 20.8402C18.9183 20.8402 17.6768 19.4608 17.6768 17.7714C17.6768 16.082 18.8873 14.7025 20.4373 14.7025C21.9717 14.7025 23.2271 16.082 23.1961 17.7714C23.1961 19.4608 21.9872 20.8402 20.4373 20.8402Z"
                                    />
                                </svg>
                            </a>
                        </Navbar>
                    }
                    docsRepositoryBase="https://github.com/btwld/mix/blob/main/website"
                    navigation={{ prev: true, next: true }}
                    toc={{ float: true, backToTop: "Scroll to top" }}
                    darkMode={false}
                    nextThemes={{ defaultTheme: "dark", forcedTheme: "dark" }}
                    sidebar={{ defaultMenuCollapseLevel: 5, autoCollapse: false, toggleButton: false }}
                    editLink={"Edit this page on GitHub"}
                    footer={
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
                                    />
                                </a>
                            </div>
                            <p className="mt-6 text-xs">© {new Date().getFullYear()} Leo Farias</p>
                        </div>
                    }
                >
                    {children}
                </Layout>
            </body>
        </html>
    );
}


