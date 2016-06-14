MINICONDA_ARCHIVE := https://repo.continuum.io/miniconda
INSTALLER_NAME    := Miniconda3-4.0.5-Linux-x86_64.sh
INSTALLER_URL     := $(MINICONDA_ARCHIVE)/$(INSTALLER_NAME)

IMAGE_NAME        := multiuser-conda

.PHONY: default help image installer test

default: help

help:
	@echo "Available targets are:"
	@echo
	@echo "  installer -- Download Miniconda installer for Linux"
	@echo "  image     -- Create the Docker image for this test"
	@echo "  test      -- Run the test with the image"

installer: $(INSTALLER_NAME)

$(INSTALLER_NAME):
	curl -O $(INSTALLER_URL)

image: Dockerfile $(INSTALLER_NAME)
	@if which docker >/dev/null ; then \
	  docker build -t $(IMAGE_NAME) . ; \
	else \
	  echo 'Error: docker is not on PATH' ; \
	  exit 1 ; \
	fi

test:
	@if [ -z "`docker images -q $(IMAGE_NAME)`" ] ; then \
	  echo 'Error: Docker image "$(IMAGE_NAME)" does not exist;' ; \
	  echo 'Run "make image" to create it' ; \
	  exit 1 ; \
	fi
	docker run --rm -u dev2 -i $(IMAGE_NAME) \
	  /opt/devteam/miniconda3/bin/conda --debug create -yqn dev2-name \
	                                    --clone root 2>&1 | tee test.out
	fgrep -q "failed to link" test.out && \
	  echo 'Error: link failures in the file "test.out"' && \
	  exit 1
