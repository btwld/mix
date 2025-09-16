import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import 'nextra-theme-docs/style.css'
import { Banner, Head } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'

export const metadata = {
    // Define your metadata here
    // For more information on metadata API, see: https://nextjs.org/docs/app/building-your-application/optimizing/metadata
}

const description = "An expressive way to build design systems in Flutter.";

const banner = (
    <Banner storageKey="mix-banner">
        Mix 2.0 is in development! You can access the <a href="https://mix-docs-gosljkd74-fluttertools.vercel.app/" target="_blank" rel="noopener noreferrer" style={{ color: "var(--color-purple-400)" }}>Mix 1.0 docs here</a>.
    </Banner>
)
const navbar = (
    <Navbar
        logo={
            <img
                src="/assets/logo_mix.png"
                alt="Logo"
                style={{ height: 32, width: 'auto', display: 'inline-block', verticalAlign: 'middle' }}
            />
        }
        chatLink="https://twitter.com/leoafarias"
        projectLink="https://github.com/btwld/mix"
    // ... Your additional navbar options
    />
)
const footer = <Footer>© {new Date().getFullYear()} Concepta Tech.</Footer>

export default async function RootLayout({ children }) {
    return (
        <html
            // Not required, but good for SEO
            lang="en"
            // Required to be set
            dir="ltr"
            // Suggested by `next-themes` package https://github.com/pacocoursey/next-themes#with-app
            suppressHydrationWarning
        >
            <Head>
                <meta name="msapplication-TileColor" content="#fff" />
                <meta name="theme-color" content="#fff" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta httpEquiv="Content-Language" content="en" />
                <meta name="description" content={description} />
                <meta name="og:description" content={description} />
                <meta name="twitter:card" content="summary_large_image" />
                <meta name="twitter:image" content="https://fluttermix.com/og_banner.png" />
                <meta name="twitter:site:domain" content="fluttermix.com" />
                <meta name="twitter:url" content="https://fluttermix.com" />
                <meta name="og:title" content="Mix" />
                <meta name="og:image" content="https://fluttermix.com/og_banner.png" />
                <meta name="apple-mobile-web-app-title" content="Mix" />
                <link rel="icon" href="/favicon.ico" type="image/png" />
                <link rel="icon" href="/favicon.ico" type="image/png" media="(prefers-color-scheme: dark)" />
                <link rel="shortcut icon" href="/favicon.ico" />
            </Head>
            <body>
                <Layout
                    banner={banner}
                    navbar={navbar}
                    pageMap={await getPageMap()}
                    docsRepositoryBase="https://github.com/btwld/mix/tree/main/docs"
                    footer={footer}
                    darkMode={false}
                    navigation={{ prev: true, next: true }}
                    toc={{ float: true, backToTop: "Scroll to top" }}
                    nextThemes={{ defaultTheme: "dark", forcedTheme: "dark" }}
                    sidebar={{
                        defaultMenuCollapseLevel: 8,
                        autoCollapse: false,
                        toggleButton: false,
                        defaultOpen: true,
                    }}
                // ... Your additional layout options
                >
                    {children}
                </Layout>
            </body>
        </html>
    )
}