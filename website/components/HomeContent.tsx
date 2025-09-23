import { Button } from "./Button";

import { Features } from "./Features";
import Layout from "./Layout";
import { Logo } from "./Logo";

const HomeContent = () => {
  return (
    <Layout>
      <div className="home-content">
        <div className="content-container">
          <Logo />
          <h1 className="headline">
            An Expressive Styling
            <br className="" />
            System for Flutter
          </h1>
          <p className="subtitle">
            Effortlessly style your widgets
            <br className="sm:block hidden" />
            and build design systems.
          </p>

          <div className="not-prose mb-16 mt-6 flex flex-col sm:flex-row gap-3">
            <Button href="/docs/overview" arrow="right">
              <>Getting Started</>
            </Button>
            <Button href="https://discord.com/invite/Ycn6GV3m2k" variant="discord" target="_blank">
              <>Join our community</>
            </Button>
            <Button href="/docs/overview" variant="outline">
              <>Documentation</>
            </Button>
          </div>
          <Features />
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
            font-feature-settings: initial;
            letter-spacing: -0.12rem;
            margin-left: -0.2rem;

            line-height: 1.2;
            background-image: linear-gradient(146deg, #000, #757a7d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }
          :global(.dark) .headline {
            background-image: linear-gradient(146deg, #fff, #757a7d);
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
  );
};

export default HomeContent;
