# SinriXcodeBasement
~いろんなツールを独立して保存する~

## PrefixHeader

_Version 1.0, Since 2015 Feb 26_

Some common definitions could be used in nearly all projects for convenience.

## CommonUtil

_Version 1.0, Since 2015 Feb 26_

Common utilities including UI toolkit and system predefined class extensions.

## ActiveRow

_Version 1.0, Since 2015 Feb 26_

ActiveRow is a simple implement of horizontal UITableView. It uses DataSource and Delegate Protocol Structure as well.

It is almost the same with the design and usage of UITableView, but note that it is simplified:

*Direct UI Design*

Up to this version has not contained the header/footer alike design, and the size of each column (or Cell for familiarity) is defined in the DataSource Method.

*Light Memory Management*

It has no special memory management on column reusement. Only a column array is maintained for the storage of the columns. You can directly get the column object.

*MVC Design*

The column count and the UI for each column is defined by DataSource. It also use `reload` method to completely reload the columns. Comparely, it is not as cheap as UITableView, as it updates not only the visible columns but the entire column set.