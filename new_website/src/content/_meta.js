
export default {
    index: {
        title: 'Home',
        type: 'page',
        display: 'hidden',
        theme: {
            layout: 'full',
            sidebar: false,
            breadcrumb: false,
            toc: false,
            timestamp: false,
            typesetting: "article",
        }
    },
    version: {
        title: 'Version',
        type: 'menu',
        items: {
            v2: {
                title: 'Mix v2',
                href: '/'
            },
            v1: {
                title: 'Mix v1',
                href: 'https://mix-docs-gosljkd74-fluttertools.vercel.app/'
            }
        }
    },
    documentation: {
        title: 'Docs',
        type: 'page'
    },
}