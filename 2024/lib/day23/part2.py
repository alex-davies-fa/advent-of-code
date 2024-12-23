import networkx as nx

file = "./input.test"
f = open(file, "r")

G = nx.Graph()
for l in f.readlines():
  G.add_edge(*l.strip().split("-"))

max_clique = max(nx.find_cliques(G), key=len)
print(','.join(sorted(max_clique)))
