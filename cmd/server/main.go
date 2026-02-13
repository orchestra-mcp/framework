package main

import (
	"os"
	"os/signal"
	"syscall"

	"github.com/gofiber/fiber/v3"
	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/framework/config"
	mcpproviders "github.com/orchestra-mcp/mcp/providers"
	"github.com/rs/zerolog"
)

func main() {
	logger := zerolog.New(os.Stderr).With().Timestamp().Logger()

	// Plugin system.
	cfg := config.DefaultPluginsConfig()
	pm := plugins.NewPluginManager(cfg)
	pm.SetLogger(logger)

	// Register plugins.
	loader := plugins.NewPluginLoader(cfg.PluginsPath)
	loader.SetLogger(logger)
	if err := loader.RegisterAll(pm, mcpproviders.NewMcpPlugin()); err != nil {
		logger.Fatal().Err(err).Msg("failed to register plugins")
	}

	// Boot all plugins (topological sort + activate).
	if err := pm.Boot(); err != nil {
		logger.Fatal().Err(err).Msg("failed to boot plugins")
	}

	// Fiber HTTP server.
	app := fiber.New(fiber.Config{
		AppName: "Orchestra MCP",
	})

	// Collect plugin routes.
	api := app.Group("/api")
	pm.CollectRoutes(api)

	// Health check.
	app.Get("/health", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":  "ok",
			"plugins": len(pm.Active()),
		})
	})

	// Graceful shutdown.
	go func() {
		quit := make(chan os.Signal, 1)
		signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
		<-quit
		logger.Info().Msg("shutting down...")
		_ = pm.Shutdown()
		_ = app.Shutdown()
	}()

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	logger.Info().Str("port", port).Msg("server starting")
	if err := app.Listen(":" + port); err != nil {
		logger.Fatal().Err(err).Msg("server failed")
	}
}
