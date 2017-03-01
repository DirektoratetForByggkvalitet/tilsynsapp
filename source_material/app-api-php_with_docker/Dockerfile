FROM nimmis/apache-php7
MAINTAINER Eirik Wulff <ew@dibk.no>

# Add a few necessary modules
RUN apt-get update && apt-get -y install php7.0-zip php7.0-xml && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
EXPOSE 443

# The rest is provided by the source image
