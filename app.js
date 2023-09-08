const express = require('express');
const { exec } = require('child_process');
bodyParser = require('body-parser');
let labsconfig = require('./config/labspath.json');

const app = express();

app.use(bodyParser.json())

const port = 3000; 

// test route 
app.get('/', (req, res) => {
    exec("whoami", (error, stdout, stderr) => {
        if (error) {
          console.log(stdout);
          console.error("-------------------------------------------");
          console.error(error);
          res.status(500).send('Error creating VM');
        } else {
          console.log(stdout);
          res.status(200).send('VM created successfully');
        }
      });
})


// create vm route 
app.post('/create-vm', (req, res) => {
    const labname = req.query.labname || req.body.labname || ''; 
    if (labname === '') {
      res.status(400).send('Lab name is required');
      return;
    }
    // search in labsconfig
    const labpath = labsconfig.labs[labname];
    if(!labpath) {
      res.status(404).send('Lab not found');
      return;
    }
    const vagrantfilePath = `./${labpath}`;
    const command = `VAGRANT_CWD=${vagrantfilePath} vagrant up`; 

    console.log(command);

    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(error);
        res.status(500).send('Error creating VM');
      } else {
        console.log(stdout);
        res.status(200).send('VM created successfully');
      }
    });
  });



app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});