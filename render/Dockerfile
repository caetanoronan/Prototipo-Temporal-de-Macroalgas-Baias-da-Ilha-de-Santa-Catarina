FROM mcr.microsoft.com/playwright:v1.54.2-jammy

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev --ignore-scripts --no-fund --no-audit

COPY . .

ENV NODE_ENV=production
EXPOSE 3030

CMD ["node", "server.js"]
