(* ::Package:: *)

(* :Title:   IGraphR          *)
(* :Context: IGraphR`         *)
(* :Author:  Szabolcs Horvát  *)

(* :Package Version:     0.3.1 *)
(* :Mathematica Version: 9.0   *)

BeginPackage["IGraphR`", {"RLink`"}]

IGraph::usage = "IGraph[\"fun\"] is a callable object representing an igraph function.  Graph objects in arguments are automatically converted."

`Information`$Version = "0.3.1"

Begin["`Private`"]

IGraph::igraph = "igraph is not available.  Make sure you are using an R installation that has the igraph package installed."
IGraph::mixed = "Mixed graphs are not supported."

packageAbort[] := (End[]; EndPackage[]; Abort[])

Check[
  InstallR[];
  REvaluate["library(igraph)"]
  ,
  Message[IGraph::igraph];
  packageAbort[]
]


weightedGraphQ = WeightedGraphQ[#] && PropertyValue[#, EdgeList] =!= Automatic &;


RDataTypeRegister["IGraphEdgeList",
  g_?GraphQ,
  g_?GraphQ :>
    If[TrueQ@MixedGraphQ[g] (* TrueQ is to keep this v9-compatible; note v9 doesn't have MixedGraphQ defined *)
      ,
      Message[IGraph::mixed]; $Failed
      ,
      With[{
        d = DirectedGraphQ[g],
        vc = VertexCount[g],
        names = ToString /@ VertexList[g],
        weights = If[weightedGraphQ[g], N@PropertyValue[g, EdgeWeight], Null]}
        ,
        RObject[
          Replace[ List@@Join@@EdgeList[g], Dispatch@Thread[VertexList[g] -> Range[vc]], {1} ],
          RAttributes["mmaDirectedGraph" :> {d}, "mmaVertexCount" :> {vc}, "mmaVertexNames" :> names, "mmaEdgeWeights" :> weights]
        ]
      ]
    ],
  o_RObject /; (RLink`RDataTypeTools`RExtractAttribute[o, "mmaDirectedGraph"] =!= $Failed),
  o:RObject[data_, _RAttributes] /; (RLink`RDataTypeTools`RExtractAttribute[o, "mmaDirectedGraph"] =!= $Failed) :>
    Module[{vertices, edges, names, weights},
      names = RLink`RDataTypeTools`RExtractAttribute[o, "mmaVertexNames"];
      If[names === $Failed,
        vertices = Range@First@RLink`RDataTypeTools`RExtractAttribute[o, "mmaVertexCount"];
        edges = Partition[data, 2]
        ,
        vertices = names;
        edges = Partition[names[[data]], 2];
      ];

      edges = If[First@RLink`RDataTypeTools`RExtractAttribute[o, "mmaDirectedGraph"], DirectedEdge, UndirectedEdge] @@@ edges;
      weights = RLink`RDataTypeTools`RExtractAttribute[o, "mmaEdgeWeights"];
      If[weights === $Failed,
        Graph[vertices, edges],
        Graph[vertices, edges, EdgeWeight -> weights]
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
                else {
                  g <- graph(x, n=attr(x, 'mmaVertexCount'), directed=attr(x, 'mmaDirectedGraph'))
                  V(g)$name <- attr(x, 'mmaVertexNames')
                  if (!is.null(attr(x, 'mmaEdgeWeights', exact=T))) E(g)$weight <- attr(x, 'mmaEdgeWeights')
                  g
                }
            )
    )
    if (is.igraph(res)) {
      el <- as.integer(t(get.edgelist(res, names=F)))
      attr(el, 'mmaDirectedGraph') <- is.directed(res)
      attr(el, 'mmaVertexCount') <- vcount(res)
      attr(el, 'mmaVertexNames') <- get.vertex.attribute(res, 'name')
      attr(el, 'mmaEdgeWeights') <- get.edge.attribute(res, 'weight')
      el
    }
    else res
  }"];

IGraph[fun_String][args___] :=
    Module[{rargs},
      rargs = Check[ToRForm /@ {args}, $Failed];
      If[rargs =!= $Failed,
        iIGraph[RFunction[fun],
            ToRForm[rargs]
        ],
        $Failed
      ]
    ]


End[] (* `Private` *)

EndPackage[] (* IGraphR` *)
