# Platformer

A 2D side-scrolling platformer built with Lua and LOVE2D.

## Controls

| Key | Action |
|-----|--------|
| A / Left | Move left |
| D / Right | Move right |
| Space | Jump |
| Return | Shoot |
| Left Shift | Sprint |
| Escape | Pause |

## Map System

Maps live under `src/maps/<name>/` with tile-based collision:
- Pixel color 0 = walkable
- Pixel color 1 = solid wall
- Pixel color 3 = death zone
- Pixel color 5 = grapple point

## Getting Started

```bash
npm run setup      # install npm deps + download LOVE 11.5
npm start          # launch the game
```

### Web build

```bash
npm run build      # pack src/ into .love, compile to Web/ via love.js
npm run serve      # serve Web/ at http://localhost:8080
```
