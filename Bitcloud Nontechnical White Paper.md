# Bitcloud: A Decentralized Application for Cloud Services Based on Proof of Bandwidth
## Introduction: Explaining the Need for Bitcloud
### The Emergence of Cloud Computing
One of the most important aspects of the Internet is that it allows people to communicate with each other in a somewhat decentralized manner. One user can connect directly to any other user around the world to share text, videos, audio, photos, and many other forms of media. As the Internet has evolved over time, more people have started to do their [computing in the cloud](https://en.wikipedia.org/wiki/Cloud_computing) rather than on their own computers. Since many computer users now have more than one device, they use the cloud to make sure that they can access all of their content from anywhere in the world. While this definitely improves convenience on the user's end, it also harms overall privacy and security. At the end of the day, the user has to trust the person who owns the server where all of their emails, photos, videos, and everything else is being stored. Although the world of the Internet started out as a network that allowed people to share information from many different parts of the world, it is now entering a phase of centralization through various forms of cloud-based software companies.

### Examples of Centralized Cloud Computing Services
#### YouTube/Soundcloud
When videos and audio files were first shared by various users on the Internet, they were done so in a decentralized manner. One user would send a media file directly to a friend or colleague, or they would host the file on their own website to be streamed to anyone who was sent a link. Nowadays, most people share media files by posting them on a centralized hub of servers, usually YouTube or Soundcloud. The main problem with centralizing all of our media in a handful of companies is that they have ultimate control over the files on their websites. They can choose to delete any content when they deem it to be appropriate, or they can be forced to remove content by their local government. Centralized services also tend to take advantage of their place in the marketplace when it comes to creating large profit margins. YouTube brought more competition to the market when it comes to the distribution of ad revenue to artists, but we still have room for improvement.

#### Dropbox/Google Drive

Most people think of Dropbox when they think about personal cloud storage. One of the main problems with storing all of your data with one company, such as Dropbox, is that they are a prime target for surveillance programs run by the NSA and other intelligence agencies around the world. In fact, we already know that the [NSA is hoping to target Dropbox](http://www.policymic.com/articles/47231/prism-the-8-tech-companies-who-gave-your-data-to-the-government-have-this-to-say-about-the-scandal) in the near future. Any centralized personal cloud storage company is also likely to offer less competitive pricing because of a lack of intense competition in the marketplace.

#### Gmail/Whatsapp

Although centralized, cloud-based messaging platforms may be something that is better replaced by Bitmessage or another proof of work based blockchain, the reality is that these centralized servers could also be replaced by Bitcloud. It is not yet known which solution will turn out to be the best option for users when it comes to privacy and security.

#### Ustream/Justin.tv

Centralized streaming services are another cloud platform that are subject to censorship. If the hosting company or local government does not like the content you are live streaming, they can easily shut it down.

#### Comcast/Verizon/AT&T and the Internet

We have the technology to create local mesh networks as replacements for the Internet and Internet service providers. The only problem is that there is little incentive for a new node to join a brand new network. We need to add the incentive of profit if we want to bootstrap and entirely new mesh network.

#### Proprietary Cloud Services All Have Similar Problems

As you can see, many of the current solutions for cloud-based services have a few common problems. Let's take a look at three of the main issues that we are trying to solve with the Bitcloud protocol:

##### 1. Privacy and Free Software

After the "[Summer of Snowden](https://en.wikipedia.org/wiki/Global_surveillance_disclosures_(2013%E2%80%93present))", many people from around the world are becoming more interested in computing solutions that provide real privacy and security. While proprietary cloud networks will claim that they care about your privacy and do everything in their power to protect it, the reality is that you still have to trust these companies to follow through on their word. With Bitcloud, we can offer a trustless version of privacy and security that is completely open to scrutiny. Personal cloud storage services built on top of Bitcloud can force users to encrypt their files locally before they are uploaded to the Bitcloud network. This means that the nodes will not be able to decrypt the files that they are storing. This kind of encryption is currently not turned on by automatically for proprietary options, such as Dropbox, but we feel that it is something that any cloud service should have turned on by default. This kind of local encryption needs to be turned on by default, much like how HTTPS should be turned on by default for every website. This lowers the number of privacy problems that can pop up due to user error.

It's also important to realize that you cannot achieve true security if you can't also look at the source code of the software or protocol that is handling your data. Bitcloud is going to be [free and open source software](https://en.wikipedia.org/wiki/Free_and_open-source_software), which means you will be able to look closely at the ways in which your privacy is protected. It is possible that proprietary systems could be built on top of Bitcloud, but they will lose out to the kinds of services that decide to also make their services completely free and open source. If you cannot read the source code of the service that is holding your data, then you do not know if it is actually secure.

The unmoderated layer of Bitcloud will also allow for anonymity. Since everything in the unmoderated layer of Bitcloud will be routed through multiple nodes in a way similar to [Tor](http://www.torproject.org/), the node where a user's data is sent will not know the true IP address of the user. The node will not know the identity of the user, and the user will not know the identity of the node.

##### 2. Censorship

The underlying, unmoderated layer of Bitcloud will not be subject to any censorship. While it is true that there will be moderators who provide their own services on top of Bitcloud, a user will have more options when it comes to the type of censorship they want to have on their data. For example, there may be a moderator who sets up a number of video streaming nodes that will accept all content except for child pornography. As long as users don't upload anything related to child pornography, they will have nothing to worry about. There is also the possibility that a moderator could change his or her censorship terms over time as their group of nodes becomes more popular, but then another moderator could pop up as a replacement for the moderator who has decided to change his or her ways.

##### 3. High Costs

One last factor to consider when it comes to decentralizing the cloud services on the web is cost. You may be thinking that services such as YouTube and Gmail are free, but the fact of the matter is that these kinds of services come with a high cost. Google wants to track everything you watch, read, or type while you are using their services, which means it is impossible for them to provide a secure, private, and censorship resistant service. The hidden cost of using services that are paid for with a Google-style advertising model is that Google gets to track all of your activity on YouTube and read all of your emails. By making it rather trivial for someone to create a new cloud service from the comfort of their own home, we can add much needed competition to the cloud service industry. This increased competition is bound to lead towards lower costs.

## How it Works

This will be a rather brief explanation of the inner workings of the Bitcloud protocol. For more technical details, you can take a look at the [Bitcloud Protocol Wiki](https://github.com/wetube/bitcloud/wiki/Protocol).

### The Bitcloud Protocol

#### Proof of Bandwidth

Bitcloud works on a variation of [proof of stake](https://bitcoin.it/wiki/Proof_of_Stake) known as proof of bandwidth. The nodes in this system are similar to the miners in the Bitcoin protocol in that they mine cloudcoins by providing bandwidth to the network. Instead of using a proof of work system where miners are looking for the solution to a complex mathematical equation, the nodes in Bitcloud are rewarded based on their share of the total amount of bandwidth used in the Bitcloud network. Each [block reward](https://en.bitcoin.it/wiki/Mining) is distributed among the nodes based on their share of the overall amount of bandwidth needed by the Bitcloud users.

#### Moderators

Nodes will be able to subscribe to moderators who can decide the type of content that will be stored on the node's server. The difference between this and the current system of centralized cloud services is that there will likely be an endless number of moderators who have different types of restrictions when it comes to the type of data that can be stored on their nodes' servers. Perhaps some moderators will specialize in only allowing people to upload news videos, while other moderators will allow people to upload almost anything as long as it is encrypted and not shared with many other people. This is a way for the nodes to remain neutral and follow the laws of their own countries.

##### Unmoderated

In addition to the option to have moderators pick what can be stored on their servers, nodes will also be able to choose to host unmoderated content. There are both advantages and disadvantages to this option. The data will be routed through many different nodes before it gets to the end-user, so cloud storage will more expensive. On the other hand, the unmoderated network will allow people to host and share content that will not be traced back to the uploader or the node. The data will be sent through a variety of different nodes in a manner similar to Tor.

#### Decisions to Be Made

There are still many key decisions that need to be made in the Bitcloud protocol. We have a basic idea of how everything will work, but we need assistance from programmers and thinkers from around the world who want to help this project. We've tried to come up with specific solutions as a two-man team, but there are simply too many aspects of the protocol for us to tackle alone. Head over to #bitcloud on Freenode IRC or /r/bitcloud on Reddit if you'd like to join us.

### Bitcloud is a Distributed Autonomous Corporation

If you're unfamiliar with decentralized applications or distributed autonomous corporations, then you may want to look read this simple, nontechnical article by [Kyle Torpey](http://newswax.com/2014/01/implications-crypto-assets-part-3-distributed-autonomous-corporations/). For more in-depth analysis, you can read explanations from the [Mastercoin Foundation](https://github.com/DavidJohnstonCEO/DecentralizedApplications/blob/master/README.md) and [Invictus Innovations](http://letstalkbitcoin.com/bitcoin-and-the-three-laws-of-robotics/#.UjjO0mTFT7v).

#### Providing a Service and Getting Paid

The Bitcloud protocol is a decentralized application that provides the services of cloud storage and bandwidth sharing. Users will interact with this service in a variety of different ways, but the main idea behind the protocol is that people will be able to store data in the cloud in a way that limits censorship, surveillance, and centralization. Moderators and nodes are providing a service to their users, and they need to be paid to cover their costs. Cloudcoins are the currency of the Bitcloud protocol, much like bitcoins are the currency of the Bitcoin protocol. You need bitcoins to use the Bitcoin payment system, and you need cloudcoins to use Bitcloud in certain ways. For example, someone who wants to advertise on a public video that is streamed from a Bitcloud node will have to pay for that advertisement in cloudcoins. Another example would be someone who wants to pay for personal cloud storage on the Bitcloud network. By monetizing the system, nodes can get paid for their willingness to share bandwidth, provide cloud storage, and allow for direct streaming to stored content. Adding the profit motive to the equation gives this project a chance to succeed where many others have failed in the past. Donations can only take you so far when you are trying to create something of this magnitude.

#### Opportunities for Investors

In a way, cloudcoins can be viewed almost as stock in Bitcloud. Investors who purchase cloudcoins in the early stages of development will notice that they get a return on their initial investment once more users begin to use the network. Cloudcoins will become more valuable as more people use the Bitcloud network because the number of cloudcoins needed to pay for certain services on the Bitcloud network will increase as more people are bidding for those services. This setup also encourage growths of the Bitcloud network because early adopters will want to tell everyone about the Bitcloud platform due to the fact that they basically hold stock in the distributed autonomous corporation. A similar incentive exists in Bitcoin.

## Future Applications on Top of the Bitcloud Protocol
### WeTube

WeTube was the basis for the creation of the proof of bandwidth idea. WeTube can act as a replacement for YouTube, Netflix, Hulu, Soundcloud, Spotify, and other audio and video streaming systems. The decentralized nature of WeTube will allow users to share content with the world without having to worry about censorship or privacy concerns. In addition to the ability for nodes and moderators to get paid through this DAC, artists can also get paid by opting to get a cut of the advertising revenue that is generated on their content. They can also opt to have their content remain ad-free while it is being hosted by the nodes, but there may be a fee for this service.

### Decentralized Personal Cloud Storage

Another app that can be built on top of Bitcloud would deal with personal cloud storage. Using an unmoderated form of cloud storage would be possible through relayed, Tor-like connections. This means the user wouldn't know where their files were stored and the nodes wouldn't know who sent them the files. The files would also be encrypted, so the nodes won't know what they are storing either. There could also be moderated forms of cloud storage where different types of files are allowed to be stored at different rates.

### Decentralized Web Hosting

In a form of unmoderated web hosting based on the Bitcloud protocol, it would be impossible for a web server to be shut down because it would be distributed to many different anonymous nodes across the world.

### Monetizing a Meshnet

There have many different [mesh networking](https://en.wikipedia.org/wiki/Meshnet) projects created over the years, but there hasn't been a huge incentive for new nodes to connect to the various meshnets. A variation of Bitcloud could be used to create a mesh network that pays nodes in the network for routing traffic. This means that users would make extremely small [micropayments](https://en.wikipedia.org/wiki/Micropayments) to nodes throughout the mesh network as their packets get sent to a computer on the other side of the system. With the correct structure, this network could be preferred over the centralized Internet that we have now, which is controlled by the likes of Comcast, AT&T, and other ISPs all over the world. This is nothing more than a theoretical, long-term goal right now because we currently need to work on the basics of Bitcloud.

### More

There are definitely many other applications for Bitcloud that we haven't thought about yet. If you have any ideas, don't hesitate to contact us.

## Contact Information

Freenode IRC: #bitcloud  
Reddit: /r/bitcloud  
Javier Sobrino, Original Creator, Programming Inquiries: liberman@riseup.net  
Kyle Torpey, Marketing/Nontechnical Inquiries: kyletorpey@riseup.net
