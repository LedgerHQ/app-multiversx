#include "globals.h"
#include "glyphs.h"

#ifndef _MENU_H_
#define _MENU_H_

extern volatile uint8_t setting_contract_data, setting_blind_signing;

void ui_idle(void);
void ui_settings(void);

#ifdef HAVE_NBGL

#if defined(TARGET_STAX) || defined(TARGET_FLEX)
#define ICON_APP_HOME C_icon_multiversx_logo_64x64
#elif defined(TARGET_APEX_P)
#define ICON_APP_HOME C_icon_multiversx_logo_48x48
#endif

#endif  // HAVE_NBGL

#endif  // _MENU_H_
