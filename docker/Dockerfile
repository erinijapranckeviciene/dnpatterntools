FROM bgruening/galaxy-stable

MAINTAINER Erinija Pranckeviciene, erinija.pranckeviciene@gmail.com

ENV GALAXY_CONFIG_BRAND Nucleosomal_DNA_patterns_flavor

WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

# Adding the tool definitions to the container
ADD dnpatterntools.yml $GALAXY_ROOT/dnpatterntools.yml

# Install my_tools_list
RUN install-tools $GALAXY_ROOT/dnpatterntools.yml

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
