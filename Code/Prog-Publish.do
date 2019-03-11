////////////////////////////////////////////////////////
// Create program to publish a figure to blog
// - This command has to be run after a figure is created
////////////////////////////////////////////////////////

capture program drop publish // create program to publish figure to blog
program publish
	syntax [, name(string) path(string) title(string)]
	
	local home = "/users/dietz/dropbox/growthblog/growthecon" // location of Jekyll blog code
	local post = "_posts/stagnation" // subfolder for posts
	local path = "assets/stagnation" // subfolder for png/data files
	
	if $PUBLISH == 1 { // only perform these steps if flag set to 1
		quietly {
			graph export "`home'/`path'/`name'.png", replace as(png) // save png file
			graph save "`home'/`path'/`name'", replace // save gph file
			
			preserve // hold existing dataset
				serset 0 // access data from figure
				serset use, clear // load data from figure
				export delimited "`home'/`path'/`name'", nolabel replace // save data from figure as CSV
			restore
			
			capture file close f // write figure command to file
			file open f using "`home'/`path'/`name'.do", write replace // open do-file
			graph describe "`home'/`path'/`name'.gph" // use gph information
			local command = stritrim(r(command)) // save off the command used
			file write f `" `command' "' _n // write the command used

			capture file close f // write post file
			file open f using "`home'/`post'/1999-01-01-`name'.md", write replace
			file write f "---" _n
			file write f "title: `title'" _n // use the passed text as title
			file write f "layout: post" _n 
			file write f "category: stagnation" _n  
			file write f "data: /`path'/`name'.csv" _n
			file write f "code: /`path'/`name'.do" _n
			file write f "---" _n _n
			file write f "Links to [data](/`path'/`name'.csv) and [code](/`path'/`name'.do) " _n _n
			file write f "![`title'](/`path'/`name'.png)" _n
			capture file close f
		} // end quietly
	} // end if 
end	
