Here's the things this project needs in order to make it decent:

# Core Architecture

## Tree Awareness

The command line tool currently only operates on individual files, it should be able to accept
a directory and recurse. It would assume the directory provided is the top level for an import
directive.

## Manifest

The tool should be able to build a manifest of files, constants, and mixins for use in creating
a table of contents.

## Output Formats

Implement a visitor pattern that can visit a manifest, file, mixin, or constant and emit
the correct output for it that matches a particular output format. 
This can be used for generating html, plain text, pdf, or whatever.

## Templates and Layouts

For at least the html generator, a user should be able to specify templates for the given
type and a layout for files to add headers, footer, etc. It would be awesome if these were
be written in haml, the stylesheets in Sass (using compass of course!) and then compiled into
html and css.

## Documentation Queries

There should be a mode of operation where a user can request plain text documentation on the
command line for a particular code artifact. It might look something like this:

    $ sassdoc --compass -q +alternating-rows-and-columns path/to/project/sass/files
    Mixin: +alternating-rows-and-columns(even_row_color, odd_row_color, dark_intersection[, header_color, footer_color])
    --------------------------------------------------------------------------------------------------------------------
    Sets background colors for a table so that rows and columns alternate and are shaded
    correctly.
    
    Parameter: even_row_color
      The color of even rows. Even rows must have the .even class on them
    Parameter: odd_row_color
      The color of odd rows. Odd rows must have the .odd class on them.
    Parameter: dark_intersection
      This color will be subracted from the row color for even columns.
    Parameter: header_color (default value: white)
      The color of the header.
    Parameter: footer_color (default value: white)
      The color of the footer.
    

## Implementation of Core Architecture

It's possible that much of this can be built on top of rdoc or some other code documentation tool
by implementing a parser plugin. I'm open to that possibility but I think it's a long shot.

# Implementation Details

## CLI

The CLI needs to be made more robust:

* It should accept import paths like the sass CLI does.
* Trap and report sass parser errors nicely.

## Frames Suck

Every code documentation tool uses framesets for it's output. This shouldn't be one of them. Frames blow because they make landing from a search engine a horrible experience. I like the [reference documentation used by Prototype](http://www.prototypejs.org/api/). I think we should shamelessly steal from them.

## Real world examples

We need some real projects to write documentation using SassDoc syntax and let us know what works, what doesn't, and what's missing.

# Contributing

Fork the main project and check in a change to the TODO file that indicates what you are working on.