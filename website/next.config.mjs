import nextra from 'nextra'

// Set up Nextra with its configuration
const withNextra = nextra({
    mdxOptions: {
        rehypePrettyCodeOptions: {
            theme: {
                dark: 'tokyo-night',
                light: 'github-light',
            },
        },
    },
})

// Export the final Next.js config with Nextra included
export default withNextra({
    async redirects() {
        return [
            {
                source: '/docs',
                destination: '/documentation',
                permanent: true,
            },
            {
                source: '/docs/:path*',
                destination: '/documentation/:path*',
                permanent: true,
            },
        ]
    },
})