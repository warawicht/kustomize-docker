FROM mikefarah/yq AS the_yq

FROM alpine:3.9
ENV KUSTOMIZE_VER 2.0.3
ENV KUBECTL_VER 1.14.0

RUN apk --no-cache add curl gettext
COPY --from=the_yq /usr/bin/yq /usr/bin
RUN chmod a+x /usr/bin/yq
ENV PACKAGES=" bash tzdata"
ENV TZ=Asia/Bangkok
RUN apk add --update $PACKAGES && rm /var/cache/apk/*  
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir /working
WORKDIR /working

RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VER}/kustomize_${KUSTOMIZE_VER}_linux_amd64  -o /usr/bin/kustomize \
    && chmod +x /usr/bin/kustomize

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl

CMD ["/usr/bin/kustomize"]
