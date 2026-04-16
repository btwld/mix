import { Inter, JetBrains_Mono } from 'next/font/google'
import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import 'nextra-theme-docs/style.css'
import '../../globals.css'
import { Head } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'

const inter = Inter({
    subsets: ['latin'],
    variable: '--font-inter',
    display: 'swap',
})

const jetbrainsMono = JetBrains_Mono({
    subsets: ['latin'],
    variable: '--font-jetbrains-mono',
    display: 'swap',
})

const description = "An expressive way to build design systems in Flutter."

export const viewport = {
    themeColor: '#111111',
}

export const metadata = {
    title: 'Mix',
    description,
    applicationName: 'Mix',
    icons: {
        icon: '/favicon.ico',
        shortcut: '/favicon.ico',
    },
    openGraph: {
        title: 'Mix',
        description,
        images: ['https://fluttermix.com/og_banner.png'],
    },
    twitter: {
        card: 'summary_large_image',
        images: ['https://fluttermix.com/og_banner.png'],
        domain: 'fluttermix.com',
        url: 'https://fluttermix.com',
    },
    other: {
        'msapplication-TileColor': '#111111',
        'apple-mobile-web-app-title': 'Mix',
    },
}

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
    />
)
const footer = (
    <Footer>
        <div className="flex flex-col sm:flex-row items-center justify-between w-full gap-4 text-sm text-[var(--mix-text-muted)]">
            <span>&copy; 2026 Concepta Tech.</span>
            <div className="flex items-center gap-5">
                <a href="https://github.com/btwld/mix" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">GitHub</a>
                <a href="https://pub.dev/packages/mix" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">pub.dev</a>
                <a href="https://discord.com/invite/Ycn6GV3m2k" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Discord</a>
                <a href="https://twitter.com/leoafarias" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Twitter</a>
            </div>
        </div>
    </Footer>
)

export default async function RootLayout({ children }) {
    return (
        <html
            lang="en"
            dir="ltr"
            suppressHydrationWarning
            className={`dark ${inter.variable} ${jetbrainsMono.variable}`}
        >
            <Head />
            <body>
                <Layout
                    navbar={navbar}
                    pageMap={await getPageMap()}
                    docsRepositoryBase="https://github.com/btwld/mix/tree/main/website"
                    footer={footer}
                    darkMode={false}
                    copyPageButton={false}
                    navigation={{ prev: true, next: true }}
                    toc={{ float: true, backToTop: "Scroll to top" }}
                    nextThemes={{
                        forcedTheme: "dark",
                        defaultTheme: "dark",
                        storageKey: "theme"
                    }}
                    sidebar={{
                        defaultMenuCollapseLevel: 1,
                        autoCollapse: true,
                        toggleButton: false,
                        defaultOpen: true,
                    }}
                >
                    {children}
                </Layout>
            </body>
        </html>
    )
}
