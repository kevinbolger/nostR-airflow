# Start from the Apache Airflow image
FROM apache/airflow:2.6.3

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg2 \
        dirmngr \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
        git \
        make \
        gcc \
        libgit2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the CRAN GPG key to your system's keyring
RUN gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | apt-key add -

# Add the CRAN repository for Debian bullseye
RUN echo "deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/" >> /etc/apt/sources.list

# Update the package index
RUN apt-get update

# Install the latest version of R
RUN apt-get install -y --no-install-recommends r-base-core && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the devtools package
RUN R -e "install.packages('devtools', repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages('aws.s3', repos = 'https://cloud.r-project.org/')"

# Install an R package from GitHub
RUN R -e "devtools::install_github('kevinbolger/nostr')"

USER airflow
