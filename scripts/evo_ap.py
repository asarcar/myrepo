#!/usr/bin/python

import re,string, os, sys
from os.path import *
from subprocess import *
import sys, argparse

global CurrDir
global FailedRepos

CurrDir=os.getcwd()
FailedRepos=[]


class PatchFailed(Exception):
    def __init__(self, fname, out, err, patch):
        self.dirs = fname
        self.err = err
        self.out = out
        self.patch = patch

    def __str__(self):
        return self.dirs+"\n"+"\n"+str(self.out)+"Error:"+str(self.err)+"\n\n"


class GetPatchesByDirs:
    def parseDiffFile(self, fname):
        a=re.compile(r'^project', re.M)

        f=open(fname, "r").read()
        pfiles=a.split(f)
        for p in pfiles:
            if (p.strip()):
                l=p.split("\n")
                dir=l[0].strip()
                print "Found dir="+dir
                patch=string.join(l[1:], "\n")
                self.patches[dir]=patch
        
    def __init__(self, filename):
        self.patchfile = filename
        self.patches = dict()
        self.parseDiffFile(filename)

    def applyPatch(self, cmd):
        patches = self.patches
        for dirs in patches.keys():
           os.chdir(dirs)
           print "Working on directory "+dirs+" in "+os.getcwd()

           m=Popen(cmd, stdin=PIPE, stdout=PIPE)
           (out,err) = m.communicate(patches[dirs])
           try:
            if (m.returncode > 0):
                FailedRepos.append(dirs)
                raise PatchFailed(dirs, out, err, patches[dirs])
           except PatchFailed as pf:
               print "Patch failed for ", pf

           os.chdir(CurrDir)

    def applyDiffPatch(self):
           cmd=["patch", "-p1"]
           cmd=["git", "apply"] # "--stat", "--check", "--apply"]
           self.applyPatch(cmd) 

    def applyGitFormatPatch(self):
            cmd = ["git", "am", "-3"]
            self.applyPatch(cmd)


ap = argparse.ArgumentParser(description='Patch an evo repository with diffs')
ap.add_argument("--am", action='store_true', help="Use git am instead of patch for patches generated with 'git format-patch'", default=False, dest='am')
ap.add_argument("filename", action='store', help="Use git am instead of patch")

args=ap.parse_args()

p = GetPatchesByDirs(args.filename)

try:
    if (args.am):
        p.applyGitFormatPatch()
    else:
        p.applyDiffPatch()
    print "Done with patching"
    print "Failed Repos = "+ str(FailedRepos)
except PatchFailed as pf:
    print "Patch failed for ", pf
