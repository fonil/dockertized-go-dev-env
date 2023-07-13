###
# DEVELOPMENT
###

version: ## Application: displays the Go Version
	$(call showTitle,"APPLICATION: DISPLAYS CURRENT GOLANG VERSION",$(call rpad,29))
	$(call runDockerComposeExec,go version)
	$(call taskDone)

init: ## Application: initialized the Go module
	$(call showTitle,"APPLICATION: INITIALIZES THE GO MODULE",$(call rpad,29))
	$(call runDockerComposeExecAsUser,go mod init $(MODULE_NAME))
	$(call taskDone)

tidy: ## Application: add module requirements and sum
	$(call showTitle,"APPLICATION: ADD MODULE REQUIREMENTS AND SUM",$(call rpad,29))
	$(call runDockerComposeExec,go mod tidy)
	$(call taskDone)

dependencies: ## Application: list application dependencies
	$(call showTitle,"APPLICATION: LIST APPLICATION DEPENDENCIES",$(call rpad,29))
	$(call runDockerComposeExecAsUser,go list -m all)
	$(call taskDone)

test: ## Application: executes the test suite
	$(call showTitle,"APPLICATION: EXECUTES THE TEST SUITE",$(call rpad,37))
	$(call runDockerComposeExec,go test)
	$(call taskDone)

format: ## Application: fix source code format
	$(call showTitle,"APPLICATION: FORMAT THE SOURCE CODE",$(call rpad,37))
	$(call runDockerComposeExec,go fmt)
	$(call taskDone)

run: format test ## Application: executes the main script
	$(call showTitle,"APPLICATION: RUN THE APPLICATION SERVICE",$(call rpad,29))
	$(call runDockerComposeExec,go run main.go)
	$(call taskDone)

compile: format test ## Application: build the application binary file
	$(call showTitle,"APPLICATION: BUILD THE APPLICATION BINARY FILE",$(call rpad,21))
	$(call runDockerComposeExec,go build -o /go/bin/$(MODULE_NAME) ./main.go)
	$(call taskDone)

execute: compile ## Application: executes the binary script
	$(call showTitle,"APPLICATION: EXECUTES THE APPLICATION BINARY",$(call rpad,29))
	@docker-compose exec --workdir=/go/bin app ./$(MODULE_NAME)
	$(call taskDone)

###
# PRODUCTION
###

execute-distroless: ## Application: executes the binary script from distroless image
	$(call showTitle,"APPLICATION: EXECUTES THE PRODUCTION APPLICATION BINARY",$(call rpad,13))
	@docker run app:latest
	$(call taskDone)
