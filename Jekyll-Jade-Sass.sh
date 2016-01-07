#!/bin/bash
# This script will create a file structure expected by Jekyll, uses SCSS for css, and Jade for html.
# Requires: Jekyll, SASS and JADE

# NEW JEKYLL DIRECTORY STRUCTURE
# Create Jekyll config file
touch _config.yml

# Add config statements
printf "%s\n" \
	"markdown: kramdown" >> _config.yml

# Create Jekyll File Structure
mkdir {_drafts,_includes,_layouts,_posts}

# Create Asset folders
mkdir {_jade,js,img,css,_scss}

# Create Jade Files
touch _jade/{head.jade,header.jade,footer.jade,master.jade,post.jade,index.jade}

# Add YAML markup for Jekyll Engine
printf "%s\n" \
	"| ---"  \
	"| layout: master" \
	"| ---" \
	"//- equals with single quoted newline needed to transition from YAML front-matter to normal jade/html" \
	"= '\n'" >> _jade/index.jade	
printf "%s\n" \
	"| ---"  \
	"| layout: master" \
	"| ---" \
	"//- equals with single quoted newline needed to transition from YAML front-matter to normal jade/html" \
	"= '\n'" >> _jade/post.jade	
# Add doctype, head with common tags, and body tag

printf "%s\n" \
	"doctype html" \
	"html" \
	"	head" \
	"		link(rel='stylesheet' href='css/main.css')" \
	"		script(type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js')" \
	"		script(type='text/javascript' src='js/script.js')" \
	"		meta(name='viewport' content='width=device-width, initial-scale=1')" \
	"	body" \
	"		| {{ content }}" >> _jade/master.jade

# Create SCSS file structure
touch _scss/{main.scss,_variables.scss,_grid.scss,_typography.scss,_global-layout.scss,_mobile-layout.scss}

# Creates a makefile 
touch makefile

# Adds Recipes setting up a development environment using Jade, Sass, and Jekyll
printf "%s\n" \
	"SHELL := /bin/bash " \
	"" \
	"all: " \
	"	@cat makefile" \
	"" \
	"jade-index-watch:" \
	"	jade -w ./_jade/index.jade -o ./" \
	"" \
	"jade-includes-watch:" \
	"	jade -w ./_jade/{header,head,footer}.jade -o ./_includes" \
	"" \
	"jade-layouts-watch:" \
	"	jade -w ./_jade/{master,post}.jade -o ./_layouts" \
	"" \
	"sass-watch:" \
	"	sass --watch ./_scss:./css" \
	"" \
	"jekyll-watch:" \
	"	jekyll build --watch" \
	"" \
	"# need to use reload delay to refresh browser after jade and sass compile" \
	"browser-sync-serve:" \
	"	browser-sync start --files \"index.html,css/*.css,js/*.js\" --server \"_site\" --reload-delay \"450\"	" \
	"" \
	"# Runs all watch recipes concurently in a single terminal while creating a browser-sync server" \
	"dev-environment-run:" \
	"	make jade-index-watch jade-includes-watch jade-layouts-watch sass-watch jekyll-watch browser-sync-serve -j" >> makefile
