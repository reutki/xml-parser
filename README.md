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

## Tests
Application uses **Selenium** for testing make sure to adapt your `config.ini` file according to your preferences. `clientAddr` is address on which application is running on and `serverAddr` - to which address you want to run **Selenium**. Such file were used as tested in application: `another.xsl`, `FG303.xsl`, `teste.xml`. Tests are **hardcoded** so if you want to add your own test you should firstly escape **special characters** in string as well as **spaces, tabs and new lines**. Second thing you should know **index** of string what you want to check in file. You do not have to put all indecies of lines in test if they go sequentially (one by one), just put them in array.
To run tests use:
```shell
node test.js
```
Do not forget about chrome driver. You can found it on [Google Chrome Labs](https://googlechromelabs.github.io/chrome-for-testing/).

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.