(* Mathematica source file  *)
(* Created by IntelliJ IDEA *)
(* :Author: szhorvat *)
(* :Date: 2014-11-6 *)

Module[{source},
  source = Check[
    Import["https://raw.githubusercontent.com/szhorvat/IGraphR/master/IGraphR.m", "Text", CharacterEncoding -> "UTF-8"],
    $Failed
  ];
  If[source =!= $Failed,
    Export[FileNameJoin[{$UserBaseDirectory, "Applications", "IGraphR.m"}], source, "Text"],
    Print["Failed to download IGraphR"]
  ]
]