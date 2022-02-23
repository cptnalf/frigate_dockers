from blakeblackshear/frigate:0.9.4-aarch64 AS frigate_src


FROM 
RUN \
  useradd --uid 911 --user-group --create-home abc

COPY rootfs/ /

#FROM nvcr.io/nvidia/l4t-base:r32.6.1
#COPY --from=0 / /

ENTRYPOINT [ "/init" ]
