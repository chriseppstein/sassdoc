SassDoc
=======

SassDoc is a documentation tool for Sass libraries. It allows you to document the constants and mixins
of your sass files within the contents of the sass file for easy maintenance.

SassDoc Syntax
==============

To document a mixin you must make a comment prior to your mixin and mark it as documentation by adding two extra
asterisks to the start of the documentation. This can be used with silent comments (`//`) or loud comments (`/*`).

Parameters are documented with an `@parameter` declaration and the value of the documentation indented below.

Example
-------

    //**\\
      This file handles how to handle the styles of tables.

    //**
      The odd row color for a table
    !odd_row_color = red

    //**
      The even row color for a table
    !even_row_color = blue

    //**
      Sets background colors for a table so that rows and columns alternate and are shaded
      correctly.
      @parameter even_row_color
        The color of even rows. Even rows must have the .even class on them
      @parameter odd_row_color
        The color of odd rows. Odd rows must have the .odd class on them.
      @parameter dark_intersection
        This color will be subracted from the row color for even columns.
      @parameter header_color
        The color of the header.
      @parameter footer_color
        The color of the footer.

    =alternating-rows-and-columns(!even_row_color, !odd_row_color, !dark_intersection, !header_color = #FFF, !footer_color = #FFF)
      ...

Example Output (Plain Text)
---------------------------

    File: FileName
    --------------
    This file handles how to handle the styles of tables.

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

    Variable: !odd_row_color
    -------------------------
    The odd row color for a table

    Variable: !even_row_color
    --------------------------
    The even row color for a table
