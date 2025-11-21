# Usa Node.js Alpine
FROM node:22-alpine

# Imposta working directory
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Installa git e tini per gestione PID/entrypoint
RUN apk add --no-cache git tini

# Installa dipendenze Node
RUN npm install

# Copia tutto il codice
COPY . .

# Copia script di start (se presenti)
COPY scripts/dev.sh /dev.sh
COPY scripts/prod.sh /prod.sh
RUN chmod +x /dev.sh /prod.sh

# Espone porta principale del server (Render userà PORT dinamica)
EXPOSE 5480

# Variabile PORT di Render
ENV PORT=5480

# Usa tini come entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

# Avvia il server Kottster sulla porta fornita da Render
CMD ["sh", "-c", "PORT=${PORT:-5480} npm run start"]
