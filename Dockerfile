# Builder stage

FROM node:16-alpine AS builder

RUN apk add python3 make gcc g++

# Create app directory
WORKDIR /home/node/app

# Install app dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache

# Bundle app source
COPY . .

# Build
RUN yarn build


# Runner stage

FROM node:16-alpine
ENV NODE_ENV=production
WORKDIR /home/node/app

# Install serve
RUN yarn global add serve

# Copy build files
COPY --from=builder /home/node/app/build ./build

EXPOSE 27777

CMD serve -s build -p 27777
