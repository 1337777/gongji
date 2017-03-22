(**#+TITLE: gongji.ml4

老子

https://github.com/1337777/gongji/blob/master/gongji.ml4

这 解决 《Coppel [fn:2]》的 一些 问题 ： 如何 编程 数学 入 计算机的 《公鸡》。

我 正在访着 复旦大学的《 IAS 》《 http://www.connes70.fudan.edu.cn/ 》, 从 3 月 23 日 到 4 月 7 日 : 有没有 一个人 能完成 这个 翻译 为 一个 真正的 非伪造 市场 吗？ 有没有 一个人 可以 澄清 之意义《 不再 几何的 证明 在几何 》对 计算机的 《 公鸡 》 吗？

例 :《
Add ML Path "./".
Declare ML Module "gongji".
Tactic Notation "同一" := reflexivity.

定义 d1 : nat := 5.

定义 三 : nat := 3.

引理 l1 : ( 若 true 回 nat 则 2 旁 1337 ) + 三 = d1.
  同一.
完毕.
 》

[fn:2] ~Coppel~ «A Chinese-English mathematics primer» [[http://catalogue.nla.gov.au/Record/1337321]]

**)

(**

# for install :
opam install coq.dev || sudo apt-get install libcoq-ocaml-dev ;
coq_makefile gongji.ml4 > Makefile ;
make # ./gongji.cmxs 

;; for emacs input method : 
select C-x RET C-\  chinese-py-punct
toggle C-\ 

example gongji.v :

Add ML Path "./".
Declare ML Module "gongji".

Print Grammar constr.

Tactic Notation "同一" := reflexivity.

定义 d1 : nat := 5.

定义 三 : nat := 3.

引理 l1 : ( 若 true 回 nat 则 2 旁 1337 ) + 三 = d1.
  同一.
完毕.

**)

DECLARE PLUGIN "gongji"

open Pp
open Compat
open CErrors
open Util
open Names
open Constrexpr
open Constrexpr_ops
open Extend
open Vernacexpr
open Decl_kinds
open Misctypes
open Tok (* necessary for camlp4 *)

open Pcoq
open Pcoq.Prim
open Pcoq.Constr
open Pcoq.Vernac_
open Pcoq.Module

open G_vernac
open G_proofs
open G_constr

let constr_kw = "若" :: "则" :: "旁" :: "回" :: "如" :: constr_kw

GEXTEND Gram 
  GLOBAL: gallina thm_token command binder_constr;
  
  gallina:
    [ [ d = def_token; id = pidentref; b = def_body ->
          VernacDefinition (d, id, b) ] ]
  ;

  def_token:
  [ [ IDENT "定义" -> (None, Definition) ] ]
  ;

  thm_token:
    [ [ IDENT "引理" -> Theorem ] ]
  ;

  command:
    [ [ IDENT "完毕" -> VernacEndProof (Proved (Opaque None,None)) ] ]
  ;

  binder_constr:
    [ [ "若"; c=operconstr LEVEL "200"; po = return_type;
	"则"; b1=operconstr LEVEL "200";
        "旁"; b2=operconstr LEVEL "200" ->
                   CIf (!@loc, c, po, b1, b2) ] ]
  ;

  case_type:
    [ [ "回"; ty = operconstr LEVEL "100" -> ty ] ]
  ;

  return_type:
    [ [ a = OPT [ na = OPT["如"; na=name -> na];
                  ty = case_type -> (na,ty) ] ->
        match a with
          | None -> None, None
          | Some (na,t) -> (na, Some t)
    ] ]
  ;

END;;
