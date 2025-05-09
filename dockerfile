FROM python:3.10-slim

# Install nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Copy app and configs
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Add script to start both Nginx and Gunicorn
RUN echo '#!/bin/bash\n\
service nginx start\n\
gunicorn -w 2 -b 127.0.0.1:8000 app:app' > /start.sh && chmod +x /start.sh

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
