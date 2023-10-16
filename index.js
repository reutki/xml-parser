
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
end= input.substring(st,file.length-1);
index = 0;
var res=[];
 variableIndexes.forEach((variable)=>{
  res.push( input.substring(index,variable.index));
  index=variable.index+variable.variable.length;

 })
 res.push(end)
//  console.log(res);
 response = res.map(el=>el.replace(/\s+/g, ' ').replace(/>\s+</g, '><'))

 
 return [res.map((part) => part.replace(/[.*+?^${}()|[\]\\/-]/g, '\\$&').replace(/\s+/g, '\\s*')).join(`[\\W\\w\\d]*((?=.)|(?=(-->|<--)))`),response ];

}

function extractValuesMain(file) {
  const [regexInPattern, allStrings] = regexGenerator(input);
  const fileSplit = file.split('\r')
  const regex = new RegExp(regexInPattern, 'g');
  // console.log('reg:',regex);
  var matches = [];
  let match;
  for(let x=0;x<fileSplit.length;x++){
    fileSplit[x] = fileSplit[x].replaceAll("/\s+/g", "")
    while ((match = regex.exec(fileSplit[x])) !== null) {
      matches.push(match[0]);
    }
  }
  

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




console.log(variables);
var changeTemplate = document.getElementById("change").value;

function CodeTransformer(vars,text){
    for(const match in vars){
      for(const item in vars[match]){
        console.log(`item ${item}, key ${match}`);
        console.log(vars[match][item]);
        text = text.replace(item,vars[match][item])
      }
    }
  console.log(text);
}
variables&&CodeTransformer(variables,changeTemplate)

}


//**input file .done

//**part of code -> extract values/params .done 

//*!input how to change 

//*!return a new file



