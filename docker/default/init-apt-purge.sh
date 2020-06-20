#
#   remove stale
#
    apt update
    && apt install
    && apt purge -y --auto-remove $buildDeps
    && rm -rf /var/lib/apt/lists/*

#
