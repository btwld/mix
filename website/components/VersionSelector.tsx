const VersionSelector = () => {
    const handleVersionChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
        const newVersion = event.target.value;

        if (newVersion === '1.7') {
            window.location.href = 'https://mix-docs-gosljkd74-fluttertools.vercel.app';
        } else if (newVersion === '2.0') {
            window.location.href = '/';
        }
    };

    return (
        <div className="
          bg-zinc-500/5 
          backdrop-blur-[2px]
          text-zinc-300 
          nx-border 
          border-zinc-700 
          rounded-full
          nx-px-2
          nx-py-2
          nx-text-sm
          transition
          hover:bg-zinc-900/2.5 hover:text-zinc-900 dark:text-zinc-400 dark:ring-white/10 dark:hover:bg-white/5 dark:hover:text-white
        ">
            <select
                defaultValue="2.0"
                onChange={handleVersionChange}
                className="
          nx-bg-transparent
          pr-1
        "
            >
                <option value="2.0">2.0</option>
                <option value="1.7">1.7</option>
            </select>
        </div>
    );
};

export default VersionSelector;
