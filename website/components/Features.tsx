import {
  motion,
  useMotionTemplate,
  useMotionValue,
  type MotionValue,
} from "framer-motion";
import Link from "next/link";

import {
  HandMetalIcon,
  LucideIcon,
  PaintBucketIcon,
  VenetianMaskIcon,
  WrenchIcon,
} from "lucide-react";
import React from "react";

interface IFeature {
  href: string;
  name: string;
  description: string;
  icon: LucideIcon;
}

const features: Array<IFeature> = [
  {
    href: "/documentation/overview/utility-first",
    name: "Intuitive Style Semantics",
    description:
      "Transform simple elements into elegant, complex designs, enabling flexible and scalable UIs.",
    icon: HandMetalIcon,
  },
  {
    href: "/documentation/guides/variants",
    name: "First-class Variants",
    description:
      "Seamlessly create condition and responsive styling variants, allow you to create reactive styling and variations.",
    icon: VenetianMaskIcon,
  },
  {
    href: "/documentation/guides/design-token",
    name: "Design Tokens & Theming",
    description:
      "Define consistent style properties across widgets inspired by modern design principles for a unified UI.",
    icon: PaintBucketIcon,
  },
  {
    href: "/documentation/overview/utility-first",
    name: "Utility-First",
    description:
      "Craft your styling with simple, reusable functions for easy customization and API extension.",
    icon: WrenchIcon,
  },
];

function FeatureIcon({ icon: Icon }: { icon: IFeature["icon"] }) {
  return (
    <div className="flex h-7 w-7 items-center justify-center rounded-full bg-white/7.5 ring-1 ring-white/15 backdrop-blur-[2px] transition duration-300 group-hover:bg-purple-300/10 group-hover:ring-purple-400">
      <Icon className="h-5 w-5 fill-white/10 stroke-zinc-400 transition-colors duration-300 group-hover:fill-purple-300/10 group-hover:stroke-purple-400" />
    </div>
  );
}

function FeaturePattern({
  mouseX,
  mouseY,
}: {
  mouseX: MotionValue<number>;
  mouseY: MotionValue<number>;
}) {
  const maskImage = useMotionTemplate`radial-gradient(180px at ${mouseX}px ${mouseY}px, white, transparent)`;
  const style = { maskImage, WebkitMaskImage: maskImage };

  return (
    <div className="pointer-events-none">
      <div className="absolute inset-0 rounded-2xl transition duration-300 [mask-image:linear-gradient(white,transparent)] group-hover:opacity-50"></div>
      <motion.div
        className="absolute inset-0 rounded-2xl bg-gradient-to-r from-[#23202e] to-[#282331] opacity-0 transition duration-300 group-hover:opacity-100"
        style={style}
      />
      <motion.div
        className="absolute inset-0 rounded-2xl opacity-0 mix-blend-overlay transition duration-300 group-hover:opacity-100"
        style={style}
      ></motion.div>
    </div>
  );
}

function Feature({ feature }: { feature: IFeature }) {
  const mouseX = useMotionValue(0);
  const mouseY = useMotionValue(0);

  function onMouseMove({
    currentTarget,
    clientX,
    clientY,
  }: React.MouseEvent<HTMLDivElement>) {
    const { left, top } = currentTarget.getBoundingClientRect();
    mouseX.set(clientX - left);
    mouseY.set(clientY - top);
  }

  return (
    <div
      key={feature.href}
      onMouseMove={onMouseMove}
      className="group relative flex rounded-2xl bg-white/2.5 transition-shadow hover:shadow-md hover:shadow-black/5"
    >
      <FeaturePattern mouseX={mouseX} mouseY={mouseY} />
      <div className="absolute inset-0 rounded-2xl ring-1 ring-inset ring-white/10 group-hover:ring-white/20" />
      <div className="relative rounded-2xl px-4 pb-4 pt-16">
        <FeatureIcon icon={feature.icon} />
        <h3 className="mt-4 text-sm font-semibold leading-7 text-white">
          <Link href={feature.href}>
            <span className="absolute inset-0 rounded-2xl" />
            {feature.name}
          </Link>
        </h3>
        <p className="mt-1 text-sm text-zinc-400">
          {feature.description}
        </p>
      </div>
    </div>
  );
}

export function Features() {
  return (
    <div className="my-16 xl:max-w-none">
      <div className="not-prose mt-4 grid grid-cols-1 gap-8 border-t border-white/5 pt-10 sm:grid-cols-2 xl:grid-cols-4">
        {features.map((feature) => (
          <Feature key={feature.name} feature={feature} />
        ))}
      </div>
    </div>
  );
}
