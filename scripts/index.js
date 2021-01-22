const path = require("path");
const fs = require("fs");

const year = new Date().getFullYear();
let month = new Date().getMonth() + 1;
month = month < 10 ? `0${month}` : month;
let date = new Date().getDate();
date = date < 10 ? `0${date}` : date;
const parseDate = `${year}-${month}-${date}`;

const whiteList = ["largest-contentful-paint"];
const scoreWhiteList = ["performance", "accessibility", "best-practices", "seo"];
const defaultDir = path.join(__dirname, `../result/${parseDate}`);

const throttleFolder = `${defaultDir}/default`;
const highPerformance = `${defaultDir}/high`;

const folderList = [throttleFolder, highPerformance];

const obj = {
  default: {},
  high: {},
};

folderList.forEach((folder) => {
  const folderReg = /high$/g;
  if (!!folderReg.test(folder)) {
    readFile(highPerformance, false);
  } else {
    readFile(throttleFolder, true);
  }
});

function readFile(folder, isThrottle = false) {
  fs.readdirSync(folder).forEach((file) => {
    const fileName = file.slice(0, file.length - 5);
    const throttleKey = isThrottle ? "default" : "high";

    obj[throttleKey][fileName] = {};

    const data = JSON.parse(fs.readFileSync(`${folder}/${file}`, "utf-8"));

    const auditsData = data["audits"];
    const categoryData = data["categories"];

    Object.keys(categoryData).forEach((category) => {
      if (scoreWhiteList.indexOf(category) > -1) {
        obj[throttleKey][fileName][category] = Math.round(categoryData[category]["score"] * 100);
      }
    });

    Object.keys(auditsData).forEach((item) => {
      if (whiteList.indexOf(item) > -1) {
        obj[throttleKey][fileName][item] = auditsData[item];
      }
    });
  });
}

const json = JSON.stringify(obj, null, 2);

fs.writeFile(path.join(__dirname, `../result/${parseDate}/result.json`), json, "utf8", () => {});
