<?xml version='1.0'  ?>
<xsl:stylesheet xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:user="http:www.cedacri.it" xmlns:xdsl="http:www.cedacri.it">
  <xsl:output method="html" indent="no"/>

  <xsl:include href="../../../common64/XSL/MainATitle_INC.xsl"/>

  <!-- SCRIPT XSL --> 
  
  <xsl:include href="../../errore/errore.xsl"/>
  <xsl:include href="../../errore/erroreFeu.xsl"/>
  <xsl:include href="utilities.xsl"/>
  <xsl:include href="../../commonFG/xsl/commonUtils.xsl"/>
  <xsl:template match="/">

    <script src="/XIFN/Script/FileNet.js"></script>
    <script src="/common64/Script/General.js"></script>
    <script src="/FG/PF300/JScripts/Main.js"></script>   
    <script src="/FG/PF300/JScripts/functionButton.js"></script>
    <script src="/FG/PF300/JScripts/Pagination.js"></script>
    <script language="javascript" src="FG/FGA_common/Jscripts/FGA_Common.js"></script>
    <!-- MenuCont.js Contiene gli script necessari alla gestione del menu contestuale -->
    <script src="/FG/PF300/JScripts/MenuCont.js"></script>
    <!-- MenuCont.js -->

    <LINK rel="stylesheet" type="text/css" href="/FG/PF300/css/PF300.css"/>
    <LINK rel="stylesheet" type="text/css" href="/FG/PF300/css/MenuCont.css"/>
    <link rel="stylesheet" type="text/css" href="/common64/styles/Standard.css" />
      
    <xsl:choose>
      <xsl:when test="PAGE/PARAMS/PARAM[@name='readOnly'] = 'true'">
        <link rel="stylesheet" type="text/css" href="FG/FGA_common/css/FGA_Common.css"></link>
        <xsl:apply-templates select="PAGE/DESCRIPTION"/>
        <script language="javascript">
          try{parent.framesetAppl300.rows="0,*,0,0,00";
          document.getElementById('Td_MenuPath').innerHTML='FGPFF300';
          document.getElementById('Td_Titolo').innerHTML='PF300 - PEF - Elenco Garanzie';
          } catch(errore) {}
        </script>
        <input type="hidden" name="readOnly" id="readOnly" value="true"/>
      </xsl:when>
      <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
        <link rel="stylesheet" type="text/css" href="FG/FGA_common/css/FGA_Common.css"></link>
        <script language="javascript">
          try {          
            parent.document.getElementById('Td_MenuPath').innerHTML='FGPFF300';
            parent.document.getElementById('Td_Titolo').innerHTML='PF300 - PEF - Elenco Garanzie';
          } catch(errore) {}
        </script>
      </xsl:when>
	  <xsl:otherwise>
		<LINK rel="stylesheet" type="text/css" href="/common64/styles/Standard.css"/>
		<link rel="stylesheet" type="text/css" href="/MN/common/CSS/fixedHeaderTable.css" />
		<!-- Include files per gestione degli Errori - FEU Standard  -->
		<link rel="stylesheet" type="text/css" media="screen" href="/FG/FG_common/css/errorFEU.css" />
		<script language="javascript" src="/FG/FG_common/Jscripts/errorFEU.js"></script>
		<script src="/common64/Script/GeneralFEU.js"></script>
	  </xsl:otherwise>
    </xsl:choose>	   
    <!-- XML Island di gestione dell' errore - INIZIO -->    
    <script type="application/xml" id="xml_RESULT">
      <RESULT>
        <CODE>
          <xsl:value-of select="/PAGE/OUTPUT/RESULT/CODE" />
        </CODE>
        <OUTCOME>
          <xsl:value-of select="/PAGE/OUTPUT/RESULT/OUTCOME" />
        </OUTCOME>
        <DESCRIPTION>
          <xsl:value-of select="/PAGE/OUTPUT/RESULT/DESCRIPTION" />
        </DESCRIPTION>
        <LONGDESCRIPTION>
          <xsl:value-of select="/PAGE/OUTPUT/RESULT/LONGDESCRIPTION" />
        </LONGDESCRIPTION>
        <MODULE>
          <xsl:value-of select="/PAGE/OUTPUT/RESULT/MODULE" />
        </MODULE>
      </RESULT>
    </script>
    <!-- XML Island di gestione dell' errore - FINE -->
    
    <input type="hidden" id="WB-FUNZ">
      <xsl:attribute name="value">
        <xsl:value-of select="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']"/>
      </xsl:attribute>
    </input>

    <input type="hidden" id="FUNZ">
      <xsl:attribute name="value">
        <xsl:value-of select="//FG300-FUNZ"/>
      </xsl:attribute>
    </input>

    <script type="text/javascript">      
      try{        
        if(parent.parent.FGA20 || parent.FGA20)  {
          if (parent.framesetAppl300) {
            parent.framesetAppl300.frameborder="1";
            parent.framesetAppl300.rows="0,*,0,00";                                    
          }
        }
      }
      catch(e){}
    </script>
    <!--script type="text/javascript">
      try{
      if (document.getElementById("WB-FUNZ").value=="PM") {    
      parent.framesetAppl300.rows="0,*,0,00";
      }
      }
      catch(e){}
    </script-->

    <xsl:choose>

      <xsl:when test="//CODE[.!=0]">
		<xsl:choose>
			<xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
				<xsl:call-template name="ERROREWB">
				  <xsl:with-param name="descrizione" select="//LONGDESCRIPTION"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ERROREWB_FEU">
				  <xsl:with-param name="descrizione" select="//LONGDESCRIPTION"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
      </xsl:when>

	  <xsl:when test="//FG300-FUNZ = 'C'">
		<body>
			<xsl:attribute name="onload">
				<xsl:choose>
					<xsl:when test="//FG300-RC[.='01']">
            alert(document.getElementById("FG300-MSG").value);
            recallFG300('<xsl:value-of select="PAGE/PARAMS/PARAM[@name='FUNZ-PRECEDENTE']"/>', '<xsl:value-of select="//FG300-I-NDG"/>', '<xsl:value-of select="//FG300-I-CDISTI"/>', '<xsl:value-of select="//FG300-I-DTISTR"/>', '<xsl:value-of select="//FG300-I-PRGISTR"/>');
					</xsl:when>
					<xsl:when test="//FG300-RC[.='03']">
            alert(document.getElementById("FG300-MSG").value);
            refreshFGA20('AP', '<xsl:value-of select="//FG300-I-CDTIPOL"/>', '<xsl:value-of select="//FG300-I-PRGISTR"/>');
					</xsl:when>
					<xsl:when test="//FG300-RC[.='09']">
            alert(document.getElementById("FG300-MSG").value);
            recallFG300('<xsl:value-of select="PAGE/PARAMS/PARAM[@name='FUNZ-PRECEDENTE']"/>', '<xsl:value-of select="//FG300-I-NDG"/>', '<xsl:value-of select="//FG300-I-CDISTI"/>', '<xsl:value-of select="//FG300-I-DTISTR"/>', '<xsl:value-of select="//FG300-I-PRGISTR"/>');
          </xsl:when>
					<xsl:otherwise>
						refreshFGA20('AP', '<xsl:value-of select="//FG300-I-CDTIPOL"/>', '<xsl:value-of select="//FG300-I-PRGISTR"/>');
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
      <input type="hidden" id="FG300-MSG" value="{//FG300-MSG}"></input>
		</body>
	  </xsl:when>
      <xsl:when test="((//FG300-RC[.!='00']) and (//FG300-RC[.!='02']) and (//FG300-RC[.!='03']))">
        <xsl:call-template name="RC"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="BODY"></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="BODY">

	<xsl:variable name="testWB">
		<xsl:choose>
			<xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

    <xsl:variable name="Intervallo">
      <xsl:choose>
        <xsl:when test="//FG300-O-FLAVV-PRATEST = 'S'">50000</xsl:when>
        <xsl:otherwise>500</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="//WB000-RETCOD[.=0]">

      <xsl:if test="(//FG300-RC[.='00']) or (//FG300-RC[.='02']) or (//FG300-RC[.='03'])">


        <BODY style="overflow-y:auto;" oncontextmenu="return false" name="bodyLoaded" id="bodyLoaded" topmargin="8" leftmargin="0" rightmargin="0" scroll="auto">
          <xsl:if test="$testWB='true'">
            <xsl:attribute name="topmargin">0</xsl:attribute>
          </xsl:if>

          <xsl:choose>
            <xsl:when test="//FG300-RC='02' and $testWB='false'">
              <xsl:attribute name="onload">
                <xsl:choose>
                  <xsl:when test="//FG300-I-TPFUNZ='I'">
                    indietro();
                  </xsl:when>
                  <xsl:otherwise>
                    conferma();
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="onload">                
                
                setNDG('<xsl:value-of select="//FG300-I-NDG" />');
                startApplication('<xsl:value-of select="//WB000-TIMESTAMP" />','<xsl:value-of select="//FG300-FUNZ" />');
				
				        <xsl:choose>
                  <xsl:when test="$testWB='true'">
                    if('<xsl:value-of select="PAGE/PARAMS/PARAM[@name='readOnly']"/>' == 'true')
                    {readOnly();}

					setHeightOfTable();
                  </xsl:when>
                  <xsl:otherwise>
					setHeightOfTable();
					checkRowspan();
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="(//FG300-RC[.!='01'] and //FG300-RC[.!='02'])">
                  setRange(getCurrentPage(),getTotPages());
                </xsl:if>

                controlloBlocco('<xsl:value-of select="//FG300-O-BLOCCO-NDG"/>')              
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:attribute name="onresize">
            <xsl:choose>
              <xsl:when test="$testWB='true'">
				setHeightOfTable();
              </xsl:when>
              <xsl:otherwise>
				setHeightOfTable();
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>            

        <!--  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
            <xsl:apply-templates select="PAGE/DESCRIPTION" />
          </xsl:if> -->
              
          <script type="text/javascript">      
                try{        
                  if(parent.parent.FGA20)  {
                    if (parent.framesetAppl300) {
                      document.body.style.borderWidth = "2px";                                                             
                      document.body.style.borderStyle = "inset";                      
                    }
                  }
                }
                catch(e){}
            </script>
        
          <input type="hidden" name="projMan" value="{$testWB}" />
          <input type="hidden" name="Intervallo" value="{$Intervallo}" />
		  <input type="hidden" name="flagPrep" id="flagPrep">
			<xsl:attribute name="value"><xsl:value-of select="//FG300-I-PREP"/></xsl:attribute>
		  </input>
		  
		  <input type="hidden" id="bloccaInserimento" value="N">
			<xsl:if test="//FG300-IO-FL-BLINSE = 'S'">
				<xsl:attribute name="value">S</xsl:attribute>
			</xsl:if>
		  </input>

			<xsl:variable name="avvDivisa">
				<xsl:choose>
					<xsl:when test="//FG300-O-FLAVV-GARDIV='S'">S</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>


			<xsl:variable name="labelEuro">
				<xsl:choose>
					<xsl:when test="//FG300-O-FLAVV-GARDIV='S'">(in Euro)</xsl:when>
				</xsl:choose>
			</xsl:variable>
			
			<input type="hidden" id="abilCk">
				<xsl:attribute name="value"><xsl:value-of select="//FG300-IO-FL-ABIL-CK"/></xsl:attribute>
			</input>
			
			<input type="hidden" id="abilInsAtto">
				<xsl:choose>
					<xsl:when test="//FG300-FUNZ = 'MD'">
						<xsl:attribute name="value">N</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="value">S</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</input>
    
			<div style="width:100%;">
				<xsl:if test="$testWB='false'">
					<xsl:attribute name="class">boxContainer</xsl:attribute>
					<xsl:attribute name="style">width:100%;margin:10px;</xsl:attribute>
				</xsl:if>
			<div class="boxDataCont" style="width:100%;margin:0;">
                <table class="border_top_bottom" height="100%" width="100%" cellpadding="0" border="0" cellspacing="0" >
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">summaryTable</xsl:attribute>
						<xsl:attribute name="width"></xsl:attribute>
					</xsl:if>
                  <tr>
                    <xsl:choose>
                      <xsl:when test="$testWB='true'">
                        <xsl:attribute name="class">testo_neroPF300</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class"></xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="//FG300-I-TPFUNZ='I'">

                          </xsl:when>
                          <xsl:otherwise>
                            <td style="padding-left:5;" width="9%" align="left">
								<xsl:if test="$testWB='false'">
									<xsl:attribute name="class">descColSummary</xsl:attribute>
								</xsl:if>
								<label>
								<xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldNameLblBox</xsl:attribute>
								</xsl:if>
                                <xsl:if test="//FG300-O-FILOPE-D">
                                  <xsl:value-of select="//FG300-O-FILOPE-D"/> -
                                </xsl:if>
								</label>
								<label>
								<xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldDataLblBox</xsl:attribute>
								</xsl:if>

                                <xsl:if test="//FG300-O-RUOOPE-D">
                                  <xsl:value-of select="//FG300-O-RUOOPE-D"/> -
                                </xsl:if>
								

                                <xsl:if test="//FG300-O-NDGOPE-D">
                                  <xsl:value-of select="//FG300-O-NDGOPE-D"/>
                                </xsl:if>
							  </label>
                            </td>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    
                  </tr>
                  <tr>
                    <xsl:if test="$testWB='false'">
                      <xsl:attribute name="class"></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$testWB='true'">
                      <xsl:attribute name="class">testo_neroPF300</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="//FG300-I-TPFUNZ='I'">

                        </xsl:when>
                        <xsl:otherwise>
                          <td style="text-align:left; padding-left:5px;" width="9%" align="left">
							<xsl:if test="$testWB='true'">
								<xsl:attribute name="style">text-align:left; padding-left:5px;font-weight:bold;</xsl:attribute>
							</xsl:if>
                              <xsl:if test="//FG300-O-FILOPE-D">
                                <xsl:value-of select="//FG300-O-FILOPE-D"/> -
                              </xsl:if>

                              <xsl:if test="//FG300-O-RUOOPE-D">
                                <xsl:value-of select="//FG300-O-RUOOPE-D"/> -
                              </xsl:if>

                              <xsl:if test="//FG300-O-NDGOPE-D">
                                <xsl:value-of select="//FG300-O-NDGOPE-D"/>
                              </xsl:if>
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    
                    
                    <xsl:choose>
                      <xsl:when test="//FG300-I-TPFUNZ='I'">
                        <td class="testo_nero_bold" style="padding-right:5">
                          <xsl:choose>
                            <xsl:when test="$testWB='true'">
                              <xsl:attribute name="style">padding-right:5; text-align:right; font-weight:bold;</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">descColSummary</xsl:attribute>  
                            </xsl:otherwise>
                          </xsl:choose>                          
                          <xsl:if test="//FG300-O-DTDEL">
                            <xsl:if test="//FG300-I-STATO[.='C']">
                              <label>
								  <xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldNameLblBox</xsl:attribute>
								</xsl:if>
							  Consultazione Istruttoria deliberata il </label>
							  <label>
								  <xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldDataLblBox</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="user:formatData(//FG300-O-DTDEL,4)"/>
							  </label>
                            </xsl:if>
                          </xsl:if>

                          <xsl:if test="//FG300-O-DTFINE">
                            <xsl:if test="//FG300-I-STATO[.='A']">
                              <label>
								  <xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldNameLblBox</xsl:attribute>
								</xsl:if>
							  Consultazione Istruttoria annullata il 
							  </label>
							  <label>
							  <xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldDataLblBox</xsl:attribute>
								</xsl:if>
							  <xsl:value-of select="user:formatData(//FG300-O-DTFINE,4)"/>
							  </label>
                            </xsl:if>
                          </xsl:if>

                          <xsl:if test="//FG300-O-DTINI">
                            <xsl:if test="//FG300-I-STATO[.='L']">
							<label>
							<xsl:if test="$testWB='false'">
								<xsl:attribute name="class">fieldNameLblBox</xsl:attribute>
							</xsl:if>
                              Consultazione Istruttoria in lavorazione dal 
							  </label>
							  <label>
							  <xsl:if test="$testWB='false'">
								<xsl:attribute name="class">fieldDataLblBox</xsl:attribute>
							</xsl:if>
							  <xsl:value-of select="user:formatData(//FG300-O-DTINI,4)"/>
							  </label>
                            </xsl:if>
                          </xsl:if>

                          <xsl:if test="//FG300-O-DTINI">
                            <xsl:if test="//FG300-I-STATO[.='S']">
							<label>
							<xsl:if test="$testWB='false'">
								<xsl:attribute name="class">fieldNameLblBox</xsl:attribute>
							</xsl:if>
                              Consultazione Istruttoria in lavorazione dal 
							  </label>
							  <label>
							  <xsl:if test="$testWB='false'">
								<xsl:attribute name="class">fieldDataLblBox</xsl:attribute>
							</xsl:if>
							  <xsl:value-of select="user:formatData(//FG300-O-DTINI,4)"/> <font color="#990000"> (Sospesa)</font>
							  </label>
                            </xsl:if>
                          </xsl:if>

                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:if test="//FG300-O-DTPDF">
                          <td style="padding-right:10px; text-align:right" width="9%">
							<xsl:if test="$testWB='false'">
								<xsl:attribute name="class">descColSummary</xsl:attribute>  
							</xsl:if>
							<label>
							<xsl:if test="$testWB='false'">
								<xsl:attribute name="class">fieldNameLblBox</xsl:attribute>
							</xsl:if>
							<xsl:if test="$testWB='true'">
								<xsl:attribute name="style">padding-right:10px; text-align:right;font-weight:bold;</xsl:attribute>
							</xsl:if>
                              Istruttoria in lavorazione dal 
							  </label>
							  <label>
							  <xsl:if test="$testWB='false'">
									<xsl:attribute name="class">fieldDataLblBox</xsl:attribute>
								</xsl:if>
							  <xsl:value-of select="user:formatData(//FG300-O-DTPDF,4)"/><xsl:if test="//FG300-O-TIPOPE-D">
                                - <xsl:value-of select="//FG300-O-TIPOPE-D"/>
                              </xsl:if>
							</label>
                          </td>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                  </tr>
                </table>   
				</div>
				</div>
			  <div style="width:100%;">
			  <xsl:if test="$testWB='false'">
				<xsl:attribute name="class">boxContainer</xsl:attribute>
				<xsl:attribute name="style">width:100%;margin:10px;margin-top:0;</xsl:attribute>
			</xsl:if>
          <table cellspacing="0" cellpadding="0" width="100%" border="0">
			<xsl:if test="$testWB='false'">
				<xsl:attribute name="class">stdDataTable</xsl:attribute>
			</xsl:if>
            <tr>
              <xsl:choose>
                <xsl:when test="$testWB='true'">
                  <xsl:attribute name="class">testo_neroPF300</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class"></xsl:attribute>
                  <xsl:choose>
				  <xsl:when test="$testWB='true'">
				  <td>
                    <img src="/FG/PF300/images/fidiButton.gif" name="" id="" title="Lavorazione Fidi" class="abled" style="cursor:hand">
                      <xsl:attribute name="onclick">
                        openPF100('<xsl:value-of select="//FG300-I-TPFUNZ"/>', '<xsl:value-of select="//FG300-I-STATO"/>')
                      </xsl:attribute>
                    </img>
                  </td>
				  </xsl:when>
				  <xsl:otherwise>
					<td class="titleColL" style="height:25px;"> 
						<div class="" style="position:relative;cursor:pointer;" title="Lavorazione Fidi">
							<xsl:attribute name="onclick">
								openPF100('<xsl:value-of select="//FG300-I-TPFUNZ"/>', '<xsl:value-of select="//FG300-I-STATO"/>')
							  </xsl:attribute>
							<table class="buttonContainer" id="">
								<tr>
									<td style="padding:0;padding-bottom:0px;border:0;">
										<a class="btnImgL" href="#" onClick="">
											<span style="padding-left:9px;padding-right:15px; height:20px;"><img alt="indietro" style="margin-top:3px;margin-right:10px;" src="/common64/images/btn-ico-prev.png"/><label>Fidi</label></span>
										</a>						
									</td>
								</tr>
							</table>
						</div>
					</td>
				  </xsl:otherwise>
				  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>                
              <td align="left" style="padding-left:5">
				<xsl:if test="$testWB='false'">
					<xsl:attribute name="class">titleColL</xsl:attribute>
				</xsl:if>
                Pratica Numero : <b>
                  <xsl:value-of select="//FG300-IO-PRATICA"/>
                </b>
              </td>
              <td align="left" style="padding-left:35">
				<xsl:if test="$testWB='false'">
					<xsl:attribute name="class">titleColL</xsl:attribute>
				</xsl:if>
                Totale Deliberato <xsl:value-of select="$labelEuro"/> :
                <b>
                  <xsl:choose>
                    <xsl:when test="//FG300-IO-TOTDEL">
                      <xsl:choose>
                        <xsl:when test="//FG300-IO-TOTDEL = 0">
                          0
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="user:formatDecimal(//FG300-IO-TOTDEL,0)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      0
                    </xsl:otherwise>
                  </xsl:choose>
                </b>
              </td>
              <td align="left" style="padding-left:35">
				<xsl:if test="$testWB='false'">
					<xsl:attribute name="class">titleColL</xsl:attribute>
				</xsl:if>
                Totale Operativo <xsl:value-of select="$labelEuro"/> :
                <b>
                  <xsl:choose>
                    <xsl:when test="//FG300-IO-TOTOPE">
                      <xsl:choose>
                        <xsl:when test="//FG300-IO-TOTOPE = 0">
                          0
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="user:formatDecimal(//FG300-IO-TOTOPE,0)"/>
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
			</div>
          <form name="formDati" style="margin:0;margin-top:10px;">
			<div class="boxContainer" id="mainContainer" style="width:100%;margin-top:0;border:1px solid #CCCCCC;">
			<xsl:if test="$testWB='false'">
				<xsl:attribute name="style">width:100%;margin:10px;margin-top:0;border:1px solid #CCCCCC;</xsl:attribute>
			</xsl:if>
			<div id="datiTabella">
			<div style="width:100%; border:0; position:absolute; margin-top:-1px; z-index:500;"></div>
			<div id="tableContainer">
				<table id="scollableTable" style="border:0;" width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" border="0" class="stdDataTable" >
				<xsl:choose>
                <xsl:when test="$testWB='true'">
								<xsl:attribute name="class">tabNEUTRA</xsl:attribute>
								<xsl:attribute name="cellpadding">1</xsl:attribute>
								</xsl:when>
                <xsl:otherwise><xsl:attribute name="class">stdDataTable</xsl:attribute></xsl:otherwise>
              </xsl:choose>
			  <thead class="static">
              
              <tr height="20px">
                <xsl:choose>
                  <xsl:when test="$testWB='true'">
					  <xsl:attribute name="class">titoloELENCO_TAB_PEF</xsl:attribute>
				  </xsl:when>
                  <xsl:otherwise><xsl:attribute name="class"></xsl:attribute></xsl:otherwise>
                </xsl:choose>
                <td class="firstTd">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColL</xsl:attribute>
					</xsl:if>
				&#160;<!--<img src="/FG/PF300/images/trasparent.gif" height="10" width="10"/>--></td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				&#160;<!--<img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>--></td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColR</xsl:attribute>
					</xsl:if>
				N°</td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColL</xsl:attribute>
					</xsl:if>
				Tipo</td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColL</xsl:attribute>
					</xsl:if>
				Collegamento</td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColL</xsl:attribute>
					</xsl:if>
				Comparto</td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				NDG Garante</td>
                <td class="bordo_lt">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				Scadenza</td>
                <td class="bordo_lt">
                  <xsl:if test="$testWB='true'">
                    <xsl:attribute name="style">padding-right:30px</xsl:attribute>
                  </xsl:if>
				  <xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColR</xsl:attribute>
						<xsl:attribute name="style">border-right:0;</xsl:attribute>
					</xsl:if>
                  Importo
                </td>
                <td class="bordo_t">
					<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
						<xsl:attribute name="style">border-left:0;</xsl:attribute>
					</xsl:if>
				</td>
                <td class="bordo_lt" title="Su Fidi Revocati">
                  <xsl:choose>
                    <xsl:when test="$testWB='true'">
                      <img src="/FG/PF300/images/sfrPef.gif"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <!--<img src="/FG/PF300/images/sfr.gif"/>-->
					  <xsl:attribute name="class">titleColC</xsl:attribute>
					  SFR
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="bordo_ltr" id="bordo_ltr_td_p" title="Garanzia Provvisoria">
				<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				P</td>
                <td class="bordo_ltr" title="Collegamento Linee/Garanzie Cartolarizzate">
				<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				C</td>
                <td class="bordo_ltr" title="Indicativo libro fidi">
				<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				L</td>
                <td class="bordo_ltr" title="Indicativo presenza File Allegati">
				<xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
				A</td>
				  <xsl:if test="$avvDivisa='S'">
					  <td class="bordo_ltr" title="Indicativo Garanzia in divisa">
						  <xsl:if test="$testWB='false'">
							  <xsl:attribute name="class">titleColC</xsl:attribute>
						  </xsl:if>
						  <img src="/FG/PF300/images/trasparent.gif" style="width:8px"/>
					  </td>
				  </xsl:if>
			  </tr>
            </thead>

            <tbody>
                  
                <xsl:for-each select="//FG300-OUTPUT/FG300-TAB-DATI/FG300-EL-DATI">
                  <!-- <tr>
                    <xsl:choose>
                      <xsl:when test="FG300-ERRDEL='N'">
                        <xsl:choose>
                          <xsl:when test="position() mod 2 = 0">
                            <xsl:attribute name="class">riga_elenco1</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">riga_elenco2</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">rigaErrore</xsl:attribute>
                        <xsl:attribute name="title">Errore in fase di delibera: consultare dettaglio Garanzia</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
					<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
						<xsl:attribute name="class"></xsl:attribute>
					</xsl:if>
                    <td colspan="15" style="padding:0;border:0;">
                      <table cellspacing="0" cellpadding="0" width="100%">
                       <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                          <xsl:attribute name="style">border-top:1px solid #CCCCCC;</xsl:attribute>
                        </xsl:if>  -->
                       
                        <xsl:choose>
                          <xsl:when test="string-length(FG300-PRGGAR) >= 3 and not(//FG300-O-FLAVV-PRATEST='S')"></xsl:when>
                          <xsl:when test="string-length(FG300-PRGGAR) >= 4 and //FG300-O-FLAVV-PRATEST='S'"></xsl:when>
                          <xsl:otherwise>
                            <tr height="24">

                              <td>
                                <xsl:choose>
                                  <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                    <xsl:attribute name="class">testo_biancoPF300</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">titleColL</xsl:attribute>
                                    <xsl:attribute name="style">border-top:1px solid #CCCCCC;</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>In Essere
                              </td>
                              <td class="bordo_tlb" name="tdToCheckInput" id="tdToCheckInput">
                                <xsl:if test="FG300-VISPRO='S'">
                                  <xsl:attribute name="rowspan">2</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="(//FG300-I-TPFUNZ='I')">
                                    <input type="checkbox" id="checkRow" name="checkRow">
                                      <xsl:attribute name="disabled">true</xsl:attribute>
                                      <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                        <xsl:attribute name="class">styled ck_disab_opt_normal_unsel</xsl:attribute>
                                      </xsl:if>
                                    </input>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <input type="checkbox" name="check" id="check">
                                      <!--input type="checkbox" name="check" onclick="materButton(this); abilita(this); chiudiDettaglio(riga1,50); oneCheck(this,this.form.check)"-->

                                      <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                        <xsl:attribute name="class">styled ck_disab_opt_normal_unsel</xsl:attribute>
                                      </xsl:if>

                                      <xsl:choose>
                                        <xsl:when test="FG300-BLOCCO-GAR='S'">
                                          <xsl:attribute name="disabled">true</xsl:attribute>
                                          <xsl:attribute name="title">Presenza di proposta sulla garanzia</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <xsl:attribute name="onclick">oneCheck(this,this.form.check); abilita(this)</xsl:attribute>
                                        </xsl:otherwise>
                                      </xsl:choose>

                                      <xsl:attribute name="LIBFIDI">
                                        <xsl:value-of select="//FG300-IO-BL-LIBFIDI-N"/>
                                      </xsl:attribute>
                                      <xsl:attribute name="LIBROF">
                                        <xsl:value-of select="FG300-LIBROF"/>
                                      </xsl:attribute>

                                      <!--attributo Codice Rapporto-->
                                      <xsl:variable name="progGaranzia">
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGGAR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">5</xsl:with-param>
                                        </xsl:call-template>
                                      </xsl:variable>

                                      <xsl:attribute name="cdRapp">
                                        <xsl:text>00000</xsl:text>
                                        <xsl:value-of select="FG300-PRATICA"/>
                                        <xsl:value-of select="$progGaranzia"/>
                                      </xsl:attribute>

                                      <!--attributo Pratica-->
                                      <xsl:attribute name="pratica">
                                        <xsl:value-of select="FG300-PRATICA"/>
                                      </xsl:attribute>

                                      <!--attributo Pratica Corrente-->
                                      <xsl:attribute name="praCorr">
                                        <xsl:value-of select="FG300-PRAT-CORR"/>
                                      </xsl:attribute>

                                      <!--attributo Tipo Collegamento-->
                                      <xsl:attribute name="tpCol">
                                        <xsl:value-of select="FG300-TIPCOL"/>
                                      </xsl:attribute>

                                      <!--attributo Tipo Garanzia-->
                                      <xsl:attribute name="tipGar">
                                        <xsl:value-of select="FG300-TIPGAR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Tipo Garanzia Pr-->
                                      <xsl:attribute name="tipGarPr">
                                        <xsl:value-of select="FG300-TIPGAR-PR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Importo Proposto-->
									  <xsl:attribute name="importoPr">
                                        <xsl:value-of select="FG300-IMPORTO-PR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Cod Garanzia-->
									  <xsl:attribute name="codGar">
                                        <xsl:value-of select="FG300-CODGAR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Cod Garanzia Pr-->
									  <xsl:attribute name="codGarPr">
                                        <xsl:value-of select="FG300-CODGAR-PR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Divisa-->
									  <xsl:attribute name="divisa">
										<xsl:value-of select="//FG300-TAB-DATI2/FG300-EL-DATIDIV[@ID = position()]/FG300-CDDIVIS-PR"/>
									  </xsl:attribute>

                                      <!--attributo Numero Materialità-->
                                      <xsl:choose>
                                        <xsl:when test="FG300-NUMMATER > 0">
                                          <xsl:attribute name="numMater">
                                            <xsl:value-of select="FG300-NUMMATER"/>
                                          </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <xsl:attribute name="numMater">0</xsl:attribute>
                                        </xsl:otherwise>
                                      </xsl:choose>

                                      <!--attributo Indicativo Provisorio-->
                                      <xsl:attribute name="indProv">
                                        <xsl:value-of select="FG300-IND-PROV"/>
                                      </xsl:attribute>

                                      <!--attributo Totale Operativo-->
                                      <xsl:attribute name="totOpe">
                                        <xsl:value-of select="//FG300-IO-TOTOPE"/>
                                      </xsl:attribute>

                                      <!--attributo Totale Deliberato-->
                                      <xsl:attribute name="totDel">
                                        <xsl:value-of select="//FG300-IO-TOTDEL"/>
                                      </xsl:attribute>

                                      <!--attributo costante linnee collegate-->
                                      <xsl:attribute name="costantLin">
                                        00000<xsl:value-of select="FG300-PRATICA"/>
                                      </xsl:attribute>

                                      <xsl:if test="(FG300-TIPCOL = 'P') or (FG300-TIPCOL = 'L')">
                                        <!--attributo Linee Collegate-->
                                        <xsl:attribute name="linee">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-PRGLIN"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>

                                        <xsl:attribute name="lineeEst">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-LINEST"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>

                                        <xsl:attribute name="dtRife">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-DTRIFE"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>

                                        <xsl:attribute name="prgRif">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-PRGRIF"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>
                                      </xsl:if>

                                      <xsl:if test="(FG300-TIPCOL = 'C')">
                                        <!--attributo Garanzie Collegate-->
                                        <xsl:attribute name="garanzie">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-PRGLIN"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>
                                      </xsl:if>

                                      <!--attributo Linea Cartolarizzata-->
                                      <xsl:attribute name="carto">
                                        <xsl:value-of select="FG300-INDCARTO"/>
                                      </xsl:attribute>

                                      <xsl:attribute name="visPro">
                                        <xsl:value-of select="FG300-VISPRO"/>
                                      </xsl:attribute>

                                      <xsl:attribute name="prgGar">
                                        <xsl:value-of select="FG300-PRGGAR"/>
                                      </xsl:attribute>

                                      <xsl:attribute name="dtIstr">
                                        <xsl:value-of select="//FG300-O-DTISTR"/>
                                      </xsl:attribute>
                                      <xsl:attribute name="prgIstr">
                                        <xsl:value-of select="//FG300-O-PRGISTR"/>
                                      </xsl:attribute>
                                    </input>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                              <td nowrap="true">
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;text-align:right</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>

                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                    <xsl:if test="FG300-PRGOLD">
                                      <xsl:attribute name="title">
                                        <xsl:text>Progressivo di garanzia old: </xsl:text>
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGOLD"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                        </xsl:call-template>
                                      </xsl:attribute>
                                    </xsl:if>
                                  </xsl:otherwise>

                                </xsl:choose>

                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                <xsl:if test="FG300-CODGAR">
                                  <xsl:call-template name="completa">
                                    <xsl:with-param name="text">
                                      <xsl:value-of select="FG300-PRGGAR"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                    <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                  </xsl:call-template>
                                  <xsl:if test="FG300-PRGOLD">*</xsl:if>
                                </xsl:if>
                              </td>
                              <td style="cursor:hand;">
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Campo sensibile a Tasto Destro (Garanzia Revocata)</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                    <xsl:attribute name="title">Campo sensibile a Tasto Destro</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:attribute name="dtIstrDe">
                                  <xsl:value-of select="FG300-DTOPDE"/>
                                </xsl:attribute>
                                <xsl:attribute name="prgIstrDe">
                                  <xsl:value-of select="FG300-PRGDE"/>
                                </xsl:attribute>
                                <xsl:attribute name="dtIstrPv">
                                  <xsl:value-of select="FG300-DTOPEPV"/>
                                </xsl:attribute>
                                <xsl:attribute name="prgIstrPv">
                                  <xsl:value-of select="FG300-PRGPV"/>
                                </xsl:attribute>
                                <xsl:attribute name="prgGar">
                                  <xsl:call-template name="completa">
                                    <xsl:with-param name="text">
                                      <xsl:value-of select="FG300-PRGGAR"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                    <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                  </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="storia">
                                  <xsl:value-of select="//FG300-STORIA"/>
                                </xsl:attribute>

                                <xsl:attribute name="onmousedown">
                                  <xsl:choose>
                                    <xsl:when test="//FG300-ACCVIEW='S'">
                                      RigaClick2(this);
                                    </xsl:when>
                                    <xsl:otherwise>
                                      RigaClick(this);
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:attribute>

                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                <xsl:value-of select="FG300-TIPGAR-D"/>

                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:if>

                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:choose>
                                  <xsl:when test="FG300-TIPCOL = 'L'">
                                    <xsl:text>Su Linea </xsl:text>
                                    <xsl:call-template name="completa">
                                      <xsl:with-param name="text">
                                        <xsl:value-of select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM/FG300-PRGLIN"/>
                                      </xsl:with-param>
                                      <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                      <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="FG300-TIPCOL = 'P'">
                                    <xsl:if test="count(FG300-TAB-PUNTAM/FG300-EL-PUNTAM) > 3">
                                      <!--TITLE che contiene tutte le linee collegate-->
                                      <xsl:attribute name="title">
                                        <xsl:text>Su Linee </xsl:text>
                                        <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                          <xsl:call-template name="completa">
                                            <xsl:with-param name="text">
                                              <xsl:value-of select="FG300-PRGLIN"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                            <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                          </xsl:call-template>
                                          <xsl:if test="position() != last()">, </xsl:if>
                                        </xsl:for-each>
                                      </xsl:attribute>
                                    </xsl:if>
                                    Su Linee <br/>
                                    <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                      <xsl:choose>
                                        <xsl:when test="position() &lt;= 3">
                                          <xsl:call-template name="completa">
                                            <xsl:with-param name="text">
                                              <xsl:value-of select="FG300-PRGLIN"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                            <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                          </xsl:call-template>
                                          <xsl:if test="position() != last() and position() &lt; 3">
                                            <xsl:text>, </xsl:text>
                                          </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="position() = last()">
                                          <xsl:text>...</xsl:text>
                                        </xsl:when>
                                      </xsl:choose>
                                    </xsl:for-each>
                                  </xsl:when>
                                  <xsl:when test="FG300-TIPCOL = 'G'">
                                    Tutte le Linee
                                  </xsl:when>
                                  <xsl:when test="FG300-TIPCOL = 'C'">
                                    <xsl:if test="count(FG300-TAB-PUNTAM/FG300-EL-PUNTAM) > 3">
                                      <xsl:attribute name="title">
                                        <xsl:text>Su Garanzie </xsl:text>
                                        <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                          <xsl:call-template name="completa">
                                            <xsl:with-param name="text">
                                              <xsl:value-of select="FG300-PRGLIN"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                            <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                          </xsl:call-template>
                                          <xsl:if test="position() != last()">, </xsl:if>
                                        </xsl:for-each>
                                      </xsl:attribute>
                                    </xsl:if>
                                    <!--TITLE che contiene tutte le linee collegate-->

                                    <xsl:choose>
                                      <xsl:when test="count(FG300-TAB-PUNTAM/FG300-EL-PUNTAM)>1">
                                        Su Garanzie <br/>
                                        <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                          <xsl:choose>
                                            <xsl:when test="position() &lt;= 3">
                                              <xsl:call-template name="completa">
                                                <xsl:with-param name="text">
                                                  <xsl:value-of select="FG300-PRGLIN"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                                <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                              </xsl:call-template>
                                              <xsl:if test="position() != last() and position() &lt; 3">
                                                <xsl:text>, </xsl:text>
                                              </xsl:if>
                                            </xsl:when>
                                            <xsl:when test="position() = last()">
                                              <xsl:text>...</xsl:text>
                                            </xsl:when>
                                          </xsl:choose>
                                        </xsl:for-each>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        Su Garanzia
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM/FG300-PRGLIN"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                        </xsl:call-template>                                        
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                <xsl:if test="FG300-CODGAR">
                                  <xsl:value-of select="FG300-CODGAR"/> - <xsl:value-of select="FG300-CODGAR-D"/>
                                </xsl:if>
                              </td>
                              <td class="bordo_tlb" style="cursor:hand;" title="Campo sensibile al Tasto Destro"  name="TdContextMenuDesc" id="TdContextMenuDesc">

                                <xsl:if test="FG300-VISPRO='S'">
                                  <xsl:attribute name="rowspan">2</xsl:attribute>
                                </xsl:if>

                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                  <xsl:attribute name="style">margin-left:20px; cursor:hand; text-align:left</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="(FG300-GARREV='S') and (FG300-INDANN='S')">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <!--xsl:attribute name="title">Garanzia Revocata</xsl:attribute-->
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:attribute name="onmousedown">
                                  RigaClick3('<xsl:value-of select="FG300-NDGGAR"/>','');
                                </xsl:attribute>

                                <xsl:choose>
                                  <xsl:when test="string-length(FG300-NDGGAR-INT) > 20">
                                    <xsl:attribute name="title">
                                      <xsl:value-of select="FG300-NDGGAR-INT"/> - Campo Sensibile al Tasto Destro
                                    </xsl:attribute>
                                    <xsl:value-of select="FG300-NDGGAR"/><br/>
                                    <xsl:value-of select="substring(FG300-NDGGAR-INT,1,20)"/>...
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="title">Campo Sensibile al Tasto Destro</xsl:attribute>
                                    <xsl:value-of select="FG300-NDGGAR"/>
                                    <br/>
                                    <xsl:value-of select="FG300-NDGGAR-INT"/>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                  <xsl:attribute name="align">right</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                <xsl:if test="FG300-DTSCAD">
                                  <xsl:value-of select="user:formatData(FG300-DTSCAD,2)"/>
                                </xsl:if>
                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;text-align:right</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                
                                <xsl:if test="FG300-IMPORTO">
                                  <xsl:choose>
                                    <xsl:when test="FG300-IMPORTO = 0">0</xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="user:formatDecimal(FG300-IMPORTO,0)"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:if>

                              </td>

                              <td class="bordo_tb">
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-left:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:if>
                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                              </td>

                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;padding:0 10px 0 10px;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if>

                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:choose>
                                  <xsl:when test="FG300-INDSFR = 'S'">
                                    <img src="/FG/PF300/images/OK.gif" WIDTH="10" HEIGHT="10"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <img src="/FG/PF300/images/KO.gif" WIDTH="10" HEIGHT="10"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:if>

                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:choose>
                                  <xsl:when test="FG300-IND-PROV = 'S'">
                                    P
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>

                                <xsl:choose>
                                  <xsl:when test="FG300-INDCARTO = 'C'">
                                    C
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                              <td>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if>

                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_tlb_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="FG300-LIBROF"/>
                              </td>
                              <td name="tdToCheck3" id="tdToCheck3">
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
                                  <xsl:attribute name="rowspan">2</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                  <xsl:when test="FG300-GARREV='S'">
                                    <xsl:attribute name="class">bordo_rev</xsl:attribute>
                                    <xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:choose>
                                      <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                        <xsl:attribute name="class">bordoPF300</xsl:attribute>
                                      </xsl:when>
                                      <xsl:otherwise><xsl:attribute name="class"></xsl:attribute></xsl:otherwise>
                                    </xsl:choose>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                  <xsl:when test="FG300-FLALLEG = 'S'">
                                    <img src="/FG/PF300/images/allegatiFNet.gif">
                                      <xsl:attribute name="title">Cliccare per la visualizzazione degli Allegati</xsl:attribute>
                                      <xsl:attribute name="onclick">elencoAllegati(this)</xsl:attribute>
                                      <xsl:attribute name="style">cursor:hand</xsl:attribute>
                                      <xsl:attribute name="dtCarGar">
                                        <xsl:value-of select="FG300-DTCAR"/>
                                      </xsl:attribute>
                                      
                                      <xsl:attribute name="cdRapp">
                                        <xsl:text>00000</xsl:text>
                                        <xsl:value-of select="FG300-PRATICA"/>
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGGAR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">5</xsl:with-param>
                                        </xsl:call-template>
                                      </xsl:attribute>

                                      <xsl:attribute name="cdRappEle">
                                        <xsl:text>01</xsl:text>
                                        <xsl:value-of select="FG300-PRATICA"/>
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGGAR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">2</xsl:with-param>
                                        </xsl:call-template>
                                      </xsl:attribute>
                                    </img>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <img src="/FG/PF300/images/trasparent.gif" WIDTH="8" HEIGHT="1"/>
                                    <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                      <xsl:attribute name="style">display:none</xsl:attribute>
                                    </xsl:if>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
								<xsl:if test="$avvDivisa='S'">
									<td>
                    <xsl:if test="FG300-VISPRO = 'S'">
                      <xsl:attribute name="rowspan">2</xsl:attribute>
                    </xsl:if>
										<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
											<xsl:attribute name="style">border-right:0;border-top:1px solid #CCCCCC;</xsl:attribute>
											<xsl:attribute name="rowspan">2</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="FG300-GARREV='S'">
												<xsl:attribute name="class">bordo_rev</xsl:attribute>
												<xsl:attribute name="title">Garanzia Revocata</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
														<xsl:attribute name="class">bordoPF300</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="class"></xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
										<xsl:variable name="importEssere">
											<xsl:call-template name="do-replace">
												<xsl:with-param name="replace" select="','"></xsl:with-param>
												<xsl:with-param name="by" select="''"></xsl:with-param>
												<xsl:with-param name="text" select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-IMPDIVIS"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>
									
										<xsl:variable name="ImpDivisaEssere">
											<xsl:call-template name="format-decimal">
												<xsl:with-param name="importo" select="$importEssere"></xsl:with-param>
												<xsl:with-param name="centSN" select="1"></xsl:with-param>
												<xsl:with-param name="numeroDecimali" select="3"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="importProposto">
											<xsl:call-template name="do-replace">
												<xsl:with-param name="replace" select="','"></xsl:with-param>
												<xsl:with-param name="by" select="''"></xsl:with-param>
												<xsl:with-param name="text" select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-IMPDIVIS-PR"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="ImpDivisaProposto">
											<xsl:call-template name="format-decimal">
												<xsl:with-param name="importo" select="$importProposto"></xsl:with-param>
												<xsl:with-param name="centSN" select="1"></xsl:with-param>
												<xsl:with-param name="numeroDecimali" select="3"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="cdDivisEssere">
											<xsl:value-of select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-CDDIVIS"/>
										</xsl:variable>

										<xsl:variable name="cdDivisProposto">
											<xsl:value-of select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-CDDIVIS-PR"/>
										</xsl:variable>

                    <xsl:variable name="titoloDivisa">Importo in Essere (<xsl:value-of select="$cdDivisEssere"/>): <xsl:value-of select="$ImpDivisaEssere"/><xsl:if test="FG300-VISPRO = 'S'">&#13;Importo Proposto (<xsl:value-of select="$cdDivisProposto"/>): <xsl:value-of select="$ImpDivisaProposto"/></xsl:if></xsl:variable>

										<img>
											<xsl:choose>
												<xsl:when test="($cdDivisEssere != 'EUR') or ($cdDivisProposto != 'EUR')">
													<xsl:attribute name="src">FG/PF300/images/inDivisaIco.png</xsl:attribute>
													<xsl:attribute name="title"><xsl:value-of select="$titoloDivisa"/></xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="src">FG/PF300/images/trasparent.gif</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
										</img>
									</td>
								</xsl:if>
								
                            </tr>
                          </xsl:otherwise>
                        </xsl:choose>

                        <xsl:if test="FG300-VISPRO = 'S'">
                          <tr height="24">

                            <td>
                              <xsl:choose>
                                  <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                    <xsl:attribute name="class">testo_biancoPF300</xsl:attribute>
                                  </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">titleColL</xsl:attribute>
                                  <xsl:attribute name="style">border-top:1px solid #CCCCCC;</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>Proposti
                            </td>
                            <xsl:choose>
                              <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'"></xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="bgcolor">695ED5</xsl:attribute>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="FG300-PRGGAR > $Intervallo">

                              <td class="bordo_tlb_pr" name="tdToCheckInput" id="tdToCheckInput" >
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if> 
                                <xsl:choose>
                                  <xsl:when test="(//FG300-I-TPFUNZ='I')">
                                    <input type="checkbox" id="checkRow" name="checkRow">
                                      <xsl:attribute name="disabled">true</xsl:attribute>
                                      <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                        <xsl:attribute name="class">styled ck_disab_opt_normal_unsel</xsl:attribute>
                                      </xsl:if> 
                                    </input>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <input type="checkbox" name="check" id="check">
                                      <!--input type="checkbox" name="check" onclick="materButton(this); abilita(this); chiudiDettaglio(riga1,50); oneCheck(this,this.form.check)"-->

                                      <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                        <xsl:attribute name="class">styled ck_disab_opt_normal_unsel</xsl:attribute>
                                      </xsl:if>
										
                                      <xsl:choose>
                                        <xsl:when test="(FG300-BLOCCO-GAR='S')">
                                          <xsl:attribute name="disabled">true</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <xsl:attribute name="onclick">oneCheck(this,this.form.check); abilita(this)</xsl:attribute>
                                        </xsl:otherwise>
                                      </xsl:choose>

                                      <!--attributo Codice Rapporto-->
                                      <xsl:variable name="progGaranzia">
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGGAR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">5</xsl:with-param>
                                        </xsl:call-template>                                        
                                      </xsl:variable>

                                      <xsl:attribute name="cdRapp">
                                        <xsl:text>00000</xsl:text>
                                        <xsl:value-of select="FG300-PRATICA"/>
                                        <xsl:value-of select="$progGaranzia"/>
                                      </xsl:attribute>

                                      <!--attributo Pratica-->
                                      <xsl:attribute name="pratica">
                                        <xsl:value-of select="FG300-PRATICA"/>
                                      </xsl:attribute>

                                      <!--attributo Pratica Corrente-->
                                      <xsl:attribute name="praCorr">
                                        <xsl:value-of select="FG300-PRAT-CORR"/>
                                      </xsl:attribute>

                                      <!--attributo Tipo Collegamento-->
                                      <xsl:attribute name="tpCol">
                                        <xsl:value-of select="FG300-TIPCOL"/>
                                      </xsl:attribute>

                                      <!--attributo Tipo Garanzia-->
                                      <xsl:attribute name="tipGar">
                                        <xsl:value-of select="FG300-TIPGAR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Tipo Garanzia Pr-->
                                      <xsl:attribute name="tipGarPr">
                                        <xsl:value-of select="FG300-TIPGAR-PR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Importo Proposto-->
									  <xsl:attribute name="importoPr">
                                        <xsl:value-of select="FG300-IMPORTO-PR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Cod Garanzia-->
									  <xsl:attribute name="codGar">
                                        <xsl:value-of select="FG300-CODGAR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Cod Garanzia Pr-->
									  <xsl:attribute name="codGarPr">
                                        <xsl:value-of select="FG300-CODGAR-PR"/>
                                      </xsl:attribute>
									  
									  <!--attributo Divisa-->
									  <xsl:attribute name="divisa">
										<xsl:value-of select="//FG300-TAB-DATI2/FG300-EL-DATIDIV[@ID = position()]/FG300-CDDIVIS-PR"/>
									  </xsl:attribute>

                                      <!--attributo Numero Materialità-->
                                      <xsl:choose>
                                        <xsl:when test="FG300-NUMMATER > 0">
                                          <xsl:attribute name="numMater">
                                            <xsl:value-of select="FG300-NUMMATER"/>
                                          </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <xsl:attribute name="numMater">0</xsl:attribute>
                                        </xsl:otherwise>
                                      </xsl:choose>

                                      <!--attributo Indicativo Provisorio-->
                                      <xsl:attribute name="indProv">
                                        <xsl:value-of select="FG300-IND-PROV"/>
                                      </xsl:attribute>

                                      <!--attributo Totale Operativo-->
                                      <xsl:attribute name="totOpe">
                                        <xsl:value-of select="//FG300-IO-TOTOPE"/>
                                      </xsl:attribute>

                                      <!--attributo Totale Deliberato-->
                                      <xsl:attribute name="totDel">
                                        <xsl:value-of select="//FG300-IO-TOTDEL"/>
                                      </xsl:attribute>

                                      <!--attributo costante linnee collegate-->
                                      <xsl:attribute name="costantLin">
                                        00000<xsl:value-of select="FG300-PRATICA"/>
                                      </xsl:attribute>

                                      <xsl:if test="(FG300-TIPCOL = 'P') or (FG300-TIPCOL = 'L')">
                                        <!--attributo Linee Collegate-->
                                        <xsl:attribute name="linee">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-PRGLIN"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>

                                        <xsl:attribute name="lineeEst">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-LINEST"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>

                                        <xsl:attribute name="dtRife">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-DTRIFE"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>

                                        <xsl:attribute name="prgRif">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-PRGRIF"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>
                                      </xsl:if>

                                      <xsl:if test="(FG300-TIPCOL = 'C')">
                                        <!--attributo Garanzie Collegate-->
                                        <xsl:attribute name="garanzie">
                                          <xsl:for-each select="FG300-TAB-PUNTAM/FG300-EL-PUNTAM">
                                            <xsl:value-of select="FG300-PRGLIN"/>;
                                          </xsl:for-each>
                                        </xsl:attribute>
                                      </xsl:if>

                                      <!--attributo Linea Cartolarizzata-->
                                      <xsl:attribute name="carto">
                                        <xsl:value-of select="FG300-INDCARTO"/>
                                      </xsl:attribute>


                                      <xsl:attribute name="visPro">
                                        <xsl:value-of select="FG300-VISPRO"/>
                                      </xsl:attribute>

                                      <xsl:attribute name="prgGar">
                                        <xsl:value-of select="FG300-PRGGAR"/>
                                      </xsl:attribute>

                                      <xsl:attribute name="dtIstr">
                                        <xsl:value-of select="//FG300-O-DTISTR"/>
                                      </xsl:attribute>
									  
                                      <xsl:attribute name="prgIstr">
                                        <xsl:value-of select="//FG300-O-PRGISTR"/>
                                      </xsl:attribute>
									  
                                    </input>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </td>
                            </xsl:if>

                            <td>
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:right</xsl:attribute>
                              </xsl:if>

                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>

                              <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                              <xsl:if test="FG300-CODGAR-PR">
                                <xsl:call-template name="completa">
                                  <xsl:with-param name="text">
                                    <xsl:value-of select="FG300-PRGGAR"/>
                                  </xsl:with-param>
                                  <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                  <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                </xsl:call-template>                                
                              </xsl:if>
                            </td>

                            <td title="Campo sensibile al Tasto Destro" style="cursor:hand">
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
                              </xsl:if> 

                              <xsl:attribute name="dtIstrDe">
                                <xsl:value-of select="FG300-DTOPDE"/>
                              </xsl:attribute>
                              <xsl:attribute name="prgIstrDe">
                                <xsl:value-of select="FG300-PRGDE"/>
                              </xsl:attribute>
                              <xsl:attribute name="dtIstrPv">
                                <xsl:value-of select="FG300-DTOPEPV"/>
                              </xsl:attribute>
                              <xsl:attribute name="prgIstrPv">
                                <xsl:value-of select="FG300-PRGPV"/>
                              </xsl:attribute>
                              <xsl:attribute name="prgGar">
                                <xsl:call-template name="completa">
                                  <xsl:with-param name="text">
                                    <xsl:value-of select="FG300-PRGGAR"/>
                                  </xsl:with-param>
                                  <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                  <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                </xsl:call-template>
                              </xsl:attribute>
                              <xsl:attribute name="storia">
                                <xsl:value-of select="//FG300-STORIA"/>
                              </xsl:attribute>

                              <xsl:choose>
                                <xsl:when test="FG300-INDANN = 'S'">
                                  <xsl:choose>
                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>

                              <xsl:attribute name="onmousedown">
                                <xsl:choose>
                                  <xsl:when test="FG300-ACCVIEW='S'">
                                    RigaClick2(this);
                                  </xsl:when>
                                  <xsl:otherwise>
                                    RigaClick(this);
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>

                              <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                              <xsl:value-of select="FG300-TIPGAR-D-PR"/>
                            </td>

                            <td>
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
                              </xsl:if>

                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>

                              <xsl:choose>
                                <xsl:when test="FG300-TIPCOL-PR = 'L'">
                                  <xsl:text>Su Linea </xsl:text>
                                  <xsl:call-template name="completa">
                                    <xsl:with-param name="text">
                                      <xsl:value-of select="FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR/FG300-PRGLIN-PR"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                    <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="FG300-TIPCOL-PR = 'P'">
                                  <xsl:if test="count(FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR) > 3">
                                    <!--TITLE che contiene tutte le linee collegate-->
                                    <xsl:attribute name="title">
                                      <xsl:text>Su Linee </xsl:text>
                                      <xsl:for-each select="FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR">
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGLIN-PR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:if test="position() != last()">, </xsl:if>
                                      </xsl:for-each>
                                    </xsl:attribute>
                                  </xsl:if>

                                  Su Linee <br/>
                                  <xsl:for-each select="FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR">
                                    <xsl:choose>
                                      <xsl:when test="position() &lt;= 3">
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGLIN-PR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:if test="position() != last() and position() &lt; 3">
                                          <xsl:text>, </xsl:text>
                                        </xsl:if>
                                      </xsl:when>
                                      <xsl:when test="position() = last()">
                                        <xsl:text>...</xsl:text>
                                      </xsl:when>
                                    </xsl:choose>
                                  </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="FG300-TIPCOL-PR = 'G'">
                                  Tutte le Linee
                                </xsl:when>
                                <xsl:when test="FG300-TIPCOL-PR = 'C'">

                                  <xsl:if test="count(FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR) > 3">
                                    <xsl:attribute name="title">
                                      <xsl:text>Su Garanzie </xsl:text>
                                      <xsl:for-each select="FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR">
                                        <xsl:call-template name="completa">
                                          <xsl:with-param name="text">
                                            <xsl:value-of select="FG300-PRGLIN-PR"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                          <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:if test="position() != last()">, </xsl:if>
                                      </xsl:for-each>
                                    </xsl:attribute>
                                  </xsl:if>

                                  <xsl:choose>
                                    <xsl:when test="count(FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR)>1">
                                      Su Garanzie<br/>
                                      <xsl:for-each select="FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR">
                                        <xsl:choose>
                                          <xsl:when test="position() &lt;= 3">
                                            <xsl:call-template name="completa">
                                              <xsl:with-param name="text">
                                                <xsl:value-of select="FG300-PRGLIN-PR"/>
                                              </xsl:with-param>
                                              <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                              <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:if test="position() != last() and position() &lt; 3">
                                              <xsl:text>, </xsl:text>
                                            </xsl:if>
                                          </xsl:when>
                                          <xsl:when test="position() = last()">
                                            <xsl:text>...</xsl:text>
                                          </xsl:when>
                                        </xsl:choose>
                                      </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:text>Su Garanzia </xsl:text>
                                      <xsl:call-template name="completa">
                                        <xsl:with-param name="text">
                                          <xsl:value-of select="FG300-TAB-PUNTAM-PR/FG300-EL-PUNTAM-PR/FG300-PRGLIN-PR"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="chRiempimento">0</xsl:with-param>
                                        <xsl:with-param name="lunghezzaFinale">3</xsl:with-param>
                                      </xsl:call-template>                                      
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                  <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>

                            <td>
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
                              </xsl:if>

                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>

                              <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                              <xsl:if test="FG300-CODGAR-PR">
                                <xsl:value-of select="FG300-CODGAR-PR"/> - <xsl:value-of select="FG300-CODGAR-D-PR"/>
                              </xsl:if>
                            </td>
                            <xsl:if test="FG300-PRGGAR > $Intervallo">

                              <td style="cursor:hand" title="Campo Sensibile al Tasto Destro" name="TdContextMenuDesc" id="TdContextMenuDesc">
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                  <xsl:attribute name="style">cursor:hand; text-align:left</xsl:attribute>
                                </xsl:if>  
                                <xsl:choose>

                                  <xsl:when test="FG300-INDANN = 'S'">
                                    <xsl:attribute name="class">prop_a_tlb</xsl:attribute>
                                    <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                  </xsl:when>

                                  <xsl:otherwise>
                                    <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                  </xsl:otherwise>

                                </xsl:choose>

                                <xsl:attribute name="onmousedown">
                                  RigaClick3('<xsl:value-of select="FG300-NDGGAR"/>','<xsl:value-of select="//FG300-STORIA"/>');
                                </xsl:attribute>
                                <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                <xsl:value-of select="FG300-NDGGAR"/>
                                <br/>
                                <xsl:value-of select="FG300-NDGGAR-INT"/>
                              </td>

                            </xsl:if>

                            <td>
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
                              </xsl:if> 
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                <xsl:attribute name="align">right</xsl:attribute>
                              </xsl:if> 
                              
                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>
                              
                              <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                              <xsl:if test="FG300-DTSCAD-PR">
                                <xsl:value-of select="user:formatData(FG300-DTSCAD-PR,2)"/>
                              </xsl:if>
                            </td>

                            <td valign="middle">
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:right</xsl:attribute>
                              </xsl:if> 
                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>

                              <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>

                              <xsl:if test="FG300-IMPORTO-PR">

                                <xsl:choose>
                                  <xsl:when test="FG300-IMPORTO-PR = 0">
                                    0
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="user:formatDecimal(FG300-IMPORTO-PR,0)"/>
                                  </xsl:otherwise>
                                </xsl:choose>

                              </xsl:if>

                            </td>

                            <td>
                              <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
                                <xsl:attribute name="style">border-right:0;border-left:0;padding:2px 5px 0 0;border-top:1px solid #CCCCCC;</xsl:attribute>
                              </xsl:if> 							
                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_b</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_b</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>

                              <xsl:choose>
                                <xsl:when test="FG300-TIPOPE">
									<div class="btnRapp" title="Consultazione Storico Proposte">
										<xsl:attribute name="cdIsti">
										  <xsl:value-of select="//FG300-I-CDISTI"/>
										</xsl:attribute>
										<xsl:attribute name="ndg">
										  <xsl:value-of select="//FG300-I-NDG"/>
										</xsl:attribute>
										<xsl:attribute name="dtIstr">
										  <xsl:value-of select="//FG300-O-DTISTR"/>
										</xsl:attribute>
										<xsl:attribute name="prgIstr">
										  <xsl:value-of select="//FG300-O-PRGISTR"/>
										</xsl:attribute>
										<xsl:attribute name="pratica">
										  <xsl:value-of select="//FG300-IO-PRATICA"/>
										</xsl:attribute>
										<xsl:attribute name="prgGar">
										  <xsl:value-of select="FG300-PRGGAR"/>
										</xsl:attribute>
										<xsl:attribute name="stato">
										  <xsl:value-of select="//FG300-I-STATO"/>
										</xsl:attribute>
										<xsl:attribute name="tpfunz">
										  <xsl:value-of select="//FG300-I-TPFUNZ"/>
										</xsl:attribute>
										<xsl:attribute name="onclick">
											 <xsl:choose>
												<xsl:when test="FG300-STORIA = 'S'">openStoricoProp(this);</xsl:when>
												<xsl:otherwise></xsl:otherwise>
											 </xsl:choose>
										</xsl:attribute>
										<a class="btnShort" href="#">
											<xsl:attribute name="class">
												 <xsl:choose>
													<xsl:when test="FG300-STORIA = 'S'">btnShort</xsl:when>
													<xsl:otherwise>btnShortDis</xsl:otherwise>
												 </xsl:choose>
											</xsl:attribute>
											<span>
												<img alt="" src="/common64/images/feu-btn-ico-rapporto.gif"/>
											</span>
										</a>
									</div>
                                </xsl:when>
                                <xsl:otherwise>
                                </xsl:otherwise>
                              </xsl:choose>

                            </td>
                            <td>
							<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
								  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
								</xsl:if> 

                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>

                              <xsl:choose>
                                <xsl:when test="FG300-INDSFR = 'S'">
                                  <img src="/FG/PF300/images/OK.gif" WIDTH="10" HEIGHT="10"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <img src="/FG/PF300/images/KO.gif" WIDTH="10" HEIGHT="10"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>

                            <td>
							<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
								  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
								</xsl:if> 

                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>

                              <xsl:choose>
                                <xsl:when test="FG300-IND-PROV = 'S'">
                                  P
                                </xsl:when>
                                <xsl:otherwise>
                                  <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>

                            <td>
							<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
								  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
								</xsl:if> 

                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">

                                  <xsl:choose>

                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>

                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>

                                    </xsl:otherwise>

                                  </xsl:choose>

                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>


                              <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                            </td>


                            <td>
							<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
								  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;text-align:center</xsl:attribute>
								</xsl:if> 
                              <xsl:choose>

                                <xsl:when test="FG300-INDANN = 'S'">
                                  <xsl:choose>
                                    <xsl:when test="FG300-PRGGAR > $Intervallo">
                                      <xsl:attribute name="class">prop_a_tlb</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="class">prop_a_lb</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
									
                                  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
                                </xsl:when>

                                <xsl:when test="FG300-PRGGAR > $Intervallo">
                                  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:attribute name="class">bordo_lb</xsl:attribute>
                                </xsl:otherwise>

                              </xsl:choose>
                              <xsl:value-of select="FG300-LIBROF-PR"/>
                              <!--
									<xsl:choose>
										<xsl:when test="FG300-LIBROF-PR='S'">
											S
										</xsl:when>
										<xsl:otherwise>
											<img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
										</xsl:otherwise>
									</xsl:choose>
									-->
                            </td>
							  
							<xsl:if test="FG300-PRGGAR > $Intervallo">
							   <td class="bordo_lbr" name="tdToCheck3" id="tdToCheck3">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
									</xsl:if> 
								  <xsl:choose>

									<xsl:when test="FG300-INDANN = 'S'">
									  <xsl:choose>
										<xsl:when test="FG300-PRGGAR > $Intervallo">
										  <xsl:attribute name="class">prop_a_bordo</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
										  <xsl:attribute name="class">prop_a_lbr</xsl:attribute>
										</xsl:otherwise>
									  </xsl:choose>
									  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
									</xsl:when>

									<xsl:when test="FG300-PRGGAR > $Intervallo">
									  <xsl:choose>
										<xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
											<xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									  </xsl:choose>                                  
									</xsl:when>

									<xsl:otherwise>
									  <xsl:attribute name="class">bordo_lbr</xsl:attribute>
									</xsl:otherwise>

								  </xsl:choose>
								  <xsl:choose>
									<xsl:when test="FG300-FLALLEG = 'S'">
                    <img src="/FG/PF300/images/allegatiFNet.gif">
                      <xsl:attribute name="title">Cliccare per la visualizzazione degli Allegati</xsl:attribute>
                      <xsl:attribute name="onclick">elencoAllegati(this)</xsl:attribute>
                      <xsl:attribute name="style">cursor:hand</xsl:attribute>
                      <xsl:attribute name="cdRapp">
                        <xsl:text>00000</xsl:text>
                        <xsl:value-of select="FG300-PRATICA"/>
                        <xsl:call-template name="completa">
                          <xsl:with-param name="text">
                            <xsl:value-of select="FG300-PRGGAR"/>
                          </xsl:with-param>
                          <xsl:with-param name="chRiempimento">0</xsl:with-param>
                          <xsl:with-param name="lunghezzaFinale">5</xsl:with-param>
                        </xsl:call-template>
                      </xsl:attribute>
                    </img>
									</xsl:when>
									<xsl:otherwise>
									
									</xsl:otherwise>
								  </xsl:choose>
								</td>
								</xsl:if>


							  <xsl:if test="(FG300-PRGGAR > $Intervallo) and ($avvDivisa='S')">
								  <td class="bordo_lbr" name="tdToCheck3" id="tdToCheck3">
									  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										  <xsl:attribute name="style">border-right:0;padding:0 5px;border-top:1px solid #CCCCCC;</xsl:attribute>
									  </xsl:if>
									  <xsl:choose>

										  <xsl:when test="FG300-INDANN = 'S'">
											  <xsl:choose>
												  <xsl:when test="FG300-PRGGAR > $Intervallo">
													  <xsl:attribute name="class">prop_a_bordo</xsl:attribute>
												  </xsl:when>
												  <xsl:otherwise>
													  <xsl:attribute name="class">prop_a_lbr</xsl:attribute>
												  </xsl:otherwise>
											  </xsl:choose>
											  <xsl:attribute name="title">Proposta Annullata</xsl:attribute>
										  </xsl:when>

										  <xsl:when test="FG300-PRGGAR > $Intervallo">
											  <xsl:choose>
												  <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
													  <xsl:attribute name="class">bordo_tlb_pr</xsl:attribute>
												  </xsl:when>
												  <xsl:otherwise></xsl:otherwise>
											  </xsl:choose>
										  </xsl:when>

										  <xsl:otherwise>
											  <xsl:attribute name="class">bordo_lbr</xsl:attribute>
										  </xsl:otherwise>
									  </xsl:choose>
									  
									  <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
										<xsl:variable name="importEssere">
											<xsl:call-template name="do-replace">
												<xsl:with-param name="replace" select="','"></xsl:with-param>
												<xsl:with-param name="by" select="''"></xsl:with-param>
												<xsl:with-param name="text" select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-IMPDIVIS"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>
									
										<xsl:variable name="ImpDivisaEssere">
											<xsl:call-template name="format-decimal">
												<xsl:with-param name="importo" select="$importEssere"></xsl:with-param>
												<xsl:with-param name="centSN" select="1"></xsl:with-param>
												<xsl:with-param name="numeroDecimali" select="3"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="importProposto">
											<xsl:call-template name="do-replace">
												<xsl:with-param name="replace" select="','"></xsl:with-param>
												<xsl:with-param name="by" select="''"></xsl:with-param>
												<xsl:with-param name="text" select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-IMPDIVIS-PR"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="ImpDivisaProposto">
											<xsl:call-template name="format-decimal">
												<xsl:with-param name="importo" select="$importProposto"></xsl:with-param>
												<xsl:with-param name="centSN" select="1"></xsl:with-param>
												<xsl:with-param name="numeroDecimali" select="3"></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="cdDivisEssere">
											<xsl:value-of select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-CDDIVIS"/>
										</xsl:variable>

										<xsl:variable name="cdDivisProposto">
											<xsl:value-of select="//FG300-EL-DATIDIV[@ID=$pos]/FG300-CDDIVIS-PR"/>
										</xsl:variable>

										
										<img>
											<xsl:choose>
												<xsl:when test="$cdDivisProposto != 'EUR'">
													<xsl:attribute name="src">FG/PF300/images/inDivisaIco.png</xsl:attribute>
													<xsl:attribute name="title">Importo Proposto (<xsl:value-of select="$cdDivisProposto"/>): <xsl:value-of select="$ImpDivisaProposto"/></xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="src">FG/PF300/images/trasparent.gif</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
										</img>
									  
								  </td>
							  </xsl:if>
                          </tr>

                        </xsl:if>
                        <xsl:if test="FG300-VISPRO='S'">
                          <xsl:choose>
                            <xsl:when test="FG300-PRGGAR > $Intervallo">
                            </xsl:when>

                            <xsl:when test="(FG300-GARREV='S') and (FG300-INDANN != 'S')">
                              <xsl:variable name="differenza">
                                <xsl:value-of select="FG300-IMPORTO-PR"/>
                              </xsl:variable>
                              <tr>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td class="bordo_lb"  bgcolor="#dcdcdc" style="text-align:center">
                                  <font color="black">
                                    <img src="/FG/PF300/images/delta.gif" title="Differenza"/> <xsl:value-of select="$labelEuro"/>
                                  </font>
                                </td>
                                <td class="bordo_lb" bgcolor="#E7ECF5;" >
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border-right:0;text-align:right;</xsl:attribute>
									</xsl:if> 

                                  <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>

                                  <xsl:choose>

                                    <xsl:when test="substring($differenza, 1, 1) = '-'">
                                      <xsl:variable name="lunghezza">
                                        <xsl:value-of select="(string-length($differenza))-1"/>
                                      </xsl:variable>
                                      <xsl:variable name="substr">
                                        <xsl:value-of select="substring($differenza, 2, $lunghezza)"/>
                                      </xsl:variable>
                                      - <xsl:value-of select="user:formatDecimal($substr,0)"/>
                                    </xsl:when>

                                    <xsl:otherwise>
                                      <xsl:choose>
                                        <xsl:when test="$differenza = 0">
                                          0
                                        </xsl:when>
                                        <xsl:otherwise>
                                          + <xsl:value-of select="user:formatDecimal($differenza,0)"/>
                                        </xsl:otherwise>
                                      </xsl:choose>
                                    </xsl:otherwise>

                                  </xsl:choose>

                                </td>
                                <td class="bordo_b" bgcolor="E7ECF5">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border-left:0;border-right:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td class="bordo_l" bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                              </tr>
                            </xsl:when>

                            <xsl:when test="((FG300-IMPORTO and FG300-IMPORTO-PR) or FG300-IMPORTO-PR) and (FG300-INDANN != 'S')">
                              <xsl:variable name="differenza">
                                <xsl:value-of select="FG300-IMPORTO-PR - FG300-IMPORTO"/>
                              </xsl:variable>
                              <tr height="18px"> 
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td bgcolor="white" class="border_left_differenza">
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
										<xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if>
								</td>
                                <td class="bordo_lb" bgcolor="#dcdcdc" style="text-align:center">
                                  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                    <xsl:attribute name="bgcolor">#FAF6E9</xsl:attribute>
                                    <xsl:attribute name="style">padding-left:2px;border-left:1px solid #FAF6E9;</xsl:attribute>
                                  </xsl:if>
                                  <font color="black">
                                    <img src="/FG/PF300/images/delta.gif" title="Differenza"/> <xsl:value-of select="$labelEuro"/>
                                  </font>
                                </td>
                                <td class="bordo_lb" bgcolor="E7ECF5">
                                  
                                  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                    <xsl:attribute name="bgcolor">#FAF6E9</xsl:attribute>
                                    <xsl:attribute name="style">padding-left:2px;border-left:1px solid #FAF6E9;</xsl:attribute>
                                  </xsl:if>
								  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border-right:0;text-align:right;</xsl:attribute>
									</xsl:if> 

                                  <img src="/FG/PF300/images/trasparent.gif" WIDTH="1" HEIGHT="1"/>
                                  <xsl:choose>
                                    <xsl:when test="FG300-IMPORTO">
                                      <xsl:choose>
                                        <xsl:when test="substring($differenza, 1, 1) = '-'">
                                          <xsl:variable name="lunghezza">
                                            <xsl:value-of select="(string-length($differenza))-1"/>
                                          </xsl:variable>
                                          <xsl:variable name="substr">
                                            <xsl:value-of select="substring($differenza, 2, $lunghezza)"/>
                                          </xsl:variable>
                                          - <xsl:value-of select="user:formatDecimal($substr,0)"/>
                                        </xsl:when>
                                        <xsl:otherwise>

                                          <xsl:choose>
                                            <xsl:when test="$differenza = 0">
                                              0
                                            </xsl:when>
                                            <xsl:otherwise>
                                              + <xsl:value-of select="user:formatDecimal($differenza,0)"/>
                                            </xsl:otherwise>
                                          </xsl:choose>
                                        </xsl:otherwise>
                                      </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:choose>
                                        <xsl:when test="FG300-IMPORTO-PR = 0">
                                          0
                                        </xsl:when>
                                        <xsl:otherwise>
                                          + <xsl:value-of select="user:formatDecimal(FG300-IMPORTO-PR,0)"/>
                                        </xsl:otherwise>
                                      </xsl:choose>

                                    </xsl:otherwise>
                                  </xsl:choose>

                                </td>
                                <td class="bordo_b" bgcolor="E7ECF5">
                                  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'">
                                    <xsl:attribute name="bgcolor">#FAF6E9</xsl:attribute>
                                    <xsl:attribute name="style">padding-left:10px;border-left:1px solid #FAF6E9;</xsl:attribute>
                                  </xsl:if>
								  <xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border-left:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td class="bordo_l" bgcolor="white" > 
									<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white" class="border_left_differenza">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white" class="border_left_differenza">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white" class="border_left_differenza">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                                <td bgcolor="white" class="border_left_differenza">
								<xsl:if test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']!='PM'">
									  <xsl:attribute name="style">border:0;</xsl:attribute>
									</xsl:if> 
                                  <img src="/FG/PF300/images/trasparent.gif" width="1" height="1"/>
                                </td>
                              </tr>
                            </xsl:when>

                          </xsl:choose>
                        </xsl:if>
                     <!--  </table>
                    </td>
                  </tr> -->
                  
                  <xsl:choose>
                    <xsl:when test="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']='PM'"></xsl:when>
                    <xsl:otherwise>
                      <tr>
                        <td style="height:5px;border:0;"></td>
                      </tr>
                    </xsl:otherwise>
                  </xsl:choose>
                  
                </xsl:for-each>
              
		  </tbody>
		  </table>
            </div>
            </div>
            </div>
			
			<div class="boxContainer" style="width:100%;margin:0;margin-top:0;">
			<xsl:if test="$testWB='false'">
				<xsl:attribute name="style">width:100%;margin:10px;margin-top:0;</xsl:attribute>
			</xsl:if>
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
			<xsl:if test="$testWB='false'">
				<xsl:attribute name="class">stdDataTable</xsl:attribute>
			</xsl:if>
              <col width="33%"></col>
              <col width="33%"></col>
              <col width="33%"></col>

              <tr bgcolor="#e7ecf5">
                <xsl:choose>
                  <xsl:when test="$testWB='true'">
                    <xsl:attribute name="class">testo_bianco</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise><xsl:attribute name="class"></xsl:attribute></xsl:otherwise>
                </xsl:choose>
				<xsl:if test="$testWB='false'">
					<xsl:attribute name="bgcolor"></xsl:attribute>
				</xsl:if>
                <td bgcolor="000066" align="center">
                  <xsl:if test="$testWB='true'">
                    <xsl:attribute name="class">testataTabella</xsl:attribute>
                    <xsl:attribute name="style">border-right:1px solid white</xsl:attribute>
                  </xsl:if>  
				  <xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
                  Totale in Essere <xsl:value-of select="$labelEuro"/> :
                  <b>
                    <xsl:choose>
                      <xsl:when test="//FG300-IO-TOTESS">

                        <xsl:choose>
                          <xsl:when test="//FG300-IO-TOTESS = 0">
                            0
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="user:formatDecimal(//FG300-IO-TOTESS,0)"/>
                          </xsl:otherwise>
                        </xsl:choose>

                      </xsl:when>
                      <xsl:otherwise>
                        0
                      </xsl:otherwise>
                    </xsl:choose>
                  </b>
                </td>
                <td bgcolor="1A0CA5" align="center">
                  <xsl:if test="$testWB='true'">
                    <xsl:attribute name="class">testataTabella</xsl:attribute>
                    <xsl:attribute name="style">border-right:1px solid white</xsl:attribute>
                  </xsl:if>
				  <xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
                  Totale con Proposte <xsl:value-of select="$labelEuro"/> :
                  <b>
                    <xsl:choose>
                      <xsl:when test="//FG300-IO-TOTPRO">

                        <xsl:choose>
                          <xsl:when test="//FG300-IO-TOTPRO = 0">
                            0
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="user:formatDecimal(//FG300-IO-TOTPRO,0)"/>
                          </xsl:otherwise>
                        </xsl:choose>

                      </xsl:when>
                      <xsl:otherwise>
                        0
                      </xsl:otherwise>
                    </xsl:choose>
                  </b>
                </td>
                <td bgcolor="4646B7" align="center">
                  <xsl:if test="$testWB='true'">
                    <xsl:attribute name="class">testataTabella</xsl:attribute>
                  </xsl:if>
				  <xsl:if test="$testWB='false'">
						<xsl:attribute name="class">titleColC</xsl:attribute>
					</xsl:if>
                  Differenza <xsl:value-of select="$labelEuro"/> :
                  <b>
                    <xsl:choose>
                      <xsl:when test="//FG300-IO-TOTDELTA !='0+'">
                        <xsl:value-of select="user:formatDecimal(//FG300-IO-TOTDELTA,0)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        0
                      </xsl:otherwise>
                    </xsl:choose>

                  </b>
                </td>

              </tr>
            </table>
            </div>
			
			
				<xsl:choose>
					<xsl:when test="$testWB='true'">
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td id="messaggi" style="padding-left:8" class="text_error">
								  <xsl:if test="((//FG300-RC[.='01']) or (//FG300-RC[.='03']))">                    
									<b>
									  <xsl:value-of select="//FG300-MSG"/>
									</b>
								  </xsl:if>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="((//FG300-RC[.='01']) or (//FG300-RC[.='03']))">
							<div style="position:absolute; bottom:40px; left:10px; width:97%;" id='errorContainer2'>
								<xsl:attribute name="errLongDescr">
									<xsl:value-of select="//FG300-MSG"/>
								</xsl:attribute>
								<script>
									showErrorFEU(document.getElementById("errorContainer2"), "E_HIGH" );
								</script>
							</div>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
             
            <div id="id_pag" align="center" class="unvisited"></div>
            <xsl:choose>
              <xsl:when test="//FG300-I-TPFUNZ='I'">

              </xsl:when>
              <xsl:when test="PAGE/PARAMS/PARAM[@name='readOnly'] = 'true'">
                
              </xsl:when>
              <xsl:otherwise>
                <table cellpadding="0" border="0" cellspacing="0" class="buttons" align="right">
                  <tr>
					<td>
						<input type="button" style="display: none;" name="inserisciAttoButton" id="inserisciAttoButton" onClick="inserisciAtto(this)" class="button" tabIndex="-1" value="Inserisci Atto" title="Inserisci Atto" disabled="true">
							<xsl:if test="//FG300-I-PREP = 'S'">
								<xsl:attribute name="style"></xsl:attribute>
							</xsl:if>
						</input>
					</td>
					<td>
						<input type="button" style="display: none;" name="listaAttiButton" id="listaAttiButton" value="Checklist" onclick="openFGD02(this)" class="button" disabled="disabled">
							<xsl:if test="//FG300-I-PREP = 'S'">
								<xsl:attribute name="style"></xsl:attribute>
							</xsl:if>
							<xsl:if test="//FG300-IO-FL-ABIL-CK = 'N'">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
						</input>
					</td>
                    <!--td><img src="/FG/PF300/images/fidiButton.gif" name="" id="" onclick="openPF100()" class="abled" style="cursor:hand"/></td-->
                    <td>
                      <xsl:choose>
                        <xsl:when test="$testWB='true'">
                          <input type="button" name="cancellazionePropostaButton" id="cancellazionePropostaButton" value="Canc. Proposta" onclick="cancellaProposta(this)" class="button" disabled="disabled" />
                        </xsl:when>
                        <xsl:otherwise>
                          <!--<img src="/FG/PF300/images/cancPropButton.gif" name="cancellazionePropostaButton" id="cancellazionePropostaButton" onclick="cancellaProposta(this)" class="disabled" />-->   
							<div class="btnUnit" name="cancellazionePropostaButton" id="cancellazionePropostaButton" onclick="" style="position:absolute;bottom:10px;right:305px;">
								<a class="btnImgRDis" href="#" id="acancellazionePropostaButton">
									<span style="padding-left:15px; height:20px;padding-right:15px;">
										<label>Canc. Proposta</label>
										<img alt="" style="height:16px;margin-left:10px;" src="/common64/images/feu-btn-ico-elimina.gif"/>
									</span>
								</a>
							</div>
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="$testWB='true'">
                          <input type="button" name="inserimentoButton" id="inserimentoButton" value="Inserimento" onclick="inserimentoModale(this)" class="button">
                            <xsl:if test="(//FG300-RC[.!='01'])">                              
                              <xsl:attribute name="style">cursor:hand</xsl:attribute>
                            </xsl:if>
							<xsl:if test="//FG300-IO-FL-BLINSE = 'S'">
								<xsl:attribute name="style">cursor:default</xsl:attribute>
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
                          </input>
                        </xsl:when>
                        <xsl:otherwise>
                          <!--<img src="/FG/PF300/images/insButton.gif"  name="inserimentoButton" id="inserimentoButton" onclick="inserimento(this)" class="disabled" style="cursor:default">                                                        
                            <xsl:if test="(//FG300-RC[.!='01'])">
                              <xsl:attribute name="class">abled</xsl:attribute>
                              <xsl:attribute name="style">cursor:hand</xsl:attribute>
                            </xsl:if>
                          </img>-->
						  <div class="btnUnit" name="inserimentoButton" id="inserimentoButton" onclick="inserimento(this)" style="position:absolute;bottom:10px;right:195px;">
								<a class="btnImgR" href="#" id="ainserimentoButton">
									<span style="padding-left:10px; height:20px;padding-right:15px;">
										<label>Inserimento</label>
									</span>
								</a>
							</div>
                        </xsl:otherwise>
                      </xsl:choose>
                                         
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="$testWB='true'">
                          <input type="button" name="variazioneButton" id="variazioneButton" value="Variazione" class="button" onclick="variazioneModale(this)" disabled="true"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <!--<img src="/FG/PF300/images/varButton.gif"  name="variazioneButton" id="variazioneButton" onclick="variazione(this)" class="disabled"/>-->
						  <div class="btnUnit" name="variazioneButton" id="variazioneButton" onclick="" style="position:absolute;bottom:10px;right:95px;">
								<a class="btnImgRDis" href="#" id="avariazioneButton">
									<span style="padding-left:10px; height:20px;padding-right:15px;">
										<label>Variazione</label>
									</span>
								</a>
							</div>
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </td>
                    <!--td><img src="/FG/PF300/images/matButton.gif" name="materialitaButton" id="materialitaButton" onclick="materialita(this)" class="disabled"/></td-->
                    <td>
                      <xsl:choose>
                        <xsl:when test="$testWB='true'">
                          <input type="button" name="revocaButton" id="revocaButton" class="button" value="Revoca" onclick="revoca(this)" disabled="true"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <!--<img src="/FG/PF300/images/revButton.gif" name="revocaButton" id="revocaButton" onclick="revoca(this)" class="disabled"/>-->
						  <div class="btnUnit" name="revocaButton" id="revocaButton" onclick="" style="position:absolute;bottom:10px;right:10px;">
								<a class="btnImgRDis" href="#" id="arevocaButton">
									<span style="padding-left:10px; height:20px;padding-right:15px;">
										<label>Revoca</label>
									</span>
								</a>
							</div>
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </td>
                  </tr>
                </table>
              </xsl:otherwise>
            </xsl:choose>

              <xsl:if test="$testWB='true'">
                  <input type="hidden" id="cdtipol">
                      <xsl:attribute name="value">
                          <xsl:value-of select="//FG300-I-CDTIPOL"/>
                      </xsl:attribute>
                  </input>
                  <br/>
                  <div align="right" style="background-color:#EEEEEE; height:30px; width:100%; margin-top:30px;">
                      <table height="100%" width="100%">
                          <tr>
                              <td align="right">
                                  <input type="button" class="button" value="Continua" id="continua_btn">
									  <xsl:variable name="NdgCont"><xsl:value-of select="//FG300-I-NDG"/></xsl:variable>
			                          <xsl:variable name="CdistiCont"><xsl:value-of select="//FG300-I-CDISTI"/></xsl:variable>
			                          <xsl:variable name="DtistrCont"><xsl:value-of select="//FG300-I-DTISTR"/></xsl:variable>
			                          <xsl:variable name="PrgistrCont"><xsl:value-of select="//FG300-I-PRGISTR"/></xsl:variable>
			                          <xsl:variable name="FunzPrecCont"><xsl:value-of select="//FG300-FUNZ"/></xsl:variable>
									  <xsl:variable name="CdtipolCont"><xsl:value-of select="//FG300-I-CDTIPOL"/></xsl:variable>
                                      <xsl:attribute name="onclick">
                                          clickContinua('<xsl:value-of select="$NdgCont"/>',
														'<xsl:value-of select="$CdistiCont"/>',
														'<xsl:value-of select="$DtistrCont"/>', 
														'<xsl:value-of select="$PrgistrCont"/>',
														'<xsl:value-of select="$FunzPrecCont"/>',
														'<xsl:value-of select="$CdtipolCont"/>',
														'S');
                                      </xsl:attribute>
									  <xsl:if test="//FG300-IO-FLBLOCCONT = 'S'">
										<xsl:attribute name="disabled">true</xsl:attribute>
									  </xsl:if>
                                  </input>
                              </td>
                          </tr>
                      </table>
                  </div>
                  <script language="javascript">
                      if (parent.FGA20 == null) { if (parent.parent.FGA20 == null) { document.getElementById('continua_btn').style.display = "none";  } }
                  </script>
              </xsl:if>
          </form>
          <xsl:if test="(//FG300-RC[.!='01'])">
            <!-- Paginazione -->
            <!-- Contenitore pagine -->

            <input type="hidden" name="pratica" id="pratica">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-IO-PRATICA"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="dtIstr" id="dtIstr">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-O-DTISTR"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="prgIstr" id="prgIstr">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-O-PRGISTR"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="stato" id="stato">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-STATO"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="tpfunz" id="tpfunz">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-TPFUNZ"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="cdisti" id="cdisti">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-CDISTI"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="ndg" id="ndg">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-NDG"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="flpdf" id="flpdf">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-FLPDF"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="nr_pag" id="nr_pag">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-NRPAG"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="pag_old" id="pag_old">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-PAGINA-OLD"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="pagina" id="pagina">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-PAGINA"/>
              </xsl:attribute>
            </input>

            <input type="hidden" name="nr_item" id="nr_item">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-I-NRITEM"/>
              </xsl:attribute>
            </input>
            <!-- Contenitore pagine -->
            <!-- Controlli nascosti usati per memorizzare la pagina corrente e il numero totale -->

            <input style="display:none; LEFT: 282px; TOP: 16px" id="Tot_Pagg">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-O-NRPAG"/>
              </xsl:attribute>
            </input>

            <!-- utilizzo un campo nascosto per memorizzare i parametri di input, serve per la paginazione 
			 non compare il numero di pagina perche' deve essere passato dalla paginazione -->

            <span id="Param" style="display:none">
              FUNZ = LT;
              TASKN = <xsl:value-of select="//FG300-U-TASKN"/>;
              IST = <xsl:value-of select="//FG300-I-CDISTI"/>;
              NDG = <xsl:value-of select="//FG300-I-NDG"/>;
              NRITEM = <xsl:value-of select="//FG300-O-NRITEM"/>;
              PAGINAOLD = <xsl:value-of select="//FG300-O-PAGINA"/>;
              NRPAG = <xsl:value-of select="//FG300-O-NRPAG"/>;
              TOTPRO = <xsl:value-of select="//FG300-IO-TOTPRO"/>;
              TOTESS = <xsl:value-of select="//FG300-IO-TOTESS"/>;
              TOTDEL = <xsl:value-of select="//FG300-IO-TOTDEL"/>;
              TOTOPE = <xsl:value-of select="//FG300-IO-TOTOPE"/>;
              TOTDELTA = <xsl:value-of select="//FG300-IO-TOTDELTA"/>;
              PRATICA = <xsl:value-of select="//FG300-IO-PRATICA"/>;
              TPFUNZ = <xsl:value-of select="//FG300-I-TPFUNZ"/>;
              STATO = <xsl:value-of select="//FG300-I-STATO"/>;
              DTISTR = <xsl:value-of select="//FG300-I-DTISTR"/>;
              PRGISTR = <xsl:value-of select="//FG300-I-PRGISTR"/>;
              WB-FUNZ = <xsl:value-of select="/PAGE/PARAMS/PARAM[@name='WB-FUNZ']"/>;
			  <xsl:choose>
				<xsl:when test="//FG300-FUNZ = 'MD'">
					PREP = M;
				</xsl:when>
				<xsl:otherwise>
					PREP = <xsl:value-of select="//FG300-I-PREP"/>;
				</xsl:otherwise>
			  </xsl:choose>
          </span>

            <!-- utilizzo un campo nascosto per memorizzare i parametri di input, serve per la paginazione -->

            <!-- Il numero totale di pagine e' un parametro di output -->
            <input style="display:none; LEFT: 282px;  TOP: 16px" id="Cur_Pag">
              <xsl:attribute name="value">
                <xsl:value-of select="//FG300-O-PAGINA"/>
              </xsl:attribute>
            </input>
            <!-- Controlli nascosti usati per memorizzare la pagina corrente e il numero totale -->
            <!-- Paginazione -->
          </xsl:if>
          
          

     
         
          <!-- menu contestuale -->
          <div class="TWCTXMENUDIV" id="menu" onmouseout="this.style.display='none'" onmouseover="this.style.display='inline'" style="display:none; position:absolute;WIDTH: 130px;">
            <ul class="multifuncMenu" id="menu_cc">
              <li>
                <a class="TWCTXMNUTAGME" width="100%">
                  <b>
                    Prog. Garanzia : <span id="titolo_menu" />
                  </b>
                </a>
              </li>
              <li name="TdMenuEl" style="DISPLAY: none" nowrap="true">
                <a class="TWCTXMNUTAGME" href="#" style="width:130px;">
                  <xsl:attribute name="onclick">
                    <xsl:choose>
                      <xsl:when test="$testWB='true'">
                        MenuCxClickModale('<xsl:value-of select="//FG300-I-CDISTI"/>','<xsl:value-of select="//FG300-I-NDG"/>')
                      </xsl:when>
                      <xsl:otherwise>MenuCxClick()</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  Dettaglio Garanzia
                </a>
              </li>
            </ul>
            <input id="TWCOMMONXSLMENUROWCOMODO" type="hidden" value=""/>
          </div>
          <!-- menu contestuale -->

          <!-- menu contestuale -->

          <div class="TWCTXMENUDIV" id="menu2" onmouseout="this.style.display='none'" onmouseover="this.style.display='inline'" style="display:none; position:absolute;WIDTH: 130px;">
            <ul class="multifuncMenu" id="menu_cc2">
              <li>
                <a class="TWCTXMNUTAGME" width="100%">
                  <b>
                    Prog. Linea: <span id="titolo_menu2" />
                  </b>
                </a>
              </li>
              <xsl:if test="not(//FG300-O-FLAVV-PRATEST = 'S')">
                <li name="TdMenuEl" style="DISPLAY: none" nowrap="true">
                  <a class="TWCTXMNUTAGME" href="#" style="width:130px;">
                    <xsl:attribute name="onclick">MenuCxClick2()</xsl:attribute>
                    Account View
                  </a>
                </li>
              </xsl:if>
              <li name="TdMenuEl" style="DISPLAY: none" nowrap="true">
                <a class="TWCTXMNUTAGME" href="#" style="width:130px;">
                  <xsl:attribute name="onclick">
                    <xsl:choose>
                      <xsl:when test="$testWB='true'">
                        MenuCxClickModale2('<xsl:value-of select="//FG300-I-CDISTI"/>','<xsl:value-of select="//FG300-I-NDG"/>')
                      </xsl:when>
                      <xsl:otherwise>MenuCxClick2()</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  Dettaglio Garanzia
                </a>
              </li>
            </ul>
            <input id="TWCOMMONXSLMENUROWCOMODO" type="hidden" value=""/>
          </div>
			
          <!-- menu contestuale -->

          <!-- menu contestuale -->
          <div class="TWCTXMENUDIV" id="menu3" onmouseout="this.style.display='none'" onmouseover="this.style.display='inline'" style="display:none; position:absolute;WIDTH: 130px;back">
            <ul class="multifuncMenu" id="menu_cc3">
              <li>
                <a class="TWCTXMNUTAGME" width="100%">
                  <b>
                    NDG: <span id="titolo_menu3" />
                  </b>
                </a>
              </li>
              <li name="TdMenuEl" style="DISPLAY: none" nowrap="true">
                <a class="TWCTXMNUTAGME" href="#" style="width:130px;">
                  <xsl:attribute name="onclick">MenuCxClick3()</xsl:attribute>
                  <xsl:attribute name="funz">CR200</xsl:attribute>
                  Global View
                </a>
              </li>
              <li name="TdMenuEl" style="DISPLAY: none" nowrap="true">
                <a class="TWCTXMNUTAGME" href="#" style="width:130px;">
                  <xsl:attribute name="onclick">MenuCxClick3()</xsl:attribute>
                  <xsl:attribute name="funz">CR250</xsl:attribute>
                  Risk View
                </a>
              </li>
              <li name="TdMenuEl" style="DISPLAY: none" nowrap="true">
                <a class="TWCTXMNUTAGME" href="#" style="width:130px;">
                  <xsl:attribute name="onclick">MenuCxClick3()</xsl:attribute>
                  <xsl:attribute name="funz">VR111</xsl:attribute>
                  Rating CRS
                </a>
              </li>
            </ul>
            <input id="TWCOMMONXSLMENUROWCOMODO" type="hidden" value=""/>
          </div>
			
          <!-- menu contestuale -->

          <!--OGGETTI PER UTILIZZO DI FILENET-->

          <textarea id="FN_Conditions" name="FN_Conditions" style="display:none;" cols="25" rows="15">
            <CONDITION>
              <INDEX name="ISTITUTO"  operatore="=">
                <xsl:attribute name="value">
                  <xsl:value-of select="//PAGE/ENVIRONMENT/CODIST-3N"/>
                </xsl:attribute>
              </INDEX>

              <INDEX name="NDG"  operatore="=">
                <xsl:attribute name="value">
                  <xsl:value-of select="//PAGE/ENVIRONMENT/NDG"/>
                </xsl:attribute>
              </INDEX>

              <!-- <INDEX name="TIPODOC"  operatore="=">
				<xsl:attribute name="value">ALL</xsl:attribute>
			</INDEX> 
									
			<INDEX name="SOTTOTIPODOC"  operatore="=">
				<xsl:attribute name="value">ALL</xsl:attribute>
			</INDEX> -->

              <INDEX name="COM_CONTO"  operatore="=">
                <xsl:attribute name="value"></xsl:attribute>
              </INDEX>
            </CONDITION>
          </textarea>

          <input type="hidden"  id="FN_DocumentClass" name="FN_DocumentClass" value="ANAGRAFE"/>

          <!--OGGETTI PER UTILIZZO DI FILENET-->          
        </BODY>

      </xsl:if>
    </xsl:if>

  </xsl:template>



  <xsl:template name="RC">

    <input type="hidden" name="pratica" id="pratica">
      <xsl:attribute name="value">
        <xsl:value-of select="//FG300-IO-PRATICA"/>
      </xsl:attribute>
    </input>

    <input type="hidden" name="dtIstr" id="dtIstr">
      <xsl:attribute name="value">
        <xsl:value-of select="//FG300-O-DTISTR"/>
      </xsl:attribute>
    </input>

    <input type="hidden" name="prgIstr" id="prgIstr">
      <xsl:attribute name="value">
        <xsl:value-of select="//FG300-O-PRGISTR"/>
      </xsl:attribute>
    </input>
    
    <script>      
      javascript:startApplication('<xsl:value-of select="//WB000-TIMESTAMP"/>');
    </script>

    <xsl:call-template name="ERRORE_FEU">

      <xsl:with-param name="funzione" select="'FG300'"/>
      <xsl:with-param name="nomeHostFunz" select="'FGGNF300'"/>
      <xsl:with-param name="descrFunz" select="'Pratica di fido: Elenco Garanzie'"/>
      <xsl:with-param name="returnCode" select="//FG300-RC"/>
      <xsl:with-param name="PGMerrore" select="//FG300-PGMERR"/>
      <xsl:with-param name="MSGerrore" select="//FG300-MSG"/>
      <xsl:with-param name="RESPcode" select="//FG300-RESP"/>
      <xsl:with-param name="SQLcode" select="//FG300-SQLCODE"/>

    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
