package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

const usage = `orchestra-plugin - Plugin Manager CLI for Orchestra MCP

Usage:
  orchestra-plugin <command> [arguments]

Commands:
  new <name> [--with caps]  Create a new plugin scaffold
  list [--path dir]         List all discovered plugins
  info <name>               Show detailed plugin information
  validate <path>           Validate a plugin directory structure
  enable <name>             Enable a disabled plugin
  disable <name>            Disable an active plugin
  registry [--path dir]     Generate config/plugins_registry.go

Flags:
  --with    Comma-separated capabilities (routes,settings,mcp,tray,panels,widgets,notifications,search)
  --path    Plugins directory (default: plugins)
  -h        Show this help message
`

func main() {
	if len(os.Args) < 2 {
		fmt.Print(usage)
		os.Exit(1)
	}

	command := os.Args[1]

	switch command {
	case "new":
		cmdNew(os.Args[2:])
	case "list":
		cmdList(os.Args[2:])
	case "registry":
		cmdRegistry(os.Args[2:])
	case "info":
		cmdInfo(os.Args[2:])
	case "validate":
		cmdValidate(os.Args[2:])
	case "enable":
		cmdEnable(os.Args[2:])
	case "disable":
		cmdDisable(os.Args[2:])
	case "-h", "--help", "help":
		fmt.Print(usage)
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n\n", command)
		fmt.Print(usage)
		os.Exit(1)
	}
}

func cmdNew(args []string) {
	// Extract plugin name (first non-flag arg) and collect remaining flags.
	var name string
	var flagArgs []string
	for _, a := range args {
		if name == "" && !strings.HasPrefix(a, "-") {
			name = a
		} else {
			flagArgs = append(flagArgs, a)
		}
	}

	if name == "" {
		fmt.Fprintln(os.Stderr, "Usage: orchestra-plugin new <name> [--with capabilities]")
		os.Exit(1)
	}

	fs := flag.NewFlagSet("new", flag.ExitOnError)
	withFlag := fs.String("with", "", "Comma-separated capabilities")
	pathFlag := fs.String("path", "plugins", "Plugins directory")
	fs.Parse(flagArgs)

	var caps []string
	if *withFlag != "" {
		caps = strings.Split(*withFlag, ",")
		for i := range caps {
			caps[i] = strings.TrimSpace(caps[i])
		}
	}

	if err := generatePlugin(name, caps, *pathFlag); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}

	fmt.Printf("Created plugin: %s/%s\n", *pathFlag, name)
	printScaffoldSummary(name, caps)
}

func cmdList(args []string) {
	fs := flag.NewFlagSet("list", flag.ExitOnError)
	pathFlag := fs.String("path", "plugins", "Plugins directory")
	fs.Parse(args)

	plugins, err := listPlugins(*pathFlag)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}

	printPluginList(plugins)
}

func cmdInfo(args []string) {
	name, flagArgs := extractNameAndFlags(args)
	if name == "" {
		fmt.Fprintln(os.Stderr, "Usage: orchestra-plugin info <name>")
		os.Exit(1)
	}

	fs := flag.NewFlagSet("info", flag.ExitOnError)
	pathFlag := fs.String("path", "plugins", "Plugins directory")
	fs.Parse(flagArgs)

	info, err := getPluginInfo(name, *pathFlag)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}

	printPluginInfo(info)
}

func cmdValidate(args []string) {
	name, _ := extractNameAndFlags(args)
	if name == "" {
		fmt.Fprintln(os.Stderr, "Usage: orchestra-plugin validate <path>")
		os.Exit(1)
	}

	result := validatePlugin(name)
	printValidation(result)

	if !result.IsValid() {
		os.Exit(1)
	}
}

func cmdEnable(args []string) {
	name, flagArgs := extractNameAndFlags(args)
	if name == "" {
		fmt.Fprintln(os.Stderr, "Usage: orchestra-plugin enable <name>")
		os.Exit(1)
	}

	fs := flag.NewFlagSet("enable", flag.ExitOnError)
	pathFlag := fs.String("path", "plugins", "Plugins directory")
	fs.Parse(flagArgs)

	if err := togglePlugin(name, *pathFlag, false); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}
}

func cmdDisable(args []string) {
	name, flagArgs := extractNameAndFlags(args)
	if name == "" {
		fmt.Fprintln(os.Stderr, "Usage: orchestra-plugin disable <name>")
		os.Exit(1)
	}

	fs := flag.NewFlagSet("disable", flag.ExitOnError)
	pathFlag := fs.String("path", "plugins", "Plugins directory")
	fs.Parse(flagArgs)

	if err := togglePlugin(name, *pathFlag, true); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}
}

// extractNameAndFlags separates the first positional arg from flag args.
// This handles "command <name> --flag value" where Go's flag package
// would otherwise stop parsing at the non-flag positional argument.
func extractNameAndFlags(args []string) (string, []string) {
	var name string
	var flagArgs []string
	for _, a := range args {
		if name == "" && !strings.HasPrefix(a, "-") {
			name = a
		} else {
			flagArgs = append(flagArgs, a)
		}
	}
	return name, flagArgs
}

// printScaffoldSummary shows what was generated after a successful "new".
func printScaffoldSummary(name string, caps []string) {
	fmt.Printf("\nGenerated files:\n")
	fmt.Printf("  %s/go.mod\n", name)
	fmt.Printf("  %s/config/%s.go\n", name, name)
	fmt.Printf("  %s/providers/plugin.go\n", name)
	fmt.Printf("  %s/src/service.go\n", name)
	fmt.Printf("  %s/src/types.go\n", name)
	fmt.Printf("  %s/tests/service_test.go\n", name)
	fmt.Printf("  %s/README.md\n", name)

	if len(caps) > 0 {
		fmt.Printf("\nCapabilities: %s\n", strings.Join(caps, ", "))
	}

	fmt.Printf("\nNext steps:\n")
	fmt.Printf("  1. Add replace directive to root go.mod\n")
	fmt.Printf("  2. Register plugin in cmd/server/main.go\n")
	fmt.Printf("  3. Run: cd plugins/%s && go test ./...\n", name)
}
