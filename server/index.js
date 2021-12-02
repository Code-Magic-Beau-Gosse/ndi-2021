const app = require("express")();
const PORT = 8080;
const lifeGuards = "data/lifeguards";
const boats = "data/boats";
const fs = require("fs");
const path = require("path");

app.listen(PORT, () => console.log(`It's running on localhost:${PORT}`));

app.get("/search", (req, res) => {
  res.status(200).send({
    name: "name",
    age: 20,
  });
});

app.get("/search/name/:name", (req, res) => {
  const { name } = req.params;

  res.status(200).send({
    result: name,
  });
});

app.post("/search/:id", (req, res) => {
  const { id } = req.params;
  const { logo } = req.body;
});

let rawdata = fs.readFileSync(path.resolve(lifeGuards, "lifeguard.json"));
let lifeguard = JSON.parse(rawdata);
console.log(lifeguard["1"]);
