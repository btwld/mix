// theme.config.tsx
import React from 'react'

const config = {
    sidebar: {
        defaultMenuCollapseLevel: 1, // controls accordion depth
    },
    // You can also provide custom components
    components: {
        Sidebar: ({ children }) => (
            <div className="bg-gray-100 dark:bg-gray-900 p-3 rounded-lg">
                {children}
            </div>
        )
    }
}

export default config