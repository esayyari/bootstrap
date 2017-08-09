#!/usr/bin/env python


import dendropy
import sys
import os


treeFile = sys.argv[1]

trees = dendropy.TreeList.get(path=treeFile, schema="newick", preserve_underscores=True)
for tree in trees:
	for nd in tree.postorder_internal_node_iter():
		print len(nd.adjacent_nodes())
	
