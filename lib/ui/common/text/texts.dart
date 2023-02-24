class Texts {
  static const algorithms = '''

Explore Dijsktra's and A* shortest path-finding algorithms. They are used - or serves as a basis - in areas such as telecommunications, maze-solving, and navigation systems.

Visualize Breadth-first search (BFS)  & Depth-first search (DFS). These algorithm are used for traversing or searching tree or graph data structures.

Drunk - How a drunk person would look for the shortest path, no real use here, just for fun :D

''';

  static const dijsktraExplenation = '''

- Guarantees the shortest path
- Has NO sense of direction to where the end node is.

The algorithm serves as a basis in areas such as telecommunications, maze-solving, and navigation systems.

''';

  static const aStarExplenation = '''

- Guarantees the shortest path
- Propritizes nodes closest to the end node

This additional condition makes A* algorithm much more effective.
''';

  static const breadthFirstExplenation = '''

BFS starts at the tree root and explores all nodes at the present depth prior to moving on to the nodes at the next depth level.

It can be used to find the shortest path between two vertices in an unweighted graph. So, changing the costs won't have effect on this algorithm :)
''';

  static const depthFirstExplenation = '''

DFS starts at the root node and explores as far as possible along each branch before backtracking.

Like BFS, DFS is unweighted. So, changing the costs won't have effect on this algorithm :)
''';
}
