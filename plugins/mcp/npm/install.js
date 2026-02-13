#!/usr/bin/env node
"use strict";

const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const https = require("https");
const { createGunzip } = require("zlib");
const tar = require("tar");

const REPO = "orchestra-mcp/mcp";
const BINARY = "orchestra-mcp";
const BIN_DIR = path.join(__dirname, "bin");

function getPlatform() {
  const platform = process.platform;
  const arch = process.arch;

  const osMap = { darwin: "darwin", linux: "linux", win32: "windows" };
  const archMap = { x64: "amd64", arm64: "arm64" };

  const os = osMap[platform];
  const cpu = archMap[arch];

  if (!os || !cpu) {
    throw new Error(`Unsupported platform: ${platform}/${arch}`);
  }

  return { os, arch: cpu };
}

function getVersion() {
  const pkg = require("./package.json");
  return pkg.version;
}

function download(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, (res) => {
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
          return download(res.headers.location).then(resolve, reject);
        }
        if (res.statusCode !== 200) {
          return reject(new Error(`Download failed: HTTP ${res.statusCode}`));
        }
        const chunks = [];
        res.on("data", (chunk) => chunks.push(chunk));
        res.on("end", () => resolve(Buffer.concat(chunks)));
        res.on("error", reject);
      })
      .on("error", reject);
  });
}

async function install() {
  const { os, arch } = getPlatform();
  const version = getVersion();

  const ext = os === "windows" ? "zip" : "tar.gz";
  const url = `https://github.com/${REPO}/releases/download/v${version}/${BINARY}_${os}_${arch}.${ext}`;

  console.log(`Downloading ${BINARY} v${version} for ${os}/${arch}...`);

  fs.mkdirSync(BIN_DIR, { recursive: true });

  const data = await download(url);

  if (ext === "tar.gz") {
    const tmpFile = path.join(BIN_DIR, "download.tar.gz");
    fs.writeFileSync(tmpFile, data);
    execSync(`tar -xzf "${tmpFile}" -C "${BIN_DIR}" ${BINARY}`, { stdio: "inherit" });
    fs.unlinkSync(tmpFile);
  } else {
    // For Windows zip, extract using PowerShell
    const tmpFile = path.join(BIN_DIR, "download.zip");
    fs.writeFileSync(tmpFile, data);
    execSync(
      `powershell -Command "Expand-Archive -Path '${tmpFile}' -DestinationPath '${BIN_DIR}' -Force"`,
      { stdio: "inherit" }
    );
    fs.unlinkSync(tmpFile);
  }

  const binaryPath = path.join(BIN_DIR, os === "windows" ? `${BINARY}.exe` : BINARY);
  if (!fs.existsSync(binaryPath)) {
    throw new Error(`Binary not found after extraction: ${binaryPath}`);
  }

  fs.chmodSync(binaryPath, 0o755);
  console.log(`Installed ${BINARY} v${version} to ${binaryPath}`);
}

install().catch((err) => {
  console.error(`Failed to install ${BINARY}: ${err.message}`);
  process.exit(1);
});
