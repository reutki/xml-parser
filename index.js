
var fileElement = document.getElementById("fileInput");
var resultTemplate = document.getElementById("resultTemplate").value;


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

async function transformCode() {
  try {
    const file = fileElement.files[0];
    const fileContent = await readFileAsync(file);
    
    return fileContent;
  } catch (error) {
    console.error('Error reading the file:', error);
  }
}

async function main (){
  var input = document.getElementById("parseTemplate").value;
  var mainFile = await transformCode()
  mainFile = mainFile.replaceAll("\n", "")
  mainFile = mainFile.replaceAll("\t", "")
  input = input.replaceAll("\n", "")
  input = input.replaceAll("\t", "")
  
  
  function clear(file){
    let lines = file.replaceAll(/\s{3}/g,"")
    return lines
  }
  
  mainFile=clear(mainFile);
  input=clear(input);
  

const variableIndexes = []
const variableValues = []
function extractVariables(line) {
  const regex = /\{[A-Za-z0-9]+\}/g;

  let match;
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
st = j.index + j.variable.length
end= input.substring(st,file.length);
index = 0;
const res=[];
 variableIndexes.forEach((variable)=>{
  res.push( input.substring(index,variable.index));
  index=variable.index+variable.variable.length;

 })
 res.push(end)
 response = res.map(el=>el.replace(/\s+/g, ' ').replace(/>\s+</g, '><'))

 return [res.map((part) => part.replace(/[.*+?^${}()|[\]\\]/g, '\\$&').replace(/\s+/g, '\\s*')).join("[A-Za-z0-9]*"),response ];
}

function extractValuesMain(file) {
  const [regexInPattern, allStrings] = regexGenerator(input);
  const regex = new RegExp(regexInPattern, 'g');
  var matches = [];
  let match;
  while ((match = regex.exec(file)) !== null) {
    matches.push(match[0]);
  }
  matches=matches.map(el=>el.replace(/>\s+</g, '><'))
  for(let i=0; i<allStrings.length;i++){
    for(let k=0;k<matches.length;k++){
      matches[k]=matches[k].replace(allStrings[i],",")
    }
  }
  return matches;
}
const inputLines = input.split('\n');

inputLines.forEach((inputLine) => {
 extractVariables(inputLine);
})



var values;
var result = {};
const matches = extractValuesMain(mainFile);
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

  result[`line${i + 1}`] = iterationResult;
});
return result
}


