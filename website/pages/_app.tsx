import { Analytics } from "@vercel/analytics/react";
import { Fira_Code, Inter } from "next/font/google";
import "../style.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

const firaCode = Fira_Code({
  subsets: ["latin"],
  variable: "--font-fira-code",
  display: "swap",
});

export default function MyApp({ Component, pageProps }) {
  // Use the layout defined at the page level, if available
  const getLayout = Component.getLayout || ((page) => page);

  return getLayout(
    <main>
      <style jsx global>{`
        html {
          font-family: ${inter.style.fontFamily};
        }
        code,
        kbd,
        samp,
        pre {
          font-family: ${firaCode.style.fontFamily} !important;
        }
      `}</style>
      <Component {...pageProps} />
      <Analytics />
    </main>
  );
}
