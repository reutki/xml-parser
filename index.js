
var fileElement = document.getElementById("fileInput");
var resultTemplate = document.getElementById("resultTemplate");


//reads the file
function readFileAsync(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    
    reader.onload = function() {
      resolve(reader.result);
    };

    reader.onerror = function() {
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
    console.error('Error reading the file:', error);
  }
}

//the main function
async function main (){
  var input = document.getElementById("parseTemplate").value;
  var mainFile = await transformCode()
  mainFile = mainFile.replaceAll("\t", "")

  //remove the newlines&tabs
  // input = input.replaceAll("\n", "")
  input = input.replaceAll("\t", "")
  
  //removes spaces between tags
  function clearSpaces(file){
    let lines = file.replaceAll(/>\s+</g, '><')
    return lines
  }

  
//store the indexes of the variables found
const variableIndexes = []

//extracts variables from the code --> |variable| <--
function extractVariables(line) {
  const regex = /\|[A-Za-z0-9]+\|/g;

  var match;
  while ((match = regex.exec(line)) !== null) {
    const variable = match[0];
    const index = match.index;
    if(variableIndexes)
    variableIndexes.push({variable,index})
  }
  return variableIndexes;
}


function regexGenerator(file){
j = variableIndexes[variableIndexes.length-1]
console.log("Var Indecies: ", variableIndexes)
st = j.index + j.variable.length
console.log("File: ", file)
end= input.substring(st, file.length-1);
index = 0;
var res=[];
 variableIndexes.forEach((variable)=>{
  console.log("Input Subs: ", input.substring(index,variable.index))
  res.push( input.substring(index,variable.index));
  index=variable.index+variable.variable.length;

 })
 res.push(end)
//  console.log(res);
 response = res.map(el=>el.replace(/\s+/g, ' ').replace(/>\s+</g, '><'))

 
 console.log("Result: ", res)
 console.log("Response: ", response)
 return [res.map((part) => part.replace(/[.*+?^${}()|[\]\\/-]/g, '\\$&').replace(/\s+/g, '\\s*')).join(`[\\W\\w\\d]*((?=.)|(?=(-->|<--)))`),response ];

}
let fileSplit;
const indexes = []

function extractValuesMain(file) {
  fileSplit = file.split('\r')
  const [regexInPattern, allStrings] = regexGenerator(input);
  const regex = new RegExp(regexInPattern, 'g');
  console.log('reg:',regex);
  var matches = [];
  let match;
  for(let x=0;x<fileSplit.length;x++){
    fileSplit[x] = fileSplit[x].replaceAll("/\s+/g", "")
    while ((match = regex.exec(fileSplit[x])) !== null) {
      matches.push(match[0]);
      indexes.push((x));
    }
  }
  console.log(allStrings);
  

  matches=matches.map(el=>el.replace(/>\s+</g, '><'))
  for(let i=0; i<allStrings.length;i++){
    for(let k=0;k<matches.length;k++){
      matches[k]=matches[k].replace(allStrings[i],",")
    }
  }

  // console.log(matches);
  return matches;
}
const inputLines = input.split('\n');

inputLines.forEach((inputLine) => {
 extractVariables(inputLine);
})



var values;
var variables = {};
const matches = extractValuesMain(mainFile);
console.log("Mathces: ", matches)
values = matches.map((el, i) => {
  return el.split(',').filter(value => value != '');
});

values.forEach((arr, i) => {
  const iterationResult = {};

  arr.forEach((str, t) => {
    variableIndexes.forEach((variable, k) => {
      iterationResult[`${variable.variable}`] = arr[k];
    });
  });

  variables[`match${i + 1}`] = iterationResult;
  // console.log(iterationResult);
});
resultTemplate.value =JSON.stringify(variables);

// console.log(variables);
var changeTemplate = document.getElementById("change").value;


const templateChanges=[]
//setting the variables in the new code 
function CodeTransformer(vars,text){
    for(const match in vars){
      let formatedRow =text;
      for(const item in vars[match]){
        console.log(vars[match][item]);
        console.log(`item = ${item}`);
        formatedRow = formatedRow.replace(item,vars[match][item]
        )
      }
      templateChanges.push("\n"+formatedRow)
    }
  return templateChanges
}


variables&&CodeTransformer(variables,changeTemplate)
console.log(variables);
console.log(changeTemplate);
console.log(templateChanges);

indexes.forEach((index,i)=>{
  fileSplit[index]=templateChanges[i]
})

console.log(fileSplit);
const Result = fileSplit.join(' ').trim()
resultTemplate.value=Result;
}




// Or

//**input file .done

//**part of code -> extract values/params .done 

//**input how to change 

//*!return a new file



