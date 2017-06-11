#!/usr/bin/env python


import sys
import os
import re
import glob

seqFiles = glob.glob(sys.argv[1] + '/[0-9]*_TRUE.phy')
length = int(sys.argv[2])
outdir = sys.argv[3]
if not os.path.exists(outdir):
    os.makedirs(outdir)



for seqFile in seqFiles:
	f = open(seqFile,'r')

	allLines = f.readlines()

	f.close()
	b = os.path.basename(seqFile)
	header = allLines[0].strip('\n').strip().split()
	
	b = b.replace("_", "_" + str(length) + "_")
	g = open( outdir + '/' + b ,'w')
	print >> g, header[0] + "  " + str(length)
		
	for line in allLines[1:]:
		if line.strip().strip('\n'):
			h = re.sub(' +',' ',line.strip('\n').strip()).split(' ')
			print >> g, h[0] + "  " + h[1][0:length]
	g.close()
	
	


