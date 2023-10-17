var fileElement = document.getElementById("fileInput");
var resultTemplate = document.getElementById("resultTemplate");

//reads the file
function readFileAsync(file) {
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
		const file = fileElement.files[0];
		const fileContent = await readFileAsync(file);

		return fileContent;
	} catch (error) {
		console.error("Error reading the file:", error);
	}
}

//the main function
async function main() {
	var input = document.getElementById("parseTemplate").value;
	var mainFile = await transformCode();
	mainFile = mainFile.replaceAll("\t", "");
	// mainFile = mainFile.replaceAll("\n", "")
	mainFile = clearSpaces(mainFile);

	//remove the newlines&tabs
	input = input.replaceAll("\n", "");
	input = input.replaceAll("\t", "");
	// input = clearSpaces(input)

	//removes spaces between tags
	function clearSpaces(file) {
		let lines = file.replaceAll(/>\s*</g, ">\n<");
		return lines;
	}

	//store the indexes of the variables found
	const variableIndexes = [];

	//extracts variables from the code --> |variable| <--
	function extractVariables(line) {
		const regex = /\|[A-Za-z0-9]+\|/g;

		var match;
		while ((match = regex.exec(line)) !== null) {
			const variable = match[0];
			const index = match.index;
			if (variableIndexes) variableIndexes.push({ variable, index });
		}
		return variableIndexes;
	}

	function regexGenerator(file) {
		j = variableIndexes[variableIndexes.length - 1];
		console.log("Var Indecies: ", variableIndexes);
		st = j.index + j.variable.length;
		console.log("File: ", file);
		end = input.substring(st, file.length);
		index = 0;
		var res = [];
		variableIndexes.forEach((variable) => {
			console.log("Input Subs: ", input.substring(index, variable.index));
			res.push(input.substring(index, variable.index));
			index = variable.index + variable.variable.length;
		});
		res.push(end);
		response = res.map((el) =>
			el.replace(/\s+/g, " ").replace(/>\s+</g, "><")
		);

		return [
			res,
			res
				.map((part) =>
					part
						.replace(/[.*+?^${}()|[\]\\/-]/g, "\\$&")
						.replace(/\s+/g, "\\s*")
				)
				.join(`\\d`),
			response,
		];
	}
	let fileSplit;
	const indexes = [];

	function extractValuesMain(file) {
		fileSplit = file.split("\n");
		// fileSplit = fileSplit.replaceAll("/\s+/g", "")
		// fileSplit = file

		const indecies = [];

		const [res, regexInPattern, allStrings] = regexGenerator(input);

		let splittedInputLines = clearSpaces(res.join(".*")).split("\n");
		let firstRegexLine = new RegExp(splittedInputLines[0], "g");
		console.log(firstRegexLine);
		for (let lineIndex = 0; lineIndex < fileSplit.length; lineIndex++) {
			let allIncludes = true;
			let lineArr = [];
			if (firstRegexLine.test(fileSplit[lineIndex])) {
				// console.log(fileSplit[lineIndex])

				for (
					let strIndex = 0;
					strIndex < splittedInputLines.length;
					strIndex++
				) {
					let regexLineInput = new RegExp(
						splittedInputLines[strIndex],
						"g"
					);

					if (!regexLineInput.test(fileSplit[lineIndex + strIndex])) {
						console.log(fileSplit[lineIndex + strIndex]);
						console.log(splittedInputLines[strIndex]);
						lineArr = [];
						allIncludes = false;
						break;
					} else {
						lineArr.push(lineIndex + strIndex);
					}
				}
				if (allIncludes) {
					indecies.push(lineArr);
				}
			}
		}

		console.log("Found Line Indecies: ", indecies);

		const regex = new RegExp(regexInPattern, "g");
		console.log("reg:", regex);
		var matches = [];
		let match;
		for (let x = 0; x < fileSplit.length; x++) {
			fileSplit[x] = fileSplit[x].replaceAll("/s+/g", "");
			// while ((match = regex.exec(fileSplit)) !== null) {
			// 	matches.push(match[0]);
			// 	indexes.push(x);
			// }
		}

		matches = matches.map((el) => el.replace(/>\s+</g, "><"));
		for (let i = 0; i < allStrings.length; i++) {
			for (let k = 0; k < matches.length; k++) {
				matches[k] = matches[k].replace(allStrings[i], ",");
			}
		}

		return matches;
	}
	const inputLines = input.split("\n");

	inputLines.forEach((inputLine) => {
		extractVariables(inputLine);
	});

	var values;
	var variables = {};
	const matches = extractValuesMain(mainFile);
	values = matches.map((el, i) => {
		return el.split(",").filter((value) => value != "");
	});

	values.forEach((arr, i) => {
		const iterationResult = {};

		arr.forEach((str, t) => {
			variableIndexes.forEach((variable, k) => {
				iterationResult[`${variable.variable}`] = arr[k];
			});
		});

		variables[`match${i + 1}`] = iterationResult;
	});
	resultTemplate.value = JSON.stringify(variables);

	var changeTemplate = document.getElementById("change").value;

	const templateChanges = [];
	//setting the variables in the new code
	function CodeTransformer(vars, text) {
		for (const match in vars) {
			let formatedRow = text;
			for (const item in vars[match]) {
				// console.log(vars[match][item]);
				// console.log(`item = ${item}`);
				formatedRow = formatedRow.replace(item, vars[match][item]);
			}
			templateChanges.push("\n" + formatedRow);
		}
		return templateChanges;
	}

	variables && CodeTransformer(variables, changeTemplate);

	indexes.forEach((index, i) => {
		fileSplit[index] = templateChanges[i];
	});

	const Result = fileSplit.join(" ").trim();
	resultTemplate.value = Result;
}

// Or

//**input file .done

//**part of code -> extract values/params .done

//**input how to change

//*!return a new file

// Change '><' to >\n< done

// Change vars in input line by regex

// Split input line by \n  done

// Choose how to store indecies;
