FROM node:18-alpine

WORKDIR /meshcentral

# Install meshcentral and the required MongoDB engine
RUN npm install meshcentral mongojs

# Render free tiers require web services to listen on port 10000
EXPOSE 10000

# Run MeshCentral over port 10000 and force it to listen for Render's reverse proxy headers
CMD ["node", "./node_modules/meshcentral", "--port", "10000", "--tlsoffload", "--trustedproxy"]
