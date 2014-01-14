# Introduction: Explaining the Need for Bitcloud
## The Emergence of Cloud Computing
One of the most important aspects of the Internet is that it allows people to communicate with each other in a decentralized manner. One user can connect directly to any other user around the world to share text, videos, audio, photos, and many other forms of media. As the Internet has evolved over time, more people have started to do their computing in the cloud rather than on their own computers. Since many computer users now have more than one device, they use the cloud to make sure that they can access all of their content from anywhere in the world. While this definitely improves convenience on the user's end, it also harms overall privacy. At the end of the day, the user has to trust the person who owns the server where all of their emails, photos, videos, and everything else is being stored. Although the world of the Internet started out as a decentralized network that allowed people to share information from many different parts of the world, it is now entering a phase of centralization through various forms of proprietary cloud services.

## Examples of Centralized Cloud Computing Services
### YouTube/Soundcloud
When videos and audio files first started to be shared by various users on the Internet, they were done so in a decentralized manner. One user would send a media file directly to a friend or colleague, or they would host the file on their own website to be streamed to anyone who was sent a link. Nowadays, most people share media files by posting them on a centralized hub of servers, usually YouTube or Soundcloud. The main problem with centralizing all of our media in a handful of companies is that they have ultimate control over the files on their websites. They can choose to delete any content when they deem it to be appropriate, or they can be forced to remove content by their local government. Centralized proprietary services also tend to take advantage of their place in the marketplace when it comes to creating large profit margins. Although YouTube does not see the same kind of profit margin that was seen by traditional television companies when it comes to placing advertisements on videos uploaded to their website, the reality is that they still take in far too much of a profit and leave the scraps for YouTube artists.

### Dropbox/Google Drive/Mega

Most people think of Dropbox when they think about personal cloud storage. One of the main problems with storing all of your data with one company, such as Dropbox, is that they are a prime target for surveillance programs run by the NSA and other intelligence agencies around the world. In fact, we already know that the [NSA is hoping to target Dropbox](http://www.policymic.com/articles/47231/prism-the-8-tech-companies-who-gave-your-data-to-the-government-have-this-to-say-about-the-scandal) in the near future. Any centralized personal cloud storage company is also likely to offer less competitive pricing because of a lack of intense competition in the marketplace.

### Amazon Web Services/HostGator

If you are hosting a website on another company's centralized servers, then the user accounts on your web platform can be subject to unauthorized surveillance. A lack of competition in this market also exists because it is difficult for anyone in the world to decide that they want to start a web hosting company. A centralized host can also decide to shut down your website and delete everything on the spot or be forced to do so by their local government. This is what happened in the case of MegaUpload where everyone's files hosted on the web servers were deleted, even if they had nothing to do with Internet piracy.

### Gmail/Whatsapp

Although centralized, cloud-based messaging platforms may be something that is better replaced by Bitmessage or another proof of work based blockchain, the reality is that these centralized servers could also be replaced by Bitcloud. It is not yet known which solution will turn out to be the best option for users when it comes to privacy and security.

### Ustream/Justin.tv

Centralized streaming services are another cloud platform that are subject to censorship. If the hosting company or local government does not like your content, they can easily shut it down.

### Proprietary Cloud Services All Have Similar Problems

As you can see, many of the current solutions for cloud-based services have a few common problems. Let's take a look at three of the main issues that we are trying to solve with the Bitcloud protocol:

#### 1. Privacy and Free Software

After the Summer of Snowden, many people from around the world are becoming more interested in computing solutions that provide real privacy and security. While proprietary cloud networks will claim that they care about your privacy and do everything in their power to protect it, the reality is that you still have to trust these companies to follow through on their word. With Bitcloud, we can offer a trustless version of privacy and security that is completely open to scrutiny. Personal cloud storage services built on top of Bitcloud can force users to encrypt their files locally before they are uploaded to the Bitcloud network. This means that the nodes will not be able to decrypt the files that they are storing. This kind of encryption is currently not turned on by default for proprietary options, such as Dropbox, but we feel that it is something that any cloud service should have turned on by default. This kind of local encryption is needed to be turned on by default much like how HTTPS should be turned on by default for every website. This allows the amount of user error related to privacy to be lowered.

It's also important to realize that you cannot achieve true security if you can't also look at the source code of the software or protocol that is handling your data. Bitcloud is going to be free and open source, which means you will be able to look closely at the ways in which your privacy is protected. It is possible that proprietary systems could be built on top of Bitcloud, but they will lose out to the kinds of services that decide to also make their services completely free and open source. If you cannot read the source code of the service that is holding your data, then you do not know if it is actually secure.

The unmoderated layer of Bitcloud will also allow for another layer of anonymity. Since everything in the unmoderated layer of Bitcloud will be router through Tor or other similar anonymizing networks, the node where a user's data is sent will not know the true IP address of the user. The node will not know the identity of the user, and the user will not know the identity of the node.

#### 2. Censorship

The underlying, unmoderated layer of Bitcloud will not be subject to any censorship. While it is true that there will be moderators who provide their own services on top of Bitcloud, a user will have more options when it comes to the type of censorship they want to have on their data. For example, there may be a moderator who sets up a number of video streaming nodes that will accept all content except for child pornography. As long as users don't upload anything related to child pornography, they will have nothing to worry about. There is also the possibility that a moderator could change his or her censorship terms over time as their group of nodes becomes more popular, but then another moderator could pop up who holds the original values of the moderator who has decided to change his or her ways.

#### 3. High Costs

One last factor to consider when it comes to decentralizing the cloud services on the web is cost. You may be thinking that services such as YouTube and Gmail are free, but the fact of the matter is that these kinds of services come with a high cost. Google wants to track everything you watch, read, or type while you are using their services, which means it is impossible for them to provide a secure, private, and censorship resistant service. The hidden cost of using services that are paid for with a Google-style advertising model is that Google gets to track all of your activity on YouTube and read all of your emails. By making it rather trivial for someone to create a a new cloud service from the comfort of their own home, we can add much needed competition to the cloud service industry and lower costs quite dramatically.

# How it Works

This will be a rather brief explanation of the inner workings of the Bitcloud protocol. For more technical details, you can take a look at the [Bitcloud Protocol Wiki](https://github.com/wetube/bitcloud/wiki/Protocol).

## The Bitcloud Protocol

### Proof of Bandwidth

Bitcloud works on a proof of stake variation known as proof of bandwidth. The nodes in this system are similar to the miners in the Bitcoin protocol in that they confirm everything on the blockchain every ten minutes. Instead of using a proof of work system where miners are looking for the solution to a complex mathematical equation, the nodes in Bitcloud are rewarded based on their share of the total amount of bandwidth used in the Bitcloud network. Each block reward is distributed among the nodes based on their share of the overall amount of bandwidth needed by the Bitcloud users.

### Moderators

Although nodes will not know what kind of data is stored on their local server, they will be able to subscribe to moderators who can filter out any unwanted content. Moderators can basically censor certain types of content from being stored on a nodes computer. The difference between this and the current system of centralized cloud services is that there will likely be an endless number of moderators who have different types of restrictions when it comes to the type of data that can be stored on their nodes' servers. Perhaps some moderators will specialize in only allowing people to upload news videos, while other moderators will allow people to upload almost anything as long as it is encrypted and not shared with many other people. This is a way for the nodes to remain neutral and follow the laws of their own countries.

#### Unmoderated

In addition to the option to have moderators pick what can be stored on their servers, nodes will also be able to choose to host unmoderated content. There are both advantages and disadvantages to this option. The data will be routed through many different nodes before it gets to the end-user, so cloud storage will more expensive. On the other hand, the unmoderated network will allow people to host and share content that will not be traced back to the uploader or the node. The data will be sent through a variety of different nodes in a similar many in which the Tor network works.

## Bitcloud is a Distributed Autonomous Corporation

If you're unfamiliar with decentralized applications or distributed autonomous corporations, then you may want to look into the explanations offered by the [Mastercoin Foundation](https://github.com/DavidJohnstonCEO/DecentralizedApplications/blob/master/README.md) and [Invictus Innovations](http://letstalkbitcoin.com/bitcoin-and-the-three-laws-of-robotics/#.UjjO0mTFT7v).

### Providing a Service and Getting Paid

The Bitcloud protocol is a decentralized application that provides the service of cloud storage. Users will interact with this service in a variety of different ways, but the main idea behind the protocol is that people will be able to store data in the cloud in a way that limits censorship, surveillance, and centralization. Moderators and nodes are providing a service to their users, and they need to be paid to cover their costs. Mediacoins are the currency of the Bitcloud protocol, much like bitcoins are the currency of the Bitcoin protocol. You need bitcoins to use the Bitcoin payment system, and you need mediacoins to use Bitcloud in certain ways. For example, someone who wants to advertise on a public video that is streamed from a Bitcloud node will have to pay for that advertisement in mediacoins. Another example would be someone who wants to pay for personal cloud storage on the Bitcloud network.

### Opportunities for Investors

In a way, mediacoins can be viewed almost as stock in Bitcloud. Investors who purchase mediacoins in the early stages of development will notice that they get a return on their initial investment once more users begin to use the network. Mediacoins will become more valuable as more people use the Bitcloud network because the number of mediacoins needed to pay for certain services on the Bitcloud network will increase as more people are bidding for those services. This setup also encourage growth of the Bitcloud network because early adopters will want to tell everyone about the Bitcloud platform due to the fact that they basically hold stock in the distributed autonomous corporation.

# Future Applications on Top of the Bitcloud Protocol
## WeTube

WeTube was the basis for the creation of the proof of bandwidth idea. WeTube can act as a replacement for YouTube, Netflix, Hulu, Soundcloud, and other audio and video streaming systems. The decentralized nature of WeTube will allow users to share content with the world without having to worry about censorship or privacy concerns. In addition to the ability for nodes and moderators to get paid through this DAC, artists can also get paid by opting to get a cut of the advertising revenue that is generated on their content. They can also opt to have their content remain ad-free while it is being hosted by the nodes, but there may be a fee for this service.

## Decentralized Personal Cloud Storage

Another app that can be built on top of Bitcloud would deal with personal cloud storage. Using an unmoderated form of cloud storage would be possible through relayed, Tor-based connections. This means the user wouldn't know where their files were stored and the nodes wouldn't know who sent them the files. The files would also be encrypted, so the nodes won't know what they are storing either. There could also be moderated forms of cloud storage where different types of files are allowed to be stored at different rates.

## Decentralized Web Hosting

In a form of decentralized web hosting based on the Bitcloud protocol, it would be impossible for a web server to be shut down because it would be distributed to many different nodes across the world. Hidden services for Tor and i2p could also be hosted on Bitcloud.

## More

There are probably many other applications for Bitcloud that we haven't thought about yet. If you have any ideas, don't hesitate to contact us.

# Contact Information

If you'd like to talk to us or ask us questions, you can find us in #wetube on freenode IRC. There will usually be someone in there willing to talk to you.