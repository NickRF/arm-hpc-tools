FROM aarch64/ubuntu:16.04 as builder

USER root

# Install pre reqs
RUN apt-get update && apt-get install -y \
      environment-modules \
      nano \
      vim \
      unzip \
      less \
      wget \
      python \
      python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN bash -c "wget https://developer.arm.com/-/media/Files/downloads/hpc/arm-allinea-studio/19-0/Ubuntu16.04/Arm-Compiler-for-HPC.19.0_Ubuntu_16.04_aarch64.tar && tar xf Arm-Compiler-for-HPC.19.0_Ubuntu_16.04_aarch64.tar && ./ARM-Compiler-for-HPC*/*.sh --accept; rm -rf /tmp/*"

# By rebuilding the image from scratch,  and copying in the result
# we save image size
FROM aarch64/ubuntu:16.04
COPY --from=builder / /

RUN useradd -ms /bin/bash test_user
USER test_user
#ENV PATH="/opt/arm/licenceserver/bin/:${PATH}"
ENV MODULEPATH /opt/arm/modulefiles
WORKDIR /home/test_user

CMD ["bash", "-l"]
