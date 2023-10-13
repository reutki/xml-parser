function onlyLettersAndNumbers(str) {
    return /[a-zA-Z0-9\W]/.test(str);
  }
  
  const str1 = 'C5-IO-STR-U';
  const str2 = 'contains spaces';
  const str3 = 'has special characters !@#$%^&';
  const str4 = '"@[ID=3]"';
  const str5 = 'John-SNW-IO';
  const str6 = '--> comment <--';
  const str7 = '//comment ';
  const str8 = ':10%';
  
  console.log(onlyLettersAndNumbers(str1)); 
  console.log(onlyLettersAndNumbers(str2)); 
  console.log(onlyLettersAndNumbers(str3)); 
  console.log(onlyLettersAndNumbers(str4)); 
  console.log(onlyLettersAndNumbers(str5)); 
  console.log(onlyLettersAndNumbers(str6)); 
  console.log(onlyLettersAndNumbers(str7)); 
  console.log(onlyLettersAndNumbers(str8)); 