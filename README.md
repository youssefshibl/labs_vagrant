![Untitled-2023-08-22-1535](https://github.com/youssefshibl/labs_vagrant/assets/63800183/36226fbd-96f3-45a3-a78a-f077145f10d5)

---

# 🛰️ Labs Vagrant

#### 🚀 many platform which make labs for you to learn and practice on it , it make vm for you and install all tools you need to start your labs , this architecture apply on many platform like : [TryHackMe](https://tryhackme.com/) , [HackTheBox](https://www.hackthebox.eu/) , [PentesterLab](https://pentesterlab.com/) , [VulnHub](https://www.vulnhub.com/) , [OverTheWire](https://overthewire.org/wargames/) , [RootMe](https://www.root-me.org/) , [PentesterAcademy](https://www.pentesteracademy.com/) , [PortSwigger](https://portswigger.net/web-security) , [Pentestit](https://lab.pentestit.ru/) , [PentestBox](https://pentestbox.org/) , [PentestTools](https://pentest-tools.com/home) , [PentestMonkey](https://pentestmonkey.net/)

### 📌 How this architecture work ?

this architecture work by using vagrant and virtualbox , vagrant is a tool to create vm and virtualbox is a tool to run vm , vagrant use virtualbox to create vm and install all tools you need to start your labs , when user want to practice on any lab he should download openvpen file which allow to access private network and access to vm , after that user should choose the lab which he want to practice on it , this will create vm and install all tools you need to start your labs , after that you can access to vm by ip or try to make anaylsis this lab `server` to get flag or make task in this machine

### 📌 How to use this architecture For User ?

#### 🚀 assume that this architecture run in high resource machine like server or cloud server , and user want to practice on any lab , so user should do the following steps :

1 - open web browser and go to this architecture website `http://localhost:3000/labs` the web page will show all labs which user can practice on it , user should choose the lab which he want to practice on it

![ezgif com-video-to-gif](https://github.com/youssefshibl/labs_vagrant/assets/63800183/f7c015b4-bbef-4701-96e1-505328a15746)

but before enter to lab user should download openvpn file which allow to access private network and access to vm (examplefile.ovpn) , after that user should choose the lab which he want to practice on it , this will create vm and install all tools you need to start your labs , after the vm for lab start successfully user can access to vm by ip or try to make anaylsis this lab `server` to get flag or make task in this machine, the ip of machine will show in the web page
![Screenshot from 2023-09-15 16-46-56](https://github.com/youssefshibl/labs_vagrant/assets/63800183/9b19e063-8c87-4608-8611-aa487e106fb7)
now user can access to vm by ip and start his labs

note : there are many type of labs , there are lab which it give user username and password to access to vm , and there are lab which it give user ip and user should try to get or change some thing insiede this machine to get flag or make task in this machine

### 📌 How to use this architecture For Admin ?

you should first install vagrant and virtualbox in your machine , now you can make vm by vagrant , how vagrant make vm ? , vagrant use vagrantfile to make vm , vagrantfile is a file which contain all information about vm like : name , ip , os , tools , username , password , and many information , and you should make `vagrantf up` in dir of the vagrant file to create vm , after this you can run script in this vm after make it up, the script which run in machine will locate with vagrantfile , to run this script with the vm run `vagrant provision`

after install all require you shoud import the lab box of vagrant , but what is vagrant box ? , The vagrant box is a ready-made base image of a Virtual Machine Environment , how export this box from you lab ?

#### 🚀 How to export vagrant box ?

- make vm in your hypervisor (virtualbox) , and install all tools you need to start your labs and make all configuration you need to start your labs

- run vagrant script in this vm , this script will manage your vm to make it compatible with vagrant , like make user vagrant and change root password and install vagrant ssh key and install vagrant tools and install vagrant network and install vagrant share and install vagrant guest tools , this script will locate at `.\scripts\vagrant.sh`

- after finish your vm you should export it to vagrant box , how to export it ? , open terminal and run `vagrant package --output <box_name>.box` , this will export the box from your lab

after make lab box you should make new dir under labs directory with name of your lab , and make new file with name of `vagrantfile` and put this code in it

```ruby


Vagrant.configure("2") do |config|
  config.vm.box = "@@VM_BOX@@"
  #config.vm.box = "debian/jessie64"
  # config.vm.box_url = "./package.box"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 1
    # set name of vm in virtualbox
    vb.name = "@@VM_NAME@@"
  end
  config.vm.network "private_network", type: "dhcp",name: "vboxnet1",virtualbox__intnet: false
  #config.vm.network "public_network", ip: "192.168.56.10"
  config.vm.define "init_lab"
  # Remove any other network configurations
  config.vm.provision "shell", path: "script.sh"
  # set name to vm in vagrant
  config.vm.hostname = "@@VM_NAME@@"

end
```

and put your script of this lab with vagrant file , after this you should set all info of your app in `config/labpath.json` which be like this

```json
{
  "labs": {
    "init_lab": {
      "lab_path": "labs/init_lab",
      "lab_name": "init_lab",
      "lab_box": "init_lab",
      "lab_image": "lab_image.png",
      "os": "linux",
      "level": "beginner",
      "description": "This is a test lab"
    }
  }
}
```

#### 🚀 Running web server

after that run `app.js` to run server , this server will run on port 3000 , and you can access to it by `http://localhost:3000/labs` , this page will show all labs which user can practice on it , user should choose the lab which he want to practice on it

#### 🧢 Routes of web server

- `/labs` : this route will show all labs which user can practice on it , user should choose the lab which he want to practice on it

- `/create-vm/:lab_name` : this route will create vm for user to practice on it , this route will create vm and install all tools you need to start your labs , after the vm for lab start successfully user can access to vm by ip , response of this route will be json contain ip of vm and other information 
    ```js
    {
        vmname: vmname,
        labname: labname,
        labpath: labpath,
        vagrantfilePath: vagrantfilePath,
        ip: ip,
        hostname: hostname,
        hosts: hosts,
        resolv: resolv,
    }
    ```

- `/delete-vm/:id` : this route will delete vm for user to practice on it 
- `/get-vm/:id` : this route will get vm information for user to practice on it
- `/download/vpnfile` : this route will download vpn file for user to access to vm
- `get-all-running-vm` : this route will get all running vm in your machine