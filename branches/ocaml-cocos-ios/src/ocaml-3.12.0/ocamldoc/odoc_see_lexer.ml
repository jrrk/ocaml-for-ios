# 1 "odoc_see_lexer.mll"
 
(***********************************************************************)
(*                             OCamldoc                                *)
(*                                                                     *)
(*            Maxence Guesdon, projet Cristal, INRIA Rocquencourt      *)
(*                                                                     *)
(*  Copyright 2001 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: odoc_see_lexer.mll 9547 2010-01-22 12:48:24Z doligez $ *)

let print_DEBUG2 s = print_string s ; print_newline ()

(** the lexer for special comments. *)

open Lexing
open Odoc_parser

let buf = Buffer.create 32


# 27 "odoc_see_lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base = 
   "\000\000\249\255\250\255\251\255\252\255\253\255\254\255\005\000\
    \001\000\002\000\255\255\004\000\255\255\006\000\003\000\255\255\
    \005\000\007\000\254\255\255\255";
  Lexing.lex_backtrk = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255";
  Lexing.lex_default = 
   "\001\000\000\000\000\000\000\000\000\000\000\000\000\000\255\255\
    \009\000\009\000\000\000\011\000\000\000\011\000\014\000\000\000\
    \014\000\018\000\000\000\000\000";
  Lexing.lex_trans = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\007\000\006\000\000\000\007\000\007\000\007\000\000\000\
    \000\000\007\000\007\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \007\000\000\000\004\000\000\000\000\000\007\000\012\000\003\000\
    \012\000\000\000\015\000\000\000\015\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\005\000\000\000\000\000\255\255\
    \010\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\016\000\
    \013\000\016\000\013\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\255\255\255\255\255\255\255\255\255\255\255\255\019\000\
    ";
  Lexing.lex_check = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\255\255\000\000\000\000\007\000\255\255\
    \255\255\007\000\007\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\000\000\255\255\255\255\007\000\011\000\000\000\
    \013\000\255\255\014\000\255\255\016\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\000\000\255\255\255\255\008\000\
    \009\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\014\000\
    \011\000\016\000\013\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\008\000\009\000\014\000\011\000\016\000\013\000\017\000\
    ";
  Lexing.lex_base_code = 
   "";
  Lexing.lex_backtrk_code = 
   "";
  Lexing.lex_default_code = 
   "";
  Lexing.lex_trans_code = 
   "";
  Lexing.lex_check_code = 
   "";
  Lexing.lex_code = 
   "";
}

let rec main lexbuf =
  __ocaml_lex_main_rec lexbuf 0
and __ocaml_lex_main_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 28 "odoc_see_lexer.mll"
  (
    print_DEBUG2 "[' ' '\013' '\009' '\012'] +";
    main lexbuf
  )
# 135 "odoc_see_lexer.ml"

  | 1 ->
# 34 "odoc_see_lexer.mll"
      (
        print_DEBUG2 " [ '\010' ] ";
        main lexbuf
      )
# 143 "odoc_see_lexer.ml"

  | 2 ->
# 40 "odoc_see_lexer.mll"
      (
        print_DEBUG2 "call url lexbuf" ;
        url lexbuf
      )
# 151 "odoc_see_lexer.ml"

  | 3 ->
# 46 "odoc_see_lexer.mll"
      (
        print_DEBUG2 "call doc lexbuf" ;
        doc lexbuf
      )
# 159 "odoc_see_lexer.ml"

  | 4 ->
# 53 "odoc_see_lexer.mll"
      (
        print_DEBUG2 "call file lexbuf" ;
        file lexbuf
      )
# 167 "odoc_see_lexer.ml"

  | 5 ->
# 59 "odoc_see_lexer.mll"
      (
        print_DEBUG2 "EOF";
        EOF
      )
# 175 "odoc_see_lexer.ml"

  | 6 ->
# 65 "odoc_see_lexer.mll"
      (
        Buffer.reset buf ;
        Buffer.add_string buf (Lexing.lexeme lexbuf);
        desc lexbuf
      )
# 184 "odoc_see_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_main_rec lexbuf __ocaml_lex_state

and url lexbuf =
  __ocaml_lex_url_rec lexbuf 8
and __ocaml_lex_url_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 73 "odoc_see_lexer.mll"
      (
        let s = Lexing.lexeme lexbuf in
        print_DEBUG2 ("([^'>'] | '\n')+ \">\" with "^s) ;
        See_url (String.sub s 0 ((String.length s) -1))
      )
# 199 "odoc_see_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_url_rec lexbuf __ocaml_lex_state

and doc lexbuf =
  __ocaml_lex_doc_rec lexbuf 11
and __ocaml_lex_doc_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 82 "odoc_see_lexer.mll"
      (
        let s = Lexing.lexeme lexbuf in
        See_doc (String.sub s 0 ((String.length s) -1))
      )
# 213 "odoc_see_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_doc_rec lexbuf __ocaml_lex_state

and file lexbuf =
  __ocaml_lex_file_rec lexbuf 14
and __ocaml_lex_file_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 89 "odoc_see_lexer.mll"
      (
        let s = Lexing.lexeme lexbuf in
        See_file (String.sub s 0 ((String.length s) -1))
      )
# 227 "odoc_see_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_file_rec lexbuf __ocaml_lex_state

and desc lexbuf =
  __ocaml_lex_desc_rec lexbuf 17
and __ocaml_lex_desc_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 97 "odoc_see_lexer.mll"
      ( Desc (Buffer.contents buf) )
# 238 "odoc_see_lexer.ml"

  | 1 ->
# 99 "odoc_see_lexer.mll"
      (
        Buffer.add_string buf (Lexing.lexeme lexbuf);
        desc lexbuf
      )
# 246 "odoc_see_lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_desc_rec lexbuf __ocaml_lex_state

;;

