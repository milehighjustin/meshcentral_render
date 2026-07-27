FROM node:20-slim
 
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
 
WORKDIR /opt/meshcentral
 
# Installs the meshcentral npm package (pulls in NeDB by default; we override with Mongo at runtime)
RUN npm install meshcentral --omit=dev
 
COPY entrypoint.sh /opt/meshcentral/entrypoint.sh
RUN chmod +x /opt/meshcentral/entrypoint.sh
 
ENV NODE_ENV=production
EXPOSE 8080
 
ENTRYPOINT ["/opt/meshcentral/entrypoint.sh"]