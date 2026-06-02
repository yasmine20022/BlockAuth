FROM node:20-slim
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
USER 1001
EXPOSE 8000
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1
CMD ["npm", "start"]