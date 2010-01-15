unzip -ou example.zargo
xsltproc -o example.dot ../src/org/argouml/graphviz/xsl/ClassDiagram2DOT.xsl example.xmi
if [ ! -e default-uml14.xmi ]
then
    wget -nc http://argouml.org/profiles/uml14/default-uml14.xmi
fi
if [ ! -e default-uml14.xmi ]
then
    cp default-uml14.xmi.fallback default-uml14.xmi
fi
dot -Tpng example.dot -oexample.png
dot -Tpdf example.dot -oexample.pdf
