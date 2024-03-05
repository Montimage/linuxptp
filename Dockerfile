ARG LINUXPTP_VERSION=v4.1
FROM ubuntu:22.04 AS builder

RUN apt update && apt install -y git make gcc musl-dev

WORKDIR /linuxptp-agent
RUN git clone https://git.code.sf.net/p/linuxptp/code linuxptp && \
    cd linuxptp && \
    git checkout ${LINUXPTP_VERSION} && \
    make

FROM ubuntu:22.04

COPY --from=builder /linuxptp-agent/linuxptp/ptp4l /usr/local/bin/
COPY --from=builder /linuxptp-agent/linuxptp/phc2sys /usr/local/bin/
COPY --from=builder /linuxptp-agent/linuxptp/pmc /usr/local/bin/

RUN apt update && apt install -y musl-dev bc && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    ldconfig