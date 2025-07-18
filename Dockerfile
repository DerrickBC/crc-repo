FROM registry.access.redhat.com/ubi9/ubi-minimal

# Install nginx
RUN microdnf install -y nginx && \
    microdnf clean all && \
    rm -rf /var/cache/yum

# Create a non-root user
RUN useradd -r -u 1001 -g root -d /usr/share/nginx/html -s /sbin/nologin nginxuser

# Create web root and set permissions
RUN mkdir -p /usr/share/nginx/html && \
    chown -R nginxuser:root /usr/share/nginx/html

# Create config directory and copy mime.types
RUN mkdir -p /opt/nginx && \
    cp /etc/nginx/mime.types /opt/nginx/mime.types

# Copy website files
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# Copy custom nginx config
COPY nginx.conf /opt/nginx/nginx.conf

# Set permissions
RUN chmod -R 755 /usr/share/nginx/html

# Switch to non-root user
USER 1001

# Expose non-privileged port
EXPOSE 8080

# Use custom config
CMD ["nginx", "-c", "/opt/nginx/nginx.conf", "-g", "daemon off; error_log /dev/stderr;"]

