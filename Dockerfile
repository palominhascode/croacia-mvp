FROM nimlang/nim:latest

WORKDIR /app

COPY . .

RUN nimble install -y

EXPOSE 8080

CMD ["nim", "c", "-r", "src/main.nim"]
