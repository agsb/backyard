#
#   remove stale
#
    apt
    && apt-get purge -y --auto-remove $buildDeps
    && rm -rf /var/lib/apt/lists/*

#
