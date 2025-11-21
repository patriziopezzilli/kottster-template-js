FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN apk add --no-cache git tini
RUN npm install
COPY . .
EXPOSE 5480
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["sh", "-c", "node dist/server/server.cjs --port=$PORT"]
