extern CAMLprim value caml_gr_plot(value vx, value vy);
extern CAMLprim value caml_gr_moveto(value vx, value vy);
extern CAMLprim value caml_gr_current_x(void);
extern CAMLprim value caml_gr_current_y(void);
extern CAMLprim value caml_gr_lineto(value vx, value vy);
extern CAMLprim value caml_gr_draw_rect(value vx, value vy, value vw, value vh);
extern CAMLprim value caml_gr_draw_text(value text,value x);
extern CAMLprim value caml_gr_fill_rect(value vx, value vy, value vw, value vh);
extern CAMLprim value caml_gr_sound(value freq, value vdur);
extern CAMLprim value caml_gr_point_color(value vx, value vy);
extern CAMLprim value caml_gr_circle(value x,value y,value radius);
extern CAMLprim value caml_gr_set_window_title(value text);
extern CAMLprim value caml_gr_draw_arc(value *argv, int argc);
extern CAMLprim value caml_gr_draw_arc_nat(int vx, int vy, int vrx, int vry, int vstart, int vend);
extern CAMLprim value caml_gr_set_line_width(value vwidth);
extern CAMLprim value caml_gr_set_color(value vcolor);
extern CAMLprim value caml_gr_show_bitmap(value filename,int x,int y);
extern CAMLprim value caml_gr_get_mousex(void);
extern CAMLprim value caml_gr_get_mousey(void);
extern CAMLprim value caml_gr_set_font(value fontname);
extern CAMLprim value caml_gr_set_text_size (value sz);
extern CAMLprim value caml_gr_draw_char(value chr);
extern CAMLprim value caml_gr_draw_string(value str);
extern CAMLprim value caml_gr_text_size(value str);
extern CAMLprim value caml_gr_fill_poly(value vect);
extern CAMLprim value caml_gr_fill_arc(value *argv, int argc);
extern CAMLprim value caml_gr_fill_arc_nat(int vx, int vy, int vrx, int vry, int vstart, int vend);
extern CAMLprim value caml_gr_create_image(value vw, value vh);
extern CAMLprim value caml_gr_blit_image (value i, value x, value y);
extern CAMLprim value caml_gr_draw_image(value i, value x, value y);
extern CAMLprim value caml_gr_make_image(value matrix);
extern CAMLprim value caml_gr_dump_image (value img);
extern CAMLprim value caml_gr_wait_event(value eventlist) /* ML */;
extern CAMLprim value caml_gr_clear_graph(void);;
extern CAMLprim value caml_gr_open_graph(value arg);
extern CAMLprim value caml_gr_close_graph(void);
extern CAMLprim value caml_gr_clear_graph(void);
extern CAMLprim value caml_gr_size_x(void);
extern CAMLprim value caml_gr_size_y(void);
extern CAMLprim value caml_gr_resize_window (value vx, value vy);
extern CAMLprim value caml_gr_synchronize(void);
extern CAMLprim value caml_gr_display_mode(value flag);
extern CAMLprim value caml_gr_remember_mode(value flag);
extern CAMLprim value caml_gr_sigio_signal(value unit);
extern CAMLprim value caml_gr_sigio_handler(void);

typedef enum {FALSE, TRUE} BOOL;
typedef unsigned char BYTE;

enum {INVALID_HANDLE_VALUE, TRANSPARENT, PS_SOLID, BS_SOLID, HWND_DESKTOP, TA_UPDATECP, TA_BOTTOM, SRCCOPY, SRCAND, SRCPAINT, ANSI_CHARSET, FW_NORMAL,
	FIXED_PITCH, FF_MODERN, WNDCLASS, CS_HREDRAW, CS_VREDRAW, CS_DBLCLKS, CS_OWNDC, WNDPROC, COLOR_WINDOW, IDC_ARROW, SM_CXSCREEN, SM_CYSCREEN, INFINITE,
	WM_CLOSE, WHITENESS, MM_TEXT, COLOR_WINDOWTEXT, WHITE_PEN, WHITE_BRUSH,CW_USEDEFAULT,WINDOW_NAME,WS_OVERLAPPEDWINDOW,
	SW_SHOWNORMAL};

typedef void *HDC, *HBITMAP, *HANDLE, *HWND, *MSG;
typedef struct {int lopnColor;} LOGPEN;
typedef struct {void *gcBitmap, *gc; int height, width, CurrentFontSize, CurrentColor, grx, gry; LOGPEN *CurrentPen; void *CurrentBrush, *CurrentFont,  *tempDC, *hwnd,
	*hBitmap; } GR_WINDOW;
typedef struct {int x,y;} POINT;
typedef struct {int left, right, bottom, top; } RECT;
typedef long COLORREF;
typedef void *HPEN;
typedef void *HBRUSH;
typedef struct {int lbStyle, lbColor; } LOGBRUSH;
typedef void *HFONT;
typedef struct { int lfCharSet, lfWeight, lfHeight, lfPitchAndFamily; char lfFaceName[64]; } LOGFONT;
typedef struct {int cx, cy;} SIZE;

extern GR_WINDOW grwindow;
extern char *window_name;
#define Wcvt(coord) coord

extern int AfficheBitmap(value, void *, int, int);
extern int Arc(void *, int, int, int, int, int, int, int, int);
extern int Beep(value, value);
extern int BitBlt(void *, int, int, int w, int h, void *, int x, int y, int );
extern int CloseHandle(void *);
extern HBRUSH CreateBrushIndirect(LOGBRUSH *);
extern void *CreateCompatibleBitmap(void *, int w, int h);
extern void *CreateCompatibleDC(void *);
extern void *CreateEvent(void *, BOOL, BOOL, void *);
extern HFONT CreateFontIndirect(LOGFONT *);
extern HPEN CreatePenIndirect(LOGPEN *);
extern HPEN CreatePen(int, int, int);
extern HFONT MyCreationFont(char *);
extern int DeleteDC(void *);
extern int DeleteObject(void *);
extern int Ellipse(void *, int, int, int, int);
extern int FillRect(void *, RECT *, void *);
extern int GetClientRect(HWND, RECT *);
extern int GetCursorPos(POINT *);
extern void *GetDC(void *);
extern int GetObject(void *, int, LOGPEN *);
extern int GetPixel(void *, int, int);
extern void *GetStockObject(int);
extern int GetSysColor(int);
extern int GetSystemMetrics(int);
extern int GetTextExtentPoint(void *, char *, int, SIZE *);
extern int LineTo(void *, int, int);
extern int MapWindowPoints(int, void *, POINT *, int);
extern int MoveToEx(HDC, int, int, void *);
extern int Pie(void *, int, int, int, int, int, int, int, int);
extern int Polygon(void *, POINT *, int);
extern int Polyline(void *, POINT *, int);
extern int PostMessage(void *, int, int, int);
extern COLORREF RGB(int,int,int);
extern void *SelectObject(void *, void *);
extern int SetBkMode(void *, int);
extern int SetMapMode(void *, int);
extern int SetPixel(void *, int, int, int);
extern int SetTextAlign(void *, int);
extern int SetTextColor(void *, int);
extern int SetWindowText(void *, char *);
extern int TextOut(void *,int,int,char *,int);
extern int WaitForSingleObject(void *, int);
extern CAMLprim value caml_gr_wait_event_blocking(long);
extern value caml_gr_wait_event_poll(void);
extern value caml_gr_window_id(void);
extern void gr_fail(char *fmt, char *arg);
extern int gr_open_graph_internal(value);
extern void gr_check_open(void);
extern value caml_gr_open_subwindow(value vx, value vy, value width, value height);
extern value caml_gr_close_subwindow(value wid);

