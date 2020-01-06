FROM alpine:latest AS base
RUN apk upgrade --update

FROM base AS builder
ENV RUST_BACKTRACE=1
RUN apk add --no-cache cargo build-base openssl-dev
RUN USER=root cargo new yaskkserv2_build
COPY yaskkserv2/Cargo.toml yaskkserv2/Cargo.lock /yaskkserv2_build/
WORKDIR /yaskkserv2_build
RUN cargo build --release
RUN rm src/*.rs
COPY yaskkserv2/src ./src
RUN cargo build --release

FROM base
RUN apk add --no-cache libstdc++ openssl
COPY --from=builder /yaskkserv2_build/target/release/yaskkserv2 /yaskkserv2_build/target/release/yaskkserv2_make_dictionary /usr/local/bin/
WORKDIR /data

CMD ["/usr/local/bin/yaskkserv2", "--no-daemonize", "--google-cache-filename=/data/yaskkserv2.cache", "/data/dictionary.yaskkserv2"]
