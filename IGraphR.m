(* ::Package:: *)

BeginPackage["IGraphR`", {"RLink`"}]

IGraph::usage = "IGraph[\"fun\"] is a callable object representing an igraph function.  Graph objects in arguments are automatically converted.  Examples: IGraph[\"\"][CycleGraph[5]]"
IGraph::igraph = "igraph is not available.  Make sure you are using an R installation that has the igraph package installed"

Begin["`Private`"]


Check[
  InstallR[];
  REvaluate["library(igraph)"]
  ,
  Message[IGraph::igraph];
  Abort[]
]

RDataTypeRegister["IGraphEdgeList",
  _?GraphQ,
  g_?GraphQ :>
    With[{d=DirectedGraphQ[g], vc=VertexCount[g]},
      RObject[
        Replace[ List@@Join@@EdgeList[g], Dispatch@Thread[VertexList[g] -> Range[vc]], {1} ],
        RAttributes["mmaDirectedGraph" :> {d}, "mmaVertexCount" :> {vc}]]
    ],
  o_RObject /; (RLink`RDataTypeTools`RExtractAttribute[o, "mmaDirectedGraph"] =!= $Failed),
  o:RObject[data_, _RAttributes] /; (RLink`RDataTypeTools`RExtractAttribute[o, "mmaDirectedGraph"] =!= $Failed) :>
    With[
      {vertices = Range@First@RLink`RDataTypeTools`RExtractAttribute[o, "mmaVertexCount"],
       edges = Partition[data, 2]}
      ,
      If[First@RLink`RDataTypeTools`RExtractAttribute[o, "mmaDirectedGraph"],
        Graph[vertices, DirectedEdge @@@ edges],
        Graph[vertices, UndirectedEdge @@@ edges]
      ]
    ]
]

iIGraph = 
  RFunction["function (fun, args) {
    res <- do.call(fun,
            lapply(
              args,
              function (x)
                if (is.null(attr(x, 'mmaDirectedGraph', exact=T))) x
                else graph(x, n=attr(x, 'mmaVertexCount'), directed=attr(x, 'mmaDirectedGraph'))
            )
    )
    if (is.igraph(res)) {
      el <- as.integer(get.edgelist(res, names=F))
      attr(el, 'mmaDirectedGraph') <- is.directed(res)
      attr(el, 'mmaVertexCount') <- vcount(res)
      el
    }
    else res
  }"];

IGraph[fun_String][args___] :=
    iIGraph[RFunction[fun],
        ToRForm[ToRForm /@ {args}]
    ]


End[] (* `Private` *)

EndPackage[] (* IGraphR` *)
