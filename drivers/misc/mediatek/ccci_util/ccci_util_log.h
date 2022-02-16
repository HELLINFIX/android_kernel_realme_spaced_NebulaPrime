/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (C) 2015 MediaTek Inc.
 */

#ifndef __CCCI_UTIL_LOG_H__
#define __CCCI_UTIL_LOG_H__

#if IS_ENABLED(CONFIG_MTK_AEE_IPANIC)
extern void mrdump_mini_add_misc(unsigned long addr, unsigned long size,
	unsigned long start, char *name);
#endif

#define BRING_UP_LOG_MODE

/* #define BRING_UP_LOG_MODE */
#ifndef BRING_UP_LOG_MODE
/* ------------------------------------------------------------------------- */
/* For normal stage log */
/* ------------------------------------------------------------------------- */
/* No MD id message part */
#define CCCI_UTIL_DBG_MSG(fmt, args...) \
do {} while (0)

#define CCCI_UTIL_INF_MSG(fmt, args...) \
do {} while (0)

#define CCCI_UTIL_ERR_MSG(fmt, args...) \
do {} while (0)

/* With MD id message part */
#define CCCI_UTIL_DBG_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#define CCCI_UTIL_INF_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#define CCCI_UTIL_NOTICE_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#define CCCI_UTIL_ERR_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#else

/* ------------------------------------------------------------------------- */
/* For bring up stage log */
/* ------------------------------------------------------------------------- */
/* No MD id message part */
#define CCCI_UTIL_DBG_MSG(fmt, args...)  do {} while (0)
#define CCCI_UTIL_INF_MSG(fmt, args...)  do {} while (0)
#define CCCI_UTIL_ERR_MSG(fmt, args...)  do {} while (0)

/* With MD id message part */
#define CCCI_UTIL_DBG_MSG_WITH_ID(id, fmt, args...) \
	do {} while (0)
#define CCCI_UTIL_INF_MSG_WITH_ID(id, fmt, args...) \
	do {} while (0)
#define CCCI_UTIL_NOTICE_MSG_WITH_ID(id, fmt, args...) \
	do {} while (0)
#define CCCI_UTIL_ERR_MSG_WITH_ID(id, fmt, args...) \
	do {} while (0)

#define CCCI_UTIL_INF_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#define CCCI_UTIL_NOTICE_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#define CCCI_UTIL_ERR_MSG_WITH_ID(id, fmt, args...) \
do {} while (0)

#endif /* end of #ifndef BRING_UP_LOG_MODE */
#endif /*__CCCI_UTIL_LOG_H__ */
