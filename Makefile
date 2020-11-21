UNAME_S     := $(shell uname -s)
TFLINT      := $(shell which tflint)
CHECKOV_TAG ?= latest
TFDOCS_TAG  ?= latest
PATH        := $(PATH):${HOME}/.local/bin
PROJ_DIR    := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: test test-junitxml all clean dep tf-init checkov install-tflint fmt docs

# Check the system keychain for stored encryption pass
ifeq ($(UNAME_S),Linux)
OS := linux
endif
ifeq ($(UNAME_S),Darwin)
OS := darwin
endif

clean:
	@rm -rf .terraform/
	@rm -f checkov.xml

hooks:
	@echo "IyEvYmluL3NoCm1ha2UgZG9jcyA+IC9kZXYvbnVsbCAyPiYxCmlmIFsgIiQkKGdpdCBzdGF0dXMgLXMgZG9jcy8gfCB3YyAtbCkiIC1ndCAwIF07IHRoZW4KCWVjaG8gIltQT0xJQ1ldIC0gRG9jdW1lbnRhdGlvbiBkcmlmdCBkZXRlY3RlZC4gUGxlYXNlIHN0YWdlIGRvY3VtZW50YXRpb24gYW5kIHRyeSBhZ2Fpbi4iIDE+JjIKCWV4aXQgMQpmaQo=" | base64 -d > $(PROJ_DIR).git/hooks/pre-commit && chmod +x $(PROJ_DIR).git/hooks/pre-commit

install-tflint:
ifeq ($(TFLINT),)
	@echo "Installing tflint"
	@mkdir -p ${HOME}/.local/bin
	@curl -ss -L "$(shell curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_$(OS)_amd64.zip")" -o /tmp/tflint.zip && unzip -q -o -d ${HOME}/.local/bin/ /tmp/tflint.zip
	@echo "Installing azurerm tflint plugin"
	@mkdir -p ${HOME}/.tflint.d/plugins && curl -ss -L "$(shell curl -Ls https://api.github.com/repos/terraform-linters/tflint-ruleset-azurerm/releases/latest | grep -o -E "https://.+?_$(OS)_amd64.zip")" -o ${HOME}/.tflint.d/plugins/tflint-azure.zip && unzip -q -o -d ${HOME}/.tflint.d/plugins/ ${HOME}/.tflint.d/plugins/tflint-azure.zip
else
	@echo "tflint found at $(TFLINT)"
endif

test: dep lint checkov fmt
test-junitxml: dep lint checkov.xml fmt

tf-init:
	terraform init -backend=false

tf-plan: tf-init dep
	terraform plan -out "out.plan"

docs:
	mkdir -p $(PROJ_DIR)docs/
	docker run -v $(PROJ_DIR):/tf quay.io/terraform-docs/terraform-docs markdown table /tf > $(PROJ_DIR)docs/README.md

dep: tf-init install-tflint
	docker pull bridgecrew/checkov:$(CHECKOV_TAG)
	docker pull quay.io/terraform-docs/terraform-docs:$(TFDOCS_TAG)
	terraform get -update

validate:
	@cd examples; terraform init -backend=false; terraform validate

fmt:
	terraform fmt -recursive -diff -check

lint:
	tflint

checkov:
	docker run -t -v $(PROJ_DIR):/tf bridgecrew/checkov -d /tf

checkov.xml:
	docker run -t -v $(PROJ_DIR):/tf bridgecrew/checkov -s -d /tf # print results to the screen
	docker run -v $(PROJ_DIR):/tf bridgecrew/checkov -d /tf -o junitxml > checkov.xml

