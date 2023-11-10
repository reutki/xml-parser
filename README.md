# XML Parser

XML Parser is a JavaScript application that allows you to replace lines in a certain XML file with custom lines while preserving variables taken from the lines of the original file.

## Installation

Application itself doesn't require any installation. However, if you want to run tests you have to install **Selenium** and other dependecies. To install dependencies run:
```shell
npm install
``` 

## Run
For the work was used a extensions from VS Code - Live Server. HTML file was launched through it, which started JavaScript code.

## Usage
When you run `index.html` you will get such page:

There are three input fields. 
* First one called *Where to look for* is expecting XML file. 
* The second one *Set the vars* expecting string from XML file but with some replaces. For example: `<xsl name="|var1|" id="|var2|"/>`. 
* The third line *Change to* is the string you want to replace with. For example `<div>|var1| |var2|</div>`.

The latest text field is redacted original file.

## Important
Here we describe important features of the application that may create a different result than expected. Keep these in mind when using the application:
* The **application reads the tabulation** in the code in the original file. If spaces are used instead of tabs in the original file, it will prevent the program from defining the correct variables. In the worst case, the **program will return a replacement string with spaces** instead of variables;
* Be careful when you enter your code. Enter it as you would like it to appear in the final file. Extra spaces are removed in the lines you enter, but tabs and new even blank lines are retained. **Remove unnecessary tabs and lines**.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.