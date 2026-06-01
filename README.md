# legacy-lua-platformer
##### _Platformer_

![logo](assets/logo.png)

## About
**Platformer** is a 2D side-scrolling platformer built with Lua and [LOVE2D](https://love2d.org), originally written around 2011. Jump, shoot, and grapple your way through tile-based maps.

## Features
- Side-scrolling movement with jump and grapple mechanics
- Tile-based collision via pixel-color map layers
- Projectile shooting in facing direction
- Enemy spawning and combat
- Camera tracking through large scrolling maps
- Sprint modifier
- Web build via love.js (WASM)

### Links
<p align="center">
    <a href="https://andrewiankidd.github.io/legacy-lua-platformer/">
        <img src="https://img.shields.io/badge/%F0%9F%8E%AE%20Platformer-darkgreen.svg" height="50" target="_blank" />
    </a>
    <br>
    <strong>Play:</strong>
    <br>
    <a href="https://andrewiankidd.github.io/legacy-lua-platformer/Web/index.html">
        <img src="https://img.shields.io/badge/%f0%9f%8c%90%20Browser-darkgreen.svg" />
    </a>
    <a href="https://github.com/andrewiankidd/legacy-lua-platformer/releases/download/latest-main/Platformer-love.zip">
        <img src="https://img.shields.io/badge/.love%20File-darkgreen.svg" />
    </a>
    <br>
    <strong>Source Code:</strong>
    <br>
    <a href="https://github.com/andrewiankidd/legacy-lua-platformer">
        <img src="https://img.shields.io/badge/GitHub-darkgreen.svg?logo=gitHub" />
    </a>
    <br>
    <a href="https://github.com/andrewiankidd/legacy-lua-platformer/actions/workflows/publish.yml">
        <img src="https://github.com/andrewiankidd/legacy-lua-platformer/actions/workflows/publish.yml/badge.svg" />
    </a>
</p>

## Video

Click to play

[![screenshot](assets/screenshot.png)](https://youtu.be/SyZG4rahW-4)

## Running locally

    npm run setup      # install npm deps + download LOVE 11.5
    npm start          # launch the game

### Web build

    npm run build      # pack src/ into .love, compile to Web/ via love.js
    npm run serve      # serve Web/ at http://localhost:8080

## Documentation

See the [docs](docs/index.md) for game systems and controls.

## License

MIT License. See `LICENSE` file for details.
