var mainFile = `<tr class="voce" id="TEST1" tot="TEST2" segno="+">
    <td> III) TEST3</td>
    <td align="right" style="padding-right:3px">
        <input  maxlength="13" style="width:100px" col="1">
            <xsl:if test="//CB935-O-TPFUNZ='I'">
                <xsl:attribute name="readOnly">true</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class"><xsl:value-of select="$in1"/></xsl:attribute>
            <xsl:attribute name="onKeyDown">zero(this)</xsl:attribute>
            <xsl:attribute name="onBlur">campoValorizzato(this)</xsl:attribute>
            <xsl:if test="//CB935-IO-VOCIG/CB935-RIGA[CB935-V = 'G01530']/CB935-V1!=''">
                <xsl:attribute name="value">
                    <xsl:value-of select="user:punti(//CB935-IO-VOCIG/CB935-RIGA[CB935-V = 'G01530']/CB935-V1)"/>
                </xsl:attribute>
            </xsl:if>
        </input>
    </td>
    <td align="right" style="padding-right:3px">
        <input maxlength="13" style="width:100px" readonly="true" col="2" disabled="true">
            <xsl:attribute name="class"><xsl:value-of select="$in2"/></xsl:attribute>
            <xsl:attribute name="onKeyDown">zero(this)</xsl:attribute>
            <xsl:attribute name="onBlur">campoValorizzato(this)</xsl:attribute>
            <xsl:if test="//CB935-IO-VOCIG/CB935-RIGA[CB935-V = 'G01530']/CB935-V2!=''">
                <xsl:attribute name="value">
                    <xsl:value-of select="user:punti(//CB935-IO-VOCIG/CB935-RIGA[CB935-V = 'G01530']/CB935-V2)"/>
                </xsl:attribute>
            </xsl:if>
        </input>
    </td>
    <td align="right" style="padding-right:3px">
        <input class="input_finto" style="width:100px" disabled="true" col="3">
        <xsl:if test="//CB935-IO-VOCIG/CB935-RIGA[CB935-V = 'G01530']/CB935-V3!=''">
            <xsl:attribute name="value">
                <xsl:value-of select="user:punti(//CB935-IO-VOCIG/CB935-RIGA[CB935-V = 'G01530']/CB935-V3)"/>
            </xsl:attribute>
        </xsl:if>
        </input>
    </td>
</tr>`;

const input = `<xsl:if test="//CB935-IO-VOCIG/CB935-RIGA[CB935-V = '{VAR1}']/CB935-{VAR2}!=''">
                <xsl:attribute name="value">
                <xsl:value-of select="user:punti(//CB935-IO-VOCIG/CB935-RIGA[CB935-V = '{VAR5}']/CB935-{VAR6})"/>
                </xsl:attribute>
                </xsl:if>`;

mainFile = mainFile.replaceAll("\n", "")
mainFile = mainFile.replaceAll("\t", "")


function extractVariables(line) {
  const regex = /\{[A-Za-z0-9]+\}/g;
  const assignments = {};
  let match;

  while ((match = regex.exec(line)) !== null) {
    const variable = match[1];
    const value = match[2];
    assignments[variable] = value;
    findIndex(match.input.slice(0, match.index), match.index)
    // console.log(match.input.slice(0, match.index))
  }

  return assignments;
}

const mainLines = mainFile.split('\n');
// console.log(mainLines)
const inputLines = input.split('\n');
console.log(inputLines);

const variableDifferences = {};
inputLines.forEach((inputLine, inputLineIndex) => {
  const inputAssignments = extractVariables(inputLine);

})

function findIndex(str, index) {
  let lines = mainFile.split(/\s{3}/)
  lines = lines.map((element) => element.trim() )
  lines = lines.filter((element) => element != "")
  for (let line of mainFile.split(/\s{3}/)) {
    // console.log("Line: ", line)
    if (line.startsWith(str)) {
      console.log(line);
      console.log(line.slice(index))
    }
  }
  // console.log(lines);
}

console.log(variableDifferences);