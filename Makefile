
.PHONY: default
default:
	./scripts/cqfd/cqfd

%:
	./scripts/cqfd/cqfd -b $@
