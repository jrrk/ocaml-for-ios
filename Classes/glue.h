/*
 *  glue.h
 *  OcamlExample
 *
 *  Created by Jonathan Kimmitt on 17/09/2010.
 *  Copyright 2010 OMSI Limited. All rights reserved.
 *
 */

extern const char *getPwd(void);
extern void LaunchThread(void);
extern void wakethread(void);
extern void gr_open(void);
extern void gr_close(void);
extern void DrawText(const char *str, const char *fnt, int len, int x, int y, int siz);

#define Nothing ((value) 0)
	
	enum geom {qEnd,qTriangle,qCircle,qEllipse,qLine,qRect,qCurve,qBezier,qSetLineWidth,
		qSetColor,qBeginShape,qVertex,qEndShape,qFill,qSetFont,qReset};
	
	extern void queue(enum geom func, long arg1, long arg2, long arg3, long arg4);
	extern void queue2(enum geom func, long arg1, long arg2, long arg3, long arg4, long arg5, long arg6, long arg7, long arg8);
	extern long unix_error_of_code (int errcode);
	extern void unix_error (int errcode, char * cmdname, long arg) __attribute__ ((noreturn));
	extern void uerror (char * cmdname, long arg) __attribute__ ((noreturn));	

typedef struct camlsyms {
		const char *sym;
		void (*ref);
	} camlsyms;
	
	extern struct camlsyms nat_camlsyms[];
	extern struct camlsyms str_camlsyms[];
	extern struct camlsyms graph_camlsyms[];
	extern struct camlsyms unix_camlsyms[];
	extern struct camlsyms dbm_camlsyms[];
	extern struct camlsyms bigarray_camlsyms[];
	extern struct camlsyms thread_camlsyms[];
	extern struct camlsyms systhread_camlsyms[];

	int ocaml_main(int argc, const char **argv);
	int stdin_read(char *buf, int siz);
	int stdout_write(const char *buf, int len);
	int bas_read(int fd, char *buf, int len);
	int bas_write(int fd, char *buf, int len);
	int bas_open(char *name, int flags, int mode);
	
	int of_font(const char *name);
	
	char *					_ctext;
	int						head, tail;
	char 					ringbuf[256];
