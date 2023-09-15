![Untitled-2023-08-22-1535](https://github.com/youssefshibl/labs_vagrant/assets/63800183/36226fbd-96f3-45a3-a78a-f077145f10d5)

---
# Labs Vagrant 
#### many platform which make labs for you to learn and practice on it , it make vm for you and install all tools you need to start your labs , this architecture apply on many platform like :  [TryHackMe](https://tryhackme.com/) , [HackTheBox](https://www.hackthebox.eu/) , [PentesterLab](https://pentesterlab.com/) , [VulnHub](https://www.vulnhub.com/) , [OverTheWire](https://overthewire.org/wargames/) , [RootMe](https://www.root-me.org/) , [PentesterAcademy](https://www.pentesteracademy.com/) , [PortSwigger](https://portswigger.net/web-security) , [Pentestit](https://lab.pentestit.ru/) , [PentestBox](https://pentestbox.org/) , [PentestTools](https://pentest-tools.com/home) , [PentestMonkey](https://pentestmonkey.net/)

### How this architecture work ?
this architecture work by using vagrant and virtualbox , vagrant is a tool to create vm and virtualbox is a tool to run vm , vagrant use virtualbox to create vm and install all tools you need to start your labs , when user want to practice on any lab he should download openvpen file which allow to access private network and access to vm , after that user should choose the lab which he want to practice on it , this will create vm and install all tools you need to start your labs , after that you can access to vm by ip or try to make anaylsis this lab `server` to get flag or make task in this machine

### How to use this architecture For User ? 

#### assume that this architecture run in high resource machine like server or cloud server , and user want to practice on any lab , so user should do the following steps :
1 - open web browser and go to this architecture website  `http://localhost:3000/labs` the web page will show all labs which user can practice on it , user should choose the lab which he want to practice on it

![ezgif com-video-to-gif](https://github.com/youssefshibl/labs_vagrant/assets/63800183/f7c015b4-bbef-4701-96e1-505328a15746)

but before enter to lab user should download openvpn file which allow to access private network and access to vm , after that user should choose the lab which he want to practice on it , this will create vm and install all tools you need to start your labs , after the vm for lab start successfully user can access to vm by ip or try to make anaylsis this lab `server` to get flag or make task in this machine, the ip of machine will show in the web page

![Screenshot from 2023-09-15 16-46-56](https://github.com/youssefshibl/labs_vagrant/assets/63800183/9b19e063-8c87-4608-8611-aa487e106fb7)