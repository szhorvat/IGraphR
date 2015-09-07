IGraphR
=======

Call [igraph](http://igraph.org/) with ease from Mathematica through [RLink](http://reference.wolfram.com/mathematica/RLink/guide/RLink.html).  RLink is available in Mathematica 9 or later.

See a short IGraphR tutorial [here](http://www3.nd.edu/~szhorvat/pelican/using-igraph-from-mathematica.html).

### Installation

**Easy automatic install:**

Just evaluate `Get["https://raw.githubusercontent.com/szhorvat/IGraphR/master/install.m"]`.  It will install into `$UserBaseDirectory` and overwrite any old versions there.

**Manual installation:**

[Download `IGraphR.m`](https://raw.githubusercontent.com/szhorvat/IGraphR/master/IGraphR.m) and drop it into the directory opened by this command:

    SystemOpen@FileNameJoin[{$UserBaseDirectory, "Applications"}]
    
### Loading

First, make sure that you are using an R installation that has the igraph package.  

**On Windows**, you can simply install it into Mathematica's internal R like this:

    REvaluate["install.packages('igraph')"]
    
**On OS X** and **Linux** it is necessary to use an external R installation.  See [this guide](http://www.nd.edu/~szhorvat/pelican/setting-up-rlink-for-mathematica.html) on how to do that.  Run the R version you are using outside of Mathematica and run `install.packages('igraph')` to install the igraph package into it.

Now you are ready to load ``IGraphR` `` in Mathematica:

    Needs["IGraphR`"]

### Examples

```
In[]:= IGraph["vertex.connectivity"][CycleGraph[5]]
Out[]= {2.}

In[]:= IGraph["barabasi.game"][10]
Out[]= --Graph--

In[]:= IGraph["plot"][Graph[{a <-> b, b <-> c}]]
```

### Limitations

Mathematica 10 supports mixed graphs which have both directed and undirected edges.  These are not supported by igraph or IGraphR.

### Support

If you encounter any problems with IGraphR, send a mail to `szhorvat` at `gmail.com`.

### Related software

[IGraph/M](https://github.com/szhorvat/IGraphM) is a more advanced but less complete Mathematica interface to igraph.  I recommend using [IGraph/M](https://github.com/szhorvat/IGraphM) when it has the functions you need.

### Licensing

This package is provided under the [MIT license](http://opensource.org/licenses/mit-license.html).  See `LICENSE.txt` for details.
