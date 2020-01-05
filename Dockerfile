FROM alpine:3.8
ENV KUSTOMIZE_VER 3.5.3
ENV KUBECTL_VER 1.14.0

RUN apk --no-cache add curl gettext

ENV PACKAGES="\
  py-pip \
  jq \
  bash \
"

RUN apk add --update $PACKAGES \
  && pip install yq \
  && rm /var/cache/apk/*
  
RUN mkdir /working
WORKDIR /working

RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VER}/kustomize_${KUSTOMIZE_VER}_linux_amd64  -o /usr/bin/kustomize \
    && chmod +x /usr/bin/kustomize

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl

CMD ["/usr/bin/kustomize"]
