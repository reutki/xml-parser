var fileInput = document.getElementById("fileInput");
var resultTemplate = document.getElementById("resultTemplate");
var downloadBtn = document.getElementById("downloadBtn");
downloadBtn.style.display = "none";

var Result, fileName, extension, mainFile, regexer;
var mainFileSplitted, originalMainLines, lines, doubleMainFile

var variableIndexes = [];
var linesFoundIndexes = [];
var templateChanges = [];
var totalIndecies = []
var splittedInputLines
var firstRegexLine

downloadBtn.addEventListener("click", () => {
	Result !== '' && download(fileName,Result,extension);
});

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

		return [fileContent, extension, name];
	} catch (error) {
		console.error("Error reading the file:", error);
	}
}


//removes spaces between tags
function clearSpaces(file) {
	//>\n[\W\S]+\n<
	let lines = file.replaceAll(/>[\s]*</g, ">\n<");
	return lines;
}

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

//extracts the values from the file passed in
function extractValuesMain(file, inputTemplate) {
	//splitting to get the indexes of the lines
	mainFileSplitted = file.split("\n");

	const [cuttedStrings, tryStrings] = regexGenerator(inputTemplate);

	let tryArr = tryStrings.join(".*?")
	regexer = new RegExp(tryArr, "g")

	var currentMatch;
	var resultFinal = []

	while ((currentMatch = regexer.exec(doubleMainFile)) !== null) {
		const variable = currentMatch[0].replaceAll(/\s{2,}/g, "")
		const index = currentMatch.index

		resultFinal.push({variable, index})
	}

	let unsplitedValues = [];

	for (let obj of resultFinal) {
		unsplitedValues.push(obj.variable)
	}

	//extracts the values from the lines
	for (let k = 0; k < unsplitedValues.length; k++) {
		for (let i = 0; i < cuttedStrings.length; i++) {
			unsplitedValues[k] = unsplitedValues[k].replace(
				cuttedStrings[i],
				","
			);
		}
	}

	return unsplitedValues;
}


//allows to download the file after the result was made
function download(filename, text, extension) {
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


//generates the regex of the lines we are looking for to replace
function regexGenerator(file) {
	//the index of each varibale found used to be missed by the slice
	let lastVarObj = variableIndexes[variableIndexes.length - 1];
	//from where it will start to cut
	//(+variable length => to not use the variable as well in the slice that was cut)
	let startIndex = lastVarObj.index + lastVarObj.variable.length;
	//till where it should cut the slice
	let endIndex = file.substring(startIndex, file.length);
	let index = 0;
	//contains the code sliced without the variables
	var slicedQuery = [];

	variableIndexes.forEach((variable) => {
		slicedQuery.push(file.substring(index, variable.index));
		index = variable.index + variable.variable.length;
	});

	slicedQuery.push(endIndex);

	// removes the spaces between the tags
	let tryStrings = slicedQuery.map((el) => {

		el = el.replaceAll(/[.*+?^${}()|[\]\\/]/g, "\\$&") // escaping special characters
		el = el.replace(/>\s*</g, ">\\s*<") // replace spaces with its regex represention

		// ex: >  0 < becomes >\s*0\s*<
		el = el.replace(/(>)\s*(\W+)\s*(<)/g, "$1\\s*$2\\s*$3");

		return el
	})
	
	let cuttedStrings = slicedQuery.map((el) => el.replace(/>\s+</g, "><"));


	return [cuttedStrings, tryStrings];
}


//setting the variables in the new transformed code
function CodeTransformer(vars, text) {
	for (const match in vars) {
		let formatedRow = text;
		for (const item in vars[match]) {
			formatedRow = formatedRow.replaceAll(item, vars[match][item]);
		}
		templateChanges.push(formatedRow);
	}
	
	let currentMatch = []
	let currentTemplate = 0 
	
	console.log("Regexr:",regexer)
	let copyDouble = doubleMainFile + ""


	copyDouble = copyDouble.replace(regexer, (match, index) => {
		const variable = match
		const replacement = templateChanges[currentTemplate]
		currentTemplate++
		return replacement
	})

	return copyDouble;
}



//the main function that does everything -> called on Transform button
async function main() {

	var inputTemplate = document.getElementById("parseTemplate").value;
	[mainFile, extension, fileName] = await transformCode();
	doubleMainFile = mainFile
	originalMainLines = mainFile.split("\n");

	//removes all the tabs from the file to get the correct indexes
	mainFile = mainFile.replaceAll("\t", "");
	//removes the spaces between the >< and replaces them with newlines
	mainFile = clearSpaces(mainFile);

	//remove the newlines&tabs from the inputTemplate
	inputTemplate = inputTemplate.replaceAll("\n", "");
	inputTemplate = inputTemplate.replaceAll("\t", "");
	
	const inputLines = inputTemplate.split("\n");
	
	//stores the indexes of the variables found in the inputTemplate
	variableIndexes = [];
	linesFoundIndexes = [];
	
	inputLines.forEach((line) => {
		extractVariables(line);
	});

	//contains all the matches and their indexes where they are
	var variables = {};

	const matches = extractValuesMain(mainFile, inputTemplate);
	//an array of arrays that contains the items it has to look for
	var values = matches.map((el) => {
		return el.split(",").filter((value) => value !== "");
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

	templateChanges = [];

	let finalDoc = CodeTransformer(variables, changeTemplate);
	resultTemplate.value = finalDoc;

	console.log("Final Doc:", finalDoc.split("\n"))
	console.log("Original File:", originalMainLines)

	downloadBtn.style.display = "block";
}