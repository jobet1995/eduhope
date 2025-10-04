#!/bin/bash

# Exit on error
set -e

# Check if domain and email are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./init-letsencrypt.sh <domain> <email>"
    echo "Example: ./init-letsencrypt.sh example.com your-email@example.com"
    exit 1
fi

DOMAIN=$1
EMAIL=$2

# Create necessary directories
mkdir -p ./data/certbot/conf/live/$DOMAIN
mkdir -p ./data/certbot/www

# Create dummy certificate to allow Nginx to start
if [ ! -f "./data/certbot/conf/live/$DOMAIN/privkey.pem" ]; then
    echo "Creating dummy certificate for $DOMAIN..."
    docker-compose run --rm --entrypoint "\
        openssl req -x509 -nodes -newkey rsa:4096 \
        -keyout '/etc/letsencrypt/live/$DOMAIN/privkey.pem' \
        -out '/etc/letsencrypt/live/$DOMAIN/fullchain.pem' \
        -days 1 \
        -subj '/CN=localhost'" certbot
else
    echo "Certificate already exists, skipping dummy certificate creation"
fi

# Start Nginx with dummy certificate
echo "Starting Nginx with dummy certificate..."
docker-compose up --force-recreate -d nginx

# Delete dummy certificate
echo "Deleting dummy certificate..."
docker-compose run --rm --entrypoint "rm -Rf /etc/letsencrypt/live/$DOMAIN && rm -Rf /etc/letsencrypt/archive/$DOMAIN && rm -Rf /etc/letsencrypt/renewal/$DOMAIN.conf" certbot

# Request real certificate
echo "Requesting Let's Encrypt certificate for $DOMAIN..."

# Enable staging mode if needed (avoids hitting rate limits during testing)
# STAGING_FLAG="--staging"
STAGING_FLAG=""

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $STAGING_FLAG \
    --email $EMAIL \
    -d $DOMAIN \
    -d www.$DOMAIN \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot

# Reload Nginx to use the new certificate
echo "Reloading Nginx with the new certificate..."
docker-compose exec nginx nginx -s reload

echo "\n🎉 SSL certificate for $DOMAIN has been successfully installed!"
echo "🔒 Your site is now secured with HTTPS!"
echo "\nTo check the certificate status, run:"
echo "docker-compose exec nginx nginx -t"

echo "\nTo test the SSL configuration, visit:"
echo "https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN"
