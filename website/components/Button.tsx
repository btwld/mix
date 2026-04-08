"use client";

import clsx from "clsx";
import Link from "next/link";
import React from "react";

function ArrowIcon(props: React.ComponentPropsWithoutRef<"svg">) {
  return (
    <svg viewBox="0 0 20 20" fill="none" aria-hidden="true" {...props}>
      <path
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        d="m11.5 6.5 3 3.5m0 0-3 3.5m3-3.5h-9"
      />
    </svg>
  );
}

const variantStyles = {
  primary:
    "rounded-lg bg-violet-600 py-2.5 px-6 text-white shadow-[0_4px_20px_rgba(139,92,246,0.3)] hover:-translate-y-px hover:shadow-[0_6px_25px_rgba(139,92,246,0.4)] hover:bg-violet-500",
  secondary:
    "rounded-lg bg-[var(--mix-surface-bright)] py-2.5 px-6 text-white border border-[var(--mix-border-card)] hover:bg-white/[0.05]",
  filled:
    "rounded-lg bg-violet-600 py-2.5 px-6 text-white shadow-[0_4px_20px_rgba(139,92,246,0.3)] hover:-translate-y-px hover:shadow-[0_6px_25px_rgba(139,92,246,0.4)] hover:bg-violet-500",
  outline:
    "rounded-lg py-2.5 px-6 text-zinc-300 border border-[var(--mix-border-card)] hover:bg-white/[0.05] hover:text-white",
  text: "text-violet-400 hover:text-violet-300",
  discord:
    "rounded-lg bg-[var(--mix-surface-bright)] py-2.5 px-6 text-zinc-300 border border-[var(--mix-border-card)] hover:bg-white/[0.05] hover:text-white",
};

type ButtonProps = {
  variant?: keyof typeof variantStyles;
  arrow?: "left" | "right";
} & (
    | React.ComponentPropsWithoutRef<typeof Link>
    | (React.ComponentPropsWithoutRef<"button"> & { href?: undefined })
  );

export function Button({
  variant = "primary",
  className,
  children,
  arrow,
  ...props
}: ButtonProps) {
  className = clsx(
    "inline-flex gap-1.5 items-center justify-center overflow-hidden text-[15px] font-medium transition-all duration-200 cursor-pointer",
    variantStyles[variant],
    className
  );

  const arrowIcon = (
    <ArrowIcon
      className={clsx(
        "h-5 w-5",
        arrow === "left" && "-ml-1 rotate-180",
        arrow === "right" && "-mr-1"
      )}
    />
  );

  const inner = (
    <>
      {arrow === "left" && arrowIcon}
      {children}
      {arrow === "right" && arrowIcon}
    </>
  );

  if (typeof props.href === "undefined") {
    return (
      <button className={className} {...props}>
        {inner}
      </button>
    );
  }

  return (
    <Link className={className} {...props}>
      {inner}
    </Link>
  );
}
