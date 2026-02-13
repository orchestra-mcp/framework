package main

import (
	"fmt"
	"os"

	"github.com/orchestra-mcp/mcp/src/bootstrap"
	"github.com/orchestra-mcp/mcp/src/tools"
	"github.com/orchestra-mcp/mcp/src/transport"
	"github.com/orchestra-mcp/mcp/src/version"
)

const cmdInit = "init"

func main() {
	ws := "."
	var cmd string

	args := os.Args[1:]
	for i := 0; i < len(args); i++ {
		switch args[i] {
		case "--version", "-v":
			fmt.Printf("orchestra-mcp %s (commit %s, built %s)\n",
				version.Version, version.Commit, version.Date)
			return
		case "--help", "-h":
			printUsage()
			return
		case "--workspace":
			if i+1 < len(args) {
				ws = args[i+1]
				i++
			}
		case cmdInit:
			cmd = cmdInit
		}
	}

	if cmd == cmdInit {
		if err := bootstrap.Run(ws); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %s\n", err)
			os.Exit(1)
		}
		return
	}

	s := transport.New("orchestra-mcp", version.Version)
	s.RegisterTools(tools.Project(ws))
	s.RegisterTools(tools.Epic(ws))
	s.RegisterTools(tools.Story(ws))
	s.RegisterTools(tools.Task(ws))
	s.RegisterTools(tools.Workflow(ws))
	s.RegisterTools(tools.Prd(ws))
	s.RegisterTools(tools.Bugfix(ws))
	s.RegisterTools(tools.Usage(ws))
	s.RegisterTools(tools.Readme(ws))
	s.RegisterTools(tools.Artifacts(ws))

	fmt.Fprintf(os.Stderr, "[Orchestra MCP] Server v%s running with %d tools\n",
		version.Version, len(s.GetTools()))
	s.Run()
}

func printUsage() {
	fmt.Print(`orchestra-mcp — AI-powered project management via Model Context Protocol

Usage:
  orchestra-mcp [flags]
  orchestra-mcp init [--workspace <path>]

Commands:
  init              Initialize MCP workspace (.mcp.json, .projects/)

Flags:
  --workspace <path>  Set workspace directory (default: ".")
  --version, -v       Print version and exit
  --help, -h          Print this help message

Examples:
  orchestra-mcp                          Start MCP server (stdio JSON-RPC)
  orchestra-mcp --workspace /my/project  Start with custom workspace
  orchestra-mcp init                     Initialize workspace in current dir
  orchestra-mcp init --workspace /path   Initialize workspace at path
`)
}
