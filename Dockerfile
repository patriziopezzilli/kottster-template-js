FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN apk add --no-cache git tini

RUN npm install

# Copia tutto il codice
COPY . .

# Inizializza Kottster headless (solo build-time)
RUN npm run dev -- --headless

# Build produzione
RUN npm run build

EXPOSE 5480

ENV PORT=5480

ENTRYPOINT ["/sbin/tini", "--"]

# Avvia il server di produzione (uso porta Render)
CMD ["sh", "-c", "node dist/server/server.cjs --port=${PORT}"]
