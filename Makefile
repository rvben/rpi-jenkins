.PHONY: all build bash run certificates
AUTHOR = rvben
NAME = rpi-jenkins
VERSION = $(shell date +'%Y%m%d')
FULLDOCKERNAME = $(AUTHOR)/$(NAME):$(VERSION)

build: $(BINARY)
	docker build --rm --no-cache -t $(FULLDOCKERNAME) .
	docker tag $PREFIX/$IMAGE:$VERSION $PREFIX/$IMAGE:latest

push:
	docker push $(FULLDOCKERNAME)
