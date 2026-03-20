#!/usr/bin/env node
/**
 * @orchestra-mcp/cli — postinstall script
 *
 * Downloads the correct pre-built binary from GitHub Releases
 * based on the current platform and architecture.
 */
const { execSync } = require("child_process");
const fs = require("fs");
const https = require("https");
const path = require("path");
const os = require("os");
const { createGunzip } = require("zlib");

const REPO = "orchestra-mcp/framework";
const pkg = require("../package.json");
const VERSION = `v${pkg.version}`;

const PLATFORM_MAP = { darwin: "darwin", linux: "linux", win32: "windows" };
const ARCH_MAP = { x64: "amd64", arm64: "arm64" };

const platform = PLATFORM_MAP[os.platform()];
const arch = ARCH_MAP[os.arch()];

if (!platform || !arch) {
  console.error(
    `Unsupported platform: ${os.platform()}-${os.arch()}. ` +
      `Use the install script instead: curl -fsSL https://orchestra-mcp.dev/install.sh | sh`
  );
  process.exit(1);
}

const tarball = `orchestra-${platform}-${arch}.tar.gz`;
const url = `https://github.com/${REPO}/releases/download/${VERSION}/${tarball}`;
const binDir = path.join(__dirname, "..", "bin");
const ext = platform === "windows" ? ".exe" : "";

fs.mkdirSync(binDir, { recursive: true });

console.log(`Downloading Orchestra ${VERSION} for ${platform}-${arch}...`);

function download(url, redirects = 5) {
  return new Promise((resolve, reject) => {
    if (redirects <= 0) return reject(new Error("Too many redirects"));

    const proto = url.startsWith("https") ? https : require("http");
    proto
      .get(url, { headers: { "User-Agent": "orchestra-npm-install" } }, (res) => {
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
          return resolve(download(res.headers.location, redirects - 1));
        }
        if (res.statusCode !== 200) {
          return reject(new Error(`Download failed: HTTP ${res.statusCode} from ${url}`));
        }
        resolve(res);
      })
      .on("error", reject);
  });
}

async function main() {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "orchestra-"));
  const tmpTar = path.join(tmpDir, tarball);

  try {
    // Download
    const stream = await download(url);
    const file = fs.createWriteStream(tmpTar);
    await new Promise((resolve, reject) => {
      stream.pipe(file);
      file.on("finish", resolve);
      file.on("error", reject);
    });

    // Extract with tar (available on all platforms including Windows via Git Bash)
    execSync(`tar -xzf "${tmpTar}" -C "${binDir}"`, { stdio: "pipe" });

    // Make executable
    const orchestraBin = path.join(binDir, `orchestra${ext}`);
    if (fs.existsSync(orchestraBin)) {
      fs.chmodSync(orchestraBin, 0o755);
    }

    // Verify
    try {
      const version = execSync(`"${orchestraBin}" version`, {
        encoding: "utf8",
        timeout: 5000,
      }).trim();
      console.log(`Installed: ${version}`);
    } catch {
      console.log(`Installed orchestra to ${orchestraBin}`);
    }
  } finally {
    // Cleanup
    fs.rmSync(tmpDir, { recursive: true, force: true });
  }
}

main().catch((err) => {
  console.error(`Failed to install Orchestra: ${err.message}`);
  console.error(
    `You can install manually: curl -fsSL https://orchestra-mcp.dev/install.sh | sh`
  );
  // Don't fail npm install — the binary is optional for some use cases
  process.exit(0);
});
