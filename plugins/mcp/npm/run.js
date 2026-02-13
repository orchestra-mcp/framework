#!/usr/bin/env node
"use strict";

const { execFileSync } = require("child_process");
const path = require("path");

const BINARY = "orchestra-mcp";
const ext = process.platform === "win32" ? ".exe" : "";
const binaryPath = path.join(__dirname, "bin", BINARY + ext);

try {
  execFileSync(binaryPath, process.argv.slice(2), { stdio: "inherit" });
} catch (err) {
  if (err.status !== undefined) {
    process.exit(err.status);
  }
  console.error(`Failed to run ${BINARY}: ${err.message}`);
  process.exit(1);
}
