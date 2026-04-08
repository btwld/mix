
"use client";

import { motion } from "framer-motion";
import { Button } from "./Button";
import { FeatureShowcase } from "./FeatureShowcase";
import { HeroBackground } from "./HeroBackground";

import Layout from "./Layout";
import { Logo } from "./Logo";

const fadeUp = {
  hidden: { opacity: 0, y: 20 },
  visible: (delay: number) => ({
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.7,
      delay,
      ease: [0.25, 0.4, 0.25, 1] as const,
    },
  }),
};

export const HomeContent = () => {
  return (
    <>
      <HeroBackground />
      <Layout>
        <div className="home-content relative z-10">
          <div className="content-container">
            <motion.div
              initial="hidden"
              animate="visible"
              custom={0}
              variants={fadeUp}
            >
              <Logo />
            </motion.div>

            <motion.div
              initial="hidden"
              animate="visible"
              custom={0.1}
              variants={fadeUp}
            >
              <h1 className="headline">
                An Expressive Styling
                <br className="hidden sm:inline" />
                System for Flutter
              </h1>
            </motion.div>

            <motion.div
              initial="hidden"
              animate="visible"
              custom={0.2}
              variants={fadeUp}
            >
              <p className="subtitle">
                Effortlessly style your widgets
                <br className="hidden sm:inline" />
                and build design systems.
              </p>
            </motion.div>

            <motion.div
              className="not-prose mb-16 mt-6 flex flex-col sm:flex-row gap-3"
              initial="hidden"
              animate="visible"
              custom={0.3}
              variants={fadeUp}
            >
              <Button href="/documentation/overview/getting-started" arrow="right">
                <>Getting Started</>
              </Button>
              <Button href="https://discord.com/invite/Ycn6GV3m2k" variant="discord" target="_blank">
                <>Join our community</>
              </Button>
            </motion.div>
            <FeatureShowcase />

            {/* Bottom CTA */}
            <motion.div
              className="not-prose mt-32 mb-20 border-t border-white/[0.06] pt-16"
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-80px" }}
              transition={{ duration: 0.7, ease: [0.25, 0.4, 0.25, 1] as const }}
            >
              <h2 className="text-2xl font-bold tracking-[-0.03em] text-zinc-100 sm:text-3xl">
                Ready to build?
              </h2>
              <p className="mt-3 max-w-[440px] text-[15px] leading-7 text-zinc-400">
                Explore the full API, learn the patterns, and start
                building your design system with Mix.
              </p>
              <div className="mt-6 flex flex-col sm:flex-row gap-3">
                <Button href="/documentation/overview/introduction" variant="filled" arrow="right">
                  <>Read the docs</>
                </Button>
                <Button href="/documentation/overview/getting-started" variant="outline">
                  <>Quick start</>
                </Button>
              </div>
            </motion.div>
          </div>

          <style jsx>{`
            .content-container {
              margin: 0 auto;
            }
            .headline {
              display: inline-flex;
              font-size: 3.125rem;
              font-size: min(4.375rem, max(8vw, 2.5rem));
              font-weight: 700;
              letter-spacing: -0.12rem;
              margin-left: -0.2rem;
              line-height: 1.2;
              background-image: var(--mix-gradient-heading, linear-gradient(146deg, #000, #757a7d));
              -webkit-background-clip: text;
              -webkit-text-fill-color: transparent;
              background-clip: text;
              font-feature-settings: initial;
              text-align: left;
            }
            .subtitle {
              font-size: 1.6rem;
              font-size: min(1.6rem, max(3.5vw, 1.3rem));
              font-feature-settings: initial;
              line-height: 1.6;
              margin-top: 1.5rem;
            }
            .nextjs-link {
              color: currentColor;
              text-decoration: none;
              font-weight: 600;
            }
          `}</style>
        </div>
      </Layout>
    </>
  );
};
