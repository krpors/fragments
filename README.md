# fragments

This is a sort of re-implementation of fluid-fun.

Things to do:

1. Create a grid
1. Particle collision
1. Particle response on collision

# Broad phase collision detection

Use a spatial grid. This need to be configurable (i.e. grow, shrink) to check
the optimal configuration and to play with.

An emitter creates particle instances and will add them to the array of
particles. Therefore each emitter maintains the particles.

After each particle updates its position, determine the Grid position

window width: 800
grid size: 10

800 / 10 = 80
