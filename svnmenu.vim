" GITmenu.vim : Vim menu for using GIT			vim:tw=0:sw=2:ts=8
" Author : Chi-hsien Lin				vim600:fdm=marker
" License : LGPL
"
" Tested with Vim 7.4
" Modified from Throsten Maerz's cvsmenu (https://www.vim.org/scripts/script.php?script_id=58)
"
" Change Log:
" [11/25/2014]
"  - Added svn 1.7+ support

"#############################################################################
" Settings
"#############################################################################
" global variables : may be set in ~/.vimrc	{{{1

" this *may* interfere with :help (inhibits highlighting)
" disable autocheck, if this happens to you.
if ($SVNOPT == '')
"  let $SVNOPT='-z9'
endif

if ($SVNCMD == '')
  let $SVNCMD='svn'
endif

if !exists("g:SVNforcedirectory")
  let g:SVNforcedirectory = 0		" 0:off 1:once 2:forever
endif
if !exists("g:SVNqueryrevision")
  let g:SVNqueryrevision = 0		" 0:fast update 1:query for revisions
endif
if !exists("g:SVNdumpandclose")
  let g:SVNdumpandclose = 2		" 0:new buffer 1:statusline 2:autoswitch
endif
if !exists("g:SVNsortoutput")
  let g:SVNsortoutput = 1		" sort svn output (group conflicts,updates,...)
endif
if !exists("g:SVNcompressoutput")
  let g:SVNcompressoutput = 1		" show extended output only if error
endif
if !exists("g:SVNtitlebar")
  let g:SVNtitlebar = 1			" notification output to titlebar
endif
if !exists("g:SVNstatusline")
  let g:SVNstatusline = 1		" notification output to statusline
endif
if !exists("g:SVNautocheck")
  let g:SVNautocheck = 1		" do local status on every read/write
endif
if !exists("g:SVNeasylogmessage")
  let g:SVNeasylogmessage = 1		" make editing log message easier
endif
if !exists("g:SVNofferrevision")
  let g:SVNofferrevision = 1		" offer current revision on queries
endif
if !exists("g:SVNsavediff")
  let g:SVNsavediff = 1			" save settings when using :diff
endif
if !exists("g:SVNdontswitch")
  let g:SVNdontswitch = 0		" don't switch to diffed file
endif
if !exists("g:SVNdefaultmsg")
  let g:SVNdefaultmsg = ''		" message to use for commands below
endif
if !exists("g:SVNusedefaultmsg")
  let g:SVNusedefaultmsg = 'aj'		" a:Add, i:Commit, j:Join in, p:Import
endif
if !exists("g:SVNallowemptymsg")
  let g:SVNallowemptymsg = 'a'          " a:Add, i:Commit, j:Join in, p:Import
endif
if !exists("g:SVNfullstatus")
  let g:SVNfullstatus = 0		" display all fields for fullstatus
endif
if !exists("g:SVNreloadaftercommit")
  let g:SVNreloadaftercommit = 1	" reload file to update SVN keywords
endif
if !exists("g:SVNspacesinannotate")
  let g:SVNspacesinannotate = 1		" spaces to add in annotated source
endif
if !exists("g:SVNcmdencoding")
  let g:SVNcmdencoding = ''		" the encoding of SVN(NT) commands
endif
if !exists("g:SVNfileencoding")
  let g:SVNfileencoding = ''		" the encoding of files in SVN
endif
if !exists("g:SVNdontconvertfor")
  let g:SVNdontconvertfor = ''		" commands that need no conversion
endif
if !exists("g:SVNusetmpfolder")
  let g:SVNusetmpfolder = 1		" save diff tmp files in /tmp folder instead of current folder
endif

" problems with :help on console
if !(has("gui_running"))
  let g:SVNautocheck = 0
endif


" script variables	{{{1
if has('unix')				" path separator
  let s:sep='/'
else
  let s:sep='\'
endif
let s:script_path=expand('<sfile>:p:h')	" location of this script
let s:script_name=expand('<sfile>:p:t')	" should be 'svnmenu.vim'
let s:SVNentries='SVN'.s:sep.'Entries'	" location of 'SVN/Entries' file
let s:svnmenuhttp="http://ezytools.svn.sourceforge.net/ezytools/VimTools/"
let s:svnmenusvn=":pserver:anonymous@ezytools.svn.sourceforge.net:/svnroot/ezytools"
let s:SVNdontupdatemapping = 0		" don't SVNUpdateMapping (internal!)
let s:SVNupdatequeryonly = 0		" update -n (internal!)
let s:SVNorgtitle = &titlestring	" backup of original title
let g:orgpath = getcwd()
let g:SVNleavediff = 0
let g:SVNdifforgbuf = 0

if exists("loaded_svnmenu")
  aunmenu SVN
endif

"-----------------------------------------------------------------------------
" Menu entries		{{{1
"-----------------------------------------------------------------------------
" Spaces after items to inhibit translation (no one wants a 'svn Differenz':)
" as well as to prevent the hot keys from being altered
" <esc> in Keyword menus to avoid expansion
" use only TAB between menu item and command (used for MakeLeaderMapping)

amenu &SVN.In&fo\ 						:call SVNShowInfo()<cr>
"amenu &SVN.Settin&gs\ .In&fo\ (buffer)\ 			:call SVNShowInfo(1)<cr>
"amenu &SVN.Settin&gs\ .Show\ &mappings\ 			:call SVNShowMapping()<cr>
"amenu &SVN.Settin&gs\ .-SEP1-					:
"amenu &SVN.Settin&gs\ .&Autocheck\ .&Enable\ 			:call SVNSetAutocheck(1)<cr>
"amenu &SVN.Settin&gs\ .&Autocheck\ .&Disable\ 			:call SVNSetAutocheck(0)<cr>
"amenu &SVN.Settin&gs\ .&Target\ .File\ in\ &buffer\ 		:call SVNSetForceDir(0)<cr>
"amenu &SVN.Settin&gs\ .&Target\ .&Directory\ 			:call SVNSetForceDir(2)<cr>
"amenu &SVN.Settin&gs\ .&Diff\ .Stay\ in\ &original\ 		:call SVNSetDontSwitch(1)<cr>
"amenu &SVN.Settin&gs\ .&Diff\ .Switch\ to\ &diffed\ 		:call SVNSetDontSwitch(0)<cr>
"amenu &SVN.Settin&gs\ .&Diff\ .-SEP1-				:
"amenu &SVN.Settin&gs\ .&Diff\ .&Autorestore\ prev\.mode\ 	:call SVNSetSaveDiff(1)<cr>
"amenu &SVN.Settin&gs\ .&Diff\ .&No\ autorestore\ 		:call SVNSetSaveDiff(0)<cr>
"amenu &SVN.Settin&gs\ .&Diff\ .-SEP2-				:
"amenu &SVN.Settin&gs\ .&Diff\ .Re&store\ pre-diff\ mode\ 	:call SVNRestoreDiffMode()<cr>
"amenu &SVN.Settin&gs\ .Revision\ &queries\ .&Enable\ 		:call SVNSetQueryRevision(1)<cr>
"amenu &SVN.Settin&gs\ .Revision\ &queries\ .&Disable\ 		:call SVNSetQueryRevision(0)<cr>
"amenu &SVN.Settin&gs\ .Revision\ &queries\ .-SEP1-		:
"amenu &SVN.Settin&gs\ .Revision\ &queries\ .&Offer\ current\ rev\ 	:call SVNSetOfferRevision(1)<cr>
"amenu &SVN.Settin&gs\ .Revision\ &queries\ .&Hide\ current\ rev\ 	:call SVNSetOfferRevision(0)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .N&otifcation.Enable\ &statusline\ 	:call SVNSetStatusline(1)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .N&otifcation.Disable\ status&line\ 	:call SVNSetStatusline(0)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .N&otifcation.-SEP1-			:
"amenu &SVN.Settin&gs\ .&Output\ .N&otifcation.Enable\ &titlebar\ 	:call SVNSetTitlebar(1)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .N&otifcation.Disable\ title&bar\ 	:call SVNSetTitlebar(0)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .-SEP1-				:
"amenu &SVN.Settin&gs\ .&Output\ .To\ new\ &buffer\ 		:call SVNSetDumpAndClose(0)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .&Notify\ only\ 		:call SVNSetDumpAndClose(1)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .&Autoswitch\ 			:call SVNSetDumpAndClose(2)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .-SEP2-				:
"amenu &SVN.Settin&gs\ .&Output\ .&Compressed\ 			:call SVNSetCompressOutput(1)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .&Full\ 			:call SVNSetCompressOutput(0)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .-SEP3-				:
"amenu &SVN.Settin&gs\ .&Output\ .&Sorted\ 			:call SVNSetSortOutput(1)<cr>
"amenu &SVN.Settin&gs\ .&Output\ .&Unsorted\ 			:call SVNSetSortOutput(0)<cr>
"amenu &SVN.Settin&gs\ .-SEP2-					:
"amenu &SVN.Settin&gs\ .&Install\ .&Install\ updates\ 		:call SVNInstallUpdates()<cr>
"amenu &SVN.Settin&gs\ .&Install\ .&Download\ updates\ 		:call SVNDownloadUpdates()<cr>
"amenu &SVN.Settin&gs\ .&Install\ .Install\ buffer\ as\ &help\ 	:call SVNInstallAsHelp()<cr>
"amenu &SVN.Settin&gs\ .&Install\ .Install\ buffer\ as\ &plugin\ 	:call SVNInstallAsPlugin()<cr>
"amenu &SVN.&Keyword\ .&Author\ 					a$Author<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Date\ 					a$Date<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Header\ 					a$Header<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Id\ 					a$Id<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Name\ 					a$Name<esc>a$<esc>
"amenu &SVN.&Keyword\ .Loc&ker\ 					a$Locker<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Log\ 					a$Log<esc>a$<esc>
"amenu &SVN.&Keyword\ .RCS&file\ 				a$RCSfile<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Revision\ 				a$Revision<esc>a$<esc>
"amenu &SVN.&Keyword\ .&Source\ 					a$Source<esc>a$<esc>
"amenu &SVN.&Keyword\ .S&tate\ 					a$State<esc>a$<esc>
"amenu &SVN.Director&y\ .&Log\ 					:call SVNlog_dir()<cr>
"amenu &SVN.Director&y\ .&Status\ 				:call SVNstatus_dir()<cr>
"amenu &SVN.Director&y\ .S&hort\ status\ 			:call SVNshortstatus_dir()<cr>
"amenu &SVN.Director&y\ .Lo&cal\ status\ 			:call SVNLocalStatus_dir()<cr>
"amenu &SVN.Director&y\ .-SEP1-					:
"amenu &SVN.Director&y\ .&Query\ update\ 			:call SVNqueryupdate_dir()<cr>
"amenu &SVN.Director&y\ .&Update\ 				:call SVNupdate_dir()<cr>
"amenu &SVN.Director&y\ .-SEP2-					:
"amenu &SVN.Director&y\ .&Add\ 					:call SVNadd_dir()<cr>
"amenu &SVN.Director&y\ .Comm&it\ 				:call SVNcommit_dir()<cr>
"amenu &SVN.Director&y\ .-SEP3-					:
"amenu &SVN.Director&y\ .Re&move\ from\ repositoy\ 		:call SVNremove_dir()<cr>
"amenu &SVN.E&xtra\ .&Create\ patchfile\ .&Context\ 		:call SVNdiffcontext()<cr>
"amenu &SVN.E&xtra\ .&Create\ patchfile\ .&Standard\ 		:call SVNdiffstandard()<cr>
"amenu &SVN.E&xtra\ .&Create\ patchfile\ .&Uni\ 			:call SVNdiffuni()<cr>
"amenu &SVN.E&xtra\ .&Diff\ to\ revision\ 			:call SVNdifftorev()<cr>
"amenu &SVN.E&xtra\ .&Log\ to\ revision\ 			:call SVNlogtorev()<cr>
"amenu &SVN.E&xtra\ .-SEP1-					:
"amenu &SVN.E&xtra\ .Check&out\ revision\ 			:call SVNcheckoutrevision()<cr>
"amenu &SVN.E&xtra\ .&Update\ to\ revision\ 			:call SVNupdatetorev()<cr>
"amenu &SVN.E&xtra\ .&Merge\ in\ revision\ 			:call SVNupdatemergerev()<cr>
"amenu &SVN.E&xtra\ .Merge\ in\ revision\ di&ffs\ 		:call SVNupdatemergediff()<cr>
"amenu &SVN.E&xtra\ .-SEP2-					:
"amenu &SVN.E&xtra\ .Comm&it\ to\ revision\ 			:call SVNcommitrevision()<cr>
"amenu &SVN.E&xtra\ .Im&port\ to\ revision\ 			:call SVNimportrevision()<cr>
"amenu &SVN.E&xtra\ .&Join\ in\ to\ revision\ 			:call SVNjoininrevision()<cr>
"amenu &SVN.E&xtra\ .-SEP3-					:
"amenu &SVN.E&xtra\ .SVN\ lin&ks\ 				:call SVNOpenLinks()<cr>
"amenu &SVN.E&xtra\ .&Get\ file\ 				:call SVNGet()<cr>
"amenu &SVN.E&xtra\ .Get\ file\ (pass&word)\ 			:call SVNGet('','','io')<cr>
"amenu &SVN.-SEP1-						:
"amenu &SVN.Ad&min\ .Log&in\ 					:call SVNlogin()<cr>
"amenu &SVN.Ad&min\ .Log&out\ 					:call SVNlogout()<cr>
"amenu &SVN.D&elete\ .Re&move\ from\ repository\ 		:call SVNremove()<cr>
"amenu &SVN.D&elete\ .Re&lease\ workdir\ 			:call SVNrelease()<cr>
"amenu &SVN.&Tag\ .&Create\ tag\ 				:call SVNtag()<cr>
"amenu &SVN.&Tag\ .&Remove\ tag\ 				:call SVNtagremove()<cr>
"amenu &SVN.&Tag\ .Create\ &branch\ 				:call SVNbranch()<cr>
"amenu &SVN.&Tag\ .-SEP1-					:
"amenu &SVN.&Tag\ .Cre&ate\ tag\ by\ module\ 			:call SVNrtag()<cr>
"amenu &SVN.&Tag\ .Rem&ove\ tag\ by\ module\ 			:call SVNrtagremove()<cr>
"amenu &SVN.&Tag\ .Create\ branc&h\ by\ module\ 			:call SVNrbranch()<cr>
"amenu &SVN.&Watch/Edit\ .&Watchers\ 				:call SVNwatchwatchers()<cr>
"amenu &SVN.&Watch/Edit\ .Watch\ &add\ 				:call SVNwatchadd()<cr>
"amenu &SVN.&Watch/Edit\ .Watch\ &remove\ 			:call SVNwatchremove()<cr>
"amenu &SVN.&Watch/Edit\ .Watch\ o&n\ 				:call SVNwatchon()<cr>
"amenu &SVN.&Watch/Edit\ .Watch\ o&ff\ 				:call SVNwatchoff()<cr>
"amenu &SVN.&Watch/Edit\ .-SEP1-					:
"amenu &SVN.&Watch/Edit\ .&Editors\ 				:call SVNwatcheditors()<cr>
"amenu &SVN.&Watch/Edit\ .Edi&t\ 				:call SVNwatchedit()<cr>
"amenu &SVN.&Watch/Edit\ .&Unedit\ 				:call SVNwatchunedit()<cr>
"amenu &SVN.-SEP2-						:
amenu &SVN.&Diff\ 						:call SVNdiff()<cr>
amenu &SVN.A&nnotate\ 						:call SVNannotate()<cr>
"amenu &SVN.Histo&ry\ 						:call SVNhistory()<cr>
amenu &SVN.&Log\ 						:call SVNlog()<cr>
"amenu &SVN.&Status\ 						:call SVNstatus()<cr>
"amenu &SVN.S&hort\ status\ 					:call SVNshortstatus()<cr>
"amenu &SVN.Lo&cal\ status\ 					:call SVNLocalStatus()<cr>
"amenu &SVN.-SEP3-						:
"amenu &SVN.Check&out\ 						:call SVNcheckout()<cr>
"amenu &SVN.&Query\ update\ 					:call SVNqueryupdate()<cr>
"amenu &SVN.&Update\ 						:call SVNupdate()<cr>
"amenu &SVN.Re&vert\ changes\ 					:call SVNrevertchanges()<cr>
"amenu &SVN.-SEP4-						:
"amenu &SVN.&Add\ 						:call SVNadd()<cr>
"amenu &SVN.Comm&it\ 						:call SVNcommit()<cr>
"amenu &SVN.Im&port\ 						:call SVNimport()<cr>
"amenu &SVN.&Join\ in\ 						:call SVNjoinin()<cr>

" create key mappings from this script		{{{1
" key mappings : <Leader> (mostly '\' ?), then same as menu hotkeys
" e.g. <ALT>ci = \ci = SVN.Commit
function! SVNMakeLeaderMapping()
  silent! call SVNMappingFromMenu(s:script_path.s:sep.s:script_name,',')
endfunction

function! SVNMappingFromMenu(filename,...)
  if !filereadable(a:filename)
    return
  endif
  if a:0 == 0
    let leader = '<Leader>'
  else
    let leader = a:1
  endif
  " create mappings from &-chars
  new
  exec 'read '.SVNEscapePath(a:filename)
  " leave only amenu defs
  exec 'g!/^\s*amenu/d'
  " delete separators and blank lines
  exec 'g/\.-SEP/d'
  exec 'g/^$/d'
  " count entries
  let entries=line("$")
  " extract menu entries, put in @m
  exec '%s/^\s*amenu\s\([^'."\t".']*\).\+/\1/eg'
  exec '%y m'
  " extract mappings from '&'
  exec '%s/&\(\w\)[^&]*/\l\1/eg'
  " create cmd, delete to @k
  exec '%s/^\(.*\)$/nmap '.leader.'\1 :em /eg'
  exec '%d k'
  " restore menu, delete '&'
  normal "mP
  exec '%s/&//eg'
  " visual block inserts failed, when called from script (vim60at)
  " append keymappings
  normal G"kP
  " merge keys/commands, execute
  let curlin=0
  while curlin < entries
    let curlin = curlin + 1
    call setline(curlin,getline(curlin + entries).getline(curlin).'<cr>')
    exec getline(curlin)
  endwhile
  set nomodified
  bwipeout
endfunction

"-----------------------------------------------------------------------------
" escape user message	{{{1
"-----------------------------------------------------------------------------
function! SVNEscapeMessage(msg)
  if has('unix')
    let result = escape(a:msg,'"`\')
  else
    let result = escape(a:msg,'"')
    if &shell =~? 'cmd\.exe'
      let result = substitute(result,'\([&<>|^]\)','^\1','g')
    endif
  endif
  return result
endfunction

"-----------------------------------------------------------------------------
" escape file path	{{{1
"-----------------------------------------------------------------------------
function! SVNEscapePath(path)
  if has('unix')
    return escape(a:path,' \')
  else
    return a:path
  endif
endfunction

"-----------------------------------------------------------------------------
" show svn info		{{{1
"-----------------------------------------------------------------------------
" Param : ToBuffer (bool)
function! SVNShowInfo(...)
  if a:0 == 0
    let tobuf = 0
  else
    let tobuf = a:1
  endif
  call SVNChDir(expand('%:p:h'))
  " show SVN info from directory
  let svnroot='SVN'.s:sep.'Root'
  let svnrepository='SVN'.s:sep.'Repository'
  silent! exec 'split '.svnroot
  let root=getline(1)
  bwipeout
  silent! exec 'split '.svnrepository
  let repository=getline(1)
  bwipeout
  unlet svnroot svnrepository
  " show settings
  new
  let zbak=@z
  let @z = ''
    \."\n\"SVNmenu $Revision: 1.150 $"
    \."\n\"Current directory : ".expand('%:p:h')
    \."\n\"Current Root : ".root
    \."\n\"Current Repository : ".repository
    \."\nlet $SVNROOT\t\t= \'"			.$SVNROOT."\'"			."\t\" Set environment var to svnroot"
    \."\nlet $SVN_RSH\t\t= \'"			.$SVN_RSH."\'"			."\t\" Set environment var to rsh/ssh"
    \."\nlet $SVNOPT\t\t= \'"			.$SVNOPT."\'"			."\t\" Set svn options (see svn --help-options)"
    \."\nlet $SVNCMDOPT\t\t= \'"		.$SVNCMDOPT."\'"		."\t\" Set svn command options"
    \."\nlet $SVNCMD\t\t\= '"			.$SVNCMD."\'"			."\t\" Set svn command"
    \."\nlet g:SVNforcedirectory\t= "		.g:SVNforcedirectory		."\t\" Refer to directory instead of current file"
    \."\nlet g:SVNqueryrevision\t= "		.g:SVNqueryrevision		."\t\" Query for revisions (0:no 1:yes)"
    \."\nlet g:SVNdumpandclose\t= "		.g:SVNdumpandclose		."\t\" Output to: 0=buffer 1=notify 2=autoswitch"
    \."\nlet g:SVNsortoutput\t= "		.g:SVNsortoutput		."\t\" Toggle sorting output (0:no sorting)"
    \."\nlet g:SVNcompressoutput\t= "		.g:SVNcompressoutput		."\t\" Show extended output only if error"
    \."\nlet g:SVNtitlebar\t= "			.g:SVNtitlebar			."\t\" Notification on titlebar"
    \."\nlet g:SVNstatusline\t= "		.g:SVNstatusline		."\t\" Notification on statusline"
    \."\nlet g:SVNautocheck\t= "		.g:SVNautocheck			."\t\" Get local status when file is read/written"
    \."\nlet g:SVNeasylogmessage\t= "		.g:SVNeasylogmessage		."\t\" Ease editing the SVN log message in Vim"
    \."\nlet g:SVNofferrevision\t= "		.g:SVNofferrevision		."\t\" Offer current revision on queries"
    \."\nlet g:SVNsavediff\t= "			.g:SVNsavediff			."\t\" Save settings when using :diff"
    \."\nlet g:SVNdontswitch\t= "		.g:SVNdontswitch		."\t\" Don't switch to diffed file"
    \."\nlet g:SVNdefaultmsg\t= \'"		.g:SVNdefaultmsg."\'"		."\t\" Message to use for commands below"
    \."\nlet g:SVNusedefaultmsg\t= \'"		.g:SVNusedefaultmsg."\'"	."\t\" a:Add, i:Commit, j:Join in, p:Import"
    \."\nlet g:SVNallowemptymsg\t= \'"		.g:SVNallowemptymsg."\'"	."\t\" a:Add, i:Commit, j:Join in, p:Import"
    \."\nlet g:SVNfullstatus\t= "		.g:SVNfullstatus		."\t\" Display all fields for fullstatus"
    \."\nlet g:SVNreloadaftercommit = "		.g:SVNreloadaftercommit		."\t\" Reload file to update SVN keywords"
    \."\nlet g:SVNspacesinannotate = "		.g:SVNspacesinannotate		."\t\" Spaces to add in annotated source"
    \."\nlet g:SVNcmdencoding = \'"		.g:SVNcmdencoding."\'"		."\t\" The encoding of SVN(NT) commands"
    \."\nlet g:SVNfileencoding = \'"		.g:SVNfileencoding."\'"		."\t\" The encoding of files in SVN"
    \."\nlet g:SVNdontconvertfor = \'"		.g:SVNdontconvertfor."\'"	."\t\" Commands that need no conversion"
    \."\nlet g:SVNusetmpfolder = \'"		.g:SVNusetmpfolder."\'"		."\t\" Save diff tmp files in /tmp folder instead of current folder"
    \."\n\"----------------------------------------"
    \."\n\" Change above values to your needs."
    \."\n\" To execute a line, put the cursor on it and press <shift-cr> or doubleclick."
    \."\n\" Site: http://ezytools.svn.sourceforge.net/ezytools/VimTools/"
  normal "zP
  let @z=zbak
  normal dd
  if tobuf == 0
    silent! exec '5,$g/^"/d'
    " dont dump this to titlebar
    let titlebak = g:SVNtitlebar
    let g:SVNtitlebar = 0
    call SVNDumpAndClose()
    let g:SVNtitlebar = titlebak
    unlet titlebak
  else
    map <buffer> q :bd!<cr>
    map <buffer> <s-cr> :exec getline('.')<cr>:set nomod<cr>:echo getline('.')<cr>
    map <buffer> <2-LeftMouse> <s-cr>
    set syntax=vim
    set nomodified
  endif
  call SVNRestoreDir()
  unlet root repository tobuf
endfunction

"-----------------------------------------------------------------------------
" syntax, MakeRO/RW		{{{1
"-----------------------------------------------------------------------------

function! SVNUpdateSyntax()
  syn match svnupdateMerge	'^M .*$'
  syn match svnupdatePatch	'^P .*$'
  syn match svnupdateConflict	'^C .*$'
  syn match svnupdateDelete	'^D .*$'
  syn match svnupdateUnknown	'^? .*$'
  syn match svncheckoutUpdate	'^U .*$'
  syn match svnimportNew	'^N .*$'
  syn match svntagNew		'^T .*$'
  hi link svntagNew		Special
  hi link svnimportNew		Special
  hi link svncheckoutUpdate	Special
  hi link svnupdateMerge	Special
  hi link svnupdatePatch	Constant
  hi link svnupdateConflict	WarningMsg
  hi link svnupdateDelete	Statement
  hi link svnupdateUnknown	Comment

  syn match svnstatusUpToDate	'^File:\s.*\sStatus: Up-to-date$'
  syn match svnstatusLocal	'^File:\s.*\sStatus: Locally.*$'
  syn match svnstatusNeed	'^File:\s.*\sStatus: Need.*$'
  syn match svnstatusConflict	'^File:\s.*\sStatus: File had conflict.*$'
  syn match svnstatusUnknown	'^File:\s.*\sStatus: Unknown$'
  hi link svnstatusUpToDate	Type
  hi link svnstatusLocal	Constant
  hi link svnstatusNeed		Identifier
  hi link svnstatusConflict	Warningmsg
  hi link svnstatusUnknown	Comment

  syn match svnlocalstatusUnknown	'^unknown:.*'
  syn match svnlocalstatusUnchanged	'^unchanged:.*'
  syn match svnlocalstatusMissing	'^missing:.*'
  syn match svnlocalstatusModified	'^modified:.*'
  hi link svnlocalstatusUnknown		Comment
  hi link svnlocalstatusUnchanged	Type
  hi link svnlocalstatusMissing		Identifier
  hi link svnlocalstatusModified	Constant

  syn match svnmergeConflict		'rcsmerge: warning: conflicts during merge'
  hi link svnmergeConflict		WarningMsg

  syn match svndate	/^\s*\d\+\s\+\w\{-} \d\{4}\-\d\{2}\-\d\{2} /	contains=svnuser nextgroup=svnuser
  syn match svnuser	/^\s*\d\+\s\+\w\{-} /				contained contains=svnver nextgroup=svnver
  syn match svnver	/^\s*\d\+/					contained
  hi link svndate	Identifier
  hi link svnuser	Type
  hi link svnver	Constant

  if !filereadable($VIM.s:sep.'syntax'.s:sep.'rcslog')
    syn match svnlogRevision	/^r\d\+/			contained nextgroup=svnlogUser
    syn match svnlogUser	/| \w\+ |/hs=s+2,he=e-2		contained nextgroup=svnlogDate
    syn match svnlogDate	/ \d\{4}-\d\{2}-\d\{2}/hs=s+1	contained
    syn region svnlogInfo	start='^r\d' end='$' contains=svnlogRevision,svnlogUser,svnlogUser
    hi link svnlogRevision	Constant
    hi link svnlogUser		Type
    hi link svnlogDate		Identifier
  endif
endfunction

function! SVNAddConflictSyntax()
  syn region SVNConflictOrg start="^<<<<<<<" end="^====" contained
  syn region SVNConflictNew start="===$" end="^>>>>>>>" contained
  syn region SVNConflict start="^<<<<<<<" end=">>>>>>>.*" contains=SVNConflictOrg,SVNConflictNew keepend
"  hi link SVNConflict Special
  hi link SVNConflictOrg DiffChange
  hi link SVNConflictNew DiffAdd
endfunction

function! SVNMakeRO()
  set nomodified
  set readonly
  setlocal nomodifiable
endfunction

function! SVNMakeRW()
  set noreadonly
  setlocal modifiable
endfunction

function! SVNSetScratch()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
endfunction

" output window: open file under cursor by <doubleclick> or <shift-cr>
function! SVNUpdateMapping()
  nmap <buffer> <2-LeftMouse> :call SVNFindFile()<cr>
  nmap <buffer> <S-CR> :call SVNFindFile()<cr>
  nmap <buffer> q :bd!<cr>
  nmap <buffer> ? :call SVNShowMapping()<cr>
  nmap <buffer> <Leader>a :call SVNFindFile()<cr>:call SVNadd()<cr>
  nmap <buffer> <Leader>d :call SVNFindFile()<cr>:call SVNdiff()<cr>
  nmap <buffer> <Leader>i :call SVNFindFile()<cr>:call SVNcommit()<cr>
  nmap <buffer> <Leader>u :call SVNFindFile()<cr>:call SVNupdate()<cr>
  nmap <buffer> <Leader>s :call SVNFindFile()<cr>:call SVNstatus()<cr>
  nmap <buffer> <Leader>h :call SVNFindFile()<cr>:call SVNshortstatus()<cr>
  nmap <buffer> <Leader>c :call SVNFindFile()<cr>:call SVNlocalstatus()<cr>
  nmap <buffer> <Leader>v :call SVNFindFile()<cr>:call SVNrevertchanges()<cr>
endfunction

function! SVNShowMapping()
  echo 'Mappings in output buffer :'
  echo '<2-LeftMouse> , <SHIFT-CR>      : open file in new buffer'
  echo 'q                               : close output buffer'
  echo '?                               : show this help'
  echo '<Leader>a                       : open file and SVNadd'
  echo '<Leader>d                       : open file and SVNdiff'
  echo '<Leader>i                       : open file and SVNcommit'
  echo '<Leader>u                       : open file and SVNupdate'
  echo '<Leader>s                       : open file and SVNstatus'
  echo '<Leader>h                       : open file and SVNshortstatus'
  echo '<Leader>c                       : open file and SVNlocalstatus'
  echo '<Leader>v                       : open file and SVNrevertchanges'
endfunction

function! SVNFindFile()
  let curdir = getcwd()
  exec 'cd '.SVNEscapePath(g:workdir)
  normal 0W
  exec 'cd '.SVNEscapePath(curdir)
  unlet curdir
endfunction

"-----------------------------------------------------------------------------
" sort output		{{{1
"-----------------------------------------------------------------------------

" move all lines matching "searchstr" to top
function! SVNMoveToTop(searchstr)
  silent exec 'g/'.a:searchstr.'/m0'
endfunction

" only called by SVNshortstatus
function! SVNSortStatusOutput()
  " allow changes
  call SVNMakeRW()
  call SVNMoveToTop('Status: Unknown$')
  call SVNMoveToTop('Status: Needs Checkout$')
  call SVNMoveToTop('Status: Needs Merge$')
  call SVNMoveToTop('Status: Needs Patch$')
  call SVNMoveToTop('Status: Locally Removed$')
  call SVNMoveToTop('Status: Locally Added$')
  call SVNMoveToTop('Status: Locally Modified$')
  call SVNMoveToTop('Status: File had conflicts on merge$')
endfunction

" called by SVNDoCommand
function! SVNSortOutput()
  " allow changes
  call SVNMakeRW()
  " localstatus
  call SVNMoveToTop('^unknown:')
  call SVNMoveToTop('^unchanged:')
  call SVNMoveToTop('^missing:')
  call SVNMoveToTop('^modified:')
  " org svn
  call SVNMoveToTop('^? ')	" unknown
  call SVNMoveToTop('^T ')	" tag
  call SVNMoveToTop('^D ')	" delete
  call SVNMoveToTop('^N ')	" new
  call SVNMoveToTop('^U ')	" update
  call SVNMoveToTop('^M ')	" merge
  call SVNMoveToTop('^P ')	" patch
  call SVNMoveToTop('^C ')	" conflict
endfunction

"-----------------------------------------------------------------------------
" status variables		{{{1
"-----------------------------------------------------------------------------

function! SVNSaveOpts()
  let s:SVNROOTbak            = $SVNROOT
  let s:SVN_RSHbak            = $SVN_RSH
  let s:SVNOPTbak             = $SVNOPT
  let s:SVNCMDOPTbak          = $SVNCMDOPT
  let s:SVNCMDbak             = $SVNCMD
  let s:SVNforcedirectorybak  = g:SVNforcedirectory
  let s:SVNqueryrevisionbak   = g:SVNqueryrevision
  let s:SVNdumpandclosebak    = g:SVNdumpandclose
  let g:SVNsortoutputbak	= g:SVNsortoutput
  let g:SVNcompressoutputbak	= g:SVNcompressoutput
  let g:SVNtitlebarbak		= g:SVNtitlebar
  let g:SVNstatuslinebak	= g:SVNstatusline
  let g:SVNautocheckbak		= g:SVNautocheck
  let g:SVNofferrevisionbak	= g:SVNofferrevision
  let g:SVNsavediffbak		= g:SVNsavediff
  let g:SVNdontswitchbak	= g:SVNdontswitch
endfunction

function! SVNRestoreOpts()
  let $SVNROOT                = s:SVNROOTbak
  let $SVN_RSH                = s:SVN_RSHbak
  let $SVNOPT                 = s:SVNOPTbak
  let $SVNCMDOPT              = s:SVNCMDOPTbak
  let $SVNCMD                 = s:SVNCMDbak
  let g:SVNforcedirectory     = s:SVNforcedirectorybak
  let g:SVNqueryrevision      = s:SVNqueryrevisionbak
  let g:SVNdumpandclose       = s:SVNdumpandclosebak
  let g:SVNsortoutput		= g:SVNsortoutputbak
  let g:SVNcompressoutput	= g:SVNcompressoutputbak
  let g:SVNtitlebar		= g:SVNtitlebarbak
  let g:SVNstatusline		= g:SVNstatuslinebak
  let g:SVNautocheck		= g:SVNautocheckbak
  let g:SVNofferrevision	= g:SVNofferrevisionbak
  let g:SVNsavediff		= g:SVNsavediffbak
  let g:SVNdontswitch		= g:SVNdontswitchbak
  unlet g:SVNsortoutputbak g:SVNcompressoutputbak g:SVNtitlebarbak
  unlet g:SVNstatuslinebak g:SVNautocheckbak g:SVNofferrevisionbak
  unlet g:SVNsavediffbak g:SVNdontswitchbak
  unlet s:SVNROOTbak s:SVN_RSHbak s:SVNOPTbak s:SVNCMDOPTbak s:SVNCMDbak
  unlet s:SVNforcedirectorybak s:SVNqueryrevisionbak s:SVNdumpandclosebak
endfunction

" set scope : file or directory, inform user
function! SVNSetForceDir(value)
  let g:SVNforcedirectory=a:value
  if g:SVNforcedirectory==1
    echo 'SVN:Using current DIRECTORY once'
  elseif g:SVNforcedirectory==2
    echo 'SVN:Using current DIRECTORY'
  else
    echo 'SVN:Using current buffer'
  endif
endfunction

" Set output to statusline, close output buffer
function! SVNSetDumpAndClose(value)
  if a:value > 1
    echo 'SVN:output to status(file) and buffer(dir)'
  elseif a:value > 0
    echo 'SVN:output to statusline'
  else
    echo 'SVN:output to buffer'
  endif
  let g:SVNdumpandclose = a:value
endfunction

" enable/disable revs/branchs queries
function! SVNSetQueryRevision(value)
  if a:value > 0
    echo 'SVN:Enabled revision queries'
  else
    echo 'SVN:Not asking for revisions'
  endif
  let g:SVNqueryrevision = a:value
endfunction

" Sort output (group conflicts,updates,...)
function! SVNSetSortOutput(value)
  if a:value > 0
    echo 'SVN:sorting output'
  else
    echo 'SVN:unsorted output'
  endif
  let g:SVNsortoutput = a:value
endfunction

" compress output to one line
function! SVNSetCompressOutput(value)
  if a:value > 0
    echo 'SVN:compressed output'
  else
    echo 'SVN:full output'
  endif
  let g:SVNcompressoutput = a:value
endfunction

" output to statusline
function! SVNSetStatusline(value)
  if a:value > 0
    echo 'SVN:output to statusline'
  else
    echo 'SVN:no output to statusline'
  endif
  let g:SVNstatusline = a:value
endfunction

" output to titlebar
function! SVNSetTitlebar(value)
  if a:value > 0
    echo 'SVN:output to titlebar'
  else
    echo 'SVN:no output to titlebar'
  endif
  let g:SVNtitlebar = a:value
endfunction

" show local status (autocheck)
function! SVNSetAutocheck(value)
  if a:value > 0
    echo 'SVN:autochecking each file'
  else
    echo 'SVN:autocheck disabled'
  endif
  let g:SVNautocheck = a:value
endfunction

" show current revision as default, when asking for it
function! SVNSetOfferRevision(value)
  if a:value > 0
    echo 'SVN:offering current revision'
  else
    echo 'SVN:not offering current revision'
  endif
  let g:SVNofferrevision = a:value
endfunction

" SVNDiff : activate original or checked-out
function! SVNSetDontSwitch(value)
  if a:value > 0
    echo 'SVN:switching to compared file'
  else
    echo 'SVN:stay in original when diffing'
  endif
  let g:SVNdontswitch = a:value
endfunction

" save settings when using :diff
function! SVNSetSaveDiff(value)
  if a:value > 0
    echo 'SVN:saving settings for :diff'
  else
    echo 'SVN:not saving settings for :diff'
  endif
  let g:SVNsavediff = a:value
endfunction

function! SVNChDir(path)
  let g:orgpath = getcwd()
  let g:workdir = expand("%:p:h")
  exec 'cd '.SVNEscapePath(a:path)
endfunction

function! SVNRestoreDir()
  if isdirectory(g:orgpath)
    exec 'cd '.SVNEscapePath(g:orgpath)
  endif
endfunction

"}}}
"#############################################################################
" SVN commands
"#############################################################################
"-----------------------------------------------------------------------------
" SVN call		{{{1
"-----------------------------------------------------------------------------

" return > 0 if is win 95-me
function! SVNIsW9x()
  return has("win32") && (match($COMSPEC,"command\.com") > -1)
endfunction

function! SVNDoCommand(cmd,...)
  " needs to be called from orgbuffer
  let isfile = SVNUsesFile()
  " change to buffers directory
  call SVNChDir(expand('%:p:h'))
  " get file/directory to work on (if not given)
  if a:0 < 1
    if g:SVNforcedirectory > 0
      let filename=''
    else
      let filename=expand('%:p:t')
    endif
  else
    let filename = a:1
  endif
  " problem with win98se : system() gives an error
  " cannot open 'F:\WIN98\TEMP\VIo9134.TMP'
  " piping the password also seems to fail (maybe caused by svn.exe)
  " Using 'exec' creates a confirm prompt - only use this s**t on w9x
  if SVNIsW9x()
    let tmp=tempname()
    silent exec '!'.$SVNCMD.' '.$SVNOPT.' '.a:cmd.' '.$SVNCMDOPT.' '.filename.'>'.tmp
    exec 'split '.tmp
    let dummy=delete(tmp)
    unlet tmp dummy
  else
    let regbak=@z
    let cntenc=''
    let cmd=a:cmd
    if has('iconv') && g:SVNcmdencoding != ''
      let cmd=iconv(cmd, &encoding, g:SVNcmdencoding)
      let filename=iconv(filename, &encoding, g:SVNcmdencoding)
      let cntenc=g:SVNcmdencoding
    endif
    if &shell =~? 'cmd\.exe'
      let shellxquotebak=&shellxquote
      let &shellxquote='"'
    endif
    let @z=system($SVNCMD.' '.$SVNOPT.' '.cmd.' '.$SVNCMDOPT.' '.filename)
    if &shell =~? 'cmd\.exe'
      let &shellxquote=shellxquotebak
      unlet shellxquotebak
    endif
    let svncmd=matchstr(a:cmd,'\(^\| \)\zs\w\+\>')
    if (svncmd == 'annotate' || svncmd == 'update')
	  \&& g:SVNfileencoding != ''
      let cntenc=g:SVNfileencoding
    endif
    if has('iconv') && cntenc != ''
	  \&& ','.g:SVNdontconvertfor.',' !~ ','.svncmd.','
      let @z=iconv(@z, cntenc, &encoding)
    endif
    new
    silent normal "zP
    let @z=regbak
    unlet regbak cntenc cmd svncmd
  endif
  call SVNProcessOutput(isfile, filename, a:cmd)
  call SVNRestoreDir()
  unlet filename
endfunction

" also jumped in by SVNLocalStatus
function! SVNProcessOutput(isfile,filename,cmd)
  " delete leading and trainling blank lines
  while getline(1) == '' && line("$") > 1
    silent exec '0d'
  endwhile
  while getline("$") == '' && line("$") > 1
    silent exec '$d'
  endwhile
  " group conflicts, updates, ....
  if g:SVNsortoutput > 0
    silent call SVNSortOutput()
  endif
  " compress output ?
  if g:SVNcompressoutput > 0
    if (g:SVNdumpandclose > 0) && a:isfile
      silent call SVNCompressOutput(a:cmd)
    endif
  endif
  " move to top
  normal gg
  setlocal nowrap
  " reset single shot flag
  if g:SVNforcedirectory == 1
    let g:SVNforcedirectory = 0
  endif
  call SVNMakeRO()
  if (g:SVNdumpandclose == 1) || ((g:SVNdumpandclose == 2) && a:isfile)
    call SVNDumpAndClose()
  else
    if s:SVNdontupdatemapping == 0
      call SVNUpdateMapping()
    endif
    call SVNUpdateSyntax()
  endif
  let s:SVNdontupdatemapping = 0
endfunction

" return: 1=file 0=dir
function! SVNUsesFile()
  let filename=expand("%:p:t")
  if    ((g:SVNforcedirectory == 0) && (filename != ''))
"   \ || ((g:SVNforcedirectory > 0) && (filename == ''))
    return 1
  else
    return 0
  endif
  unlet filename
endfunction

" compress output
function! SVNCompressOutput(cmd)
    " commit
    if match(a:cmd,"commit") > -1
      let v:errmsg = ''
      silent! exec '/^svn \[commit aborted]:'
      " only compress, if no error found
      if v:errmsg != ''
	silent! exec 'g!/^new revision:/d'
      endif
    " skip localstatus
    elseif match(a:cmd,"localstatus") > -1
    " status
    elseif match(a:cmd,"status") > -1
      silent! exec 'g/^=\+$/d'
      silent! exec 'g/^$/d'
      silent! exec '%s/.*Status: //'
      silent! exec '%s/^\s\+Working revision:\s\+\([0-9.]*\).*/W:\1/'
      silent! exec '%s/^\s\+Repository revision:\s\+\([0-9.]*\).*/R:\1/'
      silent! exec '%s/^\s\+Sticky Tag:\s\+/T:/'
      silent! exec '%s/^\s\+Sticky Date:\s\+/D:/'
      silent! exec '%s/^\s\+Sticky Options:\s\+/O:/'
      silent! normal ggJJJJJJ
    endif
endfunction

" get version
function! SVNver()
  let rev=system($SVNCMD.' --version | cat | head -1 | grep --color=none -o "[0-9]\.[0-9]\.[0-9]"')
  return rev
endfunction

"#############################################################################
" following commands read from STDIN. Call SVN directly
"#############################################################################

"-----------------------------------------------------------------------------
" SVN login / logout (password prompt)		{{{1
"-----------------------------------------------------------------------------

function! SVNlogin(...)
  if a:0 == 0
    let pwpipe = ''
  else
    let pwpipe = 'echo'
    if !has("unix")
      if a:1 == ''
        let pwpipe = pwpipe . '.'
      endif
    endif
    if a:1 != ''
      if has("unix")
	" Piping works well because the clean escaping scenario, but I
	" have not found an environment where SVN actually accepts the
	" password from the pipe.  I am keeping this just in case it
	" works somewhere.
        let pwpipe = pwpipe . ' "' . escape(a:1,'!#%"`\') . '"'
      else
	" I failed to find a way to escape strings here for Windows
	" command lines without requiring a special external program.
	" So your password may not contain some special symbols like
	" `&', `|', and `"'.
        let pwpipe = pwpipe . ' '  . escape(a:1,'!#%')
      endif
    endif
    let pwpipe = pwpipe . '|'
  endif
  if has("unix")
    " show password prompt
    exec '!'.pwpipe.$SVNCMD.' '.$SVNOPT.' login '.$SVNCMDOPT
  else
    " shell is opened in win32 (dos?)
    silent! exec '!'.pwpipe.$SVNCMD.' '.$SVNOPT.' login '.$SVNCMDOPT
  endif
endfunction

function! SVNlogout()
  silent! exec '!'.$SVNCMD.' '.$SVNOPT.' logout '.$SVNCMDOPT
endfunction

"-----------------------------------------------------------------------------
" SVN release (confirmation prompt)		{{{1
"-----------------------------------------------------------------------------

function! SVNrelease()
  let localtoo=input('Release: Also delete local file [y]: ')
  if (localtoo=='y') || (localtoo=='')
    let localtoo='-d '
  else
    let localtoo=''
  endif
  let releasedir=expand('%:p:h')
  call SVNChDir(releasedir.s:sep.'..')
  " confirmation prompt -> dont use SVNDoCommand
  if has("unix")
    " show confirmation prompt
    exec '!'.$SVNCMD.' '.$SVNOPT.' release '.localtoo.releasedir.' '.$SVNCMDOPT
  else
    silent! exec '!'.$SVNCMD.' '.$SVNOPT.' release '.localtoo.releasedir.' '.$SVNCMDOPT
  endif
  call SVNRestoreDir()
  unlet localtoo releasedir
endfunction

"#############################################################################
" from here : use SVNDoCommand wrapper
"#############################################################################

"-----------------------------------------------------------------------------
" SVN diff (diffsplit)		{{{1
"-----------------------------------------------------------------------------

function! SVNdiff(...)
  if filewritable(expand("%h"))
    let tmp=localtime().expand("%:t")
  else
    if g:SVNusetmpfolder > 0
      let tmp="/tmp/".localtime().expand("%:t")
    else
      " Fail to write temp file. Bail out
      echo "Cannot write temp file. Try enabling SVNusetmpfolder to save temp file in /tmp"
      return
    endif
  endif
 let bak=@z
 let file=expand("%")
 call SVNBackupDiffMode()
 call SVNSwitchDiffMode()
 let @z=str2nr(system($SVNCMD.' status '.file.' | wc -l'))
 if (@z==0)
   let @z=system('cat '.file)
 else
   silent exec '!'.$SVNCMD.' diff '.file.' | patch -R -o '.tmp.' '.file
   let @z=system('cat '.tmp)
   silent exec '!rm '.tmp
 endif
 vne
 call SVNSetScratch()
 call SVNMakeRW()
 silent normal "zPGddgg
 difft
 let @z=bak
 unlet tmp file bak
 silent! nmap <unique> <buffer> q :bd<cr>:call SVNSwitchDiffMode()<cr>
endfunction

" diff to a specific revision
function! SVNdifftorev()
  " Force revision input
  let rev=SVNInputRev('Revision: ')
  if rev==''
    echo "SVN diff to revision: aborted"
    return
  endif
  call SVNdiff(rev)
  unlet rev
endfunction

"-----------------------------------------------------------------------------
" SVN diff / patchfile		{{{1
"-----------------------------------------------------------------------------
function! SVNgetdiff(parm)
  call SVNSaveOpts()
  let g:SVNdumpandclose = 0
  let g:SVNtitlebar = 1			" Notification output to titlebar
  " query revision
  let rev=SVNInputRev('Revision (optional): ')
  if rev!=''
    let rev=' -r '.rev.' '
  endif
  call SVNDoCommand('diff '.a:parm.rev)
  set syntax=diff
  call SVNRestoreOpts()
  unlet rev
endfunction

function! SVNdiffcontext()
  call SVNgetdiff('-c')
endfunction

function! SVNdiffstandard()
  call SVNgetdiff('')
endfunction

function! SVNdiffuni()
  call SVNgetdiff('-u')
endfunction


"-----------------------------------------------------------------------------
" SVN annotate / log / status / history		{{{1
"-----------------------------------------------------------------------------

function! SVNannotate()
  call SVNSaveOpts()
  let g:SVNdumpandclose = 0
  let g:SVNtitlebar = 0
  let s:SVNdontupdatemapping = 1
  if !exists('b:SVNentry')
    call SVNGetLocalStatus()
  endif
"  if exists('b:SVNentry')
"    let $SVNCMDOPT='-r ' . SVNSubstr(b:SVNentry,'/',2) . ' '
"  endif
  call SVNDoCommand('annotate -v',expand('%:p:t'))
  if g:SVNspacesinannotate > 0	" insert spaces to make TABs align better
    let spaces = ''
    let space_cnt = g:SVNspacesinannotate
    while space_cnt > 0
      let spaces = spaces . ' '
      let space_cnt = space_cnt - 1
    endwhile
    call SVNMakeRW()
    normal m`
    exec 'silent! :%s/):/):' . spaces . '/e'
    normal ``
    exec '%s/\d\d:\d\d:\d\d .\d\{4} (.\{-}) //'
    exec '0'
    call SVNMakeRO()
    unlet spaces space_cnt
  endif
  wincmd _
  call SVNRestoreOpts()
  silent! nmap <unique> <buffer> q :bwipeout<cr>
endfunction

function! SVNstatus()
  call SVNDoCommand('status')
endfunction

function! SVNstatus_dir()
  call SVNSetForceDir(1)
  call SVNstatus()
endfunction

function! SVNhistory()
  call SVNSaveOpts()
  let g:SVNdumpandclose = 0
  let s:SVNdontupdatemapping = 1
  call SVNDoCommand('history')
  call SVNRestoreOpts()
  silent! nmap <unique> <buffer> q :bwipeout<cr>
endfunction

function! SVNlog()
  call SVNSaveOpts()
  let g:SVNdumpandclose = 0
  if g:SVNqueryrevision > 0
    if g:SVNofferrevision > 0
      let default = '1.1:'.SVNSubstr(b:SVNentry,'/',2)
    else
      let default = ''
    endif
    let rev=input('Revisions (optional): ',default)
  else
    let rev=''
  endif
  if rev!=''
    let rev=' -r'.rev.' '
  endif
  let s:SVNdontupdatemapping = 1
  call SVNDoCommand('log'.rev)
  call SVNRestoreOpts()
  silent! nmap <unique> <buffer> q :bwipeout<cr>
endfunction

function! SVNlog_dir()
  call SVNSetForceDir(1)
  call SVNlog()
endfunction

" log between specific revisions
function! SVNlogtorev()
  let querybak=g:SVNqueryrevision
  let g:SVNqueryrevision = 1
  call SVNlog()
  let g:SVNqueryrevision=querybak
  unlet querybak
endfunction

"-----------------------------------------------------------------------------
" SVN watch / edit : common		{{{1
"-----------------------------------------------------------------------------

function! SVNQueryAction()
  let action=input('Action (e)dit, (u)nedit, (c)ommit, (a)ll, [n]one: ')
  if action == 'e'
    let action = '-a edit '
  elseif action == 'u'
    let action = '-a unedit '
  elseif action == 'a'
    let action = '-a all '
  else
    let action = ''
  endif
  return action
endfunction

"-----------------------------------------------------------------------------
" SVN edit		{{{1
"-----------------------------------------------------------------------------

function! SVNwatcheditors()
  call SVNDoCommand('editors')
endfunction

function! SVNwatchedit()
  let action=SVNQueryAction()
  call SVNDoCommand('edit '.action)
  unlet action
endfunction

function! SVNwatchunedit()
  "call SVNDoCommand('unedit')
  " Do not use the original method of SVNDoCommand since `svn unedit'
  " may prompt to revert changes if svnnt is used.
  silent! exec '!'.$SVNCMD.' '.$SVNOPT.' unedit '.$SVNCMDOPT.' '.file
  unlet filename
endfunction

"-----------------------------------------------------------------------------
" SVN watch		{{{1
"-----------------------------------------------------------------------------

function! SVNwatchwatchers()
  call SVNDoCommand('watchers')
endfunction

function! SVNwatchadd()
  let action=SVNQueryAction()
  call SVNDoCommand('watch add '.action)
  unlet action
endfunction

function! SVNwatchremove()
  call SVNDoCommand('watch remove')
endfunction

function! SVNwatchon()
  call SVNDoCommand('watch on')
endfunction

function! SVNwatchoff()
  call SVNDoCommand('watch off')
endfunction

"-----------------------------------------------------------------------------
" SVN tag		{{{1
"-----------------------------------------------------------------------------

function! SVNDoTag(usertag,tagopt)
  " force tagname input
  let tagname = SVNEscapeMessage(input('tagname: '))
  if tagname==''
    echo 'SVN tag: aborted'
    return
  endif
  " if rtag, force module instead local copy
  if a:usertag > 0
    let tagcmd = 'rtag '
    let module = input('Enter module name: ')
    if module == ''
      echo 'SVN rtag: aborted'
      return
    endif
    let target = module
    unlet module
  else
    let tagcmd = 'tag '
    let target = ''
  endif
  " g:SVNqueryrevision ?
  " tag by date, revision or local
  let tagby=input('Tag by (d)ate, (r)evision (default:none): ')
  if (tagby == 'd')
    let tagby='-D '
    let tagwhat=input('Enter date: ')
  elseif tagby == 'r'
    let tagby='-r '
    let tagwhat=SVNInputRev('Revision (optional): ')
  else
    let tagby = ''
  endif
  " input date / revision
  if tagby != ''
    if tagwhat == ''
      echo 'SVN tag: aborted'
      return
    else
      let tagwhat = tagby.tagwhat.' '
    endif
  else
    let tagwhat = ''
  endif
  " check if working file is unchanged (if not rtag)
  if a:usertag == 0
    let checksync=input('Override sync check [n]: ')
    if (checksync == 'n') || (checksync == '')
      let checksync='-c '
    else
      let checksync=''
    endif
  else
    let checksync=''
  endif
  call SVNDoCommand(tagcmd.' '.a:tagopt.checksync.tagwhat.tagname,target)
  unlet checksync tagname tagcmd tagby tagwhat target
endfunction

" tag local copy (usertag=0)
function! SVNtag()
  call SVNDoTag(0,'')
endfunction

function! SVNtagremove()
  call SVNDoTag(0,'-d ')
endfunction

function! SVNbranch()
  call SVNDoTag(0,'-b ')
endfunction

" tag module (usertag=1)
function! SVNrtag()
  call SVNDoTag(1,'')
endfunction

function! SVNrtagremove()
  call SVNDoTag(1,'-d ')
endfunction

function! SVNrbranch()
  call SVNDoTag(1,'-b ',)
endfunction

"-----------------------------------------------------------------------------
" SVN update / query update		{{{1
"-----------------------------------------------------------------------------

function! SVNupdate()
  " ask for revisions to merge/join (if wanted)
  if g:SVNqueryrevision > 0
    let rev=SVNInputRev('Revision (optional): ')
    if rev!=''
      let rev='-r '.rev.' '
    endif
    let mergerevstart=SVNInputRev('Merge from 1st Revision (optional): ')
    if mergerevstart!=''
      let mergerevstart='-j '.mergerevstart.' '
    endif
    let mergerevend=SVNInputRev('Merge from 2nd Revision (optional): ')
    if mergerevend!=''
      let mergerevend='-j '.mergerevend.' '
    endif
  else
    let rev = ''
    let mergerevstart = ''
    let mergerevend = ''
  endif
  " update or query
  if s:SVNupdatequeryonly > 0
    " svn server (v1.11.15): -z option causes error message when
    " invoking "update" with -n parameter.
    let svnoptbak = $SVNOPT
    let oldkeyword = &iskeyword
    set iskeyword=!-~
    let removpat = '\<-z[ \t]*[0-9]\>'      " remove the '-z #' option
    let removidx = match($SVNOPT,removpat)
    let mlen = strlen(matchstr($SVNOPT,removpat))
    let &iskeyword = oldkeyword
    if removidx >= 0
      let $SVNOPT = strpart($SVNOPT,0,removidx).strpart($SVNOPT,removidx+mlen)
    endif
    call SVNDoCommand('-n update -P '.rev.mergerevstart.mergerevend)
    let $SVNOPT = svnoptbak
    unlet svnoptbak oldkeyword removpat removidx mlen
  else
    call SVNDoCommand('update '.rev.mergerevstart.mergerevend)
  endif
  unlet rev mergerevstart mergerevend
endfunction

function! SVNupdate_dir()
  call SVNSetForceDir(1)
  call SVNupdate()
endfunction

function! SVNqueryupdate()
  let s:SVNupdatequeryonly = 1
  call SVNupdate()
  let s:SVNupdatequeryonly = 0
endfunction

function! SVNqueryupdate_dir()
  call SVNSetForceDir(1)
  call SVNqueryupdate()
endfunction

function! SVNupdatetorev()
  " Force revision input
  let rev=SVNInputRev('Revision: ')
  if rev==''
    echo "SVN Update to revision: aborted"
    return
  endif
  let rev='-r '.rev.' '
  " save old state
  call SVNSaveOpts()
  let $SVNCMDOPT=rev
  " call update
  call SVNupdate()
  " restore options
  call SVNRestoreOpts()
  unlet rev
endfunction

function! SVNupdatemergerev()
  " Force revision input
  let mergerevstart=SVNInputRev('Merge from 1st Revision: ')
  if mergerevstart==''
    echo "SVN merge revision: aborted"
    return
  endif
  let mergerevstart='-j '.mergerevstart.' '
  " save old state
  call SVNSaveOpts()
  let $SVNCMDOPT=mergerevstart
  " call update
  call SVNupdate()
  " restore options
  call SVNRestoreOpts()
  unlet mergerevstart
endfunction

function! SVNupdatemergediff()
  " Force revision input
  let mergerevstart=SVNInputRev('Merge from 1st Revision: ')
  if mergerevstart==''
    echo "SVN merge revision diffs: aborted"
    return
  endif
  let mergerevend=SVNInputRev('Merge from 2nd Revision: ')
  if mergerevend==''
    echo "SVN merge revision diffs: aborted"
    return
  endif
  let mergerevstart='-j '.mergerevstart.' '
  let mergerevend='-j '.mergerevend.' '
  " save old state
  call SVNSaveOpts()
  let $SVNCMDOPT=mergerevstart.mergerevend
  " call update
  call SVNupdate()
  " restore options
  call SVNRestoreOpts()
endfunction

"-----------------------------------------------------------------------------
" SVN remove (request confirmation)		{{{1
"-----------------------------------------------------------------------------

function! SVNremove()
  " remove from rep. also local ?
  if g:SVNforcedirectory>0
    let localtoo=input('Remove: Also delete local DIRECTORY [y]: ')
  else
    let localtoo=input('Remove: Also delete local file [y]: ')
  endif
  if (localtoo=='y') || (localtoo=='')
    let localtoo='-f '
  else
    let localtoo=''
  endif
  " force confirmation
  let confrm=input('Remove: confirm with "y": ')
  if confrm!='y'
    echo 'SVN remove: aborted'
    return
  endif
  call SVNDoCommand('remove '.localtoo)
  unlet localtoo
endfunction

function! SVNremove_dir()
  call SVNSetForceDir(1)
  call SVNremove()
endfunction

"-----------------------------------------------------------------------------
" SVN add		{{{1
"-----------------------------------------------------------------------------

function! SVNadd()
  if (g:SVNusedefaultmsg =~ 'a') && ((g:SVNallowemptymsg =~ 'a') || (g:SVNdefaultmsg != ''))
    let message = g:SVNdefaultmsg
  else
    " force message input
    let message = SVNEscapeMessage(input('Message: '))
  endif
  if (g:SVNallowemptymsg !~ 'a') && (message == '')
    echo 'SVN add: aborted'
    return
  endif
  call SVNDoCommand('add -m "'.message.'"')
  unlet message
endfunction

function! SVNadd_dir()
  call SVNSetForceDir(1)
  call SVNadd()
endfunction

"-----------------------------------------------------------------------------
" SVN commit		{{{1
"-----------------------------------------------------------------------------

function! SVNcommit()
  if (&modified || expand('%') == '') && (g:SVNforcedirectory == 0)
    echo 'SVN commit: file not saved!'
    return
  endif
  if (g:SVNusedefaultmsg =~ 'i') && (g:SVNdefaultmsg != '')
    let message = g:SVNdefaultmsg
  else
    " force message input
    let message = SVNEscapeMessage(input('Message: '))
  endif
  if (g:SVNallowemptymsg !~ 'i') && (message == '')
    echo 'SVN commit: aborted'
    return
  endif
  " query revision (if wanted)
  if g:SVNqueryrevision > 0
    let rev=SVNInputRev('Revision (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-r '.rev.' '
  endif
  if g:SVNforcedirectory > 0
    let forcedir=1
  else
    let forcedir=0
  endif
  if g:SVNreloadaftercommit > 0 && forcedir == 0
    checktime
    " Using 'FileChangedShell' is a trick to avoid the Vim prompt to
    " reload the file
    exec 'au FileChangedShell * let $SVNOPT=$SVNOPT'
  endif
  call SVNDoCommand('commit -m "'.message.'" '.rev)
  if g:SVNreloadaftercommit > 0 && forcedir == 0
    checktime
    exec 'au! FileChangedShell *'
    let laststatus=g:SVNlaststatus
    edit
    redraw!
    echo laststatus
    let g:SVNlaststatus=laststatus
    unlet laststatus
  endif
  unlet message rev forcedir
endfunction

function! SVNcommit_dir()
  call SVNSetForceDir(1)
  call SVNcommit()
endfunction

function! SVNcommitrevision()
  let querybak=g:SVNqueryrevision
  let g:SVNqueryrevision=1
  call SVNcommit()
  let g:SVNqueryrevision=querybak
endfunction

"-----------------------------------------------------------------------------
" SVN join in		{{{1
"-----------------------------------------------------------------------------

function! SVNjoinin(...)
  if a:0 == 1
    let message = a:1
  elseif g:SVNusedefaultmsg =~ 'j' && g:SVNdefaultmsg != ''
    let message = g:SVNdefaultmsg
  else
    " force message input
    let message = SVNEscapeMessage(input('Message: '))
    if (g:SVNallowemptymsg !~ 'j') && (message == '')
      echo 'SVN add/commit: aborted'
      return
    endif
  endif
  " query revision (if wanted)
  if g:SVNqueryrevision > 0
    let rev=SVNInputRev('Revision (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-r '.rev.' '
  endif
  call SVNDoCommand('add -m "'.message.'"')
  call SVNDoCommand('commit -m "'.message.'" '.rev)
  call SVNLocalStatus()
  unlet message rev
endfunction

function! SVNjoininrevision()
  let querybak=g:SVNqueryrevision
  let g:SVNqueryrevision=1
  call SVNjoinin()
  let g:SVNqueryrevision=querybak
endfunction

"-----------------------------------------------------------------------------
" SVN import		{{{1
"-----------------------------------------------------------------------------

function! SVNimport()
  if (g:SVNusedefaultmsg =~ 'p') && (g:SVNdefaultmsg != '')
    let message = g:SVNdefaultmsg
  else
    " force message input
    let message = SVNEscapeMessage(input('Message: '))
  endif
  if (g:SVNallowemptymsg !~ 'p') && (message == '')
    echo 'SVN import: aborted'
    return
  endif
  " query branch (if wanted)
  if g:SVNqueryrevision > 0
    let rev=input('Branch (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-b '.rev.' '
  endif
  " query vendor tag
  let vendor=input('Vendor tag: ')
  if vendor==''
    echo 'SVN import: aborted'
    return
  endif
  " query release tag
  let release=input('Release tag: ')
  if release==''
    echo 'SVN import: aborted'
    return
  endif
  " query module
  let module=input('Module: ')
  if module==''
    echo 'SVN import: aborted'
    return
  endif
  " only works on directories
  call SVNDoCommand('import -m "'.message.'" '.rev.module.' '.vendor.' '.release)
  unlet message rev vendor release
endfunction

function! SVNimportrevision()
  let querybak=g:SVNqueryrevision
  let g:SVNqueryrevision=1
  call SVNimport()
  let g:SVNqueryrevision=querybak
endfunction

"-----------------------------------------------------------------------------
" SVN checkout		{{{1
"-----------------------------------------------------------------------------

function! SVNcheckout()
  let destdir=expand('%:p:h')
  let destdir=input('Checkout to: ',destdir)
  if destdir==''
    return
  endif
  let module=input('Module name: ')
  if module==''
    echo 'SVN checkout: aborted'
    return
  endif
  " query revision (if wanted)
  if g:SVNqueryrevision > 0
    let rev=SVNInputRev('Revision (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-r '.rev.' '
  endif
  call SVNChDir(destdir)
  call SVNDoCommand('checkout '.rev.module)
  call SVNRestoreDir()
  unlet destdir module rev
endfunction

function! SVNcheckoutrevision()
  let querybak=g:SVNqueryrevision
  let g:SVNqueryrevision=1
  call SVNcheckout()
  let g:SVNqueryrevision=querybak
endfunction
"}}}
"#############################################################################
" extended commands
"#############################################################################
"-----------------------------------------------------------------------------
" revert changes, shortstatus		{{{1
"-----------------------------------------------------------------------------

function! SVNrevertchanges()
  let filename=expand("%:p:t")
  call SVNChDir(expand("%:p:h"))
  if filename == ''
    echo 'Revert changes:only on files'
    return
  endif
  if delete(filename) != 0
    echo 'Revert changes:could not delete file'
    return
  endif
  call SVNSaveOpts()
  "let $SVNCMDOPT='-A '
  call SVNupdate()
  call SVNRestoreOpts()
  call SVNRestoreDir()
endfunction

" get status info, compress it (one line/file), sort by status
function! SVNshortstatus()
  let isfile = SVNUsesFile()
  " save flags
  let filename = expand("%:p:t")
  let savedump = g:SVNdumpandclose
  let forcedirbak = g:SVNforcedirectory
  " output needed
  let g:SVNdumpandclose=0
  silent call SVNstatus()
  call SVNMakeRW()
  silent call SVNCompressStatus()
  if g:SVNsortoutput > 0
    silent call SVNSortStatusOutput()
  endif
  normal gg
  call SVNMakeRO()
  " restore flags
  let g:SVNdumpandclose = savedump
  if forcedirbak == 1
    let g:SVNforcedirectory = 0
  else
    let g:SVNforcedirectory = forcedirbak
  endif
  if   (g:SVNdumpandclose == 1) || ((g:SVNdumpandclose == 2) && isfile)
    call SVNDumpAndClose()
  endif
  unlet savedump forcedirbak filename isfile
endfunction

function! SVNshortstatus_dir()
  call SVNSetForceDir(1)
  call SVNshortstatus()
endfunction

"-----------------------------------------------------------------------------
" tools: output processing, input query		{{{1
"-----------------------------------------------------------------------------

" Dump output to statusline, close output buffer
function! SVNDumpAndClose()
  " collect in reg. z first, otherwise func
  " will terminate, if user stops output with "q"
  let curlin=1
  let regbak=@z
  let @z = getline(curlin)
  while curlin < line("$")
    let curlin = curlin + 1
    let @z = @z . "\n" . getline(curlin)
  endwhile
  " appends \n on winnt
  "exec ":1,$y z"
  set nomodified
  bwipeout
  if g:SVNstatusline
    redraw
    " statusline may be cleared otherwise
    let g:SVNlaststatus=@z
    echo @z
  endif
  if g:SVNtitlebar
    let cleantitle = substitute(@z,'\t\|\r\|\s\{2,\}',' ','g')
    let cleantitle = substitute(cleantitle,"\n",' ',"g")
    let &titlestring = '%t%( %M%) (%<%{expand("%:p:h")}) - '.cleantitle
    let b:SVNbuftitle = &titlestring
    unlet cleantitle
  endif
  let @z=regbak
endfunction

" leave only leading line with status info (for SVNshortstatus)
function! SVNCompressStatus()
  exec 'g!/^File:\|?/d'
endfunction

" delete stderr ('checking out...')
" SVN checkout ends with ***************(15)
function! SVNStripHeader()
  call SVNMakeRW()
  silent! exec '1,/^\*\{15}$/d'
endfunction

function! SVNInputRev(...)
  if !exists("b:SVNentry")
    let b:SVNentry = ''
  endif
  if a:0 == 1
    let query = a:1
  else
    let query = ''
  endif
  if g:SVNofferrevision > 0
    let default = SVNSubstr(b:SVNentry,'/',2)
  else
    let default = ''
  endif
  return input(query,default)
endfunction

"-----------------------------------------------------------------------------
" quick get file.		{{{1
"-----------------------------------------------------------------------------

function! SVNGet(...)
  " Params :
  " 0:ask file,rep
  " 1:filename
  " 2:repository
  " 3:string:i=login,o=logout
  " 4:string:login password
  " save flags, do not destroy SVNSaveOpts
  let svnoptbak=$SVNCMDOPT
  let outputbak=g:SVNdumpandclose
    let rep=''
    let log=''
  " eval params
  if     a:0 > 2	" file,rep,logflag[,logpw]
    let fn  = a:1
    let rep = a:2
    let log = a:3
  elseif a:0 > 1	" file,rep
    let fn  = a:1
    let rep = a:2
  elseif a:0 > 0	" file: (use current rep)
    let fn  = a:1
  endif
  if fn == ''		" no name:query file and rep
    let rep=input("SVNROOT: ")
    let fn=input("Filename: ")
  endif
  " still no filename : abort
  if fn == ''
    echo "SVN Get: aborted"
  else
    " prepare param
    if rep != ''
      let $SVNOPT = '-d'.rep
    endif
    " no output windows
    let g:SVNdumpandclose=0
    " login
    if match(log,'i') > -1
      if (a:0 == 4)	" login with pw (if given)
        call SVNlogin(a:4)
      else
        call SVNlogin()
      endif
    endif
    " get file
"    call SVNDoCommand('checkout -p',fn)
    call SVNDoCommand('checkout',fn)
    " delete stderr ('checking out...')
    if !SVNIsW9x()
      call SVNStripHeader()
    endif
    set nomodified
    " logout
    if match(log,'o') > -1
      call SVNlogout()
    endif
  endif
  " restore flags, cleanup
  let g:SVNdumpandclose=outputbak
  let $SVNOPT=svnoptbak
  unlet fn rep outputbak svnoptbak
endfunction

"-----------------------------------------------------------------------------
" Download help and install		{{{1
"-----------------------------------------------------------------------------

function! SVNInstallUpdates()
  if confirm("Install updates: Close all buffers, first !","&Cancel\n&Ok") < 2
    echo 'SVN Install updates: aborted'
    return
  endif
  call SVNDownloadUpdates()
  if match(getline(1),'^\*svnmenu.txt\*') > -1
    call SVNInstallAsHelp('svnmenu.txt')
    let helpres="Helpfile installed"
  else
    let helpres="Error: Helpfile not installed"
  endif
  bwipeout
  redraw
  if match(getline(1),'^" SVNmenu.vim :') > -1
    call SVNInstallAsPlugin('svnmenu.vim')
    let plugres="Plugin installed"
  else
    let plugres="Error: Plugin not installed"
  endif
  bwipeout
  redraw
  echo helpres."\n".plugres
  echo "Changes take place in next vim session"
endfunction

function! SVNDownloadUpdates()
  call SVNGet('VimTools/svnmenu.vim',s:svnmenusvn,'i','')
  call SVNGet('VimTools/svnmenu.txt',s:svnmenusvn,'o','')
endfunction

function! SVNInstallAsHelp(...)
  " ask for name to save as (if not given)
  if (a:0 == 0) || (a:1 == '')
    let dest=input('Help file name (clear to abort): ','svnmenu.txt')
  else
    let dest=a:1
  endif
  " abort if still no filename
  if dest==''
    echo 'SVN Install help: aborted'
  else
    " create directory like "~/.vim/doc" if needed
    call SVNAssureLocalDirs()
    " copy to local doc dir
    exec 'w! '.s:localvimdoc.'/'.dest
    " create tags
    exec 'helptags '.s:localvimdoc
  endif
  unlet dest
endfunction

function! SVNInstallAsPlugin(...)
  " ask for name to save as
  if (a:0 == 0) || (a:1 == '')
    let dest=input('Plugin file name (clear to abort): ','svnmenu.vim')
  else
    let dest=a:1
  endif
  " abort if still no filename
  if dest==''
    echo 'SVN Install plugin: aborted'
  else
    " copy to plugin dir
    exec 'w! '.s:script_path.s:sep.dest
  endif
  unlet dest
endfunction

"-----------------------------------------------------------------------------
" user directories / SVNLinks		{{{1
"-----------------------------------------------------------------------------

function! SVNOpenLinks()
  let links=s:localvim.s:sep.'svnlinks.vim'
  call SVNAssureLocalDirs()
  if !filereadable(links)
    let @z = "\" ~/svnlinks.vim\n"
      \ . "\" move to a command and press <shift-cr> to execute it\n"
      \ . "\" (one-liners only).\n\n"
      \ . "nmap <buffer> <s-cr> :exec getline('.')<cr>\n"
      \ . "finish\n\n"
      \ . "\" add modifications below here\n\n"
      \ . "\" look for a new Vim\n"
      \ . "\" login, get latest Vim README.txt, logout\n"
      \ . "call SVNGet('vim/README.txt', ':pserver:anonymous@svn.vim.org:/svnroot/vim', 'io', '')\n\n"
      \ . "\" manual svnmenu update (-> SVN.Settings.Install buffer as...)\n"
      \ . "\" login, get latest version of svnmenu.vim\n"
      \ . "call SVNGet('VimTools/svnmenu.vim',':pserver:anonymous@ezytools.svn.sourceforge.net:/svnroot/ezytools','i','')\n"
      \ . "\" get latest svnmenu.txt, logout\n"
      \ . "call SVNGet('VimTools/svnmenu.vim',':pserver:anonymous@ezytools.svn.sourceforge.net:/svnroot/ezytools','o','')\n\n"
      \ . "\" Get some help on this\n"
      \ . "help SVNFunctions"
    call SVNChDir(s:localvim)
    new
    normal "zP
    exec ':x '.links
    call SVNRestoreDir()
  endif
  if !filereadable(links)
    echo 'SVNLinks: cannot access '.links
    return
  endif
  exec ':sp '.links
  exec ':so %'
  unlet links
endfunction

function! SVNAssureLocalDirs()
  if !isdirectory(s:localvimdoc)
    silent! exec '!mkdir '.s:localvimdoc
  endif
endfunction

function! SVNGetFolderNames()
  let s:localvim=s:script_path.s:sep.'..'
  let s:localvimdoc=s:localvim.s:sep.'doc'
endfunction

"-----------------------------------------------------------------------------
" LocalStatus : read from SVN/Entries		{{{1
"-----------------------------------------------------------------------------

function! SVNLocalStatus()
  " needs to be called from orgbuffer
  let isfile = SVNUsesFile()
  " change to buffers directory
  call SVNChDir(expand('%:p:h'))
  if g:SVNforcedirectory>0
    let filename=expand('%:p:h')
  else
    let filename=expand('%:p:t')
  endif
  let regbak=@z
  let @z = SVNCompare(filename)
  new
  " seems to be a vim bug : when executed as autocommand when doing ':help',
  " vim echoes 'not modifiable'
  set modifiable
  normal "zP
  call SVNProcessOutput(isfile, filename, '*localstatus')
  let @z=regbak
  call SVNRestoreDir()
  unlet filename
endfunction

function! SVNLocalStatus_dir()
  call SVNSetForceDir(1)
  call SVNLocalStatus()
endfunction

" get info from SVN/Entries about given/current buffer/dir
function! SVNCompare(...)
  " return, if no SVN dir
  if !filereadable(s:SVNentries)
    echo 'No '.s:SVNentries.' !'
    return
  endif
  " eval params
  if (a:0 == 1) && (a:1 != '')
    if filereadable(a:1)
      let filename = a:1
      let dirname  = ''
    else
      let filename = ''
      let dirname  = a:1
    endif
  else
    let filename = expand("%:p:t")
    let dirname  = expand("%:p:h")
  endif
  let result = ''
  if filename == ''
    let result = SVNGetLocalDirStatus(dirname)
  else
    let result = SVNGetLocalStatus(filename)
  endif  " filename given
  return result
endfunction

" get info from SVN/Entries about given file/current buffer
function! SVNGetLocalStatus(...)
  if a:0 == 0
    let filename = expand("%:p:t")
  else
    let filename = a:1
  endif
  if filename == ''
    return 'error:no filename'
  endif
  if a:0 > 1
    let entry=a:2
  else
    let entry=SVNGetEntry(filename)
  endif
  let b:SVNentry=entry
  let status = ''
  if entry == ''
    if isdirectory(filename)
      let status = "unknown:   <DIR>\t".filename"
    else
      let status = 'unknown:   '.filename
    endif
  else
    let entryver  = SVNSubstr(entry,'/',2)
    let entryopt  = SVNSubstr(entry,'/',4)
    let entrytag  = SVNSubstr(entry,'/',5)
    let entrytime = SVNtimeToStr(entry)
    if (!SVNUsesFile()) || (g:SVNfullstatus > 0)
      let status = filename."\t".entryver." ".entrytime." ".entryopt." ".entrytag
    else
      let status = entryver." ".entrytag." ".entryopt
    endif
    if !filereadable(filename)
      if isdirectory(filename)
        let status = 'directory: '.filename
      else
	if entry[0] == 'D'
          let status = "missing:   <DIR>\t".filename
	else
          let status = 'missing:   '.status
	endif
      endif
    else
      if entrytime == SVNFiletimeToStr(filename)
	let status = 'unchanged: '.status
      else
	let status = 'modified:  '.status
      endif " time identical
    endif " file exists
    if SVNUsesFile()
      let status = substitute(status,':','','g')
      let status = substitute(status,'\s\{2,}',' ','g')
    endif
  endif  " entry found
  unlet entry
  return status
endfunction

" get info on all files from SVN/Entries and given/current directory
" opens SVN/Entries only once, passing each entryline to SVNGetLocalStatus
function! SVNGetLocalDirStatus(...)
  let zbak = @z
  let ybak = @y
  if a:0 == 0
    let dirname = expand("%:p:h")
  else
    let dirname = a:1
  endif
  call SVNChDir(dirname)
  let @z = glob("*")
  new
  silent! exec 'read '.s:SVNentries
  let entrycount = line("$") - 1
  normal k"zP
  if (line("$") == entrycount) && (getline(entrycount) == '')
    " empty directory
    set nomodified
    return
  endif
  let filecount = line("$") - entrycount
  " collect status of all found files in @y
  let @y = ''
  let curlin = 0
  while curlin < filecount
    let curlin = curlin + 1
    let fn=getline(curlin)
    if fn != 'SVN'
      let search=escape(fn,'.')
      let v:errmsg = ''
      " find SVNEntry
      silent! exec '/^D\?\/'.search.'\//'
      if v:errmsg == ''
        let entry = getline(".")
	" clear found file from SVN/Entries
	silent! exec 's/.*//eg'
      else
	let entry = ''
      endif
      " fetch info
      let @y = @y . SVNGetLocalStatus(fn,entry) . "\n"
    endif
  endwhile
  " process files from SVN/Entries
  let curlin = filecount
  while curlin < line("$")
    let curlin = curlin + 1
    let entry = getline(curlin)
    let fn=SVNSubstr(entry,'/',1)
    if fn != ''
      let @y = @y . SVNGetLocalStatus(fn,entry) . "\n"
    endif
  endwhile
  set nomodified
  let result = @y
  bwipeout
  call SVNRestoreDir()
  let @z = zbak
  let @y = ybak
  unlet zbak ybak
  return result
endfunction

" return info about filename from 'SVN/Entries'
function! SVNGetEntry(filename)
  let result = ''
  if a:filename != ''
    silent! exec 'split '.s:SVNentries
    let v:errmsg = ''
    let search=escape(a:filename,'.')
    silent! exec '/^D\?\/'.search.'\//'
    if v:errmsg == ''
      let result = getline(".")
    endif
    set nomodified
    silent! bwipeout
  endif
  return result
endfunction

" extract and convert timestamp from SVNEntryItem
function! SVNtimeToStr(entry)
  return SVNAsctimeToStr(SVNSubstr(a:entry,'/',3))
endfunction
" get and convert filetime
" include local time zone info
function! SVNFiletimeToStr(filename)
  let time=getftime(a:filename)-(GMTOffset() * 60*60)
  return strftime('%Y-%m-%d %H:%M:%S',time)
endfunction

" entry format : ISO C asctime()
function! SVNAsctimeToStr(asctime)
  let mon=strpart(a:asctime, 4,3)
  let DD=SVNLeadZero(strpart(a:asctime, 8,2))
  let hh=SVNLeadZero(strpart(a:asctime, 11,2))
  let nn=SVNLeadZero(strpart(a:asctime, 14,2))
  let ss=SVNLeadZero(strpart(a:asctime, 17,2))
  let YY=strpart(a:asctime, 20,4)
  let MM=SVNMonthIdx(mon)
  " SVN/WinNT : no date given for merge-results
  if MM == ''
    let result = ''
  else
    let result = YY.'-'.MM.'-'.DD.' '.hh.':'.nn.':'.ss
  endif
  unlet YY MM DD hh nn ss mon
  return result
endfunction

" append a leading zero
function! SVNLeadZero(value)
  let nr=substitute(a:value,' ','','g')
  if nr =~ '0.'                         " Already has a leading zero
    return nr
  endif
  if nr < 10
    let nr = '0' . nr
  endif
  return nr
endfunction

" return month (leading zero) from cleartext
function! SVNMonthIdx(month)
  if match(a:month,'Jan') > -1
    return '01'
  elseif match(a:month,'Feb') > -1
    return '02'
  elseif match(a:month,'Mar') > -1
    return '03'
  elseif match(a:month,'Apr') > -1
    return '04'
  elseif match(a:month,'May') > -1
    return '05'
  elseif match(a:month,'Jun') > -1
    return '06'
  elseif match(a:month,'Jul') > -1
    return '07'
  elseif match(a:month,'Aug') > -1
    return '08'
  elseif match(a:month,'Sep') > -1
    return '09'
  elseif match(a:month,'Oct') > -1
    return '10'
  elseif match(a:month,'Nov') > -1
    return '11'
  elseif match(a:month,'Dec') > -1
    return '12'
  else
    return
endfunction

" divide string by sep, return field[index] .start at 0.
function! SVNSubstr(string,separator,index)
  let sub = ''
  let idx = 0
  let bst = 0
  while bst < strlen(a:string) && idx <= a:index
    if a:string[bst] == a:separator
      let idx = idx + 1
    else
      if (idx == a:index)
        let sub = sub . a:string[bst]
      endif
    endif
    let bst = bst + 1
  endwhile
  unlet idx bst
  return sub
endfunction

"Get difference between local time and GMT
"strftime() returns the adjusted time
"->strftime(0) GMT=00:00:00, GMT+1=01:00:00
"->midyear=summertime: strftime(182*24*60*60)=02:00:00 (GMT+1)
"linux bug:wrong CEST information before 1980
"->use 331257600 = 01.07.80 00:00:00
function! GMTOffset()
  let winter1980 = (10*365+2)*24*60*60      " = 01.01.80 00:00:00
  let summer1980 = winter1980+182*24*60*60  " = 01.07.80 00:00:00
  let summerhour = strftime("%H",summer1980)
  let summerzone = strftime("%Z",summer1980)
  let winterhour = strftime("%H",winter1980)
  let winterday  = strftime("%d",winter1980)
  let curzone    = strftime("%Z",localtime())
  if curzone == summerzone
    let result = summerhour
  else
    let result = winterhour
  endif
  if result =~ '0.'                     " Leading zero will cause the number
    let result = strpart(result, 1)     " be regarded as octals
  endif
  " GMT - x : invert sign
  if winterday == 31
    let result = result - 24
  endif
  unlet curzone winterday winterhour summerzone summerhour summer1980 winter1980
  return result
endfunction

"-----------------------------------------------------------------------------
" Autocommand : set title, restore diffmode		{{{1
"-----------------------------------------------------------------------------

" restore title
function! SVNBufEnter()
  " set/reset title
  if g:SVNtitlebar
    if !exists("b:SVNbuftitle")
      let &titlestring = s:SVNorgtitle
    else
      let &titlestring = b:SVNbuftitle
    endif
  endif
endfunction

" show status, add syntax
function! SVNBufRead()
  " query status if wanted, file and SVNdir exist
  if (g:SVNautocheck > 0)
   \ && (expand("%:p:t") != '')
   \ && filereadable(expand("%:p:h").s:sep.s:SVNentries)
    call SVNLocalStatus()
  endif
  " highlight conflicts on every file
  call SVNAddConflictSyntax()
endfunction

" show status
function! SVNBufWrite()
  " query status if wanted, file and SVNdir exist
  if (g:SVNautocheck > 0)
   \ && (expand("%:p:t") != '')
   \ && filereadable(expand("%:p"))
   \ && filereadable(expand("%:p:h").s:sep.s:SVNentries)
    call SVNLocalStatus()
  endif
endfunction

" save pre diff settings
function! SVNDiffEnter()
  let g:SVNdifforgbuf = bufnr('%')
  let g:SVNbakdiff		= &diff
  let g:SVNbakscrollbind	= &scrollbind
  let g:SVNbakwrap		= &wrap
  let g:SVNbakfoldcolumn	= &foldcolumn
  let g:SVNbakfoldenable	= &foldenable
  let g:SVNbakfoldlevel		= &foldlevel
  let g:SVNbakfoldmethod	= &foldmethod
endfunction

" restore pre diff settings
function! SVNDiffLeave()
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&diff'	  , g:SVNbakdiff	)
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&scrollbind' , g:SVNbakscrollbind	)
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&wrap'	  , g:SVNbakwrap	)
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&foldcolumn' , g:SVNbakfoldcolumn	)
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&foldenable' , g:SVNbakfoldenable	)
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&foldlevel'  , g:SVNbakfoldlevel	)
  call setwinvar(bufwinnr(g:SVNdifforgbuf), '&foldmethod' , g:SVNbakfoldmethod	)
endfunction

" save original settings
function! SVNBackupDiffMode()
  let g:SVNorgdiff		= &diff
  let g:SVNorgscrollbind	= &scrollbind
  let g:SVNorgwrap		= &wrap
  let g:SVNorgfoldcolumn	= &foldcolumn
  let g:SVNorgfoldenable	= &foldenable
  let g:SVNorgfoldlevel		= &foldlevel
  let g:SVNorgfoldmethod	= &foldmethod
endfunction

" restore original settings
function! SVNRestoreDiffMode()
  let &diff			= g:SVNorgdiff
  let &scrollbind		= g:SVNorgscrollbind
  let &wrap			= g:SVNorgwrap
  let &foldcolumn		= g:SVNorgfoldcolumn
  let &foldenable		= g:SVNorgfoldenable
  let &foldlevel		= g:SVNorgfoldlevel
  let &foldmethod		= g:SVNorgfoldmethod
endfunction

" this is useful for mapping
function! SVNSwitchDiffMode()
  if &diff
    call SVNRestoreDiffMode()
  else
    diffthis
  endif
endfunction

" remember restoring prediff mode
function! SVNDiffPrepareLeave()
  if match(expand("<afile>:e"),'dif','i') > -1
    " diffed buffer gets unloaded twice by :vert diffs
    " only react to the second unload
    let g:SVNleavediff = g:SVNleavediff + 1
    " restore prediff settings (see SVNPrepareLeave)
    if (g:SVNsavediff > 0) && (g:SVNleavediff > 1)
      call SVNDiffLeave()
      let g:SVNleavediff = 0
    endif
  endif
endfunction

" edit SVN log message
function! SVNCheckLogMsg()
  if &filetype == 'svn' && g:SVNeasylogmessage > 0
    let reg_bak=@"
    normal ggyy
    " insert an empty line if the first line begins with 'SVN:'
    if @" =~ '^SVN:'
      exec "normal i\<CR>\<C-O>k"
      set nomodified
    endif
    let @"=reg_bak
    " make <CR> save the log message and quit
    nmap <buffer> <CR> :x<CR>
    startinsert
  endif
endfunction

"-----------------------------------------------------------------------------
" finalization		{{{1
"-----------------------------------------------------------------------------

call SVNGetFolderNames()		" vim user directories
call SVNMakeLeaderMapping()		" create keymappings from menu shortcuts
call SVNBackupDiffMode()		" save pre :diff settings

" provide direct access to SVN commands, using dumping and sorting from this script
command! -nargs=+ -complete=expression -complete=file -complete=function -complete=var SVN call SVNDoCommand(<q-args>)

" highlight conflicts on every file
au BufRead * call SVNBufRead()
" update status on write
au BufWritePost * call SVNBufWrite()
" set title
au BufEnter * call SVNBufEnter()
" restore prediff settings
au BufWinLeave *.dif call SVNDiffPrepareLeave()
" insert an empty line and start in insert mode for the SVN log message
au BufRead svn*,\d\+ call SVNCheckLogMsg()

if !exists("loaded_svnmenu")
  let loaded_svnmenu=1
endif


"}}}
