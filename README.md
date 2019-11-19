# fragments

This is a sort of re-implementation of fluid-fun.

Things to do:

1. Create a grid
1. Particle collision
1. Particle response on collision


Emitter:
- Emits particles on mousedowns.
- Right click drop a particle factory

Particle has properties such as:
- Lifetime
- Spread in directions?
- Element type

Element has properties:
- Affected by gravity (i.e. gas, liquids, solids)?
- Color
- Interaction with other elements. E.g. fire -> water? Water -> fire? Plant -> fire.
  Or for instance gas + gas = other element ?
