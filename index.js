const fileInput = document.getElementById("fileInput");
const parseTemplate = document.getElementById("parseTemplate").value;
const resultTemplate = document.getElementById("resultTemplate").value;

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
    const file = fileInput.files[0];
    const fileContent = await readFileAsync(file);
    
    console.log(fileContent);
    console.log('Test');
  } catch (error) {
    console.error('Error reading the file:', error);
  }
}
