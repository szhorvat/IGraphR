IGraphR
=======

Call [igraph](http://igraph.org/) with ease from Mathematica through [RLink](http://reference.wolfram.com/mathematica/RLink/guide/RLink.html).  RLink is available in Mathematica 9 or later.

See a short IGraphR tutorial [here](http://www3.nd.edu/~szhorvat/pelican/using-igraph-from-mathematica.html).

###Installation

Drop `IGraphR.m` into the directory opened by this command:

    SystemOpen@FileNameJoin[{$UserBaseDirectory, "Applications"}]
    
###Loading

First, make sure that you are using an R installation that has the igraph package.  

**On Windows**, you can simply install it into Mathematica's internal R like this:

    REvaluate["install.packages('igraph')"]
    
**On OS X**, you'll need to use an external R installation.  First, [download and install the official R distribution](http://www.r-project.org/) (other distributions may or may not work with RLink).  Start it up and install igraph using the R command `install.packages('igraph')`.  Then in Mathematica load RLink and connect to the external R version *before* you load ``IGraphR` ``:

```
Needs["RLink`"]

SetEnvironment[
 "DYLD_LIBRARY_PATH" -> 
  "/Library/Frameworks/R.framework/Resources/lib"];
```

For Mathematica 9.0.1 and 10.0.0, use

```
InstallR["RHomeLocation" -> "/Library/Frameworks/R.framework/Resources"];
```

For Mathematica 10.0.1, it is also necessary to specify the R version, e.g.:

```
InstallR["RHomeLocation" -> "/Library/Frameworks/R.framework/Resources", "RVersion" -> "3.1"];
```

Verify that the expected version of R is being used with

```
REvaluate["R.version.string"]
```

(more information [here](http://mathematica.stackexchange.com/a/43732/12))

Now you are ready to load ``IGraphR` ``:

    Needs["IGraphR`"]

###Examples

```
In[]:= IGraph["vertex.connectivity"][CycleGraph[5]]
Out[]= {2.}

In[]:= IGraph["barabasi.game"][10]
Out[]= --Graph--
```

###Known issues

Only graphs whose vertices are named as 1, 2, 3, … are supported.

###Licensing

This package is provided under the [MIT license](http://opensource.org/licenses/mit-license.html).  See `LICENSE.txt` for details.
