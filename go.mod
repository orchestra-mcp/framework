module github.com/orchestra-mcp/framework

go 1.24.4

require (
	github.com/gofiber/fiber/v3 v3.0.0-beta.4
	github.com/orchestra-mcp/ai v0.0.0
	github.com/orchestra-mcp/browser v0.0.0
	github.com/orchestra-mcp/discord v0.0.0
	github.com/orchestra-mcp/http v0.0.0
	github.com/orchestra-mcp/markdown v0.0.0
	github.com/orchestra-mcp/mcp v0.0.0
	github.com/orchestra-mcp/notifications v0.0.0
	github.com/orchestra-mcp/panels v0.0.0
	github.com/orchestra-mcp/search v0.0.0
	github.com/orchestra-mcp/settings v0.0.0
	github.com/orchestra-mcp/socket v0.0.0
	github.com/orchestra-mcp/themes v0.0.0
	github.com/orchestra-mcp/tray v0.0.0
	github.com/orchestra-mcp/widgets v0.0.0
	github.com/rs/zerolog v1.33.0
	github.com/stretchr/testify v1.11.1
)

replace github.com/orchestra-mcp/mcp => ./plugins/mcp

replace github.com/orchestra-mcp/discord => ./plugins/discord

replace github.com/orchestra-mcp/http => ./plugins/http

replace github.com/orchestra-mcp/notifications => ./plugins/notifications

replace github.com/orchestra-mcp/themes => ./plugins/themes

replace github.com/orchestra-mcp/settings => ./plugins/settings

replace github.com/orchestra-mcp/search => ./plugins/search

replace github.com/orchestra-mcp/socket => ./plugins/socket

replace github.com/orchestra-mcp/ai => ./plugins/ai

replace github.com/orchestra-mcp/browser => ./plugins/browser

replace github.com/orchestra-mcp/markdown => ./plugins/markdown

replace github.com/orchestra-mcp/panels => ./plugins/panels

replace github.com/orchestra-mcp/tray => ./plugins/tray

replace github.com/orchestra-mcp/widgets => ./plugins/widgets

require (
	github.com/alecthomas/chroma/v2 v2.2.0 // indirect
	github.com/andybalholm/brotli v1.1.1 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/dlclark/regexp2 v1.10.0 // indirect
	github.com/fasthttp/websocket v1.5.12 // indirect
	github.com/fxamacker/cbor/v2 v2.7.0 // indirect
	github.com/gofiber/schema v1.2.0 // indirect
	github.com/gofiber/utils/v2 v2.0.0-beta.7 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/gorilla/websocket v1.5.3 // indirect
	github.com/joho/godotenv v1.5.1 // indirect
	github.com/klauspost/compress v1.18.0 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/philhofer/fwd v1.1.3-0.20240916144458-20a13a1f6b7c // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/redis/go-redis/v9 v9.17.3 // indirect
	github.com/savsgio/gotils v0.0.0-20240704082632-aef3928b8a38 // indirect
	github.com/tinylib/msgp v1.2.5 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasthttp v1.58.0 // indirect
	github.com/valyala/tcplisten v1.0.0 // indirect
	github.com/x448/float16 v0.8.4 // indirect
	github.com/yuin/goldmark v1.7.8 // indirect
	github.com/yuin/goldmark-highlighting/v2 v2.0.0-20230729083705-37449abec8cc // indirect
	golang.org/x/crypto v0.46.0 // indirect
	golang.org/x/net v0.48.0 // indirect
	golang.org/x/sys v0.39.0 // indirect
	golang.org/x/text v0.32.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20251202230838-ff82c1b0f217 // indirect
	google.golang.org/grpc v1.79.1 // indirect
	google.golang.org/protobuf v1.36.11 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)
