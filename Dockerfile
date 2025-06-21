FROM python:3.10-slim

# Instaliraj potrebne pakete
RUN apt-get update && \
    apt-get install -y wget curl unzip gnupg2 fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libcups2 libdbus-1-3 libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 xdg-utils libgbm1 libgtk-3-0 libpango-1.0-0 libpangocairo-1.0-0

# Instaliraj Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable

# Instaliraj Python pakete
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Kopiraj kod aplikacije
COPY . /app
WORKDIR /app

# Start aplikacije
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
