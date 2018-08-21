" File:         cfr.vim
" Purpose:      vim plugin for 'cfr' decompiler.
"
" Assume that cfr file is accessible from PATH
" and the file contents is something like
" #!/bin/sh
" java -jar /tools/cfr/cfr_0_132.jar $*

augroup class
  " Remove all cfr autocommands
  au!
  autocmd BufReadPre,FileReadPre	*.class  set bin
  autocmd BufReadPost,FileReadPost	*.class  call s:read("cfr")
augroup END

" After reading decompiled file: Decompiled text in buffer with "cmd"
fun s:read(cmd)
  " make 'patchmode' empty, we don't want a copy of the written file
  let pm_save = &pm
  set pm      =
  " set 'modifiable'
  set ma

  let javafile = expand("<afile>:r") . ".java"
  let orig    = expand("<afile>")
  " now we have no binary file, so set 'nobinary'
  set nobin
  "Split and show code in a new window
  g/.*/d
  execute "silent r !" a:cmd . " " . orig
  1
  " set file name, type and file syntax to java
  execute ":file " . javafile
  set ft      =java
  set syntax  =java
  " recover global variables
  let &pm     = pm_save
endfun
