FROM registry.access.redhat.com/ubi9/ubi-minimal

# Install nginx and clean up
RUN microdnf install -y nginx && \
    microdnf clean all && \
    rm -rf /var/cache/yum

# Create a non-root user and group
RUN useradd -r -u 1001 -g root -d /usr/share/nginx/html -s /sbin/nologin nginxuser

# Create the web root directory and set permissions
RUN mkdir -p /usr/share/nginx/html && \
    chown -R nginxuser:root /usr/share/nginx/html

# Copy website files into the image (assumes they are in the build context)
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# Set permissions
RUN chmod -R 755 /usr/share/nginx/html

# Switch to non-root user
USER 1001

# Expose port 8080 (OpenShift prefers non-privileged ports)
EXPOSE 8080

# Override the default nginx port to 8080
RUN sed -i 's/listen       80;/listen       8080;/g' /etc/nginx/nginx.conf

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

