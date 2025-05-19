# Stage 1: Build frontend
FROM node:20 AS frontend-builder
WORKDIR /app/frontend
COPY frontend/ .
RUN npm install && npm run build

# Stage 2: Build Go backend
FROM golang:1.21 AS backend-builder
WORKDIR /app/backend
COPY backend/ .
RUN go build -o daedalus

# Stage 3: Final container
FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=backend-builder /app/backend/daedalus .
COPY --from=frontend-builder /app/frontend/out ./frontend

EXPOSE 8080
CMD ["./daedalus"]
