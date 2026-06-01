# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- CI/CD pipeline with rolling `latest-main` releases and GitHub Pages deploy
- Project website with play-in-browser, download links, and feature list
- Documentation (`docs/`) covering controls, map system, and collision
- `npm run setup` bootstraps a dev machine (installs deps + downloads LOVE 11.5)
- `npm start` launches the game using the locally-installed LOVE binary
- love.js web build (WASM) — play in the browser
- Shared module submodule (`src/lib/`) for input, animation, camera, collision, config, storage, settings

### Changed
- Game source moved from `game/` to `src/`
- Animation library switched from AnAL.lua to shared `lib/animation.lua` via compat shim
- Configuration uses shared `lib/conf.lua` with persistent settings support
- README modernized with logo, badges, and standard layout

### Removed
- Committed binaries (love.exe, DLLs, lovedist.exe)
- Legacy build scripts (`_compile.bat`, `_start.bat`)

## 2011 — Original Release

### Added
- 2D side-scrolling platformer with jump, shoot, and grapple mechanics
- Tile-based collision via pixel-color map layers
- Camera tracking through large scrolling maps
- Sprint modifier
