# Use Node 20 base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package files and install dependencies first (cache optimization)
COPY package*.json ./
RUN npm install --production

# Copy the rest of the app
COPY . .

# Build Strapi admin panel
RUN npm run build

# Expose Strapi port
EXPOSE 1337

# Start the Strapi server
CMD ["npm", "run", "start"]