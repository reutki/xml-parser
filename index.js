var fileInput = document.getElementById("fileInput");
var resultTemplate = document.getElementById("resultTemplate");

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
		const fileContent = await readFile(file);

		return fileContent;
	} catch (error) {
		console.error("Error reading the file:", error);
	}
}

function getTabs(str){
	const tabs = str.match(/\t/g);
	return tabs ? tabs.length:0;
}

function putTabsInFront(str, minimalTab) {
	return Array(minimalTab).fill("\t").join("") + str + "\n"
}

//the main function that does everything -> called on Transform button
async function main() {
	var inputTemplate = document.getElementById("parseTemplate").value;
	var mainFile = await transformCode();
	const splittedMainFile = mainFile.split("\n")
	
	//removes all the tabs from the file to get the correct indexes
	mainFile = mainFile.replaceAll("\t", "");
	//removes the spaces between the >< and replaces them with newlines
	mainFile = clearSpaces(mainFile);

	//remove the newlines&tabs from the inputTemplate
	inputTemplate = inputTemplate.replaceAll("\n", "");
	inputTemplate = inputTemplate.replaceAll("\t", "");

	
	const fileTabs = {}

	for (let i=0; i < splittedMainFile.length; i++) {
		let tabsCount = 0
		let characterIndex = 0
		while (splittedMainFile[i].charAt(characterIndex++) === "\t") {
			tabsCount++
		}
		fileTabs[i] = tabsCount
	}


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
		cuttedStrings = slicedQuery.map((el) =>
			el.replace(/>\s+</g, "><")
		);

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
		let splittedInputLines = clearSpaces(slicedQuery.map((str) => str.replaceAll(/[.*+?^${}()|[\]\\/-]/g, "\\$&").replaceAll(/\s+/g, "\\s*")).join(".*")).split("\n")
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
			for (let strIndex = 0; strIndex < splittedInputLines.length; strIndex++) {
				//contains the regexes that it has to go through and check
				let regexLineInput = new RegExp(splittedInputLines[strIndex], "g");
			//if it does not pass it will go to the next line in the file 
				if (!regexLineInput.test(mainFileSplitted[lineIndex + strIndex])) {
						linesArr = [];
						passedAllLinesRegex = false;
						break;
					} 
				else {
					//will add the line index to the array linesArr
					linesArr.push(lineIndex + strIndex);
				}
			}
			//if it passes all the lines from the linesArr, it will add the linesArr to the linesFoundIndexes
				if (passedAllLinesRegex) {
					linesFoundIndexes.push(linesArr);
				}
			}
		}

		
		//will contain all the values at the indexes that were found
		let unsplitedValues = []
		//finds the lines where we should find the values
		for (let i=0; i < linesFoundIndexes.length; i++) {
			unsplitedValues.push(linesFoundIndexes[i].map((position) => {
				return mainFileSplitted[position]
			}).join(""))

		}
		//extracts the values from the lines
		for (let k=0; k < unsplitedValues.length; k++)
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

		return templateChanges;
	}


	variables && CodeTransformer(variables, changeTemplate);

	const lines = []
	// get original lines from original file according to their indecies
	for (let i=0; i < linesFoundIndexes.length; i++) {
		let currentArr = []
		for (let j=0; j < linesFoundIndexes[i].length; j++) {
			currentArr.push(mainFileSplitted[linesFoundIndexes[i][j]])
		}
		lines.push(currentArr.join(""))
	}
	
	const initialTabStrings = []
	// get strings in their initial states with tabs
	// traversing each line from main file
	for (let mainLine = 0; mainLine < splittedMainFile.length; mainLine++){
		// traversing each line from the original lines (that can be code blocks also)
		let trimmedLine = splittedMainFile[mainLine].trim()
		for (let line=0; line < lines.length; line++) {
			// check if line from main file is substring of line (code block)
			if (trimmedLine !== "" && lines[line].includes(trimmedLine)) {
				let allChecked = 0
				let checkedStrings = []

				// cause we take only one line from main and string that can be multiline block
				// we should traverse nearest lines after current line to check if block are the same
				for (let blockIndex = mainLine; blockIndex < mainLine + linesFoundIndexes[0].length; blockIndex++) {
					let trimmedBlock = splittedMainFile[blockIndex].trim()
					// the same check as upper
					// TODO Put in one function
					if (trimmedBlock !== "" && lines[line].includes(trimmedBlock)) {
						// in case when block and string are actually the same
						// we push string from main file in array at the time
						if (trimmedBlock == lines[line]) {
							allChecked = linesFoundIndexes[0].length
							checkedStrings.push(splittedMainFile[blockIndex])
							break
						}
						// allChecked counts how many lines from main file correspond
						// to multiline block
						allChecked++
						checkedStrings.push(splittedMainFile[blockIndex])
					}
				}
				
				// if all lines correspond code block pushes it in array
				if (allChecked == linesFoundIndexes[0].length) {
					initialTabStrings.push(checkedStrings)
				}
			}
		}
	}


	let totalIndecies = []
	// getting all indeceies of original strings in original file
	// traversing each array in initialTabStrings
	for (let i=0; i < initialTabStrings.length; i++) {
		let indeciesInMainFile = []
		// traversing each string from array
		// let lastIndecies = totalIndecies[totalIndecies.length-1] == undefined ? 0 : totalIndecies[totalIndecies.length-1] 
		// let latestIndex = lastIndecies[lastIndecies.length-1] == undefined ? 0 : lastIndecies[lastIndecies.length-1]
		
		let startIndex = 0
		for (let j=0; j < initialTabStrings[i].length; j++) {
			// find index of line using indexOf
			// cause the different lines can appear before the line that is needed
			// we find the first occurence after the latest element
			// if there is no latest element we start finding from 0 
			
			let lastArr = totalIndecies[totalIndecies.length-1]
			let lastIndex = 0

			if (indeciesInMainFile.length > 0) {
				// indecies not empty
				let lastIndexMain = indeciesInMainFile[indeciesInMainFile.length-1] 
				if (lastIndexMain == undefined) {
					// last index main is undefined
					startIndex = 0
				} else {
					startIndex = lastIndexMain
				}
			} else if (lastArr != undefined) {
				// last arr defined
				lastIndex = lastArr[lastArr.length-1]
				if (lastIndex != undefined) {
					// last index defined
					startIndex = lastIndex
				} else {
					// last index undefined
					startIndex = 0
				}
			}

			indeciesInMainFile
				.push(
					splittedMainFile.indexOf( 
						initialTabStrings[i][j],
						startIndex
						)
					)
		}

		totalIndecies.push(indeciesInMainFile)
	}

	// ! It looks that `uniqueStrings` are the same to `initialTabStrings`
	let uniqueStrings = []
	// traversing all indecies
	for (let i=0; i < totalIndecies.length; i++) {
		let currentArr = []
		for (let j=0; j < totalIndecies[i].length; j++) {
			// get strings from original file with tabs
			currentArr.push(splittedMainFile[totalIndecies[i][j]])
		}
		uniqueStrings.push(currentArr)
	}

	const tabsFromMain = []
	// getting minimal number of tabs
	uniqueStrings&&uniqueStrings.forEach((arr)=>{
		arr.forEach((line) => {
			const tabs = getTabs(line);
			tabsFromMain.push(tabs)
		})
	})

	
	let minimalTab = Math.min(...tabsFromMain)

	let startIndex = 0
	let processingArr = []
	let endIndex

	// it works by slicing array of lines
	// ex: main file looks like this [1,2,smthToReplace,4,smthToReplace,5,6,7,smthToReplace,9,10]
	// after it slices it turns into: [1,2] [4] [5,6,7] [9,10]
	// between slices we put values that we put instead of initial
	// final array is [1..10] thus all spaces from original file are saved 
	totalIndecies.forEach((arr, i) => {
		// for each array in total indecies we take first index that is index of start line
		endIndex = arr[0]

		processingArr.push(...splittedMainFile.slice(startIndex, endIndex))
		
		// put in front of resulting string tabs
		let currentNewString = templateChanges[i].split("\n")
		if (currentNewString.length != 1) {
			currentNewString = currentNewString.map((str) => putTabsInFront(str, minimalTab)).join("")
		} else {
			currentNewString = putTabsInFront(currentNewString.join(""), minimalTab)
		}

		processingArr.push(currentNewString)
		
		// start index is the last string that matches template
		startIndex = arr[arr.length-1] + 1
	})

	// finding the start index that is the latest index in array (latest occurency) for final push
	let innerLastArr = totalIndecies[totalIndecies.length-1]
	startIndex = innerLastArr[innerLastArr.length-1] + 1
	endIndex = splittedMainFile.length

	processingArr.push(...splittedMainFile.slice(startIndex, endIndex))

	const Result = processingArr.join(" ").trim();
	resultTemplate.value = Result;
}

// * DONE 
// input file
// part of code -> extract values/params
// change '><' to >\n<
// Split input line by \n
// input how to change
// ?choose how to store indexes;
// refractoring
// save in file
// remember number of spaces and tabs
// replace correctly

// TODO 