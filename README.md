IGraphR
=======

Call igraph with ease from Mathematica through RLink.

###Installation

Drop `IGraphR.m` in this directory:

    SystemOpen@FileNameJoin[{$UserBaseDirectory, "Applications"}]
    
###Loading

First, make sure that you are using an R installation that has the igraph package.  

**On Windows**, you can simply install it into Mathematica's internal R like this:

    REvaluate["install.packages('igraph')"]
    
**On OS X**, you'll need to use an external R installation.  First, [download and install R](http://cran.rstudio.com).  Start it up and install igraph using the R command `install.packages('igraph')`.  Then in Mathematica, do 

```
Needs["RLink`"]

SetEnvironment[
 "DYLD_LIBRARY_PATH" -> 
  "/Library/Frameworks/R.Framework/Resources/lib"];

InstallR["RHomeLocation" -> "/Library/Frameworks/R.Framework/Resources"];
```

Now you are ready to load ``IGraphR` ``:

    Needs["IGraphR`"]

###Examples

```
In[]:= IGraph["vertex.connectivity"][CycleGraph[5]]
Out[]= {2.}

In[]:= IGraph["barabasi.game"][10]
Out[]= --Graph--
```
