
# Generated by nginxconfig.io
# https://www.digitalocean.com/community/tools/nginx#?0.php=false&0.wordpress&0.django&0.proxy&0.fallback_html&0.access_log_domain&0.error_log_domain&resolver_cloudflare=false&server_tokens&limit_req&log_not_found&pid=%2Fvar%2Frun%2Fnginx.pid

user www-data;

pid /var/run/nginx.pid;

worker_processes auto;

worker_rlimit_nofile 65535;

events {
	multi_accept on;
	worker_connections 2000;
}

http {
	charset utf-8;
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	types_hash_max_size 2048;
	client_max_body_size 16M;

	# MIME
	include mime.types;
	default_type application/octet-stream;

	# logging
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log warn;

	# limits
	limit_req_log_level warn;
	limit_req_zone $binary_remote_addr zone=login:10m rate=10r/m;

	# SSL
	ssl_session_timeout 1d;
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off;

	# Diffie-Hellman parameter for DHE ciphersuites
	ssl_dhparam /etc/nginx/dhparam.pem;

	# Mozilla Intermediate configuration
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

	# OCSP Stapling
	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 valid=60s;
	resolver_timeout 2s;

	# load configs
	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}

/etc/nginx/sites-available/example.com.conf

server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name example.com;
	root /var/www/example.com/public;

	# SSL
	ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;

	# security
	include nginxconfig.io/security.conf;

	# logging
	access_log /var/log/nginx/example.com.access.log;
	error_log /var/log/nginx/example.com.error.log warn;

	# index.html fallback
	location / {
		try_files $uri $uri/ /index.html;
	}

	# reverse proxy
	location / {
		proxy_pass http://127.0.0.1:3000;
		include nginxconfig.io/proxy.conf;
	}

	# additional config
	include nginxconfig.io/general.conf;
}

# subdomains redirect
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name *.example.com;

	# SSL
	ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;

	return 301 https://example.com$request_uri;
}

# HTTP redirect
server {
	listen 80;
	listen [::]:80;

	server_name .example.com;

	include nginxconfig.io/letsencrypt.conf;

	location / {
		return 301 https://example.com$request_uri;
	}
}

/etc/nginx/nginxconfig.io/letsencrypt.conf

# ACME-challenge
location ^~ /.well-known/acme-challenge/ {
	root /var/www/_letsencrypt;
}

/etc/nginx/nginxconfig.io/security.conf

# security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

# . files
location ~ /\.(?!well-known) {
	deny all;
}

/etc/nginx/nginxconfig.io/general.conf

# favicon.ico
location = /favicon.ico {
	log_not_found off;
	access_log off;
}

# robots.txt
location = /robots.txt {
	log_not_found off;
	access_log off;
}

# assets, media
location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
	expires 7d;
	access_log off;
}

# svg, fonts
location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
	add_header Access-Control-Allow-Origin "*";
	expires 7d;
	access_log off;
}

# gzip
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;

/etc/nginx/nginxconfig.io/proxy.conf

proxy_http_version	1.1;
proxy_cache_bypass	$http_upgrade;

proxy_set_header Upgrade			$http_upgrade;
proxy_set_header Connection 		"upgrade";
proxy_set_header Host				$host;
proxy_set_header X-Real-IP			$remote_addr;
proxy_set_header X-Forwarded-For	$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto	$scheme;
proxy_set_header X-Forwarded-Host	$host;
proxy_set_header X-Forwarded-Port	$server_port;

# Lovingly made by Bálint Szekeres and maintained by DigitalOcean.
