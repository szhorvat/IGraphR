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
		With[{d=DirectedGraphQ[g]},
			RObject[List@@@EdgeList[g],
				RAttributes["mmaDirectedGraph" :> {d}]]
		],
	o_RObject /; (RExtractAttribute[o, "mmaDirectedGraph"] =!= $Failed),
	o:RObject[data_, _RAttributes] /; (RExtractAttribute[o, "mmaDirectedGraph"] =!= $Failed) :>
		If[First@RExtractAttribute[o, "mmaDirectedGraph"],
			Graph[DirectedEdge @@@ data],
			Graph[UndirectedEdge @@@ data]]
]

iIGraph = 
	RFunction["function (fun, args) {
	  res <- do.call(fun,
	          lapply(
	            args,
	            function (x)
	              if (is.null(attr(x, 'mmaDirectedGraph', exact=T))) x
	              else graph.edgelist(x, directed=attr(x, 'mmaDirectedGraph'))
	          )
	  )
	  if (is.igraph(res)) {
	    el <- get.edgelist(res)
	    attr(el, 'mmaDirectedGraph') <- is.directed(res)
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
