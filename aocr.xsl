<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes'/>
	<xsl:template match="/asprise-ocr">
		<xsl:variable name="slashedPath" select="translate(@input,'\','/')"/>
		<HTML>
			<HEAD>
				<TITLE>Asprise OCR Result of <xsl:value-of select="@input"/>
				</TITLE>
				<style>
  body   {background-color:lightgray; font-family: arial; }
  div.page   {background-color: white; border: outset 3px #666;  background-image: url("file:///<xsl:value-of select="$slashedPath"/>");  background-repeat: no-repeat; }
  div.pageNo {position: absolute; right: 10px; top: 10px; font-size: 24px; color: #f09; font-style: italic;}
  
  a.block {display: block; position: absolute; border: solid 1px #9df; margin: 0px; padding: 0px; overflow: visible;}
  a.block:hover {background-color: #def; border: solid 1px #39d;}
  a.block:hover span {background-color: #def; color: #000; font-size: 1.0em; z-index: 999;}
  
  a.block span {color: transparent;}
  a.block div.info {position: absolute; right: 0px; top: 0px; color: #33f; font-size: medium;}
  
  a.cell {position: absolute; border: dotted 1px #3c3; }
  a.cell:hover {background-color: #e0ffe0;}
  a.checked { background-color: #9f9; }
  a.not_checked { background-color: #ddd; }
  span.cellId    {color: #396; font-family: arial;}  
  
</style>
			</HEAD>
			<BODY>
				<h1>
          Asprise OCR Result of <xsl:value-of select="@input"/>
				</h1>
				<xsl:apply-templates select="page"/>
				
				
				<span style="font-family: Arial; color: #999; font-size: 12px; align: center;">Generated by <a href="http://asprise.com/royalty-free-library/ocr-api-for-java-csharp-vb.net.html" target="_blank">Asprise OCR SDK for Java, C#, VB.NET</a> &#169;1998 - 2014.</span>
			</BODY>
		</HTML>
	</xsl:template>
	<xsl:template match="page">
		<div class="page">
			<xsl:attribute name="style">
				  position: relative; width: <xsl:value-of select="@width"/>px;
				  ; height: <xsl:value-of select="@height"/>px;
				</xsl:attribute>
			<div class="pageNo">Page #<xsl:value-of select="@no"/>
			</div>
			<xsl:apply-templates select=".//cell"/>
			<xsl:apply-templates select=".//block"/>
		</div>
		<!-- end of page -->
		<br style="clear: both;"/>
	</xsl:template>
	
	<xsl:template match="cell">
		<xsl:variable name="className">
			<xsl:choose>
				<xsl:when test="@largestContentArea = 0">
					<xsl:text>cell not_checked</xsl:text>
				</xsl:when>
				<xsl:when test="@largestContentArea &gt; @width * @height * 0.3">
					<xsl:text>cell checked</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>cell</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="checkedInfo">
			<xsl:choose>
				<xsl:when test="@largestContentArea = 0">
					<xsl:text>
Cell is UNTICKED</xsl:text>
				</xsl:when>
				<xsl:when test="@largestContentArea &gt; @width * @height * 0.3">
					<xsl:text>
Cell is TICKED</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		
		<xsl:variable name="depth" select="count(ancestor::*)"/>
		<a>
			<xsl:attribute name="class"><xsl:value-of select="$className"/></xsl:attribute>
			<xsl:attribute name="style">
				   top: <xsl:value-of select="@y"/>px;
				  left: <xsl:value-of select="@x"/>px; width: <xsl:value-of select="@width"/>px; height: <xsl:value-of select="@height"/>px; 
				  ; height: <xsl:value-of select="@height"/>px; z-index: <xsl:value-of select="$depth"/>;
				</xsl:attribute>
			<xsl:attribute name="title">Table Cell ID:<xsl:value-of select="@id"/> [<xsl:value-of select="@row"/>, <xsl:value-of select="@col"/>] (x: <xsl:value-of select="@x"/>, y: <xsl:value-of select="@y"/>, width: <xsl:value-of select="@width"/>, height: <xsl:value-of select="@height"/>)<xsl:value-of select="$checkedInfo"/></xsl:attribute>
			<span class="cellId">
				<xsl:value-of select="@id"/>
			</span>
			<xsl:apply-templates select="formatting"/>
		</a>
	</xsl:template>
	
	<xsl:template match="block">
		<xsl:variable name="fontSize">
			<xsl:choose>
				<xsl:when test="@font-size &gt; 10">
					<xsl:choose>
						<xsl:when test="@font-size &gt; @height ">
							<xsl:value-of select="ceiling(@height * 0.8)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ceiling(@font-size * 0.85)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="12"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="depth" select="count(ancestor::*)"/>
		<a class="block">
			<xsl:attribute name="style">
				  top: <xsl:value-of select="@y"/>px;
				  left: <xsl:value-of select="@x"/>px; width: <xsl:value-of select="@width"/>px; height: <xsl:value-of select="@height"/>px; 
				  ; height: <xsl:value-of select="@height"/>px; font-size: <xsl:value-of select="$fontSize"/>px;
				  z-index: <xsl:value-of select="$depth"/>;
				</xsl:attribute>
			<xsl:attribute name="title">Block ID:<xsl:value-of select="@id"/>, type: <xsl:value-of select="@type"/>/<xsl:value-of select="@subtype"/> (x: <xsl:value-of select="@x"/>, y: <xsl:value-of select="@y"/>, width: <xsl:value-of select="@width"/>, height: <xsl:value-of select="@height"/>)
<xsl:value-of select="."/></xsl:attribute>
			<span><xsl:value-of select="."/></span>
			<div class="info">
				<xsl:value-of select="@id"/>
			</div>
			<xsl:apply-templates select="formatting"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
