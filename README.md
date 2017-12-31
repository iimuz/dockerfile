# jupyter-science

This jupyter is based from jupyter-scipy-notebook.
This container includes some packages and extensions.

* based container
  * [jupyter/scipy-notebook][scipy-nb]
  * [jupyter/docker-stacks][scipy-dc]

[scipy-nb]: https://hub.docker.com/r/jupyter/scipy-notebook/
[scipy-dc]: https://github.com/jupyter/docker-stacks

## added packages

These packages add in this container.

* [pandas-datareader][pdr]
  * [docs][pdr-docs]
* [tqdm][tqdm]

[pdr]: https://github.com/pydata/pandas-datareader
[pdr-docs]: https://pandas-datareader.readthedocs.io/en/latest/
[tqdm]: https://github.com/tqdm/tqdm

## added nbextensions

These nbextensions add in this container.

* [jupyter_cms][cms]
* [jupyter_contrib_nbextensions][contrib]

[cms]: https://github.com/jupyter-incubator/contentmanagement
[contrib]: https://github.com/ipython-contrib/jupyter_contrib_nbextensions

### default enabled

These nbextensions is enabled.

* code_font_size
* code_prettify
* codefolding
* collapsible_headings
* comment-uncomment
* equation-numbering
* limit_output
* python-markdown
* ruler
* scratchpad
* select_keymap
* spellchecker
* table_beautifier
* toc2
* toggle_all_line_numbers
* tree-filter
* varInspector
* zenmode

