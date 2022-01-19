FROM rust:1.58 AS builder
ENV RUST_BACKTRACE=1
RUN USER=root cargo new yaskkserv2_build
COPY yaskkserv2/Cargo.toml yaskkserv2/Cargo.lock /yaskkserv2_build/
WORKDIR /yaskkserv2_build
RUN cargo build --release
RUN rm src/*.rs
COPY yaskkserv2/src ./src
RUN cargo build --release
COPY util.sh /yaskkserv2_build/
ENV PREFIX=/yaskkserv2_build/target/release
RUN ./util.sh dic L

FROM gcr.io/distroless/cc
WORKDIR /data
COPY yaskkserv2.conf /config/yaskkserv2.conf
COPY --from=builder /yaskkserv2_build/dictionary.yaskkserv2 /data/dictionary.yaskkserv2
COPY --from=builder /yaskkserv2_build/target/release/yaskkserv2 /yaskkserv2_build/target/release/yaskkserv2_make_dictionary /usr/local/bin/

CMD ["/usr/local/bin/yaskkserv2", "--no-daemonize", "--config-filename=/config/yaskkserv2.conf"]
