/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 2004 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../../LICENSE.  */
/*                                                                     */
/***********************************************************************/

/* $Id: events.c 6553 2004-07-13 12:25:21Z xleroy $ */

#include "../../byterun/custom.h"
#include "../../byterun/mlvalues.h"
#include "../../byterun/alloc.h"
#include "../../byterun/memory.h"
#include "../../byterun/fail.h"
#include "graphstubs.h"
#include "glue.h"

enum {
  EVENT_BUTTON_DOWN = 1,
  EVENT_BUTTON_UP = 2,
  EVENT_KEY_PRESSED = 4,
  EVENT_MOUSE_MOTION = 8
};

struct event_data {
  short mouse_x, mouse_y;
  unsigned char kind;
  unsigned char button;
  unsigned char key;
};

CAMLprim value caml_gr_wait_event(value eventlist) /* ML */
{
  int mask, poll;

  gr_check_open();
  mask = 0;
  poll = 0;
  while (eventlist != Val_int(0)) {
    switch (Int_val(Field(eventlist, 0))) {
    case 0:                     /* Button_down */
      mask |= EVENT_BUTTON_DOWN; break;
    case 1:                     /* Button_up */
      mask |= EVENT_BUTTON_UP; break;
    case 2:                     /* Key_pressed */
      mask |= EVENT_KEY_PRESSED; break;
    case 3:                     /* Mouse_motion */
      mask |= EVENT_MOUSE_MOTION; break;
    case 4:                     /* Poll */
      poll = 1; break;
    }
    eventlist = Field(eventlist, 1);
  }
  if (poll)
    return caml_gr_wait_event_poll();
  else
    return caml_gr_wait_event_blocking(mask);
}
