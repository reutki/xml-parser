var fileInput = document.getElementById("fileInput");
var resultTemplate = document.getElementById("resultTemplate");
var downloadBtn = document.getElementById("downloadBtn");
downloadBtn.style.display = "none";

//reads the file
function readFile(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = function () {
      resolve(reader.result);
    };

    reader.onerror = function () {
      reject(reader.error);
    };

    reader.readAsText(file);
  });
}

//returns the file as text
async function transformCode() {
  try {
    const file = fileInput.files[0];
    const extension = file.type;
    const name = file.name;
    const fileContent = await readFile(file);
    console.log("extension", extension);
    return [fileContent, extension, name];
  } catch (error) {
    console.error("Error reading the file:", error);
  }
}

//the main function that does everything -> called on Transform button
async function main() {
  var inputTemplate = document.getElementById("parseTemplate").value;
  var [mainFile, extension, filename] = await transformCode();
  //removes all the tabs from the file to get the correct indexes
  mainFile = mainFile.replaceAll("\t", "");
  //removes the spaces between the >< and replaces them with newlines
  mainFile = clearSpaces(mainFile);

  //remove the newlines&tabs from the inputTemplate
  inputTemplate = inputTemplate.replaceAll("\n", "");
  inputTemplate = inputTemplate.replaceAll("\t", "");

  //removes spaces between tags
  function clearSpaces(file) {
    let lines = file.replaceAll(/>\s*</g, ">\n<");
    return lines;
  }

  //stores the indexes of the variables found in the inputTemplate
  const variableIndexes = [];

  //extracts variables from the code
  function extractVariables(line) {
    // find all the items that are in |...| -> |variable| (combiation of letters and numbers)
    // 1 or more letter or number ,/g -> globally
    const regex = /\|[A-Za-z0-9]+\|/g;

    var match;
    //if we have a match  it will store the variable name and the index in the variableIndexes[]
    while ((match = regex.exec(line)) !== null) {
      const variable = match[0];
      const index = match.index;
      if (variableIndexes) variableIndexes.push({ variable, index });
    }
    return variableIndexes;
  }
  //generates the regex of the lines we are looking for to replace
  function regexGenerator(file) {
    //the index of each varibale found used to be missed by the slice
    j = variableIndexes[variableIndexes.length - 1];
    //from where it will start to cut
    //(+variable length => to not use the variable as well in the slice that was cut)
    start = j.index + j.variable.length;
    //till where it should cut the slice
    end = inputTemplate.substring(start, file.length);
    index = 0;
    //contains the code sliced without the variables
    var slicedQuery = [];

    variableIndexes.forEach((variable) => {
      slicedQuery.push(inputTemplate.substring(index, variable.index));
      index = variable.index + variable.variable.length;
    });
    slicedQuery.push(end);
    //removes the spaces between the tags
    cuttedStrings = slicedQuery.map((el) => el.replace(/>\s+</g, "><"));

    return [slicedQuery, cuttedStrings];
  }

  //the main file but is splitted by lines in an array
  let mainFileSplitted;
  const linesFoundIndexes = [];
  //extracts the values from the file passed in
  function extractValuesMain(file) {
    //splitting to get the indexes of the lines
    mainFileSplitted = file.split("\n");

    const [slicedQuery, cuttedStrings] = regexGenerator(inputTemplate);

    //contains the regex of each line from the inputTemplate
    let splittedInputLines = clearSpaces(
      slicedQuery
        .map((str) =>
          str
            .replaceAll(/[.*+?^${}()|[\]\\/-]/g, "\\$&")
            .replaceAll(/\s+/g, "\\s*")
        )
        .join(".*")
    ).split("\n");

    //the first line that contains regex in it
    let firstRegexLine = new RegExp(splittedInputLines[0], "g");

    //we go through all the lines of the main file
    for (let lineIndex = 0; lineIndex < mainFileSplitted.length; lineIndex++) {
      //we check if it has passed all the regex lines from the splittedInputLines
      let passedAllLinesRegex = true;
      //will contain the indexes of the lines where it has passed the regex
      let linesArr = [];

      if (firstRegexLine.test(mainFileSplitted[lineIndex])) {
        //if it passes the first regex from the splittedInputLines array of regexes, it will loop through it
        for (
          let strIndex = 0;
          strIndex < splittedInputLines.length;
          strIndex++
        ) {
          //contains the regexes that it has to go through and check
          let regexLineInput = new RegExp(splittedInputLines[strIndex], "g");
          //if it does not pass it will go to the next line in the file
          if (!regexLineInput.test(mainFileSplitted[lineIndex + strIndex])) {
            linesArr = [];
            passedAllLinesRegex = false;
            break;
          } else {
            //will add the line index to the array linesArr
            linesArr.push(lineIndex + strIndex);
          }
        }
        //if it passes all the lines from the linesArr, it will add the linesArr to the linesFoundIndexes
        if (passedAllLinesRegex) {
          linesFoundIndexes.push(linesArr);
          console.log(linesArr);
        }
      }
    }

    //will contain all the values at the indexes that were found
    let unsplitedValues = [];
    //finds the lines where we should find the values
    for (let i = 0; i < linesFoundIndexes.length; i++) {
      unsplitedValues.push(
        linesFoundIndexes[i]
          .map((position) => {
            return mainFileSplitted[position];
          })
          .join("")
      );
    }
    //extracts the values from the lines
    for (let k = 0; k < unsplitedValues.length; k++)
      for (let i = 0; i < cuttedStrings.length; i++) {
        unsplitedValues[k] = unsplitedValues[k].replace(cuttedStrings[i], ",");
      }
    return unsplitedValues;
  }

  //the code where we set the vars splitted
  const inputLines = inputTemplate.split("\n");

  inputLines.forEach((line) => {
    extractVariables(line);
  });

  //contains all the matches and their indexes where they are
  var variables = {};

  const matches = extractValuesMain(mainFile);
  //an array of arrays that contains the items it has to look for
  var values = matches.map((el, i) => {
    //removes the items that are ',' or empty
    return el.split(",").filter((value) => value != "");
  });

  //will create an object that will contain {matchX: '|variable|':variableIndex}
  values.forEach((arr, i) => {
    const iterationResult = {};

    arr.forEach(() => {
      variableIndexes.forEach((variable, k) => {
        iterationResult[`${variable.variable}`] = arr[k];
      });
    });
    variables[`match${i + 1}`] = iterationResult;
  });
  //the template of how to modify the lines that were found
  var changeTemplate = document.getElementById("change").value;

  const templateChanges = [];
  //setting the variables in the new transformed code
  function CodeTransformer(vars, text) {
    for (const match in vars) {
      let formatedRow = text;
      for (const item in vars[match]) {
        formatedRow = formatedRow.replace(item, vars[match][item]);
      }
      templateChanges.push(formatedRow);
    }
    console.log("new lines (Template changes): ", templateChanges);
    console.log("SPLITTED FILE: ", mainFileSplitted);
    return templateChanges;
  }

  variables && CodeTransformer(variables, changeTemplate);

  //TODO Fix this code to replace correctly the lines.
  for (let i = 0; i < linesFoundIndexes.length; i++) {
    linesFoundIndexes[i].forEach((childIndex) => {
      if (linesFoundIndexes[i].indexOf(childIndex) == 0) {
        mainFileSplitted.splice(
          linesFoundIndexes[i][0],
          linesFoundIndexes[i].length,
          templateChanges[i]
        );
      } else {
        mainFileSplitted.splice(
          linesFoundIndexes[i][linesFoundIndexes[i].indexOf(childIndex)],
          linesFoundIndexes[i].length,
          ""
        );
      }
    });
  }

  console.log(mainFileSplitted.join("\n"));
  const Result = mainFileSplitted.join(" ").trim();
  resultTemplate.value = Result;
  downloadBtn.style.display = "block";
  downloadBtn.addEventListener("click", () => download(filename, Result));

  //allows to download the file after the result was made
  function download(filename, text) {
    var element = document.createElement("a");
    element.setAttribute(
      "href",
      `data:${extension};charset=utf-8,` + encodeURIComponent(text)
    );
    element.setAttribute("download", filename);

    element.style.display = "none";
    document.body.appendChild(element);

    element.click();

    document.body.removeChild(element);
  }
}

// fs.writeFileSync('/tmp/test-sync', 'Hey there!');
// * DONE
// input file
// part of code -> extract values/params
// change '><' to >\n<
// Split input line by \n
// input how to change
// ?choose how to store indexes;
// refractoring
// save in file

// TODO
// replace correctly
// remember number of spaces and tabs
