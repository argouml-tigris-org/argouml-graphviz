<!-- $Id$
Copyright (c) 2007-2008 The Regents of the University of California. All
Rights Reserved. Permission to use, copy, modify, and distribute this
software and its documentation without fee, and without a written
agreement is hereby granted, provided that the above copyright notice
and this paragraph appear in all copies. This software program and
documentation are copyrighted by The Regents of the University of
California. The software program and documentation are supplied "AS
IS", without any accompanying services from The Regents. The Regents
does not warrant that the operation of the program will be
uninterrupted or error-free. The end-user understands that the program
was developed for research purposes and is advised not to rely
exclusively on the program for any reason. IN NO EVENT SHALL THE
UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE. THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE
PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT,
UPDATES, ENHANCEMENTS, OR MODIFICATIONS.-->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes"
	xmlns:UML="org.omg.xmi.namespace.UML" exclude-result-prefixes="xs xdt UML">
    <xsl:output method="text" media-type="text/xml" indent="yes" encoding="utf-8" />
    <xsl:variable name="from" select="0"/>
    <xsl:variable name="to" select="NON"/>
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
		  <xsl:when test="contains($text,$replace)">
		    <xsl:value-of select="substring-before($text,$replace)"/>
		    <xsl:value-of select="$with"/>
		    <xsl:call-template name="replace-string">
		      <xsl:with-param name="text"
	select="substring-after($text,$replace)"/>
		      <xsl:with-param name="replace" select="$replace"/>
		      <xsl:with-param name="with" select="$with"/>
		    </xsl:call-template>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="$text"/>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:template>
    <xsl:template match="XMI.header"/>
    <xsl:template match="XMI.content">
        <xsl:call-template name="pre-graph"/>
        <xsl:apply-templates
                    select="UML:Model/UML:Namespace.ownedElement/UML:Package/UML:Namespace.ownedElement/UML:Class" />
        <xsl:apply-templates
                    select="UML:Model/UML:Namespace.ownedElement/UML:Package/UML:Namespace.ownedElement/UML:Interface" />
        <xsl:apply-templates
			        select="UML:Model/UML:Namespace.ownedElement/UML:Package/UML:Namespace.ownedElement/UML:Association"/>
        <xsl:apply-templates
			        select="UML:Model/UML:Namespace.ownedElement/UML:Abstraction"/>
        <xsl:apply-templates
                    select="UML:Model/UML:Namespace.ownedElement/UML:Package/UML:Namespace.ownedElement/UML:Generalization" />
        <xsl:call-template name="post-graph"/>
    </xsl:template>
    <xsl:template name="attributes">
        int x;
    </xsl:template>
    <xsl:template name="functions">
        public static void main(String[] args){
        }
    </xsl:template>
    <xsl:template name="pre-graph">
        digraph g {
		fontname=Helvetica
		fontsize=10
        graph [
        rankdir = "LR"
		ranksep=1.4
		nodesep=0.9
        ];
        node [
		fontname=Helvetica
		fontsize=10
        shape = "ellipse"
        ];
        edge [
		fontname=Helvetica
		fontsize=10
        ];
    </xsl:template>
    <xsl:template name="post-graph">
        }
    </xsl:template>


	<!-- replace -->
	<xsl:template name="replaceCharsInString">
		<xsl:param name="stringIn"/>
		<xsl:param name="charsIn"/>
		<xsl:param name="charsOut"/>
		<xsl:choose>
			<xsl:when test="contains($stringIn,$charsIn)">
				<xsl:value-of select="concat(substring-before($stringIn,$charsIn),$charsOut)"/>
				<xsl:call-template name="replaceCharsInString">
					<xsl:with-param name="stringIn" select="substring-after($stringIn,$charsIn)"/>
					<xsl:with-param name="charsIn" select="$charsIn"/>
					<xsl:with-param name="charsOut" select="$charsOut"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stringIn"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- visibility -->
	<xsl:template name="printVisibility">
		<xsl:param name="visibility"/>
		<xsl:choose>
			<xsl:when test="@visibility = 'public' or $visibility = 'public'">+</xsl:when>
			<xsl:when test="@visibility = 'private' or $visibility = 'private'">-</xsl:when>
			<xsl:when test="@visibility = 'protected' or $visibility = 'protected'">#</xsl:when>
			<xsl:when test="@visibility = 'package' or $visibility = 'package'">~</xsl:when>
		</xsl:choose>
	</xsl:template>



	<!-- parameters -->
	<xsl:template name="printOperations">
		<xsl:for-each select="UML:Classifier.feature/UML:Operation"><xsl:call-template name="printVisibility"/><xsl:value-of select="@name"/>(<xsl:for-each select="UML:BehavioralFeature.parameter/UML:Parameter"><xsl:if test="@name != 'return'"><xsl:value-of select="@name"/><xsl:if test="last() != position()">, </xsl:if></xsl:if></xsl:for-each>)\l</xsl:for-each>
	</xsl:template>



	<!-- Class -->
    <xsl:template match="UML:Namespace.ownedElement/UML:Class">
    <xsl:variable name="xmiid_a">
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="@xmi.id"/>
        <xsl:with-param name="replace" select="'-'"/>
        <xsl:with-param name="with" select="''"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="xmiid">
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="$xmiid_a"/>
        <xsl:with-param name="replace" select="':'"/>
        <xsl:with-param name="with" select="''"/>
      </xsl:call-template>
    </xsl:variable>
        "<xsl:value-of select="@xmi.id"/>" [
		<xsl:if test="@isAbstract = 'true'">fontname="Helvetica-Oblique"</xsl:if>

        label = "      <xsl:call-template name="printVisibility"/><xsl:value-of select="@name"/> | <xsl:for-each select="UML:Classifier.feature/UML:Attribute"><xsl:call-template name="printVisibility"/><xsl:value-of select="@name"/>\l</xsl:for-each> | <xsl:call-template name="printOperations"/> "
        shape = "record"
        ];
    </xsl:template>



	<!-- Interface -->
    <xsl:template match="UML:Namespace.ownedElement/UML:Interface">
        "<xsl:value-of select="@xmi.id"/>" [
        label = "«interface»\n<xsl:call-template name="printVisibility"/><xsl:value-of select="@name"/> | <xsl:call-template name="printOperations"/> "
        shape = "record"
        ];
    </xsl:template>



	<!-- Association -->
    <xsl:template match="UML:Association.connection">
        <xsl:apply-templates select="UML:AssociationEnd/UML:AssociationEnd.participant/UML:Class"/>
    </xsl:template>
    <xsl:template match="UML:Association">
    <xsl:variable name="f" select="UML:Association.connection/UML:AssociationEnd/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
    <xsl:variable name="e" select="UML:Association.connection/UML:AssociationEnd"/>
        "<xsl:value-of select="$f[1]"/>" -> "<xsl:value-of select="$f[2]"/>" [
<xsl:choose>
<xsl:when test="$e[1]/@aggregation = 'composite'">arrowtail="diamond"</xsl:when>
<xsl:when test="$e[1]/@aggregation = 'aggregate'">arrowtail="odiamond"</xsl:when>
<xsl:otherwise><xsl:choose><xsl:when test="$e[2]/@isNavigable = 'true' and $e[2]/@isNavigable = 'false'">arrowhead="vee"</xsl:when><xsl:otherwise>arrowhead="none"</xsl:otherwise></xsl:choose></xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$e[2]/@aggregation = 'composite'">arrowhead="diamond"</xsl:when>
<xsl:when test="$e[2]/@aggregation = 'aggregate'">arrowhead="odiamond"</xsl:when>
<xsl:otherwise><xsl:choose><xsl:when test="$e[1]/@isNavigable = 'false' and $e[2]/@isNavigable = 'true'">arrowhead="vee"</xsl:when><xsl:otherwise>arrowhead="none"</xsl:otherwise></xsl:choose></xsl:otherwise>
</xsl:choose>
        id="<xsl:value-of select="@xmi.id"/>" headlabel="<xsl:call-template name="printVisibility"><xsl:with-param name="visibility" select="$e[1]/@visibility"/></xsl:call-template><xsl:value-of select="$e[1]/@name"/><xsl:variable name="m1" select="$e[1]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange"/><xsl:if test="$m1/@lower != '1' and $m1/@upper != '1'">\l<xsl:value-of select="$m1/@lower"/>..<xsl:choose><xsl:when test="$m1/@upper = '-1'">*</xsl:when><xsl:otherwise><xsl:value-of select="$m1/@upper"/></xsl:otherwise></xsl:choose></xsl:if><xsl:if test="$e[1]/@ordering = 'ordered'">\l{ordered}</xsl:if>\l" taillabel="<xsl:call-template name="printVisibility"><xsl:with-param name="visibility" select="$e[2]/@visibility"/></xsl:call-template><xsl:value-of select="$e[2]/@name"/><xsl:variable name="m2" select="$e[2]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange"/><xsl:if test="$m2/@lower != '1' and $m2/@upper != '1'">\l<xsl:value-of select="$m2/@lower"/>..<xsl:choose><xsl:when test="$m2/@upper = '-1'">*</xsl:when><xsl:otherwise><xsl:value-of select="$m2/@upper"/></xsl:otherwise></xsl:choose></xsl:if><xsl:if test="$e[2]/@ordering = 'ordered'">\l{ordered}</xsl:if>\l" arrowsize="1.5" <!-- no name, no newline or ordered-->
        ];
    </xsl:template>



	<!-- Abstraction -->
    <xsl:template match="UML:Namespace.ownedElement/UML:Abstraction">
        "<xsl:value-of select="UML:Dependency.client/UML:Class/@xmi.idref"/>" -> "<xsl:value-of select="UML:Dependency.supplier/UML:Interface/@xmi.idref"/>" [ style="dashed" arrowhead="onormal" arrowsize=1.5 ];
    </xsl:template>



	<!-- Generalization -->
    <xsl:template match="UML:Namespace.ownedElement/UML:Package/UML:Namespace.ownedElement/UML:Generalization">
        "<xsl:value-of select="UML:Generalization.child/UML:Class/@xmi.idref"/>" -> "<xsl:value-of select="UML:Generalization.parent/UML:Class/@xmi.idref"/>" [ arrowhead="onormal" arrowsize=1.5 ];
    </xsl:template>



    <xsl:template match="UML:Attribute">
    </xsl:template>
</xsl:stylesheet>