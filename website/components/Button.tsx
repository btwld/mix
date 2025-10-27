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
    "rounded-full bg-emerald-400/10 py-1 px-3 text-emerald-400 ring-1 ring-inset ring-emerald-400/20 hover:bg-emerald-400/10 hover:text-emerald-300 hover:ring-emerald-300",
  secondary:
    "rounded-full bg-zinc-800/40 py-1 px-3 text-zinc-400 ring-1 ring-inset ring-zinc-800 hover:bg-zinc-800 hover:text-zinc-300",
  filled:
    "rounded-full bg-emerald-500 py-1 px-3 text-white hover:bg-emerald-400",
  outline:
    "rounded-full py-1 px-3 text-zinc-400 ring-1 ring-inset ring-white/10 hover:bg-white/5 hover:text-white",
  text: "text-emerald-400 hover:text-emerald-500",
  discord: "rounded-full bg-purple-400/10 py-1 px-3 text-purple-400 ring-1 ring-inset ring-purple-400/20 hover:bg-purple-400/10 hover:text-purple-300 hover:ring-purple-300",
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
    "inline-flex gap-0.5 justify-center overflow-hidden text-sm font-medium transition",
    variantStyles[variant],
    className
  );

  const arrowIcon = (
    <ArrowIcon
      className={clsx(
        "mt-0.5 h-5 w-5",
        variant === "text" && "relative top-px",
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
