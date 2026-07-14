import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Mix Rendering Performance — Cost, State, and Practical Impact",
  description:
    "An evidence-backed report on where Mix spends rendering-pipeline CPU time, what fires during state changes, and whether the remaining overhead is practically significant.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
