# Introduction #

If you came here because you installed OCAML for the iPad, take a moment to learn
about the benefits of functional programming

This application was recently approved at the Apple Store. The link to the executable is below. In due course I hope to upgrade to a Universal App.

http://itunes.apple.com/app/ocamlexample/id396515573?mt=8#

This language uses a lot of strange punctuation, although available on the built-in touch pad there may be three or four keypresses per character in some cases. An external wireless or wired keyboard is recommended. The wireless keyboard can be shared with a mac as well.

# Welcome Screen #

The welcome screen it has to be said is a bit plain by iPad standards, fortunately you can change it to whatever you want using the document download/upload feature of iTunes.

Should you wish to show the default screen again after it has cleared, just use

welcome 20;;

where 20 is a number representing the time delay for display

Here we look at the contents of the welcome screen in more detail (called ocamlinit)

(**This sample demonstrates the floating point capability by achieving a high accuracy
approximation to pi - you can print the result from the gui with the command
pi\_rational\_approx;; - the ;; represents end of current block of ocaml phrases**)

let pi\_rational\_approx = 355./.113.;;

(**These directives (only valid from the interactive toplevel) invoke the appropriate libraries from the underlying operating system. Normally this capability uses dynamic load libraries but on the iPad everything needed or possible is statically linked and code signed to prevent problems with viruses etc**)

#load "nums.cma";; (**high precision numeric library**)
#load "unix.cma";; (**for Unix.sleep command and other functions not used here**)
#load "graphics.cma";; (**for the standard ocaml graphics capability**)

(**When we open the library, it makes its contents available without using Num.
in front of every reference to that library**)

open Num;;

(**define a recursive definition of the factorial function - namely n! is n times (n-1)!
the =/ and**/ and -/ are the extended precision versions of equality, multiplication and subtraction **)**

let rec fact n =
> if n =/ Int 0 then Int 1 else n **/ fact(n -/ Int 1);;**

(**define a function which takes a plain integer argument and returns the factorial as a string**)

let f x = string\_of\_num (fact (Int x));;

(**open the graphics library**)

open Graphics;;

(**define a function named welcome which takes a delay argument and then executes the hopefully self-explanatory list of graphics instructions. This will be the display you see on startup**)

let welcome dly=
open\_graph "";
set\_color red;
draw\_rect 1 1 100 100;
set\_color green;
moveto 10 50;
set\_font "Bitmap";
draw\_string "see http://code.google.com/p/ocaml-for-ios/wiki/Welcome for instructions";
draw\_rect 100 100 200 200;
set\_color blue;
draw\_rect 200 200 100 400;
set\_font "frabk";
moveto 10 300;
draw\_string "Hello";
set\_color white;
moveto 100 400;
draw\_string "Welcome";
set\_color green;
set\_font "verdana";
moveto 200 500;
draw\_string "TO";
set\_color white;
set\_text\_size 48;
moveto 300 600;
draw\_string "OCAML";
set\_text\_size 12;
Unix.sleep dly;
close\_graph();;

(**execute the above function with a fifteen second delay**)
welcome 15;;

(**toplevel directive to launch the graph\_test.ml program. .ml represents ocaml source code like what you are reading as opposed to .cma which is a compiled library**)

(**#use "graph\_test.ml";;**)

You can try the factorial function straight away using the following syntax:

f 9;; (**you type this bit**)
- : string = "362880" (**the iPad responds**)

# Writing you own programs #

By now you are probably itching to try your own programs, especially if you already consulted the official tutorial at

http://caml.inria.fr/pub/docs/manual-ocaml/manual003.html

Where this tutorial refers to the interactive system, you can take that to mean the iPad app. If it refers to the non-interactive system, this capability is not available on the iPad (at the moment)

You may also find it useful to consult the library guide at:

http://caml.inria.fr/pub/docs/manual-ocaml/libref/index.html

As you can see, there are a lot of functions available, the majority of which should work just fine on the iPad. You need not be concerned about experimenting. Everything you do works inside a virtual machine, which checks everything you do, and whatever the virtual machine does is checked by iOS to be sure it is legal. If iOS returns an error this will be passed onto you in the gui in most cases.

# Acknowledgements #

This project would not have been possible without the generous publication of the ocaml source code by INRIA(links above), the patches for the iPad supplied by Toshiyuki Maeda http://web.yl.is.s.u-tokyo.ac.jp/~tosh/ocaml-on-iphone/ , and the object orientated GUI framework called cocos2d for iPhone ( http://www.cocos2d-iphone.org/ ) written by various authors. Last but not least, John O'Neill ( http://en.wikipedia.org/wiki/User:Jjron ) generously gave permission for his fine Camel picture to be used.