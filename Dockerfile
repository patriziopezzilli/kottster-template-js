FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN apk add --no-cache git tini

RUN npm install

# Copia tutto il codice
COPY . .

# Build produzione (crea dist/server/server.cjs)
RUN npm run build

EXPOSE 5480

ENV PORT=5480

ENTRYPOINT ["/sbin/tini", "--"]

# Avvia il server dalla build generata
CMD ["sh", "-c", "PORT=${PORT:-5480} node dist/server/server.cjs"]
