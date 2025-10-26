FROM node:20-alpine
WORKDIR /usr/src/app
COPY app/package*.json ./
RUN npm ci --only=production
COPY app/ .
ENV NODE_ENV=production
CMD ["npm","start"]