FROM jupyter/scipy-notebook:a95cb64dfe10
LABEL maintainer "iimuz"

USER root

# set locale
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

USER $NB_USER

# add packages
RUN conda install --quiet --yes \
    pandas-datareader \
    tqdm \
  && conda clean -tipsy \
  && npm cache clean --force \
  && rm -rf $CONDA_DIR/share/jupyter/lab/staging \
  && fix-permissions $CONDA_DIR

# extensions
RUN conda install --quiet --yes -c conda-forge jupyter_cms \
  && conda install --quiet --yes -c conda-forge jupyter_contrib_nbextensions \
  && conda clean -tipsy \
  && npm cache clean --force \
  && rm -rf $CONDA_DIR/share/jupyter/lab/staging \
  && fix-permissions $CONDA_DIR \
  && jupyter contrib nbextension install --sys-prefix \
  && jupyter nbextension enable code_font_size/code_font_size \
  && jupyter nbextension enable code_prettify/code_prettify \
  && jupyter nbextension enable codefolding/main \
  && jupyter nbextension enable collapsible_headings/main \
  && jupyter nbextension enable comment-uncomment/main \
  && jupyter nbextension enable equation-numbering/main \
  && jupyter nbextension enable limit_output/main \
  && jupyter nbextension enable python-markdown/main \
  && jupyter nbextension enable ruler/main \
  && jupyter nbextension enable scratchpad/main \
  && jupyter nbextension enable select_keymap/main \
  && jupyter nbextension enable spellchecker/main \
  && jupyter nbextension enable table_beautifier/main \
  && jupyter nbextension enable toc2/main \
  && jupyter nbextension enable toggle_all_line_numbers/main \
  && jupyter nbextension enable --section=tree tree-filter/index \
  && jupyter nbextension enable varInspector/main \
  && jupyter nbextension enable zenmode/main

# extensions lab
RUN conda install --quiet --yes -c conda-forge jupytext && \
  conda clean -tipsy && \
  npm cache clean --force && \
  rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
  fix-permissions $CONDA_DIR && \
  jupyter labextension install @jupyterlab/toc && \
  jupyter labextension install jupyterlab_vim
