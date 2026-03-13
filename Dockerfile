FROM node:alpine

WORKDIR /app

# Ensure only essential dependencies are copied first
COPY TODO/todo_backend/package.json TODO/todo_backend/package-lock.json* TODO/todo_backend/pnpm-lock.yaml* ./

# Check if pnpm-lock.yaml exists and install using it, otherwise fallback to npm.
# (Because the user used pnpm earlier)
# To ensure maximum compatibility with the assignment instructions, we use npm install.
RUN npm install

# Copy all the backend logic and the statically generated frontend build 
# NOTE: The frontend build must be generated and moved here prior to building this image (e.g. by the Jenkins 'Build' stage)
COPY TODO/todo_backend/ ./

# The instruction asks for the app to be accessible on port 5000 inside the container
ENV PORT=5000
EXPOSE 5000

CMD ["npm", "start"]
