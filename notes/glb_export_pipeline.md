# GLB export pipeline for `<model-viewer>`

Working notes for exporting GLB / GLTF 3D models from `dcl-core`'s
visualization utilities (or sibling tooling) so they can be served
by the site's `<model-viewer>` components.

## Goal

A repeatable pipeline that takes a scene defined in `dcl-core` (or a
notebook that uses it) and produces:

1. A `<name>.glb` file (binary glTF, single-file model) suitable
   for inclusion in `artifacts/`.
2. A `<name>-poster.png` (or `.jpg`) — a fallback still rendered
   at the same camera angle used by the model viewer's default
   view, for clients that cannot run WebGL.

## Current state

- **Not yet implemented.** `dcl-core` currently produces matplotlib
  visualizations; no GLB / GLTF export path exists.
- **Likely candidates** for the export step:
  - `plotly` (has a `write_image` for poster and could be wrapped
    with a custom GLB writer).
  - `trimesh` (Python; `Scene.export(file_type='glb')` is one
    line; easiest path if the lattice can be expressed as `trimesh`
    primitives).
  - `pythreejs` + a separate GLTF write (heavier).
- **Recommended starting point:** write a small `dcl_core.viz3d.glb`
  module that constructs the lattice unit cell as `trimesh`
  spheres + cylinders (nodes + edges) and exports the scene as a
  single GLB.

## Open questions

- **Coordinate convention.** `<model-viewer>` uses a Y-up,
  right-handed coordinate system. The `dcl_core.core3d` lattice
  uses... (confirm). If conventions differ, the exporter must
  apply the conversion before writing.
- **Materials.** Default `trimesh` materials are flat; the lattice
  visualizations may benefit from PBR materials authored in the
  glTF (metallic-roughness). Decide at first export whether to
  ship flat materials and revisit, or author PBR up front.
- **Bipartite coloring.** The two sub-lattices need visually
  distinct treatments. Either two `trimesh.Scene` nodes with
  different vertex colors, or two materials at the glTF level.

## Acceptance criteria for the first export

- [ ] `artifacts/lattice-unit-cell.glb` exists and renders in
      Chrome, Firefox, and Safari via the `<model-viewer>` element.
- [ ] Poster image `artifacts/lattice-unit-cell-poster.png` exists
      and matches the model's default camera angle.
- [ ] File size of the GLB is under 5 MB (mobile-friendly).
- [ ] The two sub-lattices are visually distinguishable (bipartite
      structure is the first thing a viewer needs to read off).
