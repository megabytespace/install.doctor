


  if &background == 'dark'

  let s:guishade0 = "#161925"
  let s:guishade1 = "#2f323e"
  let s:guishade2 = "#474b56"
  let s:guishade3 = "#60646f"
  let s:guishade4 = "#797c87"
  let s:guishade5 = "#9295a0"
  let s:guishade6 = "#aaaeb8"
  let s:guishade7 = "#c3c7d1"
  let s:guiaccent0 = "#ed254e"
  let s:guiaccent1 = "#dcdfe4"
  let s:guiaccent2 = "#f9dc5c"
  let s:guiaccent3 = "#71f79f"
  let s:guiaccent4 = "#00c1e4"
  let s:guiaccent5 = "#7cb7ff"
  let s:guiaccent6 = "#c3c7d1"
  let s:guiaccent7 = "#c74d89"
  let s:shade0 = 234
  let s:shade1 = 59
  let s:shade2 = 239
  let s:shade3 = 102
  let s:shade4 = 244
  let s:shade5 = 145
  let s:shade6 = 249
  let s:shade7 = 188
  let s:accent0 = 204
  let s:accent1 = 254
  let s:accent2 = 222
  let s:accent3 = 121
  let s:accent4 = 44
  let s:accent5 = 117
  let s:accent6 = 188
  let s:accent7 = 175

  endif



  if &background == 'light'

  let s:guishade0 = "#ffffff"
  let s:guishade1 = "#e5e6e7"
  let s:guishade2 = "#cccdcf"
  let s:guishade3 = "#b2b4b7"
  let s:guishade4 = "#999ba0"
  let s:guishade5 = "#7f8288"
  let s:guishade6 = "#666970"
  let s:guishade7 = "#4c5058"
  let s:guiaccent0 = "#ff4972"
  let s:guiaccent1 = "#dcdfe4"
  let s:guiaccent2 = "#ffff80"
  let s:guiaccent3 = "#95ffc3"
  let s:guiaccent4 = "#24e5ff"
  let s:guiaccent5 = "#a0dbff"
  let s:guiaccent6 = "#4c5058"
  let s:guiaccent7 = "#eb71ad"
  let s:shade0 = 231
  let s:shade1 = 254
  let s:shade2 = 15
  let s:shade3 = 249
  let s:shade4 = 247
  let s:shade5 = 244
  let s:shade6 = 242
  let s:shade7 = 239
  let s:accent0 = 204
  let s:accent1 = 254
  let s:accent2 = 229
  let s:accent3 = 158
  let s:accent4 = 81
  let s:accent5 = 153
  let s:accent6 = 239
  let s:accent7 = 211

  endif


  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left = [ [ s:guishade1, s:guiaccent5, s:shade1, s:accent5 ], [ s:guishade7, s:guishade2, s:shade7, s:shade2 ] ]
  let s:p.normal.right = [ [ s:guishade1, s:guishade4, s:shade1, s:shade4 ], [ s:guishade5, s:guishade2, s:shade5, s:shade2 ] ]
  let s:p.inactive.right = [ [ s:guishade1, s:guishade3, s:shade1, s:shade3 ], [ s:guishade3, s:guishade1, s:shade3, s:shade1 ] ]
  let s:p.inactive.left =  [ [ s:guishade4, s:guishade1, s:shade4, s:shade1 ], [ s:guishade3, s:guishade0, s:shade3, s:shade0 ] ]
  let s:p.insert.left = [ [ s:guishade1, s:guiaccent3, s:shade1, s:accent3 ], [ s:guishade7, s:guishade2, s:shade7, s:shade2 ] ]
  let s:p.replace.left = [ [ s:guishade1, s:guiaccent1, s:shade1, s:accent1 ], [ s:guishade7, s:guishade2, s:shade7, s:shade2 ] ]
  let s:p.visual.left = [ [ s:guishade1, s:guiaccent6, s:shade1, s:accent6 ], [ s:guishade7, s:guishade2, s:shade7, s:shade2 ] ]
  let s:p.normal.middle = [ [ s:guishade5, s:guishade1, s:shade5, s:shade1 ] ]
  let s:p.inactive.middle = [ [ s:guishade4, s:guishade1, s:shade4, s:shade1 ] ]
  let s:p.tabline.left = [ [ s:guishade6, s:guishade2, s:shade6, s:shade2 ] ]
  let s:p.tabline.tabsel = [ [ s:guishade6, s:guishade0, s:shade6, s:shade0 ] ]
  let s:p.tabline.middle = [ [ s:guishade2, s:guishade4, s:shade2, s:shade4 ] ]
  let s:p.tabline.right = copy(s:p.normal.right)
  let s:p.normal.error = [ [ s:guiaccent0, s:guishade0, s:accent0, s:shade0 ] ]
  let s:p.normal.warning = [ [ s:guiaccent2, s:guishade1, s:accent2, s:shade1 ] ]

  let g:lightline#colorscheme#Betelgeuse#palette = lightline#colorscheme#fill(s:p)
