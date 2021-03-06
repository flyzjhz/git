#ifndef GIT_UTF8_H
#define GIT_UTF8_H

typedef unsigned int ucs_char_t;  /* assuming 32bit int */

ucs_char_t pick_one_utf8_char(const char **start, size_t *remainder_p);
int utf8_width(const char **start, size_t *remainder_p);
int is_utf8(const char *text);
int is_encoding_utf8(const char *name);

int print_wrapped_text(const char *text, int indent, int indent2, int len);

#ifndef NO_ICONV
char *reencode_string(const char *in, const char *out_encoding, const char *in_encoding);
#else
#define reencode_string(a,b,c) NULL
#endif

#endif
