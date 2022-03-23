FROM cr.hotio.dev/hotio/base@sha256:7a1c08d63277cbc84b015316321e051918107238953778f399ac43af9f861c21

EXPOSE 9696

RUN apk add --no-cache libintl sqlite-libs icu-libs

ARG VERSION
ARG PACKAGE_VERSION=${VERSION}
RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://prowlarr.servarr.com/v1/update/nightly/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=arm64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Prowlarr.Update" && \
    echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[hotio](https://github.com/hotio)\nUpdateMethod=Docker\nBranch=nightly" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
