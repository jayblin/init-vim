function MyTabTitleFormatter(n)
	" return luaeval('my_tab_title_formatter()', a:n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let bufnr = buflist[winnr - 1]
	let winid = win_getid(winnr, a:n)
	let title = bufname(bufnr)

	if empty(title)
		if getqflist({'qfbufnr' : 0}).qfbufnr == bufnr
			let title = '[Quickfix List]'
		elseif winid && getloclist(winid, {'qfbufnr' : 0}).qfbufnr == bufnr
			let title = '[Location List]'
		else
			let title = '[No Name]'
		endif
	endif

	return title
	
endfunction

" let g:airline#extensions#tabline#tabtitle_formatter = 'MyTabTitleFormatter'

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
