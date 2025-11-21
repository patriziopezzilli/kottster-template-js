FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN apk add --no-cache git tini

RUN npm install

COPY . .

# Inizializza Kottster in dev mode headless (solo per generare .kottster)
RUN npm run dev -- --headless

# Build produzione
RUN npm run build

EXPOSE 5480

ENTRYPOINT ["/sbin/tini", "--"]

# Avvia server in produzione sulla porta Render
CMD ["sh", "-c", "node dist/server/server.cjs --port=$PORT"]
