const app = require("express")();
const PORT = 8080;
const fs = require("fs");
const path = require("path");

const lifeguardPath = __dirname + "/data/lifeguards";
const boatPath = __dirname + "/data/boats";

app.listen(PORT, () => console.log(`It's running on localhost:${PORT}`));

function scanDirectory(directory) {
  let files = fs.readdirSync(path.resolve(directory));
  let obj = {};
  files.forEach(function (file) {
    obj[file.replace(/\.[^/.]+$/, "")] = file;
  });
  return obj;
}

let lifeguardFiles = scanDirectory("data/lifeguards");
let boatFiles = scanDirectory("data/boats");

console.log(lifeguardFiles);
console.log(boatFiles);

function getObjects(jsonPath, Jsonfiles) {
  let result = [];
  for (const file in Jsonfiles) {
    console.log(Jsonfiles[file]);
    let rawdata = fs.readFileSync(path.resolve(jsonPath, Jsonfiles[file]));
    result.push(JSON.parse(rawdata));
  }
  return result;
}

function getLifeGuards(jsonPath, jsonFiles) {
  let result = [];
  for (const file in jsonFiles) {
    //console.log(jsonFiles[file]);
    let rawdata = fs.readFileSync(path.resolve(jsonPath, jsonFiles[file]));
    let json = JSON.parse(rawdata);
    json["id"] = file;
    result.push(json);
  }
  return result;
}

app.get("/search", (req, res) => {
  res.status(200).send({
    name: "",
  });
});

app.get("/search/all", (req, res) => {
  let lifeguards = getObjects(lifeguardPath, lifeguardFiles);
  let boats = getObjects(boatPath, boatFiles);
  res.status(200).send({ lifeguards, boats });
});

app.get("/search/name/:name", (req, res) => {
  let lifeguards = getObjects(lifeguardPath, lifeguardFiles);
  let boats = getObjects(boatPath, boatFiles);
  const { name } = req.params;
  res.status(200).send({
    result: name,
  });
});

app.get("/search/lifeguards", (req, res) => {
  let lifeguards = getLifeGuards(lifeguardPath, lifeguardFiles);
  res.status(200).send(lifeguards);
});

app.get("/search/lifeguards/name/:name", (req, res) => {
  let lifeguards = getLifeGuards(lifeguardPath, lifeguardFiles);
  const { name } = req.params;
  res.status(200).send();
});

app.post("/search/:id", (req, res) => {
  const { id } = req.params;
  const { logo } = req.body;
});

function findBy(objects, attribut, value) {
  for (const attribut in objects) {
    if (objects[attribut] === value) {
    }
  }
}
