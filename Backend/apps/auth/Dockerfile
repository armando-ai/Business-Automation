FROM node:alpine As development

WORKDIR /usr/src/app

COPY tsconfig.json ./
COPY package*.json ./
COPY . .

RUN npm install
RUN npm run build

FROM --platform=linux/amd64 node:alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY tsconfig.json ./
COPY package*.json ./

RUN npm install --only=production
COPY . .

COPY --from=development /usr/src/app/dist ./dist

# 
CMD ["node", "dist/apps/auth/main"]