import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="flex h-screen flex-col justify-center text-center">
      <h1 className="mb-4 text-2xl font-bold">Mix Documentation</h1>
      <p className="text-fd-muted-foreground">
        Welcome to the Mix documentation. Get started by exploring our guides.
      </p>
      <div className="mt-8">
        <Link
          href="/docs/v1"
          className="rounded-md bg-fd-primary px-4 py-2 text-fd-primary-foreground transition-colors hover:bg-fd-primary/80"
        >
          Get Started
        </Link>
      </div>
    </main>
  );
}
