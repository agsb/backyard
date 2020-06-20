
RUN apt-get update && \
    apt-get -y --no-install-recommends install xxxx yyyy wwww zzzz && \
              ...  && \
    apt-get purge -y xxxx yyyy wwww zzzz && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


