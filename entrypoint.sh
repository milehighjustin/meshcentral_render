#!/bin/sh
set -e

DATA_DIR="/opt/meshcentral/meshcentral-data"
mkdir -p "$DATA_DIR"

# Render injects PORT for Docker web services (defaults to 10000 if you don't set one).
PORT="${PORT:-10000}"

# Render auto-sets RENDER_EXTERNAL_HOSTNAME for every web service, e.g. my-app.onrender.com.
# Falls back to localhost if you're testing this image outside Render.
HOST="${RENDER_EXTERNAL_HOSTNAME:-localhost}"

# MONGO_URI and SESSION_KEY are set by you as Render environment variables (see setup steps).
if [ -z "$MONGO_URI" ]; then
  echo "ERROR: MONGO_URI environment variable is not set. Add your MongoDB Atlas connection string in Render's Environment tab."
  exit 1
fi

cat > "$DATA_DIR/config.json" <<EOF
{
  "\$schema": "https://raw.githubusercontent.com/Ylianst/MeshCentral/master/meshcentral-config-schema.json",
  "settings": {
    "mongoDb": "${MONGO_URI}",
    "cert": "${HOST}",
    "port": ${PORT},
    "aliasPort": 443,
    "redirPort": ${PORT},
    "TLSOffload": true,
    "trustedProxy": true,
    "WANonly": true,
    "sessionKey": "${SESSION_KEY:-changeThisToARandomSecretString}"
  },
  "domains": {
    "": {
      "title": "MeshCentral",
      "newAccounts": true
    }
  }
}
EOF

exec node node_modules/meshcentral --nice404