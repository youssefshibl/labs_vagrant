const express = require("express");
const { exec } = require("child_process");
bodyParser = require("body-parser");
let labsconfig = require("./config/labspath.json");

const app = express();

app.use(bodyParser.json());

const port = 3000;

let RunningVmData = [];
// test route
app.get("/", (req, res) => {
  exec("whoami", (error, stdout, stderr) => {
    if (error) {
      console.log(stdout);
      console.error("-------------------------------------------");
      console.error(error);
      res.status(500).send("Error creating VM");
    } else {
      console.log(stdout);
      res.status(200).send("VM created successfully");
    }
  });
});

// create vm route
app.post("/create-vm", (req, res) => {
  const labname = req.query.labname || req.body.labname || "";
  if (labname === "") {
    res.status(400).send("Lab name is required");
    return;
  }
  // search in labsconfig
  const labpath = labsconfig.labs[labname].lab_path;
  if (!labpath) {
    res.status(404).send("Lab not found");
    return;
  }
  // make new directory in running directory from labpath with date name
  let vmname = "vm" + Date.now();
  let runningDir = "running" + "/" + vmname;
  let copyCommand =
    "mkdir -p " + runningDir + " && cp -r " + labpath + "/* " + runningDir;
  console.log(copyCommand);
  // copy lab files to running directory
  exec(copyCommand, (error, stdout, stderr) => {
    if (error) {
      console.error(error);
      res.status(500).send("Error copying lab files");
    } else {
      console.log(stdout);
      // change name "@@VM_NAME@@" vagrant file with vmname
      // change boxname @@VM_BOX@@" vagrant file with boxname
      const vagrantfilePath = `./${runningDir}`;
      const ReplacevVmCommand = `sed -i 's/@@VM_NAME@@/${vmname}/g' ${vagrantfilePath}/Vagrantfile ; sed -i 's/@@VM_BOX@@/${labsconfig.labs[labname].lab_box}/g' ${vagrantfilePath}/Vagrantfile`;
      console.log(ReplacevVmCommand);

      exec(ReplacevVmCommand, (error, stdout, stderr) => {
        if (error) {
          console.error(error);
          res.status(500).send("Error creating VM");
        } else {
          console.log(stdout);
          // this test command
          // ---------------------------------------------
          res.status(200).send({
            vmname: vmname,
            labname: labname,
            labpath: labpath,
            vagrantfilePath: vagrantfilePath,
          });
          return;
          // ---------------------------------------------
          const command = `VAGRANT_CWD=${vagrantfilePath} vagrant up`;
          console.log(command);
          // run vm in RunningVmData array
          exec(command, (error, stdout, stderr) => {
            if (error) {
              console.error(error);
              res.status(500).send("Error creating VM");
            } else {
              console.log(stdout);
              // run provision script
              const provisionCommand = `VAGRANT_CWD=${vagrantfilePath} vagrant provision`;
              exec(provisionCommand, (error, stdout, stderr) => {
                if (error) {
                  console.error(error);
                  res.status(500).send("Error creating VM");
                } else {
                  console.log(stdout);
                  // get ip of vm 
                  const getIpCommand = `VAGRANT_CWD=${vagrantfilePath} vagrant ssh -c "hostname -I | awk '{print $2}'"`;
                  exec(getIpCommand, (error, stdout, stderr) => {
                    if (error) {
                      console.error(error);
                      res.status(500).send("Error creating VM");
                    } else {
                      console.log(stdout);
                      // get hostname of vm
                      const ip = stdout.split("\n")[1];
                      const provisionCommand = `VAGRANT_CWD=${vagrantfilePath} vagrant ssh -c "cat /etc/hostname"`;
                      exec(provisionCommand, (error, stdout, stderr) => {
                        if (error) {
                          console.error(error);
                          res.status(500).send("Error creating VM");
                        } else {
                          console.log(stdout);
                          // get hostes of vm
                          const hostname = stdout.split("\n")[1];
                          
                          const provisionCommand = `VAGRANT_CWD=${vagrantfilePath} vagrant ssh -c "cat /etc/hosts"`;
                          exec(provisionCommand, (error, stdout, stderr) => {
                            if (error) {
                              console.error(error);
                              res.status(500).send("Error creating VM");
                            } else {
                              console.log(stdout);
                              // get resolv of vm
                              const hosts = stdout.split("\n");
                              const provisionCommand = `VAGRANT_CWD=${vagrantfilePath} vagrant ssh -c "cat /etc/resolv.conf"`;
                              exec(provisionCommand, (error, stdout, stderr) => {
                                if (error) {
                                  console.error(error);
                                  res.status(500).send("Error creating VM");
                                } else {
                                  console.log(stdout);
                                  const resolv = stdout.split("\n");
                                  let hostsData = {
                                    vmname: vmname,
                                    labname: labname,
                                    labpath: labpath,
                                    vagrantfilePath: vagrantfilePath,
                                    ip: ip,
                                    hostname: hostname,
                                    hosts: hosts,
                                    resolv: resolv,
                                  };
                                  RunningVmData.push(hostsData);
                                  res.status(200).send(hostsData);
                                }
                              });
                            }
                          });
                        }
                      });
                    }
                  });

                }
              });
            }
          });
        }
      });
    }
  });
});

app.get("/delete-vm/:id", (req, res) => {
  const vmname = req.params.id || "";
  if (vmname === "") {
    res.status(400).send("VM name is required");
    return;
  }
  // search in runningVmData
  let vm = RunningVmData.find((vm) => vm.vmname === vmname);
  if (!vm) {
    res.status(404).send("VM not found");
    return;
  }
  // delete vm from RunningVmData array
  RunningVmData = RunningVmData.filter((vm) => vm.vmname !== vmname);
  // stop running vm
  const vagrantfilePath = vm.vagrantfilePath;

  const command = `VAGRANT_CWD=${vagrantfilePath} vagrant halt`;
  console.log(command);
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(error);
      res.status(500).send("Error deleting VM");
    } else {
      // destory this vm
      const command = `VAGRANT_CWD=${vagrantfilePath} vagrant destroy`;
      console.log(command);
      exec(command, (error, stdout, stderr) => {
        if (error) {
          console.error(error);
          res.status(500).send("Error deleting VM");
        } else {
          console.log(stdout);
          // delete vm from running directory
          const deleteCommand = `rm -rf running/${vmname}`;
          exec(deleteCommand, (error, stdout, stderr) => {
            if (error) {
              console.error(error);
              res.status(500).send("Error deleting VM");
            } else {
              console.log(stdout);
              res.status(200).send("VM deleted successfully");
            }
          });
        }
      });
    }
  });
});

app.get("/get-vm/:id", (req, res) => {
  const vmname = req.params.id || "";
  if (vmname === "") {
    res.status(400).send("VM name is required");
    return;
  }
  // search in runningVmData
  let vm = RunningVmData.find((vm) => vm.vmname === vmname);
  if (!vm) {
    res.status(404).send("VM not found");
    return;
  }
  res.status(200).send(vm);
});

app.get("/get-all-vm", (req, res) => {
  res.status(200).send(RunningVmData);
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
