{%- from 'intellij/settings.sls' import intellij with context %}

export INTELLIJ_HOME={{ intellij.intellij_home }}
export PATH=$INTELLIJ/bin:$PATH
