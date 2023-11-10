const webdriver = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const path = require("path")
const testsData = require("./tests.json")

const config = require("../config.json")
const By = webdriver.By;

(async () => {
  try {
    const options = new chrome.Options();
    // Set any Chrome-specific options here, if needed.
    console.log("Setting Options")
    options.setChromeBinaryPath(config['chromePath'])
    
    console.log("Creating Driver")

    var driver = new webdriver.Builder()
        .usingServer(config['serverAddr'])
        .withCapabilities(webdriver.Capabilities.chrome())
        .build();

    await driver.get(config['clientAddr']);

    console.log("Finding Input Field")
    const fileInput = await driver.findElement(By.id("fileInput"))

    console.log("Finding File")
    for (let obj of testsData['tests']) {

      console.log("FilePath: ", config[obj['filepath']])
      
      const filePath = path.resolve(__dirname, config[obj['filepath']])
      await fileInput.sendKeys(filePath)
      
      console.log("Finding Template Field")
      
      const setVars = await driver.findElement(By.id("parseTemplate"))
      await driver.executeScript("arguments[0].value = arguments[1];", setVars, obj['template'])

      
      console.log("Finding Change To Field")
      const changeTo = await driver.findElement(By.id("change"))

      await driver.executeScript("arguments[0].value = arguments[1];", changeTo, obj['changeto'])
      
      console.log("Finding Transform Btn")
      const tfmBtn = await driver.findElement(By.id("tfmBtn"))
      await tfmBtn.click()
      
      
      console.log("Getting Output")
      const output = await driver.findElement(By.id("resultTemplate"))
      let res = await output.getAttribute('value')

      await setVars.clear()
      await changeTo.clear()
      await output.clear()

      let splittedRes = res.split("\n")

      for (let index of Object.keys(obj['expected'])) {
        for (let string of obj['expected'][index]) {

          let currentIndex = +index + obj['expected'][index].indexOf(string)

          let escapeString = string.trim()
          let escapeRes = splittedRes[currentIndex].trim()

          if (escapeString !== escapeRes) {
            console.log("-".repeat(15))
            console.log(`Test #${obj['testId']} Failed at Index #${currentIndex}`)
            console.log(`Index: ${+index}`)
            console.log(`Expected String:\n${escapeString.replaceAll(/\t/g, "\\t").replaceAll(/\n/g, "\\n")}`)
            console.log(`Output String:\n${escapeRes.replaceAll(/\t/g, "\\t").replaceAll(/\n/g, "\\n")}`)
          } else {
            console.log("-".repeat(15))
            console.log(`Test #${obj['testId']} Successfull at Index #${currentIndex}`)
          }
        }
      }
      
    }

  } catch (error) {
    console.error("An error occurred:", error);
  }
}) ();