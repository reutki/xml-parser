<?xml version="1.0"   ?>
<xsl:stylesheet xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:user="http:www.cedacri.it" xmlns:xdsl="http:www.cedacri.it">
<xsl:output method="html" indent="no" />
<!-- SCRIPT XSL -->
<xsl:include href="../../COMMONFG/XSL/XMLNS_FUNCTIONS.xsl"/>
<xsl:include href="../../errore/errore.xsl"/>
<xsl:include href="../../commonFG/xsl/commonUtils.xsl"/>

  <xsl:variable name="ProjectManager">
    <xsl:choose>
      <xsl:when test="//PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<xsl:template match="/">

<script src="/COMMON64/Script/General.js"></script><script src="/FG/commonFG/jScripts/EdgePolyfill.js"></script>
<script src="/FG/FG303/JScripts/Main.js"></script>
<script src="/FG/FG303/JScripts/functionButton.js"></script>
<script src="/FG/FG303/JScripts/drawCalendar.js"></script>
<script src="/FG/FG303/JScripts/setCalendar.js"></script>

<link rel="stylesheet" type="text/css" href="/FG/FG303/css/FG303.css" />
  <xsl:if test="$ProjectManager='true'">
    <LINK rel="stylesheet" type="text/css" href="/FG/FGA_common/css/FGA_Common.css"/>
  </xsl:if>
<!-- XML Island di gestione dell' errore -->
		<script type="application/xml"  id="xml_RESULT">
		  <result>
			<code>
		<xsl:value-of select="/PAGE/OUTPUT/RESULT/CODE" />
		</code>
			<outcome>
		<xsl:value-of select="/PAGE/OUTPUT/RESULT/OUTCOME" />
		</outcome>
			<description>
		<xsl:value-of select="/PAGE/OUTPUT/RESULT/DESCRIPTION" />
		</description>
			<longdescription>
		<xsl:value-of select="/PAGE/OUTPUT/RESULT/LONGDESCRIPTION" />
		</longdescription>
			<module>
		<xsl:value-of select="/PAGE/OUTPUT/RESULT/MODULE" />
		</module>
			</result>
		</script>
<!-- XML Island di gestione dell' errore -->
<xsl:choose>
	
	<xsl:when test="//CODE[.!=0]">
			<xsl:call-template name="ERROREWBMOD">
				<xsl:with-param name="descrizione" select="//LONGDESCRIPTION"/>
			</xsl:call-template>
		</xsl:when>
	
	<xsl:otherwise>
		<xsl:if test="((//FG303-RC[.!='00']) and (//FG303-RC[.!='03']) and (//FG303-RC[.!='01']))">
			<xsl:apply-templates select="//FG303-RC"/>
		</xsl:if>
	</xsl:otherwise>	 				
</xsl:choose>
<xsl:if test="(//FG303-RC[.='00']) and (//FG303-FUNZ[.='P'])">
	<xsl:apply-templates select="//FG303-FUNZ"/>
</xsl:if>


<xsl:if test="//WB000-RETCOD[.=0]">
<xsl:if test="((//FG303-RC[.='00']) or (//FG303-RC[.='03']) or (//FG303-RC[.='01']))"><!-- and (//FG303-FUNZ[.!='R'])"> -->

  <xsl:variable name="labelEuro">
    <xsl:choose>
      <xsl:when test="//FG303-CDDIVIS != 'EUR'">(Euro)</xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="inDivisa">
    <xsl:choose>
      <xsl:when test="//FG303-CDDIVIS != 'EUR'">S</xsl:when>
      <xsl:otherwise>N</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="avvPerc">
    <xsl:choose>
      <xsl:when test="//FG303-TAB102-FLAVV-PERCGA='S'">S</xsl:when>
      <xsl:otherwise>N</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
<body style="overflow-y:hidden" topmargin="8" leftmargin="0" rightmargin="0" scroll="no">
<xsl:attribute name="onload">
		<!--startApplication('<xsl:value-of select="//WB000-TIMESTAMP" />');-->
		onFocusInput();
	</xsl:attribute>
	
	<xsl:attribute name="onresize">
		<!--startApplication('<xsl:value-of select="//WB000-TIMESTAMP" />');-->
		onFocusInput();
	</xsl:attribute>
	
<form name="dati">
    <input type="hidden" id="livelli" value="{//FG303-FIDI-3LIVELLI}"/>
	<center>
		<div class="bordo_ltr" style="background-color:000066;width:98%;height:99%">
			<table cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr class="testo_bianco">
					<td align="left" style="padding-left:5">Pratica/Progr.  : <b><xsl:value-of select="substring(//FG303-I-CDRAPP,6,10)"/>/<xsl:value-of select="substring(//FG303-I-CDRAPP,16,5)"/></b></td>
				</tr>
			</table>
		</div>
		<div class="bordo" style="background-color:ECEDFF;width:98%;height:320">
      <xsl:if test="$ProjectManager='true'">
        <xsl:attribute name="style">background-color:#F6F5F0;width:98%;height:320</xsl:attribute>
      </xsl:if>
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td height="5"></td>
				</tr>
			</table>
			<fieldset style="width:95%;height:55;">
				<legend>
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td width="20"><img src="/FG/FG303/images/garante.gif"/></td>
							<td width="50" class="testo_nero"><b>Garante</b></td>
						</tr>
					</table>
				</legend>	
				
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td height="2"></td>
					</tr>
				</table>
			<center>
					<table cellpadding="0" border="0" cellspacing="0" width="100%">
						<col width="20%"></col>
						<col width="30%"></col>
						<col width="20%"></col>
						<col width="30%"></col>
						<tr height="16">
							<td class="testo_nero">NDG :</td>
							<td class="testo_blue" colspan="3">
								<b>	<xsl:if test="//FG303-NDGGAR-E='S'"> 
										<xsl:attribute name="class">input_error</xsl:attribute>
									</xsl:if>	
									<xsl:value-of select="//FG303-IO-NDGGAR"/>
								</b> - 
								<b><xsl:value-of select="//FG303-IO-NDGGAR-INT"/></b>
							</td>
						</tr>
						<tr>	
							<td class="testo_nero">Tot.Deliberato <xsl:value-of select="$labelEuro"/> :</td>
							<td class="testo_blue">
								<b>
									<xsl:choose>
										<xsl:when test="//FG303-IO-TOTDEL">
											<xsl:choose>
												<xsl:when test="//FG303-IO-TOTDEL = 0">
													0
												</xsl:when>
												<xsl:otherwise>
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-TOTDEL" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="0" /></xsl:with-param></xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											0
										</xsl:otherwise>
									</xsl:choose>
								</b>
							</td>
							<td class="testo_nero">Tot.Operativo <xsl:value-of select="$labelEuro"/> :</td>
							<td class="testo_blue">
								<b>
									<xsl:choose>
										<xsl:when test="//FG303-IO-TOTOPE">
											<xsl:choose>
												<xsl:when test="//FG303-IO-TOTOPE = 0">
													0
												</xsl:when>
												<xsl:otherwise>
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-TOTOPE" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="0" /></xsl:with-param></xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											0
										</xsl:otherwise>
									</xsl:choose>
								</b>
							</td>
						</tr>
					</table>
				</center>
			</fieldset>
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td height="8"></td>
				</tr>
			</table>
			<div style="background-color:white; width:95%; height:220" class="bordo">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<col width="20%" style="padding-left:5"></col>
				<col width="30%"></col>
				<col width="20%"></col>
				<col width="30%"></col>
				<tr>
					<td height="3"></td>
				</tr>
				<tr height="30">
					<td class="testo_nero">Data :</td>
					<td class="testo_blue">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td class="testo_blue">
								<xsl:if test="//FG303-IO-DTULTV">
<B><xsl:call-template name="formatDataVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-DTULTV" /></xsl:with-param><xsl:with-param name="FORMATO_ANNO"><xsl:value-of select="4" /></xsl:with-param></xsl:call-template></B>
								</xsl:if>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr height="15">
					<td class="testo_nero" valign="top">Tipo Garanzia :</td>
					<td class="testo_blue" valign="top"><b><xsl:value-of select="//FG303-IO-TIPOGAR"/> - <xsl:value-of select="//FG303-IO-TIPOGAR-D"/></b></td>
					<td class="testo_nero" valign="top">Tipo Collegamento :</td>
					<td class="testo_blue" valign="top">
							<!--TITLE che contiene tutte le linee collegate-->
							<xsl:if test="//FG303-IO-TIPOCOL = 'P'">
								<xsl:attribute name="title">
									<xsl:text>Su Linee </xsl:text><xsl:for-each select="//FG303-LINEE-COLLEGATE/FG303-EL-LINCOLL"><xsl:choose><xsl:when test="position() = last()"><xsl:value-of select="FG303-PRGRAPF"/> </xsl:when><xsl:otherwise><xsl:value-of select="FG303-PRGRAPF"/>,</xsl:otherwise></xsl:choose></xsl:for-each>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="//FG303-IO-TIPOCOL = 'C'">
								<xsl:if test="count(//FG303-GARANZIE-COLLEGATE/FG303-EL-GARCOLL)>1">
									<xsl:attribute name="title">
										<xsl:text>Su Garanzie </xsl:text> <xsl:for-each select="//FG303-GARANZIE-COLLEGATE/FG303-EL-GARCOLL"><xsl:choose><xsl:when test="position() = last()"><xsl:value-of select="FG303-PRGRAPG"/> </xsl:when><xsl:otherwise><xsl:value-of select="FG303-PRGRAPG"/>,</xsl:otherwise></xsl:choose></xsl:for-each>
									</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<b>
								<xsl:value-of select="//FG303-IO-TIPOCOL"/> 
								-
								<xsl:choose>
                                    <xsl:when test="//FG303-IO-TIPOCOL = 'M'">
                                        Garanzia madre
                                        <img src="/common64/images/plus.gif" style="cursor:hand">
                                            <xsl:attribute name="onclick">
                                                callFG308('<xsl:value-of select="//FG303-I-CDRAPP"/>');
                                            </xsl:attribute>
                                        </img>
                                    </xsl:when>

									<xsl:when test="//FG303-IO-TIPOCOL = 'L'">
										Su Linea <xsl:value-of select="//FG303-LINEE-COLLEGATE/FG303-EL-LINCOLL/FG303-PRGRAPF"/>
									</xsl:when>
									<xsl:when test="//FG303-IO-TIPOCOL = 'P'">				
										Su Linee
										<xsl:for-each select="//FG303-LINEE-COLLEGATE/FG303-EL-LINCOLL">
											<xsl:choose>
												<xsl:when test="position() = 3">
													<xsl:choose>
														<xsl:when test="position() != last()">
															<xsl:value-of select="FG303-PRGRAPF"/> ...
														</xsl:when>
														<xsl:when test="position() = last()">
															<xsl:value-of select="FG303-PRGRAPF"/>
														</xsl:when>
													</xsl:choose>
												</xsl:when>
												<xsl:when test="position() = 1 or position() = 2">
													<xsl:choose>
														<xsl:when test="position() != last()">
															<xsl:value-of select="FG303-PRGRAPF"/>,
														</xsl:when>
														<xsl:when test="position() = last()">
															<xsl:value-of select="FG303-PRGRAPF"/>
														</xsl:when>
													</xsl:choose>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="//FG303-IO-TIPOCOL = 'G'">
										Tutte le Linee
									</xsl:when>
									<xsl:when test="//FG303-IO-TIPOCOL = 'C'">
										<xsl:choose>
											<xsl:when test="count(//FG303-GARANZIE-COLLEGATE/FG303-EL-GARCOLL)>1">
												Su Garanzie 
												<xsl:for-each select="//FG303-GARANZIE-COLLEGATE/FG303-EL-GARCOLL">
													<xsl:choose>
														<xsl:when test="position() = 3">
															<xsl:choose>
																<xsl:when test="position() != last()">
																	<xsl:value-of select="FG303-PRGRAPG"/> ...
																</xsl:when>
																<xsl:when test="position() = last()">
																	<xsl:value-of select="FG303-PRGRAPG"/>
																</xsl:when>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="position() = 1 or position() = 2">
															<xsl:choose>
																<xsl:when test="position() != last()">
																	<xsl:value-of select="FG303-PRGRAPG"/>,
																</xsl:when>
																<xsl:when test="position() = last()">
																	<xsl:value-of select="FG303-PRGRAPG"/>
																</xsl:when>
															</xsl:choose>
														</xsl:when>
													</xsl:choose>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												Su Garanzia <xsl:value-of select="//FG303-GARANZIE-COLLEGATE/FG303-EL-GARCOLL/FG303-PRGRAPG"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<img src="/FG/FG303/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
									</xsl:otherwise>
								</xsl:choose> 
							</b>
						</td>
				</tr>
				<tr height="15">
					<td class="testo_nero" valign="top">Importo :</td>
					<td class="testo_blue" valign="top">
            <div style="float:left">
              <b>
                <xsl:choose>
                  <xsl:when test="//FG303-CDDIVIS = 'EUR'">
                    <xsl:if test="//FG303-IO-IMPORTO">
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-IMPORTO" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="gestImportDivisa">
                      <xsl:with-param name="import" select="//FG303-IMPDIVIS"></xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </b>
            </div>
            <xsl:if test="//FG303-CDDIVIS!='EUR'">
              <div style="float:left">
                &#160;in Euro&#160;
                <b>
                  <xsl:if test="//FG303-IO-IMPORTO">
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-IMPORTO" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                  </xsl:if>
                </b>
              </div>
            </xsl:if>            
					</td>
					<td class="testo_nero" valign="top">Codice Garanzia :</td>
					<td class="testo_blue" valign="top"><b><xsl:value-of select="//FG303-IO-CODGARA"/> - <xsl:value-of select="//FG303-IO-CODGARA-D"/></b></td>
				</tr>
        <xsl:if test="$avvPerc='S'">
          <tr height="15">
            <td class="testo_nero">% calcolo importo garanzia :</td>
            <td class="testo_blue">
              <xsl:if test="//FG303-PERCUTI">
                <b>
                  <xsl:call-template name="gestPercentuale">
                    <xsl:with-param name="valore" select="//FG303-PERCUTI"></xsl:with-param>
                  </xsl:call-template>
                </b>
              </xsl:if>
            </td>
            <td class="testo_nero">
              <xsl:choose>
                <xsl:when test="//FG303-CDDIVIS!='EUR'">
                  Limite max importo garanzia calcolato <xsl:if test="//FG303-CDDIVIS != ''">(<b><xsl:value-of select="//FG303-CDDIVIS"/></b>)</xsl:if>:
                </xsl:when>
                <xsl:otherwise>Limite max importo garanzia calcolato :</xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="testo_blue">
              <div style="float:left">
                <b>
                  <xsl:choose>
                    <xsl:when test="//FG303-CDDIVIS = 'EUR'">
                      <xsl:if test="//FG303-LIMITE">
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-LIMITE" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="gestImportDivisa">
                        <xsl:with-param name="import" select="//FG303-LIMDIVIS"></xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </b>
              </div>
              <xsl:if test="//FG303-CDDIVIS!='EUR'">
                <div style="float:left">
                  <xsl:if test="//FG303-LIMITE">
                    &#160;in Euro&#160;
                    <b>
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-LIMITE" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                    </b>
                  </xsl:if>
                </div>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
				<tr height="15">
					<td class="testo_nero">Data Scadenza :</td>
					<td class="testo_blue">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td>
									<input type="text" name="dataScad" id="dataScad" maxlength="10" onKeyDown="controlloData(this)" onKeyUp="controlloData(this)" style="width:100">
										<xsl:if test="//FG303-O-DT-SCAD">
<xsl:attribute name="value"><xsl:call-template name="formatDataVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-O-DT-SCAD" /></xsl:with-param><xsl:with-param name="FORMATO_ANNO"><xsl:value-of select="4" /></xsl:with-param></xsl:call-template></xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="((//FG303-FUNZ = 'C') and ((//FG303-RC[.='00'])or(//FG303-RC[.='03'])))">
												<xsl:choose>
													<xsl:when test="//FG303-DT-SCAD-E='S'"> 
														<xsl:attribute name="class">input_error</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="class">input_out</xsl:attribute>	
													</xsl:otherwise>
												</xsl:choose>
												<xsl:attribute name="readonly">true</xsl:attribute>	
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="//FG303-DT-SCAD-E='S'"> 
														<xsl:attribute name="class">input_error</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="class">input</xsl:attribute>	
													</xsl:otherwise>
												</xsl:choose>	
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td width="20" align="center">
									<img src="/FG/FG303/images/calendar.gif" id="calendario1" name="calendario1" title="Calendario" style="border:0">
										<xsl:choose>
											<xsl:when test="//FG303-FUNZ = 'PC'">
												<xsl:attribute name="src">/FG/FG303/images/calendar.gif</xsl:attribute>
												<xsl:attribute name="onclick">showCal('Calendar1')</xsl:attribute>
												<xsl:attribute name="style">cursor:hand</xsl:attribute>
											</xsl:when>
											<xsl:when test="//FG303-FUNZ = 'C'">
												<xsl:attribute name="src">/FG/FG303/images/calendarOut.gif</xsl:attribute>
											</xsl:when>
										</xsl:choose>
									</img>
								</td>
							</tr>
						</table>
					</td>	
				</tr>
				<tr>
					<td height="8" colspan="4" bgcolor="F8F8F8"></td>
				</tr>
				
				<tr height="15">
					<td class="testo_nero">Materialit&#224; :</td>
					<td class="testo_blue">
						<input type="text" class="input" name="matValue" id="matValue" maxlength="9" style="width:70" >
							<xsl:attribute name="digitMate"><xsl:value-of select="//FG303-O-DIGIT-MATER"/></xsl:attribute>
							<xsl:choose>
								<xsl:when test="((//FG303-FUNZ = 'C') and ((//FG303-RC[.='00'])or(//FG303-RC[.='03'])))">
									<xsl:choose>
										<xsl:when test="//FG303-NUM-MATER-E='S'"> 
											<xsl:attribute name="class">input_error</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="class">input_out</xsl:attribute>	
										</xsl:otherwise>
									</xsl:choose>
									<xsl:attribute name="readonly">true</xsl:attribute>	
									<xsl:attribute name="value"><xsl:value-of select="//FG303-O-NUM-MATER"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>	
									<xsl:choose>
										<xsl:when test="//FG303-O-DIGIT-MATER = 'S'">
											<xsl:if test="//FG303-NUM-MATER-E='S'"> 
													<xsl:attribute name="class">input_error</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="value"><xsl:value-of select="//FG303-O-NUM-MATER"/></xsl:attribute>	
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="value"><xsl:value-of select="//FG303-O-NUM-MATER"/></xsl:attribute>	
											<xsl:attribute name="readonly">true</xsl:attribute>
											<xsl:choose>
												<xsl:when test="//FG303-NUM-MATER-E='S'"> 
													<xsl:attribute name="class">input_error</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">input_out</xsl:attribute>	
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</input>
					</td>
					<td class="testo_nero" title="Data Perfezionamento">Data Perfez. :</td>
					<td class="testo_blue">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td>
								<input type="text" name="dataPerf" id="dataPerf" maxlength="10"  onKeyDown="controlloData(this)" onKeyUp="controlloData(this)" style="width:100">
									<xsl:if test="//FG303-O-DT-PERF">
<xsl:attribute name="value"><xsl:call-template name="formatDataVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-O-DT-PERF" /></xsl:with-param><xsl:with-param name="FORMATO_ANNO"><xsl:value-of select="4" /></xsl:with-param></xsl:call-template></xsl:attribute>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="((//FG303-FUNZ = 'C') and ((//FG303-RC[.='00'])or(//FG303-RC[.='03'])))">
											<xsl:choose>
												<xsl:when test="//FG303-DT-PERF-E='S'"> 
													<xsl:attribute name="class">input_error</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">input_out</xsl:attribute>	
												</xsl:otherwise>
											</xsl:choose>
											<xsl:attribute name="readonly">true</xsl:attribute>	
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//FG303-DT-PERF-E='S'"> 
													<xsl:attribute name="class">input_error</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">input</xsl:attribute>	
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</td>
							<td width="20" align="center">
								<img src="/FG/FG303/images/calendar.gif" id="calendario2" name="calendario2" title="Calendario" style="border:0">
									<xsl:choose>
										<xsl:when test="//FG303-FUNZ = 'PC'">
											<xsl:attribute name="src">/FG/FG303/images/calendar.gif</xsl:attribute>
											<xsl:attribute name="onclick">showCal('Calendar2')</xsl:attribute>
											<xsl:attribute name="style">cursor:hand</xsl:attribute>
										</xsl:when>
										<xsl:when test="//FG303-FUNZ = 'C'">
											<xsl:attribute name="src">/FG/FG303/images/calendarOut.gif</xsl:attribute>
										</xsl:when>
									</xsl:choose>
								</img>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr height="15">
					<td class="testo_nero">Provvisoria :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-O-IND-PROVV = 'S'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-O-IND-PROVV = 'N'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
					<td class="testo_nero">Mater.Definitiva :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-O-TIP-MATER = 'D'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-O-TIP-MATER = 'F'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
				</tr>
				<tr height="15">
					<xsl:choose>
						<xsl:when test="//FG303-O-GEST-CAVEAU='N'">
							<td class="testo_bianco">
                <xsl:if test="$ProjectManager='true'">
                  <xsl:attribute name="style">background:none; color:white</xsl:attribute>
                </xsl:if>
                Caveau :</td>
							<td><xsl:if test="//FG303-CAVEAU-E= 'S'">
									<xsl:attribute name="class">input_error</xsl:attribute>
								</xsl:if>
								
								<input type="hidden" name="caValue" id="caValue" maxlength="3" style="width:70">
									<xsl:attribute name="gestCaveau"><xsl:value-of select="//FG303-O-GEST-CAVEAU"/></xsl:attribute>
								</input>
							</td>	
						</xsl:when>
						<xsl:otherwise>
							<td class="testo_nero">Caveau :</td>
								<td class="testo_blue">
									<input type="text" class="input" name="caValue" id="caValue" maxlength="3" style="width:70">
										<xsl:attribute name="gestCaveau"><xsl:value-of select="//FG303-O-GEST-CAVEAU"/></xsl:attribute>
										<xsl:attribute name="digitCaveau"><xsl:value-of select="//FG303-O-DIGIT-CAVEAU"/></xsl:attribute>							
										<xsl:attribute name="value"><xsl:value-of select="//FG303-O-CAVEAU"/></xsl:attribute>	
										<xsl:choose>
											<xsl:when test="((//FG303-FUNZ = 'C') and ((//FG303-RC[.='00'])or(//FG303-RC[.='03'])))">
												<xsl:choose>
													<xsl:when test="//FG303-CAVEAU-E='S'"> 
														<xsl:attribute name="class">input_error</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="class">input_out</xsl:attribute>	
													</xsl:otherwise>
												</xsl:choose>
												<xsl:attribute name="readonly">true</xsl:attribute>	
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="//FG303-O-GEST-CAVEAU = 'N'">
														<xsl:attribute name="style">visibility:hidden</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:if test="//FG303-O-DIGIT-CAVEAU ='N'">
															<xsl:attribute name="readonly">true</xsl:attribute>
															<xsl:choose>
																<xsl:when test="//FG303-CAVEAU-E='S'"> 
																	<xsl:attribute name="class">input_error</xsl:attribute>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:attribute name="class">input_out</xsl:attribute>	
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<xsl:if test="//FG303-O-DIGIT-CAVEAU ='S'">
															<xsl:if test="//FG303-CAVEAU-E='S'"> 
																<xsl:attribute name="class">input_error</xsl:attribute>
															</xsl:if>
															<xsl:if test="//FG303-CAVEAU-E='N'"> 
																<xsl:attribute name="class">input</xsl:attribute>
															</xsl:if>
														</xsl:if>	
													</xsl:otherwise>
												</xsl:choose>
												
											</xsl:otherwise>									
										</xsl:choose>	
									</input>
								</td>
						</xsl:otherwise>												
					</xsl:choose>	
					<td class="testo_nero">Extra Caveau :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-O-EXTRA-CAVEAU = 'S'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-O-EXTRA-CAVEAU = 'N'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
				</tr>
				<tr height="15">
					<td class="testo_nero">Contabile :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-O-CONTABILE = 'S'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-O-CONTABILE = 'N'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
					<td class="testo_nero">Comparto :</td>
					<td class="testo_blue"><b><xsl:value-of select="//FG303-O-COMPARTO"/></b></td>
				</tr>
				
				<tr>
					<td height="8" colspan="4" bgcolor="F8F8F8"></td>
				</tr>
				<tr height="15">
					<td class="testo_nero">Solidale :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-IO-INDSOLID = 'S'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-IO-INDSOLID = 'N'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
					<td class="testo_nero">Centrale Rischi :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-IO-CENTRIS = 'S'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-IO-CENTRIS = 'N'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
				</tr>
				<tr height="15">
					<td class="testo_nero">Libro Fidi :</td>
					<td class="testo_blue">
						<b>
							<xsl:choose>
								<xsl:when test="//FG303-IO-INDLFIDI = 'S'">
									S&#236;
								</xsl:when>
								<xsl:when test="//FG303-IO-INDLFIDI = 'N'">
									No
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
					<td class="testo_nero">Pro Quota :</td>
					<td class="testo_blue">
						<b>
							<xsl:if test="//FG303-IO-PROQUOTA !=''">
								<xsl:value-of select="//FG303-IO-PROQUOTA"/>%
							</xsl:if>
						</b>
					</td>
				</tr>
				<tr>
					<td height="8" colspan="4" bgcolor="F8F8F8"></td>
				</tr>
				<tr height="15">
					<td class="testo_nero">
            <xsl:if test="//FG303-CDDIVIS != ''">
              <xsl:attribute name="title">Valore Iscr.Ipoteca <xsl:value-of select="//FG303-CDDIVIS-D"/></xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$inDivisa='S'">
                Valore Iscr.Ipoteca <xsl:if test="//FG303-CDDIVIS != ''">(<b><xsl:value-of select="//FG303-CDDIVIS"/></b>)</xsl:if>:
              </xsl:when>
              <xsl:otherwise>Valore Iscr.Ipoteca :</xsl:otherwise>
            </xsl:choose>
          </td>
					<td class="testo_blue">
            <div style="float:left">
              <b>
                <xsl:choose>
                  <xsl:when test="//FG303-CDDIVIS = 'EUR'">
                    <xsl:if test="//FG303-IO-VALIPO">
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-VALIPO" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="gestImportDivisa">
                      <xsl:with-param name="import" select="//FG303-VALIPODIV"></xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </b>
            </div>
            <xsl:if test="//FG303-CDDIVIS!='EUR'">
              <div style="float:left">
                <xsl:if test="//FG303-IO-VALIPO">
                    &#160;in Euro&#160;
<b> <xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-VALIPO" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                    </b>
                  </xsl:if>
              </div>
            </xsl:if>
					</td>
					<td class="testo_nero">
            <xsl:if test="//FG303-CDDIVIS != ''">
              <xsl:attribute name="title">Valore Stima <xsl:value-of select="//FG303-CDDIVIS-D"/></xsl:attribute>
            </xsl:if>
						<xsl:choose>
							<xsl:when test="$inDivisa='S'">Valore Stima <xsl:if test="//FG303-CDDIVIS != ''">(<b><xsl:value-of select="//FG303-CDDIVIS"/></b>)</xsl:if>:</xsl:when>
							<xsl:otherwise>Valore Stima :</xsl:otherwise>
						</xsl:choose>
          </td>
					<td class="testo_blue">
            <div style="float:left">
              <b>
                <xsl:choose>
                  <xsl:when test="//FG303-CDDIVIS = 'EUR'">
                    <xsl:if test="//FG303-IO-VALSTIM">
<xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-VALSTIM" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="gestImportDivisa">
                      <xsl:with-param name="import" select="//FG303-VALSTIMDIV"></xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </b>
            </div>
            <xsl:if test="//FG303-CDDIVIS!='EUR'">
              <div style="float:left"> 
                <xsl:if test="//FG303-IO-VALSTIM">
                  &#160;in Euro&#160;
<b><xsl:call-template name="formatDecimalVB"><xsl:with-param name="VALUE"><xsl:value-of select="//FG303-IO-VALSTIM" /></xsl:with-param><xsl:with-param name="SHOW_DECIMAL"><xsl:value-of select="1" /></xsl:with-param></xsl:call-template></b>
                </xsl:if>
              </div>
            </xsl:if>
          </td>
				</tr>
				<tr height="15">
					<td class="testo_nero">Bene in Garanzia :</td>
					<td class="testo_blue">
						<input type="hidden" name="rappGar" id="rappGar">
						<xsl:attribute name="value"><xsl:value-of select="//FG303-IO-RAPGAR"/></xsl:attribute>
						</input>
						<b>
							<xsl:choose>
								<!-- Gestione Immobili - MODIFICA 23/10/2007 (INIZIO) -->
								<xsl:when test="//FG303-IO-TIPRAPG = 'I'">																
									<xsl:choose>
										<xsl:when test="//FG303-IO-NUMIMMO > 0">
											<b>Immobili Collegati:  <xsl:value-of select="//FG303-IO-NUMIMMO"/> </b>
										</xsl:when>
										<xsl:otherwise>
											<b>Immobili Collegati:  NESSUNO </b>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<!-- Gestione Immobili - MODIFICA 23/10/2007 (FINE) -->
								<xsl:otherwise>
									<xsl:if test="//FG303-IO-RAPGAR">
										<xsl:choose>
											<xsl:when test="//FG303-IO-PRG-RAPG">
												<xsl:value-of select="substring(//FG303-IO-RAPGAR,2,2)"/>/<xsl:value-of select="substring(//FG303-IO-RAPGAR,6,3)"/>/<xsl:value-of select="substring(//FG303-IO-RAPGAR,13,8)"/>/<xsl:value-of select="//FG303-IO-PRG-RAPG"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring(//FG303-IO-RAPGAR,2,2)"/>/<xsl:value-of select="substring(//FG303-IO-RAPGAR,6,3)"/>/<xsl:value-of select="substring(//FG303-IO-RAPGAR,13,8)"/>	
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</b>
					</td>
					<xsl:choose>
						<xsl:when test="not(//FG303-IO-TIPRAPG) or (//FG303-IO-TIPRAPG='')">
							<td></td>
						</xsl:when>								
						<xsl:otherwise>
							<td class="testo_nero" title="Tipo Bene in Garanzia">Tipo Bene in Gar. :</td>
						</xsl:otherwise>
					</xsl:choose>						
					<td class="testo_blue">								
						<table cellpadding="0" cellspacing="0">
							<tr>
								<xsl:choose>
									<xsl:when test="//FG303-IO-TIPRAPG = 'I'">
										<td><img src="/FG/FG303/images/immobile.gif" name="Immobile" id="Immobile"></img></td><td class="testo_blue"> - Immobile</td>
									</xsl:when>
									<xsl:when test="//FG303-IO-TIPRAPG = 'V'">
										<td><img src="/FG/FG303/images/veicolo.gif" name="Veicolo" id="Veicolo"></img></td><td class="testo_blue"> - Veicolo</td>
									</xsl:when>
									<xsl:when test="//FG303-IO-TIPRAPG = 'M'">
										<td><img src="/FG/FG303/images/merce.gif" name="Merce" id="Merce"></img></td><td class="testo_blue"> - Merce</td>
									</xsl:when>
									<xsl:when test="//FG303-IO-TIPRAPG = 'F'">
										<td><img src="/FG/FG303/images/finanziario.gif" name="Finanziario" id="Finanziario"></img></td><td class="testo_blue"> - Finanziario</td>
									</xsl:when>
									<xsl:otherwise>
										<td></td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</table>															
					</td>
				</tr>
			</table>
				<!--CRMD 148 08.06.2011-->
				<div style="text-align:left">
					<table border="0">
						<tr>
							<td class="testo_nero">
								Garanzia soggetta a Tassazione
							</td>
							<td class="testo_blue">
								<xsl:variable name="RC_Diverso">
									<xsl:if test="//FG303-FUNZ='C' and ((//FG303-RC!='00') or (//FG303-RC!='03'))">true</xsl:if>
								</xsl:variable>
								<input onclick="RadioChange_GAR_TAS()" type="radio" name="GaranziaSoggettaTassazione" id="GaranziaSoggettaTassazione_SI">
									<xsl:choose>
										<xsl:when test="//FG303-FUNZ='PC' or $RC_Diverso='true'">
											<xsl:choose>
												<xsl:when test="//FG303-IO-ABIL-GAR-TASS='S'">
													<xsl:if test="//FG303-IO-GAR-TASS='S'">
														<xsl:attribute name="checked">checked</xsl:attribute>
														<input type="hidden" id="Checked_GAR_TAS" name="Checked_GAR_TAS" value="S"/>
													</xsl:if>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="disabled">disabled</xsl:attribute>
													<xsl:if test="//FG303-IO-GAR-TASS='S'">
														<xsl:attribute name="checked">checked</xsl:attribute>
														<input type="hidden" id="Checked_GAR_TAS" name="Checked_GAR_TAS" value="S"/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:when test="//FG303-FUNZ='C' and ((//FG303-RC[.='00']) or (//FG303-RC[.='03']))">
											<xsl:attribute name="disabled">disabled</xsl:attribute>
										</xsl:when>
										<xsl:when test="//FG303-FUNZ='P' and //FG303-RC!='00'">
											<xsl:if test="//FG303-IO-GAR-TASS='S'">
												<xsl:attribute name="checked">checked</xsl:attribute>
												<input type="hidden" id="Checked_GAR_TAS" name="Checked_GAR_TAS" value="S"/>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</input> <b>Si</b>
								<input onclick="RadioChange_GAR_TAS()" type="radio" name="GaranziaSoggettaTassazione" id="GaranziaSoggettaTassazione_NO">
									<xsl:choose>
										<xsl:when test="//FG303-FUNZ='PC' or $RC_Diverso='true'">
											<xsl:choose>
												<xsl:when test="//FG303-IO-ABIL-GAR-TASS='S'">
													<xsl:if test="not(//FG303-IO-GAR-TASS) or //FG303-IO-GAR-TASS='N'">
														<xsl:attribute name="checked">checked</xsl:attribute>
														<input type="hidden" id="Checked_GAR_TAS" name="Checked_GAR_TAS" value="N"/>
													</xsl:if>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="disabled">disabled</xsl:attribute>
													<xsl:if test="not(//FG303-IO-GAR-TASS) or //FG303-IO-GAR-TASS='N'">
														<xsl:attribute name="checked">checked</xsl:attribute>
														<input type="hidden" id="Checked_GAR_TAS" name="Checked_GAR_TAS" value="N"/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:when test="//FG303-FUNZ='C' and ((//FG303-RC[.='00']) or (//FG303-RC[.='03']))">
											<xsl:attribute name="disabled">disabled</xsl:attribute>
										</xsl:when>
										<xsl:when test="//FG303-FUNZ='P' and //FG303-RC!='00'">
											<xsl:if test="not(//FG303-IO-GAR-TASS) or //FG303-IO-GAR-TASS='N'">
												<xsl:attribute name="checked">checked</xsl:attribute>
												<input type="hidden" id="Checked_GAR_TAS" name="Checked_GAR_TAS" value="N"/>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</input> <b>No</b>
							</td>
						</tr>
					</table>
				</div>
				<input type="hidden" name="ABIL_GAR_TASS">
					<xsl:attribute name="value"><xsl:value-of select="//FG303-IO-ABIL-GAR-TASS"/></xsl:attribute>
				</input>
				<input type="hidden" name="GAR_TASS">
					<xsl:attribute name="value"><xsl:value-of select="//FG303-IO-GAR-TASS"/></xsl:attribute>
				</input>
				<input type="hidden" name="HFunz">
					<xsl:attribute name="value"><xsl:value-of select="//FG303-FUNZ"/></xsl:attribute>
				</input>
				<input type="hidden" name="HRC">
					<xsl:attribute name="value"><xsl:value-of select="//FG303-RC"/></xsl:attribute>
				</input>
				<!--END CRMD 148 -->
			</div>
		</div>
		<table cellpadding="0" cellspacing="0" border="0" width="98%">
			<tr height="25">
        <xsl:if test="$ProjectManager='true'">
          <xsl:attribute name="style">height:35px;</xsl:attribute>
        </xsl:if>
				<td width="45%">
					<!--<xsl:if test="//FG303-FUNZ[.!='E']">-->
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td id="messaggi">
									<xsl:if test="((//FG303-RC[.='01']) or (//FG303-RC[.='03']))">
										<xsl:attribute name="class">text_error</xsl:attribute>
										<b>
											<xsl:value-of select="//FG303-MSG"/>
										</b>
									</xsl:if>
									<xsl:if test="((//FG303-RC[.='00']) and (//FG303-FUNZ[.='C']))">
										<xsl:attribute name="class">text_ok</xsl:attribute>
									</xsl:if>
								</td>
							</tr>
						</table>
					<!--</xsl:if>-->
				</td>
				<td width="15%" align="right">
					<xsl:if test="(((//FG303-RC[.='00']) or (//FG303-RC[.='03'])) and (//FG303-FUNZ[.='C']))">
            <xsl:choose>
              <xsl:when test="$ProjectManager='true'">
                <input type="button" class="button" name="unlock" id="unlock" onclick="sblocco()" value="Modifica Dati" title="Modifica Dati"/>                  
              </xsl:when>
              <xsl:otherwise>
                <img src="/FG/FG303/images/unlock.gif" name="unlock" id="unlock" style="cursor:hand" onclick="sblocco()" title="Modifica Dati"/>
              </xsl:otherwise>
            </xsl:choose>
					</xsl:if>
				</td>
				<td align="right" width="20%">
          <xsl:choose>
            <xsl:when test="$ProjectManager='true'">
              <input type="button" class="button" name="closeWindow" id="closeWindow" >
                <xsl:attribute name="onclick">try { var dialogDispenser = window.top.dispenserWrapper(); dialogDispenser.closeWindow();}catch(e){ window.close();} </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="//FG303-FUNZ = 'PC'">
                    <xsl:attribute name="value">Chiudi</xsl:attribute>
                    <xsl:attribute name="title">Chiudi la Finestra</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="//FG303-FUNZ = 'C' or //FG303-FUNZ = 'P'">
                    <xsl:attribute name="value">Annulla</xsl:attribute>
                    <xsl:attribute name="title">Annulla l'operazione</xsl:attribute>
                  </xsl:when>                  
                </xsl:choose>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <img src="" style="cursor:hand" name="closeWindow" id="closeWindow" >
                <xsl:attribute name="onclick">try { var dialogDispenser = window.top.dispenserWrapper(); dialogDispenser.closeWindow();}catch(e){ window.close();} </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="//FG303-FUNZ = 'PC'">
                    <xsl:attribute name="src">/FG/FG303/images/chiudiButton.gif</xsl:attribute>
                    <xsl:attribute name="title">Chiudi la Finestra</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="//FG303-FUNZ = 'C'">
                    <xsl:attribute name="src">/FG/FG303/images/annullaButton.gif</xsl:attribute>
                    <xsl:attribute name="title">Annulla l'operazione</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="//FG303-FUNZ = 'P'">
                    <xsl:attribute name="src">/FG/FG303/images/annullaButton.gif</xsl:attribute>
                    <xsl:attribute name="title">Annulla l'operazione</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              </img>
            </xsl:otherwise>
          </xsl:choose>
				</td>
				<td align="right" width="20%">
					<div id="riinviadati">
            <xsl:choose>
              <xsl:when test="$ProjectManager='true'">
                <input type="button" class="button" name="Button" id="Button">
                  <xsl:choose>
                    <xsl:when test="((//FG303-FUNZ !='PC') and ((//FG303-RC[.='00']) or (//FG303-RC[.='03'])))">
                      <xsl:attribute name="value">Conferma</xsl:attribute>
                      <xsl:attribute name="onclick">send('P')</xsl:attribute>
                      <xsl:attribute name="title">Conferma i Dati Inseriti</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="value">Invia</xsl:attribute>
                      <xsl:attribute name="title">Invia i Dati per il Controllo</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="(//FG303-O-GEST-CAVEAU = 'N')and(//FG303-O-DIGIT-MATER = 'N')">
                          <xsl:attribute name="onclick">send('C')</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="(//FG303-O-GEST-CAVEAU = 'N')and(//FG303-O-DIGIT-MATER = 'S')">
                          <xsl:attribute name="onclick">InviaM()</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test="(//FG303-O-DIGIT-CAVEAU ='N')and(//FG303-O-DIGIT-MATER = 'N')">
                              <xsl:attribute name="onclick">send('C')</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="(//FG303-O-DIGIT-CAVEAU ='N')and(//FG303-O-DIGIT-MATER = 'S')">
                              <xsl:attribute name="onclick">InviaM()</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="(//FG303-O-DIGIT-CAVEAU ='S')and(//FG303-O-DIGIT-MATER = 'N')">
                              <xsl:attribute name="onclick">InviaC()</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="onclick">Invia()</xsl:attribute>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </input>
              </xsl:when>
              <xsl:otherwise>
                <img class="able" name="Button" id="Button" border="0" style="cursor:hand">
                  <xsl:choose>
                    <xsl:when test="((//FG303-FUNZ !='PC') and ((//FG303-RC[.='00']) or (//FG303-RC[.='03'])))">
                      <xsl:attribute name="src">/FG/FG303/images/confermaButton.gif</xsl:attribute>
                      <xsl:attribute name="onclick">send('P')</xsl:attribute>
                      <xsl:attribute name="title">Conferma i Dati Inseriti</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="src">/FG/FG303/images/inviaButton.gif</xsl:attribute>
                      <xsl:attribute name="title">Invia i Dati per il Controllo</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="(//FG303-O-GEST-CAVEAU = 'N')and(//FG303-O-DIGIT-MATER = 'N')">
                          <xsl:attribute name="onclick">send('C')</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="(//FG303-O-GEST-CAVEAU = 'N')and(//FG303-O-DIGIT-MATER = 'S')">
                          <xsl:attribute name="onclick">InviaM()</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test="(//FG303-O-DIGIT-CAVEAU ='N')and(//FG303-O-DIGIT-MATER = 'N')">
                              <xsl:attribute name="onclick">send('C')</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="(//FG303-O-DIGIT-CAVEAU ='N')and(//FG303-O-DIGIT-MATER = 'S')">
                              <xsl:attribute name="onclick">InviaM()</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="(//FG303-O-DIGIT-CAVEAU ='S')and(//FG303-O-DIGIT-MATER = 'N')">
                              <xsl:attribute name="onclick">InviaC()</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="onclick">Invia()</xsl:attribute>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </img>
              </xsl:otherwise>
            </xsl:choose>
					</div>
				</td>
			</tr>
		</table>
	</center>
  <input type="hidden" name="WB-FUNZ" id="WB-FUNZ">
    <xsl:attribute name="value"><xsl:value-of select="//PAGE/PARAMS/PARAM[@name='WB-FUNZ']"/></xsl:attribute>
  </input>	
</form>
</body>
	
	
	<!--INPUT PER IL PASSAGGIO DATI-->
	
	<span id="ParamPerfezionamento" style="display:none">
		FG303-I-CDISTI=<xsl:value-of select="//FG303-I-CDISTI"/>;
		FG303-I-CDRAPP=<xsl:value-of select="//FG303-I-CDRAPP"/>;
		FG303-I-NDG=<xsl:value-of select="//FG303-I-NDG"/>;
		FG303-I-NDGAFF=<xsl:value-of select="//FG303-O-NDGAFF"/>;
		FG303-IO-PRGOLD=<xsl:value-of select="//FG303-IO-PRGOLD"/>;
		FG303-I-COMPARTO=<xsl:value-of select="//FG303-O-COMPARTO"/>;
		FG303-I-IND-PROVV=<xsl:value-of select="//FG303-O-IND-PROVV"/>;
		FG303-I-CONTABILE=<xsl:value-of select="//FG303-O-CONTABILE"/>;
		FG303-I-DIGIT-MATER=<xsl:value-of select="//FG303-O-DIGIT-MATER"/>;
		FG303-I-DIGIT-CAVEAU=<xsl:value-of select="//FG303-O-DIGIT-CAVEAU"/>;
		FG303-I-GEST-CAVEAU=<xsl:value-of select="//FG303-O-GEST-CAVEAU"/>;
		FG303-IO-NDGGAR=<xsl:value-of select="//FG303-IO-NDGGAR"/>;
		FG303-IO-NDGGAR-INT=<xsl:value-of select="//FG303-IO-NDGGAR-INT"/>;
		FG303-IO-TOTDEL=<xsl:value-of select="//FG303-IO-TOTDEL"/>;
		FG303-IO-TOTOPE=<xsl:value-of select="//FG303-IO-TOTOPE"/>;
		FG303-IO-TIPOGAR=<xsl:value-of select="//FG303-IO-TIPOGAR"/>;
		FG303-IO-TIPOCOL=<xsl:value-of select="//FG303-IO-TIPOCOL"/>;
		FG303-IO-CODGARA=<xsl:value-of select="//FG303-IO-CODGARA"/>;
		FG303-IO-IMPORTO=<xsl:value-of select="//FG303-IO-IMPORTO"/>;
		FG303-IO-DTULTV=<xsl:value-of select="//FG303-IO-DTULTV"/>;
		FG303-IO-TIPOGAR-D=<xsl:value-of select="//FG303-IO-TIPOGAR-D"/>;
		FG303-IO-TIPOCOL-D=<xsl:value-of select="//FG303-IO-TIPOCOL-D"/>;
		FG303-IO-CODGARA-D=<xsl:value-of select="//FG303-IO-CODGARA-D"/>;
		FG303-IO-INDLFIDI=<xsl:value-of select="//FG303-IO-INDLFIDI"/>;
		FG303-IO-INDSOLID=<xsl:value-of select="//FG303-IO-INDSOLID"/>;
		FG303-IO-CENTRIS=<xsl:value-of select="//FG303-IO-CENTRIS"/>;
		FG303-IO-PROQUOTA=<xsl:value-of select="//FG303-IO-PROQUOTA"/>;
		FG303-IO-VALSTIM=<xsl:value-of select="//FG303-IO-VALSTIM"/>;
		FG303-IO-VALIPO=<xsl:value-of select="//FG303-IO-VALIPO"/>;
		FG303-IO-RAPGAR=<xsl:value-of select="//FG303-IO-RAPGAR"/>;
		FG303-IO-TIPRAPG=<xsl:value-of select="//FG303-IO-TIPRAPG"/>;
		FG303-IO-ABIL-GAR-TASS=<xsl:value-of select="//FG303-IO-ABIL-GAR-TASS"/>;
	    FG303-IMPDIVIS=<xsl:value-of select="//FG303-IMPDIVIS"/>;
	    FG303-VALSTIMDIV=<xsl:value-of select="//FG303-VALSTIMDIV"/>;
	    FG303-VALIPODIV=<xsl:value-of select="//FG303-VALIPODIV"/>;
	    FG303-CDDIVIS=<xsl:value-of select="//FG303-CDDIVIS"/>;
		FG303-LIMITE=<xsl:value-of select="//FG303-LIMITE"/>;
		FG303-LIMDIVIS=<xsl:value-of select="//FG303-LIMDIVIS"/>;
		FG303-PERCUTI=<xsl:value-of select="//FG303-PERCUTI"/>;
		FG303-TAB102-FLAVV-PERCGA=<xsl:value-of select="//FG303-TAB102-FLAVV-PERCGA"/>;
    WB-FUNZ=<xsl:value-of select="//PAGE/PARAMS/PARAM[@name='WB-FUNZ']"/>
	</span>

	<!--INPUT PER IL PASSAGGIO DATI-->

</xsl:if> 
</xsl:if>	

</xsl:template>

<!--Se il perfezionamento &#232; stato effettuato correttamente chiudo la modale e ritorno il valore S per alert di conferma -->
<xsl:template match="//FG303-FUNZ">
	<script>
		try {
			var dialogDispenser = window.top.dispenserWrapper();
			dialogDispenser.setReturnParam("S");
			dialogDispenser.closeWindow();
		} catch(e) {
			parent.returnValue="S";
			parent.close();
		}
	</script>
</xsl:template>

<xsl:template match="//FG303-RC">

	<xsl:call-template name="ERRORE">
		
		<xsl:with-param name="funzione" select="'FG303'"/>
		<xsl:with-param name="nomeHostFunz" select="'FGGNF303'"/>
		<xsl:with-param name="descrFunz" select="'Gest. Garanzie: Perfezionamento Garanzia'"/>
		<xsl:with-param name="returnCode" select="//FG303-RC"/>
		<xsl:with-param name="PGMerrore" select="//FG303-PGMERR"/>
		<xsl:with-param name="MSGerrore" select="//FG303-MSG"/>
		<xsl:with-param name="RESPcode" select="//FG303-RESP"/>
		<xsl:with-param name="SQLcode" select="//FG303-SQLCODE"/>
			
	</xsl:call-template>
	
</xsl:template>

  <xsl:template name="gestImportDivisa">
    <xsl:param name="import"></xsl:param>

    <xsl:variable name="importValue">
      <xsl:call-template name="do-replace">
        <xsl:with-param name="replace" select="','"></xsl:with-param>
        <xsl:with-param name="by" select="''"></xsl:with-param>
        <xsl:with-param name="text" select="$import"></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="ImpElaborato">
      <xsl:call-template name="format-decimal">
        <xsl:with-param name="importo" select="$importValue"></xsl:with-param>
        <xsl:with-param name="centSN" select="1"></xsl:with-param>
        <xsl:with-param name="numeroDecimali" select="3"></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$ImpElaborato"/>

  </xsl:template>

  <xsl:template name="gestPercentuale">
    <xsl:param name="valore"/>

    <xsl:variable name="segno" select="substring($valore,string-length($valore))"/>
    <xsl:variable name="valoreCampo" select="substring($valore,0,string-length($valore))"/>

    <xsl:choose>
      <xsl:when test="$segno='-'">
        <xsl:value-of select="$segno"/>
        <xsl:value-of select="$valoreCampo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$valoreCampo"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
