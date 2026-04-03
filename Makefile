
.PHONY: default
default:
	./scripts/cqfd/cqfd -b full

%:
	./scripts/cqfd/cqfd -b $@
