FROM golang:1.22.5 as base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

# RUN go build -o main .
# Build a static Linux binary
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage - Distroless image
# FROM gcr.io/distroless/base
# Final stage - Distroless runtime
FROM gcr.io/distroless/static-debian12

WORKDIR /app

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD [ "./main" ]