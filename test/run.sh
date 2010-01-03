unzip -ou example.zargo
xsltproc -o example.dot ../src/org/argouml/graphviz/xsl/ClassDiagram2DOT.xsl example.xmi
dot -Tpdf example.dot -oexample.pdf
