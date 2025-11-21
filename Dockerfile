# Usa Node.js Alpine leggero
FROM node:22-alpine

# Imposta working directory
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Installa git e tini
RUN apk add --no-cache git tini

# Installa dipendenze Node
RUN npm install

# Copia tutto il codice
COPY . .

# Inizializza Kottster in modalità headless (genera .kottster e file iniziali)
RUN npm run dev -- --headless

# Build produzione (genera dist/server/server.cjs)
RUN npm run build

# Espone la porta predefinita (Render sovrascrive con PORT)
EXPOSE 5480

# Variabile PORT di Render
ENV PORT=5480

# Usa tini come entrypoint per gestire segnali
ENTRYPOINT ["/sbin/tini", "--"]

# Avvia il server usando la porta fornita da Render
CMD ["sh", "-c", "export PORT=${PORT:-5480} && node dist/server/server.cjs --port=$PORT"]
