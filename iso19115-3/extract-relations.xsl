<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Create a simple XML tree for relation description.
  <relations>
    <relation type="related|services|children">
      + super-brief representation.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:gco="http://www.isotc211.org/2005/gco" 
  xmlns:gmx="http://www.isotc211.org/2005/gmx" 
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:mdb="http://www.isotc211.org/2005/mdb/1.0/2013-06-24"
  xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-06-24"
  xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2013-06-24"
  xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-06-24"
  xmlns:util="java:org.fao.geonet.util.XslUtil"
  exclude-result-prefixes="#all" >
  
  
  <!-- Relation contained in the metadata record has to be returned
  It could be document or thumbnails
  -->
  <xsl:template mode="relation" match="metadata[mdb:MD_Metadata]" priority="99">
    
    <xsl:for-each select="*/descendant::*[name(.) = 'mri:graphicOverview']/*">
      <relation type="thumbnail">
        <id><xsl:value-of select="mcc:fileName/gco:CharacterString"/></id>
        <title><xsl:value-of select="mcc:fileDescription/gco:CharacterString"/></title>
      </relation>
    </xsl:for-each>
    
    <xsl:for-each select="*/descendant::*[name(.) = 'mrd:onLine']/*[cit:linkage/gco:CharacterString!='']">
      <relation type="onlinesrc">
        
        <!-- Compute title based on online source info-->
        <xsl:variable name="title">
          <xsl:variable name="title" select="''"/>
          <xsl:value-of select="if ($title = '' and ../@uuidref) then ../@uuidref else $title"/><xsl:text> </xsl:text>
          <xsl:value-of select="if (cit:name/gco:CharacterString != '') 
            then cit:name/gco:CharacterString 
            else if (cit:name/gmx:MimeFileType != '')
            then cit:name/gmx:MimeFileType
            else if (cit:description/gco:CharacterString != '')
            then cit:description/gco:CharacterString
            else cit:linkage/gco:CharacterString"/>
        </xsl:variable>
        
        <id><xsl:value-of select="cit:linkage/gco:CharacterString"/></id>
        <title>
          <xsl:value-of select="if ($title != '') then $title else cit:linkage/gco:CharacterString"/>
        </title>
        <url>
          <xsl:value-of select="cit:linkage/gco:CharacterString"/>
        </url>
        <name>
          <xsl:value-of select="cit:name/gco:CharacterString"/>
        </name>        
        <abstract><xsl:value-of select="cit:description/gco:CharacterString"/></abstract>
        <description><xsl:value-of select="cit:description/gco:CharacterString"/></description>
        <protocol><xsl:value-of select="cit:protocol/gco:CharacterString"/></protocol>
      </relation>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
